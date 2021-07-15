Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 544253C9F8C
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 15:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237706AbhGONhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 09:37:21 -0400
Received: from mout.gmx.net ([212.227.17.20]:59221 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233957AbhGONhS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 09:37:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1626356052;
        bh=lK4DUo0w2gum2CKSES+snbMoAibhMnTmiJVymqGoScQ=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=GKSy4GYzcjMFL5meKVGQ+eq5bGWPqcR7NzLsCBo8F95UCPCYL6t5D0935+qNbUjGz
         m0obY7Gg9GeXQ6RDkp7I7bFrXOJbd03OB8CXUk6xAWkWiI2CDmEUjk9ELrFn59+9G7
         4ZIxKAy7qgvZjHZqQk9u/wdVdtQpOtum9FtKCx2Y=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [87.130.101.138] ([87.130.101.138]) by web-mail.gmx.net
 (3c-app-gmx-bap31.server.lan [172.19.172.101]) (via HTTP); Thu, 15 Jul 2021
 15:34:12 +0200
MIME-Version: 1.0
Message-ID: <trinity-3bd0a864-e313-4403-8f8b-46fa344c80a4-1626356052833@3c-app-gmx-bap31>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Aw: Re: [PATCH 2/2] net: dsa: tag_ksz: dont let the hardware
 process the layer 4 checksum
Content-Type: text/plain; charset=UTF-8
Date:   Thu, 15 Jul 2021 15:34:12 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20210715131251.zhtcsjkat267yrtl@skbuf>
References: <20210714191723.31294-1-LinoSanfilippo@gmx.de>
 <20210714191723.31294-3-LinoSanfilippo@gmx.de>
 <20210714194812.stay3oqyw3ogshhj@skbuf> <YO9F2LhTizvr1l11@lunn.ch>
 <20210715065455.7nu7zgle2haa6wku@skbuf>
 <trinity-84a570e8-7b5f-44f7-b10c-169d4307d653-1626347772540@3c-app-gmx-bap31>
 <20210715114908.ripblpevmdujkf2m@skbuf>
 <trinity-0dbbc59b-1e7d-4f58-8611-adb281a82477-1626354270982@3c-app-gmx-bap31>
 <20210715131251.zhtcsjkat267yrtl@skbuf>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:g7FXDoNMqgOsC29RS9YCrcMtlvKFiTy1SX3EMgu+4LqexdvM8l7O4BKO+X11BNi/2CDT2
 t7+s2LwFRmN6Fqfi0z7cgs3Ijsc/Rxx5PuHl1wW6XqSyMg9hu22QOC8MR0OBtPUotYz8ebaNpCjm
 IC5dOuz1gJQRMKfN1tiLwfuYezDkVWk7xrpqAye9qdnfet8ldBtl1TeQlVgTPPwNFedeXfeEYCJ9
 ZeC14NpC5SrMh02eOwIPbD8oVPX+EpydtPUe/e3ymAW62xOfZBjeFnXXw35+6pfnTFPPHZ3pO/0a
 pk=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Tg1U5EnkAn0=:C2aWLSCThHRCfqy/L/Vyaz
 UkZZulhEcraxXYunTb9aaIg0wD0xQlSC2TqQ32Au3v6owqdPPZP1SGOmXkxXj/IbYrGVxFtjW
 +B3x3Sk73ITP+0BwONuKl/nNX6u2bEju/JCsxJ4yqHn3Aot0xMpAxg4raIKedbICdmNrx8sty
 +midmzmV7YJ+wAyOC79meaJ7RQuwXRPPiW90pd78jMAyfSOBMfSS7wBQn4nDeR54ZsU7UlL67
 HonhpGlm24Q9CpcqYwNpme+a52G/gfE4pV//rs9OUmVjZcHXO50tj0RbMLhVp9Q2IBhXs1y6C
 bIf+ENcSOpp3xYr46KJV1bO+EOAKQCVLiGYv9LBWWdCVpPbg+8g6Ygj7BLGq1q2B7ASvNccBH
 OAgNj5C1OZACoeF32vwtzavPTfXnbI9immQcw7HQkhdw1b99QzmA6geW73xlS1lRmJVgkEHPs
 ejDei+D91OutFcOTcX56O2tPQ5R8dKuTPQ1d/ntWQ8eoO+BdHm/CKfpiHQU9QdPUDM+Uc+A9I
 yBvVqmpc/X6wRDY/hejmLdi2jJxyDZaa1hiyI7pdNGEPTsBxn9+68o6fhwUD8F40BGhToe+Ic
 iGO2np7VqRwHAy6Tp18DH7E6pgm3dwaVEukpqQK0o7H9q2BxbRlRQrZYTGnEleVbnrW0Ob6iy
 YQMR9GKwKfOpROB5nUWKikmd5Wyy6daD4NSGimgxGlZ7XeI0CIIwjOppF3OMf6Yyp/iPD5MPi
 Qs9JKDB3TWRrwxN0InLtrdGd/+7ExzUNslPVEl4CarjopjMooxpByr4DxVNqG+YGFF9OzdN8Y
 RyaOQqzk5UHDOfykhVLx2vfWbP8PUTB1x6XIjWpqiMMpa1C9+4=
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Gesendet: Donnerstag, 15. Juli 2021 um 15:12 Uhr
> Von: "Vladimir Oltean" <olteanv@gmail.com>
> An: "Lino Sanfilippo" <LinoSanfilippo@gmx.de>
> Cc: "Andrew Lunn" <andrew@lunn.ch>, woojung.huh@microchip.com, UNGLinuxD=
river@microchip.com, vivien.didelot@gmail.com, f.fainelli@gmail.com, davem=
@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org, linux-kernel@vger=
.kernel.org
> Betreff: Re: [PATCH 2/2] net: dsa: tag_ksz: dont let the hardware proces=
s the layer 4 checksum
>
> On Thu, Jul 15, 2021 at 03:04:31PM +0200, Lino Sanfilippo wrote:
> > Please note that skb_put() asserts that the SKB is linearized. So I th=
ink we
> > should rather clear both NETIF_F_FRAGLIST and NETIF_F_SG unconditional=
ly since also
> > header taggers use some form of skb_put() dont they?
>
> The tail taggers use skb_put() as part of the routine to make room for
> the tail tag.
>
> Some of the header taggers use __skb_put_padto() when the packets are
> too small (under ETH_ZLEN). When they are so small they are definitely
> linear already.
>
> We don't have a third form/use of skb_put().
>

Ah ok, I see. Then it should be fine do clear both flags only in case of
tail taggers.

Regards,
Lino
