Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F77C515E1F
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 16:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382811AbiD3OVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 10:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382808AbiD3OVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 10:21:44 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA44811BD;
        Sat, 30 Apr 2022 07:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1651328265;
        bh=RpZTpQKzzOTn3ZLA/Gs5VRQkp2uGMos0GOqltACh2Ns=;
        h=X-UI-Sender-Class:Date:In-Reply-To:References:Subject:Reply-to:To:
         CC:From;
        b=dhlfNF1jBeDlco4SgSmA4nCwK1HgNjGr+6piBTy9qIRiFS33Iuzs22AkCnocq+SmT
         MptW0h6/ri3N0UYhXdVzdYZ8Hpqp8tH2HcgqL5QmvmjjgP5R5fUrmgUiKVskW3Wthz
         p6HZ3R1MJjh1lNgKkFssVrI9pTaLdwK9EvBns1/4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from frank-s9 ([80.245.72.211]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MnJhO-1oAGqb0I9k-00jJBp; Sat, 30
 Apr 2022 16:17:45 +0200
Date:   Sat, 30 Apr 2022 16:17:35 +0200
User-Agent: K-9 Mail for Android
In-Reply-To: <3557249.iIbC2pHGDl@phil>
References: <20220430130347.15190-1-linux@fw-web.de> <20220430130347.15190-5-linux@fw-web.de> <3557249.iIbC2pHGDl@phil>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [RFC v2 4/4] arm64: dts: rockchip: Add mt7531 dsa node to BPI-R2-Pro board
Reply-to: frank-w@public-files.de
To:     linux-rockchip@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>,
        linux-mediatek@lists.infradead.org,
        Frank Wunderlich <linux@fw-web.de>
CC:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
From:   Frank Wunderlich <frank-w@public-files.de>
Message-ID: <40BC9D9E-3E30-4779-9131-E101CDE993BC@public-files.de>
X-Provags-ID: V03:K1:ZlgyTVYfgWBO1Wy+cVSo2lW0VxJ02caKG+q8L7RxX6xFCXGwzKS
 9Udx4qBl3JfeZ447LxlY29/NnBY4gMmLSnSByEDXRWCScdrLF7Xpqq4av3NGuhFbRaMWYkK
 PkHBk3TrnU78Afq0SL++aWQVkDjqc1ghvD4bSJKSzF9ao9N6UNNApaFP05dCg0HANSYgHZO
 ye2WgAO7g1iw0nykgZxfA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:AgGhclNko/8=:aCrBet2od/8wC2RSNSK+oT
 a5aRnnJfwRSgWlKkxzCYOVhXI/79O8rT1THVM0MnbzHJCLI4Fvh8OqgLQBFT8KGUMsDt8CCBF
 /ZIuhrnsKwVevPZ+dOIZvsaZAt98lXRiMREzssZlZx1nPn+bBCpvM5CHll4nBR9xV6dsw19rR
 SXVyg90NhXFOe2TaHGck4JIe2kLiAqWqMd9z9H5BmBozxYzi/yqwoZjOb1F4tfsUOHKd/Cp5a
 vuxK04OjaSDcljtOhPHp8yJdUQ+a4X9IB9mGYju+X/SOtToT3sGOPzh1+lIDxO1PxB+ytorEc
 r+M0C0+BY9huBsLtEmv/APjzY96z1nl+Rnr/GiuL65LTyVTxSr/LCNNyngEQ5WbX84PH89QSH
 GXrbMz6poJ5w8ByUMq6Nohi3NhQL6UMV2ulKD2VBEZlF2Gzht2eU73/8nvBOx3m31YL/fRMWh
 zlAEXxeDg50H/FzGYJ8/j+/Y8KYI85DNVDfa+hjSZBbc2kZ9wPEs0tm2m3HuSR2yIln5zbf97
 xYbCnmcx7f4/ImNwuGKnP6rZYm/jitVu0BjGavWVDxzpjsdiBoEnMFnWLFbFCvWdtvDF/WKW6
 O+DwrDISWIGQ/9LRY+RRCKCnqNQ+lOJO3Qi2p2PlblYBJR/IKfhBFQOrWWLHiKAXSIbc2Gy41
 I8v+/4kJEGzo0S2HdK91aL9V51374tvnB6/md4i73yH48vbBJqjUSrl5t/jlg7ru8qtaU1zJF
 UKkxHQzD2TI3ynd9iYzd1QaOR4QCy+3fm08Uq6mbcuRqYNNpU6oRTH1kXAbwOiWFcuu2dKbCb
 Gkihb7baqLrmIoPm1hymk45EqW5vY8YHb5/h+NYgPL408xkD29786S9YtKR6DWdjiRj8borBO
 yi9VwYvK/bCqBNF7dueG2BpVsQpphPcfyQwARyUgJehMnMlUdFDc7PuQLTLH7wChdMNy8VHX8
 JIeFEFN+LRmk/nVjSM63E/eyvQ0+Rgqp8u6aBTZO5RleS7mdXk0isgrPFa/pR4K6uy5KSkKHU
 Fd1cX0xpUxzNAn9BDCqcRcoxK0uNC+dNjmTJfUAHT5qXvVxnW9RGrWELoUPbS3l/QC59ubvVr
 WK7GT44+uDZSpA=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 30=2E April 2022 16:05:06 MESZ schrieb Heiko Stuebner <heiko@sntech=2Ede=
>:
>Am Samstag, 30=2E April 2022, 15:03:47 CEST schrieb Frank Wunderlich:

>> --- a/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro=2Edts
>> +++ b/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro=2Edts
>> @@ -437,6 +437,54 @@ &i2c5 {
>>  	status =3D "disabled";
>>  };
>> =20

>> +			port@5 {
>> +				reg =3D <5>;
>> +				label =3D "cpu";
>> +				ethernet =3D <&gmac0>;
>> +				phy-mode =3D "rgmii";
>- phy-mode: String, the following values are acceptable for port
>labeled
>	"cpu":
>	If compatible mediatek,mt7530 or mediatek,mt7621 is set,
>	must be either "trgmii" or "rgmii"
>	If compatible mediatek,mt7531 is set,
>	must be either "sgmii", "1000base-x" or "2500base-x"
>
>So I guess the phy-mode needs to change?

This results from current (before my cpu-port patches) implementation in d=
river where cpu-port is fixed to port 6=2E

On Mt7530 port 6 supports rgmii and trgmii=2E On mt7531 port6 only support=
s sgmii (which is basicly 2500base-x)=2E Afaik it does not support 1G=2E Po=
rt 5 on mt7531 supports rgmii or sgmii (dual sgmii mode) but seems not refl=
ected yet in txt=2E

On thing more to change when converting txt to yaml=2E

regards Frank
