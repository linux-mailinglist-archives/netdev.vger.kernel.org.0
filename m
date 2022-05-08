Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2739B51EBFB
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 08:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiEHG3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 02:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiEHG3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 02:29:45 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D84910BB;
        Sat,  7 May 2022 23:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1651991088;
        bh=Ng4jRsIwZxysTh46jpfz6AMJR9c8fLNEyif0uXQBzMM=;
        h=X-UI-Sender-Class:Date:In-Reply-To:References:Subject:Reply-to:To:
         CC:From;
        b=X+vDZVU5h4mNwzU33pKxmhT0xREh95Q0q7hnyhDLpOlZ2oCdGgTkjLrgzT7RpZ4Xg
         J5pZeoUkLSyUcM3tj0bhMC/wwxNWpnAwJOyA408yjpzp7Rd3wTT6fc3PPcfZlnWSZT
         XD6Ssm4K6hdmWrGUbCN5IfffCJwF+b/wk92Vmj/s=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from frank-s9 ([217.61.158.76]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M8QWG-1njCcq2lQO-004WiY; Sun, 08
 May 2022 08:24:48 +0200
Date:   Sun, 08 May 2022 08:24:37 +0200
User-Agent: K-9 Mail for Android
In-Reply-To: <06157623-4b9c-6f26-e963-432c75cfc9e5@linaro.org>
References: <20220507170440.64005-1-linux@fw-web.de> <20220507170440.64005-6-linux@fw-web.de> <06157623-4b9c-6f26-e963-432c75cfc9e5@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3 5/6] dt-bindings: net: dsa: make reset optional and add rgmii-mode to mt7531
Reply-to: frank-w@public-files.de
To:     linux-rockchip@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Greg Ungerer <gerg@kernel.org>,
        =?ISO-8859-1?Q?Ren=E9_van_Dorst?= <opensource@vdorst.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
From:   Frank Wunderlich <frank-w@public-files.de>
Message-ID: <DC0D3996-DFFE-4E71-B843-8D34C613D498@public-files.de>
X-Provags-ID: V03:K1:cmDKAX75GAWrl5EVsFsdZd3/enOiiqcTlPQt33Mk48FUrUnPxAP
 U3BMSjIAlW9yIFTQxc6r5ZGwIBzhjF3Eyc7HA/HmUMOhdXJESKU/WOTVhl/KuWjQZJHCK5y
 qcuAgH7UpLQS0Nwh95lnIShPBdyyoyyqWA+QjXtfxQ2F/aeuVB1FPLxNkP2XqesUCDrQJMR
 yG7/qjijqGViHXGbgI2HQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Bt/imPOyZgc=:gwTL4xTW1EFlFic5EmehuZ
 K3tPQ1T2YEOPsfiS+vfhaZb9DEmkYVHlD/FR4mInJt3PgNl0Qv01PIPSMx17iKY2eRal/5y6i
 cP0MYxK1pg6giLZDsQj9PdZXachOyph2RT+LTBbDqyTdwbs7CLxEtm5Pwtf2rdoY5XkHJV/Y2
 ec6qOXl0/qj/VmpdrbqBy4zQ/1hWp1UBv9OS2pT3cqavFhXZQEH4aQTDLk9JNpth8plSiqJEP
 BE9PKVM66PYgl7cjxXgCg55oJEECTEZ4uTGThtMy+tIxftpoikt6Q0J23d0LsjqxAVDAf9sih
 ak0vWuCLmoNY5NmYOnWWd4Sc9ralz1sv8qqFzhM/yzJK+zVoyMDegsDf3EMuQWE5PYzDj4pNK
 dY3XDd81wQq8YIBmMsSlhcGTijit12enWbsnefF7MAk4QyKU73N6mwVkCzlv9vjFgOUxmaV0/
 SLOQ8OhLSKHn/wp+yIUFKdDFqvjEQB2SQr4iioFpsiMIA+2Ty4N3ElDilk/1USsTQJ/QBFRa9
 iBYypxmOh1oJZOOq3reAzjnp7sc4Gqi+r7H4hkR10pIpB5xO37Bz4CVE6AHlZEmX57JYSoQLR
 APgffcXp1EooN8zuPLqI3qrETvgB5qdU5oRehbBYp4hChOzWR3BEkDODs5rsA3MR4z2RtGSyg
 UXW0GmtFGQqQ/IooPXH5qyKtVv7gDNe7fNNMwScJpE1Ju5hy9w1AxFnBCF/YOi+KwwlZRbIiU
 m1x+briTvys/DR0AxtKoU/3ARfUlE//mpL0ZZhkCPqxF8jpgPhqo8Usonb7apnQRIynbEIZf7
 +6uLAzBWZbnF56sm4WObjUbVev1kBquTKBQZ/jZEbOhcjjJVnYX3CQYZlyL7dVd55dFlFsWif
 rMwUQddDBjYWvamkLP4LW2bvbqySz4gKwB9C3Zp4Rr25JpASSXbAyfDQ9S6Ic7cyOIH33ugAd
 jJU4IdGCgljdAZWOLdWvoWBxAkdvXfxY3MdzkEH8FAKA39Z11wS0BsKMJToIssVhsMwoadgFS
 qf/y3agWZoSVD2WSm0oUTvxYbC2sU47z7lz6azW8AjCOfZnBnpOBR+9akJTyG90hq/ZI4Egg6
 7LfkJf4JYSWx3k=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 7=2E Mai 2022 22:01:22 MESZ schrieb Krzysztof Kozlowski <krzysztof=2Ekoz=
lowski@linaro=2Eorg>:
>On 07/05/2022 19:04, Frank Wunderlich wrote:
>> From: Frank Wunderlich <frank-w@public-files=2Ede>
>>=20
>> Make reset optional as driver already supports it,=20
>
>I do not see the connection between hardware needing or not needing a
>reset GPIO and a driver supporting it or not=2E=2E=2E What does it mean?

My board has a shared gpio-reset between gmac and switch, so both will res=
etted if it is asserted=2E Currently it is set to the gmac and is aquired e=
xclusive=2E Adding it to switch results in 2 problems:

- due to exclusive and already mapped to gmac, switch driver exits as it c=
annot get the reset-gpio again=2E
- if i drop the reset from gmac and add to switch, it resets the gmac and =
this takes too long for switch to get up=2E Of course i can increase the wa=
it time after reset,but dropping reset here was the easier way=2E

Using reset only on gmac side brings the switch up=2E

>> allow port 5 as
>> cpu-port=20
>
>How do you allow it here?

Argh, seems i accidentally removed this part and have not recognized while=
 checking :(

It should only change description of reg for ports to:

"Port address described must be 5 or 6 for CPU port and from 0 to 5 for us=
er ports=2E"

regards Frank
