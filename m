Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED96E49F4F6
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 09:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347211AbiA1ILr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 03:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347209AbiA1ILr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 03:11:47 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9658C061714
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 00:11:46 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nDMMA-0000Rm-Kk; Fri, 28 Jan 2022 09:11:42 +0100
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 403C8258D2;
        Fri, 28 Jan 2022 08:11:41 +0000 (UTC)
Date:   Fri, 28 Jan 2022 09:11:33 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Stefan =?utf-8?B?TcOkdGpl?= <Stefan.Maetje@esd.eu>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "wg@grandegger.com" <wg@grandegger.com>
Subject: Re: [PATCH v6 0/4] can: esd: add support for esd GmbH PCIe/402 CAN
 interface
Message-ID: <20220128081133.xbiopzjag2lj4zgj@pengutronix.de>
References: <20211201220328.3079270-1-stefan.maetje@esd.eu>
 <20220125162507.sxjzjk5pqdpppxsl@pengutronix.de>
 <e9bf0faab0b38b28e68d6f6ed3d6a7f733aa5512.camel@esd.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ijyg6nxlalwhlvk2"
Content-Disposition: inline
In-Reply-To: <e9bf0faab0b38b28e68d6f6ed3d6a7f733aa5512.camel@esd.eu>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ijyg6nxlalwhlvk2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 27.01.2022 19:14:04, Stefan M=C3=A4tje wrote:
> > The kernel takes care of printing a error message in case the DMA mem
> > allocation fails. This is why checkpatch asks you to remove that messag=
e.
>=20
> I've triggered a kernel failure message for the DMA allocation by exceedi=
ng
> the DMA allocation limit. If you say it is clear from that message that t=
he
> DMA allocation fails (see included kernel messages below) I'll throw out =
the
> extra "DMA alloc failed" message from the esd_402_pci driver. The driver'=
s=20
> message is shown for both boards in my computer while the kernel message=
=20
> is printed only once.
>=20
> See the kernel messages below.

> [  778.083489] ------------[ cut here ]------------
> [  778.083490] WARNING: CPU: 0 PID: 24545 at mm/page_alloc.c:5344 __alloc=
_pages+0x292/0x330
> [  778.083496] Modules linked in: esd_402_pci(+) tcp_diag inet_diag unix_=
diag nfsv3 nfs_acl rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs
> lockd grace fscache netfs binfmt_misc nls_iso8859_1 intel_rapl_msr mei_hd=
cp intel_rapl_common snd_hda_codec_hdmi
> x86_pkg_temp_thermal intel_powerclamp snd_hda_codec_realtek snd_hda_codec=
_generic ledtrig_audio coretemp kvm_intel kvm
> crct10dif_pclmul ghash_clmulni_intel aesni_intel crypto_simd snd_hda_inte=
l snd_intel_dspcfg cryptd snd_intel_sdw_acpi rapl
> snd_hda_codec intel_cstate snd_hda_core esd_usb2 input_leds snd_hwdep snd=
_pcm snd_seq_midi snd_seq_midi_event snd_rawmidi i915
> serio_raw at24 efi_pstore video ttm snd_seq drm_kms_helper plx_pci sja100=
0 snd_seq_device cec snd_timer rc_core can_dev i2c_algo_bit
> snd fb_sys_fops syscopyarea sysfillrect mei_me sysimgblt soundcore mei ma=
c_hid sch_fq_codel msr parport_pc ppdev lp drm parport
> sunrpc ip_tables x_tables autofs4 gpio_ich crc32_pclmul psmouse i2c_i801 =
r8169 realtek ahci i2c_smbus libahci lpc_ich wmi
> [  778.083547]  [last unloaded: esd_402_pci]
> [  778.083549] CPU: 0 PID: 24545 Comm: modprobe Not tainted 5.16.0-rc7-gc=
c-9+ #2
> [  778.083551] Hardware name: Acer Veriton M2610G/Veriton M2610G, BIOS P0=
1-B1                  06/18/2012
> [  778.083553] RIP: 0010:__alloc_pages+0x292/0x330
> [  778.083556] Code: d4 89 94 7e 0f 85 3d ff ff ff e8 e8 ab d2 ff e9 33 f=
f ff ff e8 bf cf fb ff 48 89 c7 e9 a5 fe ff ff 41 81 e4 00
> 20 00 00 75 8e <0f> 0b eb 8a a9 00 00 08 00 75 6a 44 89 e1 80 e1 7f a9 00=
 00 04 00
> [  778.083557] RSP: 0018:ffffb4e84240b918 EFLAGS: 00010246
> [  778.083559] RAX: 0000000000000000 RBX: 0000000000000a24 RCX: 000000000=
0000000
> [  778.083561] RDX: 0000000000000000 RSI: 000000000000000c RDI: 000000000=
0000a24
> [  778.083562] RBP: ffffb4e84240b970 R08: 00000000ffffffff R09: 00000000f=
fffffff
> [  778.083563] R10: 0000000000000001 R11: 0000000000000001 R12: 000000000=
0000000
> [  778.083564] R13: 000000000000000c R14: ffff9a08c0e3d0d0 R15: 000000000=
1000000
> [  778.083565] FS:  00007f7d730df540(0000) GS:ffff9a09f7a00000(0000) knlG=
S:0000000000000000
> [  778.083567] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  778.083568] CR2: 00007ffe83526b40 CR3: 0000000008128006 CR4: 000000000=
00606f0
> [  778.083570] Call Trace:
> [  778.083571]  <TASK>
                  VVVVVVVVVVVVVVVVVVVVVVVV
> [  778.083574]  __dma_direct_alloc_pages+0x8e/0x120
> [  778.083578]  dma_direct_alloc+0x66/0x2a0
> [  778.083580]  dma_alloc_attrs+0x3e/0x50
                  ^^^^^^^^^^^^^^^
> [  778.083582]  pci402_probe+0x211/0x64a [esd_402_pci]
> [  778.083586]  ? kernfs_link_sibling+0x99/0xe0
> [  778.083590]  local_pci_probe+0x4b/0x90
> [  778.083594]  ? pci_match_device+0xde/0x130
> [  778.083597]  pci_device_probe+0xd8/0x1d0
> [  778.083600]  really_probe+0x1d2/0x3d0
> [  778.083604]  __driver_probe_device+0x109/0x180
> [  778.083607]  driver_probe_device+0x23/0xa0
> [  778.083610]  __driver_attach+0xbd/0x160
> [  778.083613]  ? __device_attach_driver+0xe0/0xe0
> [  778.083616]  bus_for_each_dev+0x7e/0xc0
> [  778.083619]  driver_attach+0x1e/0x20
> [  778.083621]  bus_add_driver+0x152/0x1f0
> [  778.083624]  driver_register+0x74/0xd0
> [  778.083626]  ? 0xffffffffc0c2e000
> [  778.083627]  __pci_register_driver+0x68/0x70
> [  778.083630]  pci402_driver_init+0x23/0x1000 [esd_402_pci]
> [  778.083633]  do_one_initcall+0x48/0x210
> [  778.083636]  ? kmem_cache_alloc_trace+0x32e/0x3f0
> [  778.083639]  do_init_module+0x62/0x250
> [  778.083641]  load_module+0x261c/0x2890
> [  778.083645]  __do_sys_finit_module+0xbf/0x120
> [  778.083646]  ? __do_sys_finit_module+0xbf/0x120
> [  778.083649]  __x64_sys_finit_module+0x1a/0x20
> [  778.083650]  do_syscall_64+0x3b/0xc0
> [  778.083654]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  778.083657] RIP: 0033:0x7f7d7322489d
> [  778.083658] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 4=
8 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b
> 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c3 f5 0c 00 f7 d8 64=
 89 01 48
> [  778.083660] RSP: 002b:00007ffe83529b68 EFLAGS: 00000246 ORIG_RAX: 0000=
000000000139
> [  778.083662] RAX: ffffffffffffffda RBX: 000055db638f40d0 RCX: 00007f7d7=
322489d
> [  778.083663] RDX: 0000000000000000 RSI: 000055db638f4730 RDI: 000000000=
0000003
> [  778.083664] RBP: 0000000000040000 R08: 0000000000000000 R09: 000000000=
0000000
> [  778.083665] R10: 0000000000000003 R11: 0000000000000246 R12: 000055db6=
38f4730
> [  778.083666] R13: 0000000000000000 R14: 000055db638f43e0 R15: 000055db6=
38f40d0
> [  778.083669]  </TASK>
> [  778.083670] ---[ end trace 8ac4b05d87d41ee5 ]---
> [  778.083671] esd_402_pci 0000:01:00.0: DMA alloc failed!
> [  778.083710] esd_402_pci: probe of 0000:01:00.0 failed with error -12
> [  778.095803] esd_402_pci 0000:05:00.0: ESDACC v72, freq: 80000000/80000=
000, feat/strap: 0x3c90/0x3d, cores: 2/4
> [  778.095810] acc_init_ov:146: esd_402_pci 0000:05:00.0: ESDACC ts2ns: n=
umerator 25, denominator 2
> [  778.095812] esd_402_pci 0000:05:00.0: ESDACC with CAN-FD feature detec=
ted. This driver doesn't support CAN-FD yet.
> [  778.095822] esd_402_pci 0000:05:00.0: DMA alloc failed!
> [  778.095882] esd_402_pci: probe of 0000:05:00.0 failed with error -12

Looking at the back trace, at least to a kernel developer, it's clear
that this is DMA allocation failure.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ijyg6nxlalwhlvk2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmHzpTMACgkQqclaivrt
76movgf9EDzUr/Zvh/6zNhh7L2/8fuIDzlIsqssKlrrhEB71B3GVdtg28lsTEdA8
RTSDlH6Ck9ow6PypnQiFJ/69JS5hJaPJKUO7kilP9l+LUKRq+ZaRuuXh9uweX00W
WJfAZNNgqCLlrIA3o7GxxyWOAe+EuVif17hJDsYTV9RMle92ai7iQ/vXkae7M4Fo
maMdhKpCTWMj2+umzboi6pN5dz7nCtYm+zuUxJQt2gIHUnRH18i03lnzsJ6SXy+s
yIJLItOuJ/xKpvxriOj8zxFsL9aXcUKf7lb6rU4usheNmsrb0bZv8uMqPXdg96Wf
fCVRMBfcoqeLTd9Vi0Ia4Rf0359pAw==
=oEGA
-----END PGP SIGNATURE-----

--ijyg6nxlalwhlvk2--
