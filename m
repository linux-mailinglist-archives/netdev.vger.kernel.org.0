Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76715B6C1C
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 12:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbiIMK7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 06:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231847AbiIMK7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 06:59:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8885F220
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 03:58:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A9B761411
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 10:58:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77859C433C1;
        Tue, 13 Sep 2022 10:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663066736;
        bh=7+67DRSVs56EtHWMsz0otgv7cz8+eKIZzurpMGqCAgg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GIp1O41ArUr+E+QHvqOpkd7tDETbuFoE9k7JIf9hVOeJpcTFcjR2+Cvgr5TvRW2Xi
         dJfcl4YukhLMByma76Tpl/Mg2FPV7MGA00LpI+sHxPXie2rL0vJnPtT9xOr1Aq/SSc
         nJwn3LPe0A3a3lIQSJD36G2Suc56SP94KlM1lEmRIAIQdnuJREmAM80ddqMmrh81B4
         6quvfrmOr1JGk2N8iPlDKOpzVCsv3uPMU9Tt8DiwlVxOWVHxRuq7b7Y+44+Rrjy3Q5
         MQZI4CPjiNJzH75Xr14Bp8nCurNLXZrQ4mcL+MMbftKdlNwEouNWdWnaHd3YMFt5gT
         AfXqNAEJBJ8/Q==
Date:   Tue, 13 Sep 2022 12:58:53 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        netdev <netdev@vger.kernel.org>, paulmck@kernel.org
Subject: Re: mtk_eth_soc for mt7621 won't work after 6.0-rc1
Message-ID: <YyBibTHeSxwa31Cm@lore-desk>
References: <146b9607-ba1e-c7cf-9f56-05021642b320@arinc9.com>
 <Yx8thSbBKJhxv169@lore-desk>
 <Yx9z9Dm4vJFxGaJI@lore-desk>
 <170d725f-2146-f1fa-e570-4112972729df@arinc9.com>
 <Yx+W9EoEfoRsq1rt@lore-desk>
 <CAMhs-H8wWNrqb0RgQdcL4J+=oGws8pB8Uv_H=6Q8AyzXDgF89Q@mail.gmail.com>
 <CAMhs-H8Wsin67gTLPfv9x=hHM-prz4YYensNtyc=hZx+s4d=9Q@mail.gmail.com>
 <10e9ead9-5adc-5065-0c13-702aabd5dcb0@arinc9.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="VO0tgpHQDFf3zU3/"
Content-Disposition: inline
In-Reply-To: <10e9ead9-5adc-5065-0c13-702aabd5dcb0@arinc9.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--VO0tgpHQDFf3zU3/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 13.09.2022 11:31, Sergio Paracuellos wrote:
> > Hi Lorenzo,
> >=20
> > On Tue, Sep 13, 2022 at 5:32 AM Sergio Paracuellos
> > <sergio.paracuellos@gmail.com> wrote:
> > >=20
> > > Hi Lorenzo,
> > >=20
> > > On Mon, Sep 12, 2022 at 10:30 PM Lorenzo Bianconi <lorenzo@kernel.org=
> wrote:
> > > >=20
> > > > > Hi Lorenzo,
> > > > >=20
> > > > > On 12.09.2022 21:01, Lorenzo Bianconi wrote:
> > > > > > > > Ethernet for MT7621 SoCs no longer works after changes intr=
oduced to
> > > > > > > > mtk_eth_soc with 6.0-rc1. Ethernet interfaces initialise fi=
ne. Packets are
> > > > > > > > sent out from the interface fine but won't be received on t=
he interface.
> > > > > > > >=20
> > > > > > > > Tested with MT7530 DSA switch connected to gmac0 and ICPlus=
 IP1001 PHY
> > > > > > > > connected to gmac1 of the SoC.
> > > > > > > >=20
> > > > > > > > Last working kernel is 5.19. The issue is present on 6.0-rc=
5.
> > > > > > > >=20
> > > > > > > > Ar=C4=B1n=C3=A7
> > > > > > >=20
> > > > > > > Hi Ar=C4=B1n=C3=A7,
> > > > > > >=20
> > > > > > > thx for testing and reporting the issue. Can you please ident=
ify
> > > > > > > the offending commit running git bisect?
> > > > > > >=20
> > > > > > > Regards,
> > > > > > > Lorenzo
> > > > > >=20
> > > > > > Hi Ar=C4=B1n=C3=A7,
> > > > > >=20
> > > > > > just a small update. I tested a mt7621 based board (Buffalo WSR=
-1166DHP) with
> > > > > > OpenWrt master + my mtk_eth_soc series and it works fine. Can y=
ou please
> > > > > > provide more details about your development board/environment?
> > > > >=20
> > > > > I've got a GB-PC2, Sergio has got a GB-PC1. We both use Neil's gn=
ubee-tools
> > > > > which makes an image with filesystem and any Linux kernel of choi=
ce with
> > > > > slight modifications (maybe not at all) on the kernel.
> > > > >=20
> > > > > https://github.com/neilbrown/gnubee-tools
> > > > >=20
> > > > > Sergio experiences the same problem on GB-PC1.
> > > >=20
> > > > ack, can you please run git bisect in order to identify the offendi=
ng commit?
> > > > What is the latest kernel version that is working properly? 5.19.8?
> > >=20
> > > I'll try to get time today to properly bisect and identify the
> > > offending commit. I get a working platform with 5.19.8, yes but with
> > > v6-rc-1 my network is totally broken.
> >=20
> > + [cc: Paul E. McKenney <paulmck@kernel.org> as commit author]
> >=20
> > Ok, so I have bisected the issue to:
> > 1cf1144e8473e8c3180ac8b91309e29b6acfd95f] rcu-tasks: Be more patient
> > for RCU Tasks boot-time testing
> >=20
> > This is the complete bisect log:
> >=20
> > $ git bisect log
> > git bisect start
> > # good: [70cb6afe0e2ff1b7854d840978b1849bffb3ed21] Linux 5.19.8
> > git bisect good 70cb6afe0e2ff1b7854d840978b1849bffb3ed21
> > # bad: [568035b01cfb107af8d2e4bd2fb9aea22cf5b868] Linux 6.0-rc1
> > git bisect bad 568035b01cfb107af8d2e4bd2fb9aea22cf5b868
> > # good: [3d7cb6b04c3f3115719235cc6866b10326de34cd] Linux 5.19
> > git bisect good 3d7cb6b04c3f3115719235cc6866b10326de34cd
> > # bad: [b44f2fd87919b5ae6e1756d4c7ba2cbba22238e1] Merge tag
> > 'drm-next-2022-08-03' of git://anongit.freedesktop.org/drm/drm
> > git bisect bad b44f2fd87919b5ae6e1756d4c7ba2cbba22238e1
> > # bad: [526942b8134cc34d25d27f95dfff98b8ce2f6fcd] Merge tag
> > 'ata-5.20-rc1' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/dlemoal/libata
> > git bisect bad 526942b8134cc34d25d27f95dfff98b8ce2f6fcd
> > # good: [2e7a95156d64667a8ded606829d57c6fc92e41df] Merge tag
> > 'regmap-v5.20' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap
> > git bisect good 2e7a95156d64667a8ded606829d57c6fc92e41df
> > # good: [c013d0af81f60cc7dbe357c4e2a925fb6738dbfe] Merge tag
> > 'for-5.20/block-2022-07-29' of git://git.kernel.dk/linux-block
> > git bisect good c013d0af81f60cc7dbe357c4e2a925fb6738dbfe
> > # bad: [aad26f55f47a33d6de3df65f0b18e2886059ed6d] Merge tag 'docs-6.0'
> > of git://git.lwn.net/linux
> > git bisect bad aad26f55f47a33d6de3df65f0b18e2886059ed6d
> > # good: [c2a24a7a036b3bd3a2e6c66730dfc777cae6540a] Merge tag
> > 'v5.20-p1' of git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cry=
pto-2.6
> > git bisect good c2a24a7a036b3bd3a2e6c66730dfc777cae6540a
> > # bad: [34bc7b454dc31f75a0be7ee8ab378135523d7c51] Merge branch
> > 'ctxt.2022.07.05a' into HEAD
> > git bisect bad 34bc7b454dc31f75a0be7ee8ab378135523d7c51
> > # bad: [e72ee5e1a866b85cb6c3d4c80a1125976020a7e8] rcu-tasks: Use
> > delayed_work to delay rcu_tasks_verify_self_tests()
> > git bisect bad e72ee5e1a866b85cb6c3d4c80a1125976020a7e8
> > # good: [f90f19da88bfe32dd1fdfd104de4c0526a3be701] rcu-tasks: Make RCU
> > Tasks Trace stall warning handle idle offline tasks
> > git bisect good f90f19da88bfe32dd1fdfd104de4c0526a3be701
> > # good: [dc7d54b45170e1e3ced9f86718aa4274fd727790] rcu-tasks: Pull in
> > tasks blocked within RCU Tasks Trace readers
> > git bisect good dc7d54b45170e1e3ced9f86718aa4274fd727790
> > # good: [e386b6725798eec07facedf4d4bb710c079fd25c] rcu-tasks:
> > Eliminate RCU Tasks Trace IPIs to online CPUs
> > git bisect good e386b6725798eec07facedf4d4bb710c079fd25c
> > # good: [eea3423b162d5d5cdc08af23e8ee2c2d1134fd07] rcu-tasks: Update co=
mments
> > git bisect good eea3423b162d5d5cdc08af23e8ee2c2d1134fd07
> > # bad: [1cf1144e8473e8c3180ac8b91309e29b6acfd95f] rcu-tasks: Be more
> > patient for RCU Tasks boot-time testing
> > git bisect bad 1cf1144e8473e8c3180ac8b91309e29b6acfd95f
> > # first bad commit: [1cf1144e8473e8c3180ac8b91309e29b6acfd95f]
> > rcu-tasks: Be more patient for RCU Tasks boot-time testing
> >=20
> > I don't really understand the relationship with my broken network
> > issue. I am using debian buster and the effect I see is that when the
> > network interface becomes up it hangs waiting for a "task running to
> > raise network interfaces". After about one minute the system boots,
> > the login prompt is shown but I cannot configure at all network
> > interfaces: dhclient does not respond and manually ifconfig does not
> > help also:
> >=20
> > root@gnubee:~#
> > root@gnubee:~# dhclient ethblack
> > ^C
> > root@gnubee:~# ifconfig ethblack 192.168.1.101
> > root@gnubee:~# ping 19^C
> > root@gnubee:~# ping 192.168.1.47
> > PING 192.168.1.47 (192.168.1.47) 56(84) bytes of data.
> > ^C
> > --- 192.168.1.47 ping statistics ---
> > 3 packets transmitted, 0 received, 100% packet loss, time 120ms
> >=20
> > I have tried to revert the bad commit directly in v6.0-rc1 but
> > conflicts appeared with the git revert command in
> > 'kernel/rcu/tasks.h', so I am not sure what I can do now.
>=20
> I've pinpointed the issue to 23233e577ef973c2c5d0dd757a0a4605e34ecb57 ("n=
et:
> ethernet: mtk_eth_soc: rely on page_pool for single page buffers"). Ether=
net
> works fine after reverting this and newer commits for mtk_eth_soc.

Hi Ar=C4=B1n=C3=A7,

yes, I run some bisect here as well and this seems the offending commit. Can
you please try the patch below?

Regards,
Lorenzo

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethe=
rnet/mediatek/mtk_eth_soc.c
index ec617966c953..67a64a2272b9 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1470,7 +1470,7 @@ static void mtk_update_rx_cpu_idx(struct mtk_eth *eth)
=20
 static bool mtk_page_pool_enabled(struct mtk_eth *eth)
 {
-	return !eth->hwlro;
+	return MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2);
 }
=20
 static struct page_pool *mtk_create_page_pool(struct mtk_eth *eth,

>=20
> Ar=C4=B1n=C3=A7

--VO0tgpHQDFf3zU3/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYyBibAAKCRA6cBh0uS2t
rIbJAQCjqga3rcMzULthSxPhxNFrFjiE4ebUktRTmaYin8pJqAD+Khg/QzNbOG9Q
M2XpXh+r3RbVXKI4UAAzCCopNiJekQk=
=7sqQ
-----END PGP SIGNATURE-----

--VO0tgpHQDFf3zU3/--
