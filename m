Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA4D6EF9A3
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 19:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233540AbjDZRwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 13:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233418AbjDZRwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 13:52:49 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB757DAF;
        Wed, 26 Apr 2023 10:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1682531537; i=frank-w@public-files.de;
        bh=YSXHnTZzWxnUCfTtKsu0J9OA2BMeOKUP3P1my0EJ+3c=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Wc/98jMO0/+y7MaO54jCWMwvYzpioSbvBDJiAlt9FANgCn/bkpbRnaKVc8dcJBqBX
         GG53WEFbRTn8R36obSXdVfSP4jhll7xuJO7SONgt1m7JLQj7ogSsIckFbVu9kP23zL
         vC5v8X+t/+PqETjVsBfFbi6hxrNRP2mxxsSoJVgtw901Zm+46KA4olf37ToFKpby8u
         2ScTs6vUPwHcNH1UoFAK0R6SKFd5zEEnfOcUZXv5AyfsiHj5Gk5D7EP1nWlmLSdz8R
         W/rzgAqJjLfTehvax2LmmZdRdOAsq1rD2NVr5GFl2P4elTc4+cNwpzYHa/hKVLHr7m
         51AearMfwClxA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.146.19] ([217.61.146.19]) by web-mail.gmx.net
 (3c-app-gmx-bs05.server.lan [172.19.170.54]) (via HTTP); Wed, 26 Apr 2023
 19:52:17 +0200
MIME-Version: 1.0
Message-ID: <trinity-a7837941-a0d2-4f38-aa65-0f0bd4759624-1682531537098@3c-app-gmx-bs05>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     =?UTF-8?Q?Ar=C4=B1n=C3=A7_=C3=9CNAL?= <arinc.unal@arinc9.com>
Cc:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org
Subject: Aw: Re: [net v2] net: ethernet: mtk_eth_soc: drop generic vlan rx
 offload, only use DSA untagging
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 26 Apr 2023 19:52:17 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <61ea49b7-8a04-214d-ef02-3ef6181619e9@arinc9.com>
References: <20230426172153.8352-1-linux@fw-web.de>
 <61ea49b7-8a04-214d-ef02-3ef6181619e9@arinc9.com>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:m4OLvO2aGfpIPh1kNegtBhLwbWWrwPKhw5jaBky6DTbTjIL8iU/9nCzT6in+N2xsvI+Ds
 /3WbIowJLyskcLJlw5Av77vSAEHyRpHuUJhb4mmvNHbNFUWHGGugfnL95HFeFwbsKu3i/h3qrK8f
 x96Pe7xebX75skDhOsngadfjHoWL3Hu+midtv2HOaCQ1BWgbtE/s3X18rB9RXQuBZaNhl7LFnoLK
 UNO6SUdeHM847TznfMX7LlqaaS2PTqznByv/0ZF03zLFlviZJ2Mx+PZXySbCPxzSqnPm+t16b1Pt
 XE=
UI-OutboundReport: notjunk:1;M01:P0:oZmXxWVFW/M=;/m8bA08ftBuXup6g9QipcJDbYVR
 mUgKaInR5ce2Af58dfc9nqC/Cv0P59JQZ2hi5FMU5UAXSH1dxjjMdCfSX7P9T+esNRACuhQ0k
 R6iJma/JcYDbnIyuNh6BI0u9ebFDbMBZSE+piTnzMvb1RJi8RbOrJZvX7o5+mV9lOeCjxNeE/
 qvPrbWUF4gcikV4ODz5Pjb2rdPFOC0filGeWqvYQn84m9quZAxX6Jy+w19gGbng4X+AjkOPAe
 hQNAeua91Bmjtbehj9hks6rnlNw2Ld4dgNHaZvO25u0uQJ+sFsaja0ts3ksCkx53mzsDaOAfW
 ybRWPdC/J6iQyDgWZRm9fxnKRaPDZmJRCxVYHw3gp0uNGsQmO733nBASHffS4QWDYAzn5k6ES
 r2CpHfnYOG87WziymO4iAK6/RGvNcIDy67I756a9nnag5nCDElk/pRigjUGGfBlFLq/VEJCN7
 5zJ9w5cffm6sQGd6xgVG7so1I9NJvMKMuXIifbmEinNQatBDHUIMnzLTkiE9uo8j+FoEIPjHW
 k/BhEee9BYCb6WhPHUlfyIVE5QQxDscNU5OLnwapDirQbmjidKCi15aEdhtqwxpIsFwABi6j8
 6/hR11iOtMR2/+LUAOBFcJZ9IFcKlLB9qZ2u9DLQvq+rWyFzBT7eiiaqQinECLkM5YXl+lv6u
 dH8EoVEKXrspDPqOkEAPnwaNDcIcc5uzAIGKy8d7GRw1txko8S1B86FQsM95OXTZAnWzcoJfy
 vTlv5Gk0y0Iyn9gUc277ELYljC+U85M/ZgC8lpTYlKUPUug67nfmJ1CYSEvXGTveZAd0RHP/o
 k4z+RwdZF0g033BGcC0QewuQ==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi
> Gesendet: Mittwoch, 26=2E April 2023 um 19:25 Uhr
> Von: "Ar=C4=B1n=C3=A7 =C3=9CNAL" <arinc=2Eunal@arinc9=2Ecom>

> > tested this on bananapi-r3 on non-dsa gmac1 and dsa eth0 (wan)=2E
> > on both vlan is working, but maybe it breaks HW-vlan-untagging
>=20
> I'm confused by this=2E What is HW-vlan-untagging, and which SoCs do you=
=20
> think this patch would break this feature? How can I utilise this=20
> feature on Linux so I can confirm whether it works or not?

oh, you mean my wording about "hw-vlan-untagging"=2E=2E=2Ei mean the hw vl=
an offload feature which may
not be working on non-mt7621/7622 devices as i have no idea how to check t=
his=2E i hope felix can
answer this=2E at least the feature activeated on mt7986 breaks sw-vlan on=
 the gmac1 (without
switch)=2E

regards Frank
