Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E8A2A5533
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 22:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388181AbgKCVGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 16:06:35 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:33277 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388169AbgKCVGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 16:06:33 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201103210620euoutp027f0613901dfb7109b0f422e4a88689b0~EG3qRygB30258502585euoutp02p;
        Tue,  3 Nov 2020 21:06:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201103210620euoutp027f0613901dfb7109b0f422e4a88689b0~EG3qRygB30258502585euoutp02p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1604437580;
        bh=1oVe+Mzyk4MxJ1ipUcz2F9R5YNk5nRkBDJIrpIbCamY=;
        h=From:To:Cc:Subject:Date:References:From;
        b=QggSR4jAh0Ch3rHjS/C2jefwaBu1BvHkNd2+q5EGnGEOX3/c8jDfBzeqNt/5fetpv
         t0o3DC2T4cfNYdeqqhurFRC7AQLmlEg155lQvFVE3i1xcTQnMX43Tb9hf0Um82wyiz
         U9d52sc5ymq1fl2CnjEiMiNUXQWNbbUk0YI3e20o=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201103210615eucas1p27309115b25dca3b8522fe12dcd619323~EG3lWFtN50788807888eucas1p2O;
        Tue,  3 Nov 2020 21:06:15 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 23.E3.06318.746C1AF5; Tue,  3
        Nov 2020 21:06:15 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201103210614eucas1p17e1aaa335b9562351bb0a0ed582b2f38~EG3k9OenP1959119591eucas1p1R;
        Tue,  3 Nov 2020 21:06:14 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201103210614eusmtrp29f299e0a82b5ce8514deba51666ae20c~EG3k8k5bH1931819318eusmtrp2M;
        Tue,  3 Nov 2020 21:06:14 +0000 (GMT)
X-AuditID: cbfec7f5-371ff700000018ae-52-5fa1c6472b7f
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 25.97.06017.646C1AF5; Tue,  3
        Nov 2020 21:06:14 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201103210614eusmtip1f7d4140dbb6bb2ecff46c90808b25c5d~EG3kwKB_c0573305733eusmtip17;
        Tue,  3 Nov 2020 21:06:14 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wilken Gottwalt <wilken.gottwalt@mailbox.org>,
        Jeremy Kerr <jk@ozlabs.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Colin Ian King <colin.king@canonical.com>,
        "Andreas K. Besslein" <besslein.andreas@gmail.com>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [BUG] ax88179_178a - broken hw checksumming after resume
Date:   Tue, 03 Nov 2020 22:05:55 +0100
Message-ID: <dleftjimamrw0c.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTURzAO7t3d9fZjeu0+qNZMO1DRuuJ3bAiI+j2+BD5JYSyWRcV3ZRd
        VxZhBuUrXTXDdIlTMR/T+WKO1GExyiVmS4W0Wkg+MM0eoJGPyFzHoG+/8z+//+twaELxVhpI
        J2hTBZ1WnaSk5KS9a9697WhXecyOl0aKay5qlHLN1R6S63nyleQW6/IprsR9k+Q6XmzjXtsN
        Um6gvYTiKqpuEVxX2TpucXJMesiXN2XkU7yt9q2EbzN9kPEtlhyK97xxUHzbw04JX9vfJ+MN
        NgviZ1o2nvKJlu+/KCQlXBJ02w+el8f3G9JTxoLTPK4KWQYagFzkQwO7BwpbR6lcJKcVbA0C
        t6t35TCLwDayJPVaCnYGwXzpyX8Zr+YrCSxVI6huvyfD0gQCgyMgF9E0xarAaj3jdQLYGwS8
        m26ivA7BctDaWvfX92cjYdxy/y+T7GbIKXhPeplh94Kn3oi8vJbdB7ZPwzIc94Pu4jES19FA
        sXsaeRsAOykDe7aHwtMdgdHbWQRmf5hy2WSYN8BSm1niHQ7Y61BgDMe5eQjsJXMkdiLA82qB
        wk4kDP8OwrgGhr744bZrwGh/QOAwA9mZCpwYCg13HCtFAiF/qgZh5qG2yEzh1zkLho9fJXfR
        JtN/y5j+W8a0XJVgt0Bj+3Yc3gpV5Z8JzAegoeEbWYakFrRe0IuaOEHcrRUuq0S1RtRr41QX
        kjUtaPmT9fx2/XiMOn/FOhFLI+Vq5qm9PEYhVV8Sr2icKHS50khT3WsUSGqTtYIygDnc23NO
        wVxUX7kq6JJjdPokQXSiIJpUrmd2V0yeVbBx6lQhURBSBN2/WwntE5iBUHe2cyYt/CoinkUV
        ZlqXBvta9i2qIm5FSyoLROs6s6P7+EJq1OCR4tLqLEOY9tlwyOne2ZG5+lnLNXP6IBl17G7H
        UFbjN2aPLTH9567gaeZR1kCTMX7Cd1IvH3cG3agcdOnM+uJVeR9e+MfS107uCDnhtuTUPHeE
        fh+l5ybalaQYr94ZRuhE9R/MSkexbAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t/xu7puxxbGGyz4oGmxccZ6VouNy++w
        WJze/47F4vfqXjaLOedbWCx2n9C1uLCtj9Xi8q45bBaLlrUyWxxbIGbx++UTVgduj1kNvWwe
        W1beZPLYOesuu8emVZ1sHneu7WHz2Dl7H5PHyksX2T36tqxi9Pi8SS6AM0rPpii/tCRVISO/
        uMRWKdrQwkjP0NJCz8jEUs/Q2DzWyshUSd/OJiU1J7MstUjfLkEv41JfXcET2Yo7xxexNzBe
        luhi5OSQEDCROPdzCXMXIxeHkMBSRonGGV/Yuhg5gBJSEivnpkPUCEv8udbFBlHzlFFizp6l
        rCA1bAJ6EmvXRoDERQS+M0ncm/uXBaSBWcBCYuvW1ewgtrCAo8TTVVPAbBYBVYnOybfBangF
        zCXurJnECGKLClhKbHlxnx0iLihxcuYTqDnZEl9XP2eewMg3C0lqFpLULKAzmAU0Jdbv0ocI
        a0ssW/iaGcK2lVi37j3LAkbWVYwiqaXFuem5xUZ6xYm5xaV56XrJ+bmbGIExt+3Yzy07GLve
        BR9iFOBgVOLhPbBtYbwQa2JZcWXuIUYVoDGPNqy+wCjFkpefl6okwut09nScEG9KYmVValF+
        fFFpTmrxIUZToN8mMkuJJucD00ReSbyhqaG5haWhubG5sZmFkjhvh8DBGCGB9MSS1OzU1ILU
        Ipg+Jg5OqQbGmPWJghee2i8+t3aLj/ocW9GKmbZ620xtHHNEbsUeO2rKx952LaDvo1DowrX6
        kzf6ts9jFRP8MmHd+nenZT/rfe1wP5Ow7cDTj9/PJtfOcfWq3hr/e9KExXYcitM0Pvjuutjc
        35felinMIBpozB1dfTzk1AP3VarJ0XOllFKS+z9dPBcQJ+WlxFKckWioxVxUnAgABErRcdsC
        AAA=
X-CMS-MailID: 20201103210614eucas1p17e1aaa335b9562351bb0a0ed582b2f38
X-Msg-Generator: CA
X-RootMTR: 20201103210614eucas1p17e1aaa335b9562351bb0a0ed582b2f38
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201103210614eucas1p17e1aaa335b9562351bb0a0ed582b2f38
References: <CGME20201103210614eucas1p17e1aaa335b9562351bb0a0ed582b2f38@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I've got a generic AX88179 based USB ethernet interface and I am
experiencing a following problem.

+ After resuming from suspend
+ hw tx-checksuming doesn't work
+ for UDP packets.

I've got an RPi4 on the other end of the cable. To test the connection
I=C2=A0use the following commands

tcptraceroute -n rpi4
traceroute -In rpi4   # ICMP probes
traceroute -n rpi4    # UDP probes

The former two (TCP, ICMP) work fine, the latter does not until I turn
of tx-checksumming with ethtool(8). I need to turn off both
tx-checksum-ipv4 and tx-checksum-ipv6. Only then ethtool(8) reports
tx-checksumming beeing turned off and UDP probing starts working.

The other way to fix the problem is to bring the interface down and up
again with ip(8). Then hw checksumming may be turned on and works
fine.

Do tell, if there are any other details I can share to help fixing this
problem.

Linux darkstar 4.19.0-11-amd64 #1 SMP Debian 4.19.146-1 (2020-09-17) x86_64=
 GNU/Linux

GNU Make                4.2.1
Binutils                2.31.1
Util-linux              2.33.1
Mount                   2.33.1
Dynamic linker (ldd)    2.28
Procps                  3.3.15
Kbd                     2.0.4
Console-tools           2.0.4
Sh-utils                8.30
Udev                    241
Modules Loaded          ac aesni_intel aes_x86_64 af_alg ahci algif_hash
algif_skcipher ansi_cprng arc4 autofs4 ax88179_178a battery binfmt_misc
bluetooth bnep bonding btbcm btintel btrtl btusb button ccm cfg80211
cmac coretemp cqhci crc16 crc32c_generic crc32c_intel crc32_pclmul
crct10dif_pclmul cryptd crypto_simd ctr dcdbas dell_laptop dell_rbtn
dell_smbios dell_smm_hwmon dell_smo8800 dell_wmi dell_wmi_descriptor
dm_crypt dm_mod drbg drm drm_kms_helper e1000e ecb ecdh_generic
efi_pstore efivarfs efivars ehci_hcd ehci_pci evdev ext4 fat fscrypto
ftdi_sio fuse ghash_clmulni_intel glue_helper gspca_main gspca_zc3xx hid
hid_generic i2c_algo_bit i2c_i801 i915 intel_cstate intel_powerclamp
intel_rapl intel_rapl_perf intel_uncore ip_tables ipt_MASQUERADE
irqbypass iTCO_vendor_support iTCO_wdt iwldvm iwlwifi jbd2 joydev kvm
kvm_intel libahci libata libcrc32c lp lpc_ich mac80211 mbcache media mei
mei_me mei_wdt mfd_core mii mmc_core nf_conntrack nf_defrag_ipv4
nf_defrag_ipv6 nf_nat nf_nat_ipv4 nfnetlink nf_tables nft_chain_nat_ipv4
nft_compat nft_counter nls_ascii nls_cp437 parport parport_pc pcbc
pcc_cpufreq ppdev psmouse rfcomm rfkill rng_core scsi_mod sdhci
sdhci_pci sd_mod serio_raw sg snd snd_hda_codec snd_hda_codec_generic
snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_core snd_hda_intel
snd_hwdep snd_pcm snd_rawmidi snd_seq_device snd_timer snd_usb_audio
snd_usbmidi_lib soundcore sparse_keymap sunrpc thermal tpm tpm_tis
tpm_tis_core uas usb_common usbcore usbhid usbnet usbserial usb_storage
uvcvideo vfat video videobuf2_common videobuf2_memops videobuf2_v4l2
videobuf2_vmalloc videodev wmi wmi_bmof x86_pkg_temp_thermal xhci_hcd
xhci_pci x_tables xt_conntrack xt_state

Kind regards,
=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl+hxjMACgkQsK4enJil
gBC3hgf+OHNIEkXUdeOpU5R/pKTOBBrg+1VJtJYKph5nWWdInHv26pmp0fWMhpX/
gi/YVwgi9wA0v+kI+fpW3VlYwIMXLu/KT/u/cUtK+EvnV6lj8u82Lfm02k7Bsy2a
kS7x7YxwIxONwJO+5+sOrFOvBnySejfxafVoDlArHz6ojAx3FST1EEJH1POgKccR
c0wcqYbYoQrDGAWpsMXcel+xZwqlid7Rbti6thkeXbzaciHtwxF3lRqlZQ7PdxMU
tDvLs8v1CIuHsu5rKhrNZoQHtk1ac9eTcUtRsNsXrAI1g5Vw8TxFaz+nTXBoz1wk
ESHuurphREgQIVuaw3FzmuX5qJg/GQ==
=U09c
-----END PGP SIGNATURE-----
--=-=-=--
