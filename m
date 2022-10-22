Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95E6A608EDA
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 19:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiJVRxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 13:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiJVRxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 13:53:53 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D1918DD74;
        Sat, 22 Oct 2022 10:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1666461196;
        bh=TBzr85uWzatSpkiA1DzSeFU3cieZchfrifodRz9AlJI=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=K3JdsHGTgoF1Ze2g677/8cmwtqvef7qs32CJs6K4raM6PkgUZj5uLRKMyIxzgchy8
         eiK3XlutaJhYJaY+Vgod/IGUY0IL7RTpFZEx6Yyt3tM2t5xpsUMQzqj1BBH7oUR4kT
         n0WPKNrLtbf6AqVQgci6OEIrKrog7lDGhi4wLkpk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [80.245.73.148] ([80.245.73.148]) by web-mail.gmx.net
 (3c-app-gmx-bs49.server.lan [172.19.170.102]) (via HTTP); Sat, 22 Oct 2022
 19:53:16 +0200
MIME-Version: 1.0
Message-ID: <trinity-164dc5a6-98ce-464c-a43d-b00b91ca69e5-1666461195968@3c-app-gmx-bs49>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org,
        Alexander Couzens <lynxis@fe80.eu>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Aw: Re: Re: Re: Re: [PATCH v2] net: mtk_sgmii: implement
 mtk_pcs_ops
Content-Type: text/plain; charset=UTF-8
Date:   Sat, 22 Oct 2022 19:53:16 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <Y1Qi55IwJZulL1X/@shell.armlinux.org.uk>
References: <Y1F0pSrJnNlYzehq@shell.armlinux.org.uk>
 <02A54E45-2084-440A-A643-772C0CC9F988@public-files.de>
 <Y1JhEWU5Ac6kd2ne@shell.armlinux.org.uk>
 <trinity-e60759de-3f0f-4b1e-bc0f-b33c4f8ac201-1666374467573@3c-app-gmx-bap55>
 <Y1LlnMdm8pGVXC6d@shell.armlinux.org.uk>
 <trinity-b567c57e-b87f-4fe8-acf7-5c9020f85aed-1666381956560@3c-app-gmx-bap55>
 <Y1MO6cyuVtFxTGuP@shell.armlinux.org.uk>
 <9BC397B2-3E0B-4687-99E5-B15472A1762B@fw-web.de>
 <Y1Ozp2ASm2Y+if3Q@shell.armlinux.org.uk>
 <trinity-4470b00b-771b-466e-9f3a-a3df72758208-1666435920485@3c-app-gmx-bs49>
 <Y1Qi55IwJZulL1X/@shell.armlinux.org.uk>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:OWdvSkP51RMdkQ7qb3NHHRIOta2CZi7LRpGSfsHBJuLrfbVKcY73ozQwYHiyx0BmkMDkl
 OofhqAfbiQWkba9LyqUPnvQKd29eb7xgu7r21pdZDo4zwIcESvCLPd/JCAnsqqLj3Tt1xdNqF0nJ
 cdkIXF+AiAiFk2bDIoKUlA/h70BUMMT+a+C+v2a6Z2YkVvOcCu0MtqysXDVjrMzs+1pZDCk+oXc9
 +aOlakGRHI1kSrt97/1sRGNI32hV9vH9//3uH4aU0MSWP6MDVliOQwpb/NDsrsrxx3HeAsTFegv5
 7o=
X-UI-Out-Filterresults: notjunk:1;V03:K0:RkvasrgfSok=:YRqilrFFbryqfyFbhCequw
 ZNYGO1O9Emc70JRF3Kj2JK8SGP2SzP4LW6IMaxEGBB6INEqmndgMAPmZyfkP1XxZ3MIwYrv+a
 nJMiKAE337rb5rg9s5CQNOGxGIyNN40cgtzPc56jf7Ljsdg8M8sGnj8MDe5G4oGkPbWoI0L8w
 lgKEXvvkNCq+u1WiuCdg6gPUQ57Uoh0c9Ajbx0AKHj4CNYVhr1VML8+DqMjV5zi6Bq/UBLeA9
 tolKpajW+Sz+rPVR+ONYwv7Kno3KgKGhuMqsyPmXOt6kmmYrlSY0BUTAplc6MIjeJln5B0yLK
 O58qoY2e2MAykj2h7MD9nIsdlnGxeT5o1nBe3ksr8qH8RWquXph51OWSp0z8dmPuawc7NzU1g
 MMjCImm95D3/i4UAMRKK3R9/rVhhHQbjaSJGq/i8KzGSkZXewPyf166Sc3wnVdajdJH65lijL
 Ah/Ln2tBfGxiXdNnCOCGMBQstnknmT6JH5RaT4JXn+NbVy3DACnSO2lcPeu0qPk9hmlNhCDIu
 HwvBy5Y0JN1FMbjonbFfwvdjYFR30LJoW4DybbfUrX7gZi0ZA36hRUjZhncVzSq/0j6ZXUYka
 th+KDflW5QNHbOSpb9w77A5r1zRSZKEZSVPTyr/mpIIjOTRBM7KclwO9Cim5VLEvt8C0LmNUx
 pFR5kFzpQIX/r3b2JLqVuSbtlQ/JS4TpW7WJ7SeGp3Tj02Bmyx+pWpiIUkNUExST5ao0lHWJY
 FG6+ql9xEmHR42FQ5DUDUeNtT+EQ176rUceHNc/FCGM5vLb/DBT3RMLMvfi6sDeVGKywjs9w1
 cDJ38hJ5gr9H1Dq3LGUnoriEtgjdeklxPjJUU+sH0gm9lp0WcWAPTQ5KVQvWl+zZnQNfs81wG
 y4BtgY2wE2dEcJ8iWnUTafKciY/KeyKaFK81PybxCFPG47nj8r6k2ujI4C/eB296KCEBhFv8W
 E9fn8UftUt5XFlwdg4Q6YJ0Yid6poDxX1vsPbKnj6DF6qtZAR9Q8q7WK5x2yh0Lr9FwuIBvB6
 EUe6/o9tjsLXfBg1ZCeLIKrXAXVw9pZE0nax9ViJmaUwttEs1vurfO5X0LfDQTlJLUNitFw1v
 wbKQnLjTbYbVFAWjfgYJBAS68pGlbIEKpgcFQvi8soAQbod6T37jGM152WEUSjfTWVBy1086A
 chx9QHMf7ZZy8pM/TxnDtU3TMfM4EER/pK/xuGUDq62/Xzt3wJfsu/oIEytmt6LDUIRxZNwnd
 m8m52PBCXq/KxRg+m6Uq4JNejJdgcgDDTNFWdgZ6uQf000mA9b5cfCeJ+Jk/gGBx9SgB/Hd8/
 Z0/tPM6e
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Samstag, 22. Oktober 2022 um 19:05 Uhr
> Von: "Russell King (Oracle)" <linux@armlinux.org.uk>
> On Sat, Oct 22, 2022 at 12:52:00PM +0200, Frank Wunderlich wrote:
> > > Gesendet: Samstag, 22. Oktober 2022 um 11:11 Uhr
> > > Von: "Russell King (Oracle)" <linux@armlinux.org.uk>

> > this patch breaks connectivity at least on the sfp-port (eth1).

> > pcs_get_state
> > [   65.522936] offset:0 0x2c1140
> > [   65.522950] offset:4 0x4d544950
> > [   65.525914] offset:8 0x40e041a0
> > [  177.346183] offset:0 0x2c1140
> > [  177.346202] offset:4 0x4d544950
> > [  177.349168] offset:8 0x40e041a0
> > [  177.352477] offset:0 0x2c1140
> > [  177.356952] offset:4 0x4d544950
>
> Hi,
>
> Thanks. Well, the results suggest that the register at offset 8 is
> indeed the advertisement and link-partner advertisement register. So
> we have a bit of progress and a little more understanding of this
> hardware.
>
> Do you know if your link partner also thinks the link is up?

yes link is up on my switch, cannot enable autoneg for fibre-port, so port=
 is fixed to 1000M/full flowcontrol enabled.

> What I notice is:
>
> mtk_soc_eth 15100000.ethernet eth1: Link is Up - 1Gbps/Unknown - flow co=
ntrol off
>
> The duplex is "unknown" which means you're not filling in the
> state->duplex field in your pcs_get_state() function. Given the
> link parter adverisement is 0x00e0, this means the link partner
> supports PAUSE, 1000base-X/Half and 1000base-X/Full. The resolution
> is therefore full duplex, so can we hack that in to your
> pcs_get_state() so we're getting that right for this testing please?

0xe0 is bits 5-7 are set (in lower byte from upper word)..which one is for=
 duplex?

so i should set state->duplex/pause based on this value (maybe compare wit=
h own caps)?

found a documentation where 5=3Dfull,6=3Dhalf, and bits 7+8 are for pause =
(symetric/asymetric)

regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1+8, &val);
partner_advertising =3D (val & 0x00ff0000) >> 16;

if (partner_advertising & BIT(5)) state->duplex =3D DUPLEX_FULL;
else if (partner_advertising & BIT(6)) state->duplex =3D DUPLEX_HALF;

if (partner_advertising & BIT(7)) state->pause =3D MAC_SYM_PAUSE;
else if (partner_advertising & BIT(8)) state->pause =3D MAC_ASYM_PAUSE;

> Now, I'm wondering what SGMII_IF_MODE_BIT0 and SGMII_IF_MODE_BIT5 do
> in the SGMSYS_SGMII_MODE register. Does one of these bits set the
> format for the 16-bit control word that's used to convey the
> advertisements. I think the next step would be to play around with
> these and see what effect setting or clearing these bits has -
> please can you give that a go?

these is not clear to me...should i blindly set these and how to verify wh=
at they do?

is network broken because of wrong duplex/pause setting? do not fully unde=
rstand your Patch.
But the timer-change can also break sgmii...

regards Frank
