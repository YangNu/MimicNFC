package kr.goldenmine.mimicnfc.mimic_nfc

import android.nfc.cardemulation.HostApduService
import android.os.Bundle

/**
 * HCE replay service.
 *
 * Registration-only stub for now: the manifest <service> entry points here so the OS can
 * route the AID(s) from apduservice.xml to this class. Every command is rejected with
 * 0x6F00 until the replay step fills in the real logic, which will:
 *   - load the active card directly from storage (works with the app killed),
 *   - match SELECT AID by the 00A40400 prefix,
 *   - answer READ BINARY / UPDATE BINARY by slicing a stored Type-4 file image,
 *   - broadcast tap events back to Flutter via the EventChannel.
 */
class MimicHostApduService : HostApduService() {

    override fun processCommandApdu(commandApdu: ByteArray?, extras: Bundle?): ByteArray {
        // No card data wired up yet: reject everything until replay is implemented.
        return SW_UNKNOWN
    }

    override fun onDeactivated(reason: Int) {
        // Reader moved away or a different AID was selected. Nothing to clean up yet.
    }

    companion object {
        // ISO 7816-4 status word 6F00 = "no precise diagnosis" (generic reject).
        private val SW_UNKNOWN = byteArrayOf(0x6F.toByte(), 0x00.toByte())
    }
}
