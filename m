Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFE26095CA
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 21:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbiJWTWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 15:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiJWTWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 15:22:17 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F4631FB5;
        Sun, 23 Oct 2022 12:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1666552897;
        bh=2jJEvmHSP6qPd7XxMz1AxdJbkheHxQEUt+1NyVik1qw=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=ZS24O87PTKbDXd1ulCGQiI3NI14Se4l1Qw/O+11MQrW3roytC3pjbDL4gHm/91Fzn
         NdboUlmOuKjtcJf/ASI8F9HpIOSHmBOxo/1UEhEIeW32SS4a2iwcd6eBDQLlwuZFNd
         mz3wQoL9sAapY57xGnlrhucG/dGSQ7epUXgh74+I=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [80.245.79.234] ([80.245.79.234]) by web-mail.gmx.net
 (3c-app-gmx-bs01.server.lan [172.19.170.50]) (via HTTP); Sun, 23 Oct 2022
 21:21:37 +0200
MIME-Version: 1.0
Message-ID: <trinity-169e3c3f-3a64-485c-9a43-b7cc595531a9-1666552897046@3c-app-gmx-bs01>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Frank Wunderlich <linux@fw-web.de>,
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
Subject: Aw: Re: Re: [PATCH v2] net: mtk_sgmii: implement mtk_pcs_ops
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 23 Oct 2022 21:21:37 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <trinity-ac9a840b-cb06-4710-827a-4c4423686074-1666551838763@3c-app-gmx-bs01>
References: <Y1Ozp2ASm2Y+if3Q@shell.armlinux.org.uk>
 <trinity-4470b00b-771b-466e-9f3a-a3df72758208-1666435920485@3c-app-gmx-bs49>
 <Y1Qi55IwJZulL1X/@shell.armlinux.org.uk>
 <trinity-164dc5a6-98ce-464c-a43d-b00b91ca69e5-1666461195968@3c-app-gmx-bs49>
 <Y1RCA+l2OHkrFfhB@shell.armlinux.org.uk>
 <trinity-ff9bb15b-b10c-46d6-8af2-09a03563c3c8-1666509999435@3c-app-gmx-bap20>
 <Y1UMrvk2A9aAcjo5@shell.armlinux.org.uk>
 <trinity-5350c2bc-473d-408f-a25a-16b34bbfcba7-1666537529990@3c-app-gmx-bs01>
 <Y1Vh5U96W2u/GCnx@shell.armlinux.org.uk>
 <trinity-1d4cc306-d1a4-4ccf-b853-d315553515ce-1666543305596@3c-app-gmx-bs01>
 <Y1V/asUompZKj0ct@shell.armlinux.org.uk>
 <trinity-ac9a840b-cb06-4710-827a-4c4423686074-1666551838763@3c-app-gmx-bs01>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:wnlv6cT7DXECeaYmAyNFfLMpT8nVTt9ODcAJNv437ha20MFzbjN+Dt/birFLYC0Qzrh3n
 eIEUhh4j9jBPcBOIJE0jXkXXVYYu3H+3uyUH8uxlcKcUgKIwW9XMGz25i+rtreTo3Z2b0E6CQTkN
 0yj0LrIXd3v9oBQeuEgYldLLF5+a5gtE6yhnzf1BVJgprHq+xaGWNX0WlFlVz1K+117tFjS9YYV7
 WcIwOpfQXOU3uaQcpgKhjRWNaykut341YA9UC1RqQmDV5kmz7Ud/oi1gTaJmJMRaEItmI9bvOtk9
 iM=
X-UI-Out-Filterresults: notjunk:1;V03:K0:X0wHvMwV6ZE=:mSau9Xq/zRtQppHOurG6uG
 wBdmXwWBK2aBzu5WwwAAVG/lcnTgDVH4D9LvXHrk1+FyuGWXDtLdWo6mrXrDzMwxf1NI+aZMy
 kEwaf/MemFIQnt6kDLbOSaRjBDb0qMiM2AFN0N7mQB3jCBFxbM/mI7W27Zpwq8wnyqp9/RmA6
 AyD6TKoHUXBldxXTGZ4qDYTtgyJMYE4GYpxO4SKXE/A+6NbGmJnPdBfVJrZofADBrKc8DL6rl
 mzO7XwO2wjBplyhu77gB4sVj5zrnOvWYgmC+RjO8syh64pSRsVzudpTgW5RvosQQe+gbyvsje
 CPtwz8rXRarHC9eetg9DlCv950ZEMj7phGtQ1pMcmCymt+InJahzKAzgpAXGNxxT/5XjAxUrg
 3EBsZ8jU5C89b6/7e00uIt3O1UtTBny8uTT06dKKB3pdPLgDIqNZFfnnP7paeOX44n33Yj6rc
 xMLvSlf7gu6qMCJdOgcBd31HOn/asy1d8Q+TfSbH07wY/Rz5jhRt6KQ45v9OIsOP/cMDxL7Nr
 DLI269zIESo1P29jpTUjj7na9lnaoqdorTWohIdSOKlvLJwFWDAtI1dFWegYxf1MJogTLsTel
 9zUqSTJLn8Tr2Spj+NAGl9rfysRQ8edCOzS7i222+fZpfKewMx8Gw7S/fHpP4BVaxKzsZgaXa
 +DmyuO0gOmAzBbWZOQcRl4GVkvyzwtvRND5tSdL91QgzlqCAv5EvAIgAEzg0ktcdxw87DkqP4
 VXd4I3E29sUc3bS3Ufk3U/P+GfvtTI9XiJDFk6O91e6YLW3XdRrs67lJ1n7i47s6C3EY7E7sB
 SBd012E0JFG0JLrZ7SRl4gJOcnEs95GbLot90MxDeQmypSm2DK/wstnX/IZzez5N1jmYDUXSv
 Q1rNYObyhi1895q1/n/KPRzMioz9BEKjsGM1epsQpgmjvcw8K+jYzXBTKN70M31LXPez6XYHD
 7u9Rak1ojLkuXu5u32gZK7olW0zLqLxkJP2/RnHO/bJSikPuCazgbgk1A2yN2k/6Ztx6qnh/N
 HW0Cf94UClhIEgVUp14iCWCx+ESGVZ+BCUUcHUlS8gd4bgYeLproxGvCMzfH9AA1TC7PSw8B9
 mVr4ObNX0FgKUvVmOXnSK1HpMUIijGMsU0ogfYhMjzGBi5WMjdz1gk7zKWB/qWdC2h4D79gd/
 onaPzYd7Ny00uc5oYTNZBLbf51yFDs3L8m8T+Oh7NlJ0pfdOTWWYqRKXKS4frJ9Tuu+HgydZu
 kS2ZSqrklyYruwYAnXrhSnbV6VDGn/l/SyjsdrVtzLuoJdUD0orXriYxswVWDFRbgbBOD82WX
 8+LcsKVw
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Sonntag, 23. Oktober 2022 um 21:03 Uhr
> Von: "Frank Wunderlich" <frank-w@public-files.de>

> if you fix this typo you can send the patch and add my tested-by:
>
>         regmap_read(mpcs->regmap, SGMSYS_SGMII_MODE, &val);
> -       if (interface =3D =3D=3D PHY_INTERFACE_MODE_SGMII)
> +       if (interface =3D=3D PHY_INTERFACE_MODE_SGMII)
>                 val |=3D SGMII_IF_MODE_BIT0;
>         else
>                 val &=3D ~SGMII_IF_MODE_BIT0;
>
> should i send an update for my patch including this:
>
> state->duplex =3D DUPLEX_FULL;
>
> or do you want to read the duplex from the advertisement like stated bef=
ore?
>
> regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &bm);
> regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1 + 8, &adv);
>
> phylink_mii_c22_pcs_decode_state(state, bm >> 16, adv >> 16);

with the phylink-helper it works too

https://github.com/frank-w/BPI-R2-4.14/commits/6.1-r3-sgmii2

regards Frank
