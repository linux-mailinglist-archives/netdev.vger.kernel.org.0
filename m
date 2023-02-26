Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08CB06A335E
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 19:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjBZSHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 13:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjBZSHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 13:07:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D51EB5D;
        Sun, 26 Feb 2023 10:06:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41C92B80B46;
        Sun, 26 Feb 2023 18:06:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780EEC433EF;
        Sun, 26 Feb 2023 18:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677434815;
        bh=Kg+gYcfpIk7Nt4ziTYJzcIX74yPknW+88qVZ6L234IM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TQ6z14/Zw5UgyYqvy+Ixfip3pdiNZJdngIwjFwAWrcqtdkN2/gjm8olPrvNkLzPg7
         pVw4pLJXCPpxsJLBzQzmO0kxKvtqcPFupdFPxT1UR+bsTh9BfQpkDoMTsxKzXiWDhV
         z6oEFaeE/pG17rUJNAFzTGSMdMBfTv88pEsxmEU+P0ZozdTLz4qm8AF76zAgFG/ZpW
         TFfc9IJhZzf1nzsy0ljQawVSt5lMo2VYucMTSkcorCbtPo4LzhFbTnRq78QK5aTBrr
         KmnTiMAIPk95d8YP6RI2eV0MzUKkqmPtfya9HQAmLG/OnGMcCBA25lc+YYViTN2x1y
         u5g5zw+D09vAg==
Date:   Sun, 26 Feb 2023 18:06:48 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        Jose Abreu <joabreu@synopsys.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: [PATCH net-next v8 5/9] net: phy: add
 genphy_c45_ethtool_get/set_eee() support
Message-ID: <Y/ufuLJdMcxc6f47@sirena.org.uk>
References: <20230211074113.2782508-1-o.rempel@pengutronix.de>
 <20230211074113.2782508-6-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lWNhffqPlhkr2Cm1"
Content-Disposition: inline
In-Reply-To: <20230211074113.2782508-6-o.rempel@pengutronix.de>
X-Cookie: A watched clock never boils.
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--lWNhffqPlhkr2Cm1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 11, 2023 at 08:41:09AM +0100, Oleksij Rempel wrote:
> Add replacement for phy_ethtool_get/set_eee() functions.
>=20
> Current phy_ethtool_get/set_eee() implementation is great and it is
> possible to make it even better:
> - this functionality is for devices implementing parts of IEEE 802.3
>   specification beyond Clause 22. The better place for this code is
>   phy-c45.c

Currently mainline is failing to bring up networking on the Libre
Computer AML-S905X-CC, with a bisect pointing at this commit,
022c3f87f88 upstream (although I'm not 100% sure I trust the bisect it
seems to be in roughly the right place).  I've not dug into what's going
on more than running the bisect yet.

The boot dies with:

[   15.532108] meson8b-dwmac c9410000.ethernet end0: Register
M the information provided will be safe.
[   15.569305] meson8b-dwmac c9410000.ethernet end0: PHY [mdio_mux-0.e40908=
ff:08] driver [Meson GXL Internal PHY] (irq=3D45)
[   15.585168] meson8b-dwmac c9410000.ethernet end0: No Safety Features sup=
port found
[   15.587169] meson8b-dwmac c9410000.ethernet end0: PTP not supported by HW
[   15.594673] meson8b-dwmac c9410000.ethernet end0: configuring for phy/rm=
ii link mode
[   15.601802] ------------[ cut here ]---------that are being provided
--- [   15.606093] WARNING: CPU: 1 PID: 57 at drivers/net/phy/phy.c:1168
phy_error+0x14/0x60 [   15.613854] Modules linked in: snd_soc_hdmi_codec
dw_hdmi_i2s_audio meson_gxl dwmac_generic meson_drm lima
drm_shmem_helper gpu_sched dwmac_meson8b stmmac_platform crct10dif_ce
stmmac amlogic_gxl_crypto pcs_xpcs drm_dma_helper crypto_engine
meson_canvas meson_gxbb_wdt meson_rng meson_dw_hdmi rng_core dw_hdmi cec
drm_display_helper meson_ir rc_core snd_soc_meson_aiu
snd_soc_meson_codec_glue snd_soc_meson_t9015 snd_soc_meson_gx_sound_card
snd_soc_meson_card_utils snd_soc_simple_amplifier display_conne
drm_kms_helper drm nvmem_meson_efuse [   15.661291] CPU: 1 PID: 57 Comm:
kworker/u8:2 Not tainted 6.2.0-rc7-01626-g8b68710a3121 #10
[   15.669568] Hardware name: Libre Computer AML-S905X-CC (DT)
[   15.675090] Workqueue: events_power_efficient phy_state_machine
[   15.680954] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[   15.687853] pc : phy_error+0x14/0x60
[   15.691389] lr : phy_state_machine+0xa0/0x280
[   15.695701] sp : ffff80000a8a3d40
[   15.698979] x29: ffff80000a8a3d40 x28: 0000000000000000 x27: 00000000000=
00000
[   15.706051] x26: ffff80000a170000 x25: ffff00007ba884b0 x24: ffff0000010=
09105
[   15.713124] x23: 00000000ffffffa1 x22: ffff00007ba884a8 x21: ffff00007ba=
88500
[   15.720196] x20: 0000000000000003 x19: ffff00007ba88000 x18: 00000000000=
00000
[   15.727269] x17: 0000000000000000 x16: 0000000000000000 x15: 00000000000=
00000
[   15.734341] x14: 00000000000001d6 x13: 00000000000001d6 x12: 00000000000=
00001
[   15.741414] x11: 0000000000000001 x10: ffff00007ba88420 x9 : ffff00007ba=
88418
[   15.748487] x8 : 0000000000000000 x7 : 0000000000000020 x6 : 00000000000=
00040
[   15.755559] x5 : 0000000000000000 x4 : 0000000000000000 x3 : ffff00007ba=
88500
[   15.762631] x2 : 0000000000000000 x1 : ffff000001105700 x0 : ffff00007ba=
88000
[   15.769705] Call trace:
[   15.772120]  phy_error+0x14/.  It didn't really cross my mind that
something would be hard coded like this.
[   15.786868]  kthread+0x108/0x10c
[   15.790059]  ret_from_fork+0x10/0x20
[   15.793596] ---[ end trace 0000000000000000 ]---

followed by there being no network so no NFS root.  Bisect log:

git bisect start
# good: [c9c3395d5e3dcc6daee66c6908354d47bf98cb0c] Linux 6.2
git bisect good c9c3395d5e3dcc6daee66c6908354d47bf98cb0c
# bad: [2fcd07b7ccd5fd10b2120d298363e4e6c53ccf9c] mm/mprotect: Fix successf=
ul vma_merge() of next in do_mprotect_pkey()
git bisect bad 2fcd07b7ccd5fd10b2120d298363e4e6c53ccf9c
# bad: [d5176cdbf64ce7d4eebfbec23118e9f72] Merge tag 'pinctrl-v6.3-1' of
# git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl
git bisect bad d5176cdbf64ce7d4eebf339205f17c23118e9f72
# skip: [69308402ca6f5b80a5a090ade0b13bd146891420] Merge tag
# 'platform-drivers-x86-v6.3-1' of
# git://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x86
git bisect skip 69308402ca6f5b80a5a090ade0b13bd146891420
# good: [bc61761394ce0f0cc35c6fc60426f08d83d0d488] ipv6: ICMPV6: Use
# swap() instead of open coding it
git bisect good bc61761394ce0f0cc35c6fc60426f08d83d0d488
# good: [1b72607d7321e66829e11148712b3a2ba1dc83e7] Merge tag 'thermal-6.3-r=
c1' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
git bisect good 1b72607d7321e66829e11148712b3a2ba1dc83e7
# bad: [d1fabc68f8e0541d41657096dc713cb01775652d] Merge git://git.kernel.or=
g/pub/scm/linux/kernel/git/netdev/net
git bisect bad d1fabc68f8e0541d41657096dc713cb01775652d
# good: [31de4105f00d64570139bc5494a20 after figuring out what system
# it's on1b0bdf] bpf: Add BPF_FIB_LOOKUP_SKIP_NEIGH for bpf_fib_lookup
git bisect good 31de4105f00d64570139bc5494a201b0bd57349f
# good: [1a30a6b25f263686dbf2028d56041ac012b10dcb] wifi: brcmfmac: p2p:.
git bisect good 1a30a6b25f263686dbf2028d56041ac012b10dcb
# bad: [14743ddd2495c96caa18e382625c034e49a812e2] sfc: add devlink info sup=
port for ef100
git bisect bad 14743ddd2495c96caa18e382625c034e49a812e2
# bad: [1daa8e25ed971eca8cd8c8dfd4d6d6541b1d62a2] Merge branch 'net-make-ko=
bj_type-structures-constant'
git bisect bad 1daa8e25ed971eca8cd8c8dfd4d6d6541b1d62a2
# bad: [1daa8e25ed971eca8cd8c8dfd4d6d6541b1d62a2] Merge branch 'net-make-ko=
bj_type-structures-constant'
git bisect bad 1daa8e25ed971eca8cd8c8dfd4d6d6541b1d62a2
# good: [75da437a2f172759b227309 (or whatever)1a938772e687242d0] Merge
# branch '40GbE' of
# git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
git bisect good 75da437a2f172759b2273091a938772e687242d0
# bad: [8b68710a3121e0475b123a20c4220f66a728770e] net: phy: start using gen=
phy_c45_ethtool_get/set_eee()
git bisect bad 8b68710a3121e0475b123a20c4220f66a728770e
# good: [d1ce6395d4648b41cf762714934e34ae57f0d1a4] net: ipa: define IPA v3.=
1 GSI event ring register offsets
git bisect good d1ce6395d4648b41cf762714934e34ae57f0d1a4
# good: [79cdf17e5131ccdee0792f6f25d3db0e34861998] Merge branch 'ionic-on-c=
hip-desc'
git bisect good 79cdf17e5131ccdee0792f6f25d3db0e34861998
# bad: [ when the device is
# registered022c3f87f88e2d68e90be7687d981c9cb893a3b1] net: phy: add
# genphy_c45_ethtool_get/set_eee() support
git bisect bad 022c3f87f88e2d68e90be7687d981c9cb893a3b1
# good: [14e47d1fb8f9596acc90a06a66808657a9c512b5] net: phy: add
# genphy_c45_read_eee_abilities() function
git bisect good 14e47d1fb8f9596acc90a06a66808657a9c512b5
# good: [48fb19940f2ba6b50dfea70f671be9340fb63d60] net: phy: micrel: add ks=
z9477_get_features()
git bisect good cf9f6079696840093aa6ea3c0ee405a553afe2fb
# first bad commit: [022c3f87f88e2d68e90be7687d981c9cb893a3b1] net: phy: ad=
d genphy_c45_ethtool_get/set_eee() support
=20

--lWNhffqPlhkr2Cm1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmP7n7cACgkQJNaLcl1U
h9CmIwf/a0wgHyuYNhXCytU+4OpEAgJjJ9LJOxlb7jZqK0SdM20sh2/TLFQ43RSr
DFkeGFEORz/BCjPizy15ix+QpBzNfYjJmIxbyH5BY4dZSLZrRtSlz6m6U4jhZquC
ZW6F/7bXqDJL7/dflizLk4bkADFEcAppcUCn0l43HuGALn85OSoJWOQ+9rEyTTi3
XFrn3gqjeGQNsCjTCeaiPA4S7tXNRQ4JNuowJRa1OXmsfteF7iUpIo/Y8E93F2t6
EQT9c1SdrrEXtvywAEx1w5EB3OAMQ0pnCGsH5blWvu2v+3KRDp2wITnFnp7jBxf5
2YmAfcJz4M6ZwR7Wr5FsUfGqQrG+xg==
=AOKL
-----END PGP SIGNATURE-----

--lWNhffqPlhkr2Cm1--
