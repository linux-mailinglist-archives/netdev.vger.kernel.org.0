Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9F551ED6B
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 14:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232727AbiEHMQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 08:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbiEHMQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 08:16:53 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A313AE0E9;
        Sun,  8 May 2022 05:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1652011928;
        bh=urf/6grh3HJinL6V+chc5QjAaSNuRTaSFnBMrsEERZQ=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=dp3haL9EMAb+d40ThGLw2NcWomb7pYltQytDtNfkzAZ5gbjPBwiMDhhB4553s+/q0
         Pxh1T0BrletMfoS6DkhrAbGjRG4PG0gsNFQWX7e5yKIwBy618RmnHkIIlK0h1I4HcI
         H85tzNqlGG9U35ba2U7mUc0CTXvpFE96DppUj+wg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [217.61.158.76] ([217.61.158.76]) by web-mail.gmx.net
 (3c-app-gmx-bap68.server.lan [172.19.172.68]) (via HTTP); Sun, 8 May 2022
 14:12:08 +0200
MIME-Version: 1.0
Message-ID: <trinity-7f04b598-0300-4f3c-80e7-0c2145e8ba8f-1652011928036@3c-app-gmx-bap68>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Heiko Stuebner <heiko@sntech.de>
Cc:     linux-rockchip@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Greg Ungerer <gerg@kernel.org>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Aw: Re: [PATCH v3 5/6] dt-bindings: net: dsa: make reset optional
 and add rgmii-mode to mt7531
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 8 May 2022 14:12:08 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <2509116.Lt9SDvczpP@phil>
References: <20220507170440.64005-1-linux@fw-web.de>
 <06157623-4b9c-6f26-e963-432c75cfc9e5@linaro.org>
 <DC0D3996-DFFE-4E71-B843-8D34C613D498@public-files.de>
 <2509116.Lt9SDvczpP@phil>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:5zepZXQ7VM3wRIvl1omrRkcQYRbWljpPdOn3rctdJ68EDLRb/Q24a0AfByhcEpmThRrM9
 XDXoxnndTJTTB8ftDLsJbKlbc/RsJfe6tPnM5q19yQJOp+qsA7fAHwMjuCMXI9X42gFBFwc9hJ1n
 MClWkUTW6eDQ9zRklCIDhuiIkrkRWPrpwjuJCghQ4jaxS14SEjcpUFVvsttTXFg/v+izpHP9rjHG
 5K8t4XzErdhMlTCH/eYhANMQV5xXm3aJlb+YL7E9gNFRtINKVGPK7vVv/4Tn/zZ3M303CC9DAAen
 ZY=
X-UI-Out-Filterresults: notjunk:1;V03:K0:kpgB8WD7jB0=:31o1l/JqXaifC2Kwk5BnA5
 VGzswJjo2yL+aKgrRVCfdD4clXFY0s+2dA8zSb0Vh49KYvyC17eChYgUHcpi8OIef/2dV+w/9
 Pn58j/Uc6nV6fII/bnOQ0NZIANmW21dXO6FgCMPHzMtNZPfONtGm+Pewx4XryZ0xFc0rqeUQw
 j4VlKJzc3cdZR3uPToufdhdpNVStsXL6BwLujp9kNQM5aPO/CZuZrlrM9rrWj2s23czwi53mv
 /wsWJzP+pUbjpqYXhr/8Pn1vU3L8HugYQBKVTHjAFBWf1p41wBY9xHvR/Mkzgj2nefCXPQtNn
 RLjR/a+3JA7eKzEBPDgduFS4gW1pL6rNKcBowGKzAWDOvM2rxJnd+TqmduYBthZcoyfw4r2QW
 N8oLlea5BdJN8H19WlnIrG/pQd5AsuPzHhUjS2hJehG+cbKqy/m0KCJroKtJ1mAMl+0PpIdQA
 Mb5eH9x+wFs/kUo73f3RuX+rGzXWV3CQjX2V88tuFVK85Y+XIxIYZ6rIFT3zjAe2nUcltGX6K
 mYYsBLQNqpnBuz7V5tHDOtWTM8MqDxTNy/7oZl8M/ngQO1Q8HZbxBYBXnBE+AmOFclPa5Rut9
 KEzRKol37E3i7GDtMH1woyZoLJVzFHMvU0o1/C9NFlnqyxtVAKNlOnSHfzOesXq8iCFwrcQlU
 vST0akrfSHJYXuZwP1YJoC25O+/6mSWBhtfyyzDO55reVS3f1ojxNGEhm7+W8hQgyq5nGJa9W
 lT8FIVab+rrge0tW0xSpkVXBLFFiI1lo0YLKzu/jhjzzMSCQKKlUo5AKOn89KsW1W4q7cCnVx
 igaLZ1o
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiko

> Gesendet: Sonntag, 08. Mai 2022 um 11:41 Uhr
> Von: "Heiko Stuebner" <heiko@sntech.de>
> Am Sonntag, 8. Mai 2022, 08:24:37 CEST schrieb Frank Wunderlich:
> > Am 7. Mai 2022 22:01:22 MESZ schrieb Krzysztof Kozlowski <krzysztof.ko=
zlowski@linaro.org>:
> > >On 07/05/2022 19:04, Frank Wunderlich wrote:
> > >> From: Frank Wunderlich <frank-w@public-files.de>
> > >>
> > >> Make reset optional as driver already supports it,
> > >
> > >I do not see the connection between hardware needing or not needing a
> > >reset GPIO and a driver supporting it or not... What does it mean?
> >
> > My board has a shared gpio-reset between gmac and switch, so both will=
 resetted if it
> > is asserted. Currently it is set to the gmac and is aquired exclusive.=
 Adding it to switch results in 2 problems:
> >
> > - due to exclusive and already mapped to gmac, switch driver exits as =
it cannot get the reset-gpio again.
> > - if i drop the reset from gmac and add to switch, it resets the gmac =
and this takes too long for switch
> > to get up. Of course i can increase the wait time after reset,but drop=
ping reset here was the easier way.
> >
> > Using reset only on gmac side brings the switch up.
>
> I think the issue is more for the description itself.
>
> Devicetree is only meant to describe the hardware and does in general do=
n't
> care how any firmware (Linux-kernel, *BSD, etc) handles it. So going wit=
h
> "the kernel does it this way" is not a valid reason for a binding change=
 ;-) .
>
> Instead in general want to reason that there are boards without this res=
et
> facility and thus make it optional for those.

if only the wording is the problem i try to rephrase it from hardware PoV.

maybe something like this?

https://github.com/frank-w/BPI-R2-4.14/commits/5.18-mt7531-mainline2/Docum=
entation/devicetree/bindings/net/dsa/mediatek%2Cmt7530.yaml

Another way is maybe increasing the delay after the reset (to give more ti=
me all
come up again), but imho it is no good idea resetting the gmac/mdio-bus fr=
om the
child device.

have not looked into the gmac driver if this always  does the initial rese=
t to
have a "clean state". In this initial reset the switch will be resetted to=
o
and does not need an additional one which needs the gmac/mdio initializati=
on
to be done again.

> > >> allow port 5 as
> > >> cpu-port
> > >
> > >How do you allow it here?
> >
> > Argh, seems i accidentally removed this part and have not recognized w=
hile checking :(
> >
> > It should only change description of reg for ports to:
> >
> > "Port address described must be 5 or 6 for CPU port and from 0 to 5 fo=
r user ports."

noticed that the target-phase is not removed but squashed in the first bin=
dings-patch.
This was a rebasing error and not intented...will fix in next version.

regards Frank
