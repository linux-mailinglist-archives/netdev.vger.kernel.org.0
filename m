Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB7755B6D1C
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 14:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbiIMMXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 08:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbiIMMXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 08:23:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B856D2E9E1
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 05:23:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B55B6145E
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 12:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02BF2C433C1;
        Tue, 13 Sep 2022 12:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663071795;
        bh=Ak4AMOcDKNoGI3Ras7I6sPVxXlXLSX+FHrWeFlXHJ/A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sFOswE4MWDm/SQ0dc+tkISLbVqwmZRWnOJ5gbvnCHIotuEwIYm3E/AOZTwwHoi+MS
         Cw3VS7ImTKXZY6S0uwj+E/Jy3yCjMdHxXs49nEVr7ndz9topDYSvXrquZ50c1r4Yl4
         jQAKNef7PVHvTjN/16KZ2mDrVWqb5oWHoYPsjJn9yhFMLxizP3Nc3JiLdPCPLYLJlU
         HcPAYR/uXGGKaZyrDpQ4kn6jhtLZ0uNh4nyYYQBbpQY4mIcjmN6xpSR5dsVdnI9yZ8
         IC9Uj4b4gKaiOCGU4BP9ip/1CQN0EatJYpaJfdJg7KNIPWGZvIhzE7plV0Idt4Mjmr
         7uM5h6RpDHFhg==
Date:   Tue, 13 Sep 2022 14:23:11 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        netdev <netdev@vger.kernel.org>, paulmck@kernel.org
Subject: Re: mtk_eth_soc for mt7621 won't work after 6.0-rc1
Message-ID: <YyB2L8dfnJfnrqWI@lore-desk>
References: <Yx8thSbBKJhxv169@lore-desk>
 <Yx9z9Dm4vJFxGaJI@lore-desk>
 <170d725f-2146-f1fa-e570-4112972729df@arinc9.com>
 <Yx+W9EoEfoRsq1rt@lore-desk>
 <CAMhs-H8wWNrqb0RgQdcL4J+=oGws8pB8Uv_H=6Q8AyzXDgF89Q@mail.gmail.com>
 <CAMhs-H8Wsin67gTLPfv9x=hHM-prz4YYensNtyc=hZx+s4d=9Q@mail.gmail.com>
 <10e9ead9-5adc-5065-0c13-702aabd5dcb0@arinc9.com>
 <YyBibTHeSxwa31Cm@lore-desk>
 <CAMhs-H_oe-pCBBTDQT_uzyEYUoSvJB=DveZpyUUmdB2Sz--Hww@mail.gmail.com>
 <693820e5-5e8c-fc36-5e5e-f7ca3bdcce72@arinc9.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dgOMXX22+ioQHa3u"
Content-Disposition: inline
In-Reply-To: <693820e5-5e8c-fc36-5e5e-f7ca3bdcce72@arinc9.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--dgOMXX22+ioQHa3u
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 13.09.2022 14:07, Sergio Paracuellos wrote:
> > Hi Lorenzo,
> >=20
> > On Tue, Sep 13, 2022 at 12:58 PM Lorenzo Bianconi <lorenzo@kernel.org> =
wrote:
> > >=20
> > > > On 13.09.2022 11:31, Sergio Paracuellos wrote:
> > > > > Hi Lorenzo,
> > > > >=20
> > > > > On Tue, Sep 13, 2022 at 5:32 AM Sergio Paracuellos
> > > > > <sergio.paracuellos@gmail.com> wrote:
> > > > > >=20
> > > > > > Hi Lorenzo,
> > > > > >=20
> > > > > > On Mon, Sep 12, 2022 at 10:30 PM Lorenzo Bianconi <lorenzo@kern=
el.org> wrote:
> > > > > > >=20
> > > > > > > > Hi Lorenzo,
> > > > > > > >=20
> > > > > > > > On 12.09.2022 21:01, Lorenzo Bianconi wrote:
> > > > > > > > > > > Ethernet for MT7621 SoCs no longer works after change=
s introduced to
> > > > > > > > > > > mtk_eth_soc with 6.0-rc1. Ethernet interfaces initial=
ise fine. Packets are
> > > > > > > > > > > sent out from the interface fine but won't be receive=
d on the interface.
> > > > > > > > > > >=20
> > > > > > > > > > > Tested with MT7530 DSA switch connected to gmac0 and =
ICPlus IP1001 PHY
> > > > > > > > > > > connected to gmac1 of the SoC.
> > > > > > > > > > >=20
> > > > > > > > > > > Last working kernel is 5.19. The issue is present on =
6.0-rc5.
> > > > > > > > > > >=20
> > > > > > > > > > > Ar=C4=B1n=C3=A7
> > > > > > > > > >=20
> > > > > > > > > > Hi Ar=C4=B1n=C3=A7,
> > > > > > > > > >=20
> > > > > > > > > > thx for testing and reporting the issue. Can you please=
 identify
> > > > > > > > > > the offending commit running git bisect?
> > > > > > > > > >=20
> > > > > > > > > > Regards,
> > > > > > > > > > Lorenzo
> > > > > > > > >=20
> > > > > > > > > Hi Ar=C4=B1n=C3=A7,
> > > > > > > > >=20
> > > > > > > > > just a small update. I tested a mt7621 based board (Buffa=
lo WSR-1166DHP) with
> > > > > > > > > OpenWrt master + my mtk_eth_soc series and it works fine.=
 Can you please
> > > > > > > > > provide more details about your development board/environ=
ment?
> > > > > > > >=20
> > > > > > > > I've got a GB-PC2, Sergio has got a GB-PC1. We both use Nei=
l's gnubee-tools
> > > > > > > > which makes an image with filesystem and any Linux kernel o=
f choice with
> > > > > > > > slight modifications (maybe not at all) on the kernel.
> > > > > > > >=20
> > > > > > > > https://github.com/neilbrown/gnubee-tools
> > > > > > > >=20
> > > > > > > > Sergio experiences the same problem on GB-PC1.
> > > > > > >=20
> > > > > > > ack, can you please run git bisect in order to identify the o=
ffending commit?
> > > > > > > What is the latest kernel version that is working properly? 5=
=2E19.8?
> > > > > >=20
> > > > > > I'll try to get time today to properly bisect and identify the
> > > > > > offending commit. I get a working platform with 5.19.8, yes but=
 with
> > > > > > v6-rc-1 my network is totally broken.
> > > > >=20
> > > > > + [cc: Paul E. McKenney <paulmck@kernel.org> as commit author]
> > > > >=20
> > > > > Ok, so I have bisected the issue to:
> > > > > 1cf1144e8473e8c3180ac8b91309e29b6acfd95f] rcu-tasks: Be more pati=
ent
> > > > > for RCU Tasks boot-time testing
> > > > >=20
> > > > > This is the complete bisect log:
> > > > >=20
> > > > > $ git bisect log
> > > > > git bisect start
> > > > > # good: [70cb6afe0e2ff1b7854d840978b1849bffb3ed21] Linux 5.19.8
> > > > > git bisect good 70cb6afe0e2ff1b7854d840978b1849bffb3ed21
> > > > > # bad: [568035b01cfb107af8d2e4bd2fb9aea22cf5b868] Linux 6.0-rc1
> > > > > git bisect bad 568035b01cfb107af8d2e4bd2fb9aea22cf5b868
> > > > > # good: [3d7cb6b04c3f3115719235cc6866b10326de34cd] Linux 5.19
> > > > > git bisect good 3d7cb6b04c3f3115719235cc6866b10326de34cd
> > > > > # bad: [b44f2fd87919b5ae6e1756d4c7ba2cbba22238e1] Merge tag
> > > > > 'drm-next-2022-08-03' of git://anongit.freedesktop.org/drm/drm
> > > > > git bisect bad b44f2fd87919b5ae6e1756d4c7ba2cbba22238e1
> > > > > # bad: [526942b8134cc34d25d27f95dfff98b8ce2f6fcd] Merge tag
> > > > > 'ata-5.20-rc1' of
> > > > > git://git.kernel.org/pub/scm/linux/kernel/git/dlemoal/libata
> > > > > git bisect bad 526942b8134cc34d25d27f95dfff98b8ce2f6fcd
> > > > > # good: [2e7a95156d64667a8ded606829d57c6fc92e41df] Merge tag
> > > > > 'regmap-v5.20' of
> > > > > git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap
> > > > > git bisect good 2e7a95156d64667a8ded606829d57c6fc92e41df
> > > > > # good: [c013d0af81f60cc7dbe357c4e2a925fb6738dbfe] Merge tag
> > > > > 'for-5.20/block-2022-07-29' of git://git.kernel.dk/linux-block
> > > > > git bisect good c013d0af81f60cc7dbe357c4e2a925fb6738dbfe
> > > > > # bad: [aad26f55f47a33d6de3df65f0b18e2886059ed6d] Merge tag 'docs=
-6.0'
> > > > > of git://git.lwn.net/linux
> > > > > git bisect bad aad26f55f47a33d6de3df65f0b18e2886059ed6d
> > > > > # good: [c2a24a7a036b3bd3a2e6c66730dfc777cae6540a] Merge tag
> > > > > 'v5.20-p1' of git://git.kernel.org/pub/scm/linux/kernel/git/herbe=
rt/crypto-2.6
> > > > > git bisect good c2a24a7a036b3bd3a2e6c66730dfc777cae6540a
> > > > > # bad: [34bc7b454dc31f75a0be7ee8ab378135523d7c51] Merge branch
> > > > > 'ctxt.2022.07.05a' into HEAD
> > > > > git bisect bad 34bc7b454dc31f75a0be7ee8ab378135523d7c51
> > > > > # bad: [e72ee5e1a866b85cb6c3d4c80a1125976020a7e8] rcu-tasks: Use
> > > > > delayed_work to delay rcu_tasks_verify_self_tests()
> > > > > git bisect bad e72ee5e1a866b85cb6c3d4c80a1125976020a7e8
> > > > > # good: [f90f19da88bfe32dd1fdfd104de4c0526a3be701] rcu-tasks: Mak=
e RCU
> > > > > Tasks Trace stall warning handle idle offline tasks
> > > > > git bisect good f90f19da88bfe32dd1fdfd104de4c0526a3be701
> > > > > # good: [dc7d54b45170e1e3ced9f86718aa4274fd727790] rcu-tasks: Pul=
l in
> > > > > tasks blocked within RCU Tasks Trace readers
> > > > > git bisect good dc7d54b45170e1e3ced9f86718aa4274fd727790
> > > > > # good: [e386b6725798eec07facedf4d4bb710c079fd25c] rcu-tasks:
> > > > > Eliminate RCU Tasks Trace IPIs to online CPUs
> > > > > git bisect good e386b6725798eec07facedf4d4bb710c079fd25c
> > > > > # good: [eea3423b162d5d5cdc08af23e8ee2c2d1134fd07] rcu-tasks: Upd=
ate comments
> > > > > git bisect good eea3423b162d5d5cdc08af23e8ee2c2d1134fd07
> > > > > # bad: [1cf1144e8473e8c3180ac8b91309e29b6acfd95f] rcu-tasks: Be m=
ore
> > > > > patient for RCU Tasks boot-time testing
> > > > > git bisect bad 1cf1144e8473e8c3180ac8b91309e29b6acfd95f
> > > > > # first bad commit: [1cf1144e8473e8c3180ac8b91309e29b6acfd95f]
> > > > > rcu-tasks: Be more patient for RCU Tasks boot-time testing
> > > > >=20
> > > > > I don't really understand the relationship with my broken network
> > > > > issue. I am using debian buster and the effect I see is that when=
 the
> > > > > network interface becomes up it hangs waiting for a "task running=
 to
> > > > > raise network interfaces". After about one minute the system boot=
s,
> > > > > the login prompt is shown but I cannot configure at all network
> > > > > interfaces: dhclient does not respond and manually ifconfig does =
not
> > > > > help also:
> > > > >=20
> > > > > root@gnubee:~#
> > > > > root@gnubee:~# dhclient ethblack
> > > > > ^C
> > > > > root@gnubee:~# ifconfig ethblack 192.168.1.101
> > > > > root@gnubee:~# ping 19^C
> > > > > root@gnubee:~# ping 192.168.1.47
> > > > > PING 192.168.1.47 (192.168.1.47) 56(84) bytes of data.
> > > > > ^C
> > > > > --- 192.168.1.47 ping statistics ---
> > > > > 3 packets transmitted, 0 received, 100% packet loss, time 120ms
> > > > >=20
> > > > > I have tried to revert the bad commit directly in v6.0-rc1 but
> > > > > conflicts appeared with the git revert command in
> > > > > 'kernel/rcu/tasks.h', so I am not sure what I can do now.
> > > >=20
> > > > I've pinpointed the issue to 23233e577ef973c2c5d0dd757a0a4605e34ecb=
57 ("net:
> > > > ethernet: mtk_eth_soc: rely on page_pool for single page buffers").=
 Ethernet
> > > > works fine after reverting this and newer commits for mtk_eth_soc.
> > >=20
> > > Hi Ar=C4=B1n=C3=A7,
> > >=20
> > > yes, I run some bisect here as well and this seems the offending comm=
it. Can
> > > you please try the patch below?
> > >=20
> > > Regards,
> > > Lorenzo
> > >=20
> > > diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/ne=
t/ethernet/mediatek/mtk_eth_soc.c
> > > index ec617966c953..67a64a2272b9 100644
> > > --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > > +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > > @@ -1470,7 +1470,7 @@ static void mtk_update_rx_cpu_idx(struct mtk_et=
h *eth)
> > >=20
> > >   static bool mtk_page_pool_enabled(struct mtk_eth *eth)
> > >   {
> > > -       return !eth->hwlro;
> > > +       return MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2);
> > >   }
> > >=20
> > >   static struct page_pool *mtk_create_page_pool(struct mtk_eth *eth,
> >=20
> > I have applied this patch on the top of v6-0-rc5 and the network is
> > back, so this patch seems to fix the network issue for my GNUBee pC1:
> >=20
> > Tested-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
>=20
> Can confirm the same behaviour on my GB-PC2.
>=20
> Tested-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>

I debugged a bit more the problem and the issue is due to a 2 bytes alignme=
nt
introduced by mt7621 on packet data.
Since mt7621 is a low-end SoC and I do not have other SoCs for testing, I w=
ill
enable xdp support just for MT7986 for the moment. Thanks a lot for reporti=
ng the
issue and for testing.

Regards,
Lorenzo

>=20
> Ar=C4=B1n=C3=A7

--dgOMXX22+ioQHa3u
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYyB2LwAKCRA6cBh0uS2t
rBk+AQDleg4TIm5HaxETcNIlMGj0yvLG2miE+nc3m5O7RXDn5AEAkEcTA9AzWbbj
NQ+dIiwmSMjBlasz6OJxPvLLhAbGUwc=
=jg4x
-----END PGP SIGNATURE-----

--dgOMXX22+ioQHa3u--
