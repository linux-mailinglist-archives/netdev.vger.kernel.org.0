Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E496D519CD5
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 12:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348028AbiEDK0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 06:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343997AbiEDK0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 06:26:04 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7471C131;
        Wed,  4 May 2022 03:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1651659719;
        bh=FMqy0avoQkJTPHIwxT5BOwePV8xTDg1i/a1jeG3qI+Y=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=a/tWSVIXXDy8jbJh8kiUKjnq16C+BCvfq7Pht2bkf4Zaa7YOHgg6uwuP+ohQQTy2S
         ZVZgL928GRPcDxohNdzc0IlhQuoVOdfs4oSZezf/bYEkqLY4f0gdYCRt+VPfNNd2AG
         rDI4fnq2o+3fGzGtURHnVMbQDAAQlMF3tt5mfUSE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [80.245.79.168] ([80.245.79.168]) by web-mail.gmx.net
 (3c-app-gmx-bs42.server.lan [172.19.170.94]) (via HTTP); Wed, 4 May 2022
 12:21:59 +0200
MIME-Version: 1.0
Message-ID: <trinity-050a20ad-480c-4464-99fc-95a3ce2eba11-1651659719023@3c-app-gmx-bs42>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Frank Wunderlich <linux@fw-web.de>, Andrew Lunn <andrew@lunn.ch>,
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
        DENG Qingfang <dqfext@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Aw: Re: [RFC v1] dt-bindings: net: dsa: convert binding for
 mediatek switches
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 4 May 2022 12:21:59 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <d29637f8-87ff-b5f0-9604-89b51a2ba7c1@linaro.org>
References: <20220502153238.85090-1-linux@fw-web.de>
 <d29637f8-87ff-b5f0-9604-89b51a2ba7c1@linaro.org>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:6GHTHGGG/fWYaiqZe61bZK/+zhObG4vTyf/KfTx7otfQ/biiPX6LU4lOzmXX85G4UESoG
 4hslvlK+fUX5CDwywLxRK82Ho/brj3SKPBTNOtB3qzQYfRzs2ZQDxs5e1kr6mpTzC5SuSXpGjf8h
 v81wIH6gk/s6iFE2OEcFySVDq07v+eBsZmUbLRNuTFThc9R2BtjvumXHM73Q2VCYj+clGLdu9x3Q
 nPNkkg//gwL55I/o4XoRrYf5lPV6M5JW90KB2IASWCrPb0F2dblMXebz7OhiDWgRd2pC2b2pLWaW
 Es=
X-UI-Out-Filterresults: notjunk:1;V03:K0:fzNN70NOehs=:o2y6DVX52shLGNI/cLV33n
 3HqYzOCruL5pfhyvZhdfoBxlSVtQofMnCzShO6uS/MQCk/Y/BfZaewZnrVokYmzRMyYt6lPSs
 HM1ACDcfFu2zAqSFuuVzAOeeqbgO9AeR/m6tuJCRivAJMPbIaYspcEpcu4Mkp6sBxc+MDrPau
 5C1hC/W/XiiGSnsoVXCadcSPZj7RZ38DnSfP9U9dBb/9RzWb0hTAhZgz0vqckwRdoBOkwP1eF
 re1+1RC7g1YRw/OSpzEpj4pewVnYt+NKWAX+dYnyanY7T3voCxsYqwQjdY6P+4Sa8Az8rXR/8
 zYg1anWPD8jy+h6sPfJ9Q7nXew9tBBJPIDoHx3GxBvQuxt7Cm0Mv1Kc6NbZe9L0Y1/vyUnjkl
 32kkDd0nQ5IgV3V0Kl82+4RmXIGS/NA9YG0bWszpVRVzahf44rLZ4djNNxc2M1PgrZ4/hqAAe
 +Q+CjPjlDOVs9tRCKG+i1frcFmWhH8zChohoXI5JnoJC+OhYQKyYM749LzBjbBDH22fEXrAb8
 +qicqfFBhv+su5kRv67CPgXn8eBsN0GCb7sN1lpGQl+AlKx6C3BpaUk2WKy70+cjIbNVOxXN3
 3OLooidyH8LontIKlXXN0BwUbSMlhbua7Y8M4QnLv3J0xizz8rjwuNANld93ZofDT1rHHhF4H
 tQ8YKCIILPIl245jrAnkwHPMMCwwHW7X+b/ofRpZSK4PE6Ln4q66igK+XM3KoIMnaaB+XqX8F
 qfcLQ9+/ljBVnDq5tXlTGJHTtM+cV0ceNLQ9ixyyTdCoMcFhxH7DraCZyIefbMtA0iXdbViQh
 JSQ0Yrn
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

> Gesendet: Dienstag, 03. Mai 2022 um 14:05 Uhr
> Von: "Krzysztof Kozlowski" <krzysztof.kozlowski@linaro.org>

> > +required:
> > +  - compatible
> > +  - reg
>
> What about address/size cells?

in current devicetrees the address-cells/size-cells are set above the swit=
ch on mdio-bus so i would
not add these to required for switch.

https://elixir.bootlin.com/linux/latest/source/arch/arm/boot/dts/mt7623n-b=
ananapi-bpi-r2.dts#L190

regards Frank
