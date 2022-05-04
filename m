Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3568951A419
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 17:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352255AbiEDPh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 11:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236890AbiEDPhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 11:37:55 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E3444770;
        Wed,  4 May 2022 08:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1651678400;
        bh=t1jWW/NNdc3oVoqZFIz/KOKySSaJeOvL+LAywcKQZmQ=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=LwIsFhN1rjdEiVlyxnaS7ncjk6PZYnKBBl+tr9+KXUDe/qxPl2d/Bp5Z/dr3lyxmy
         7DwxEtcOY31Hgr+5tLUBLoMC49c3EW7j2QhtbVJ9/ByKvCiueH7IJ71DX1E3k13qTc
         TVszvdU0DjJsXiHCxas+BflNR/I82iWUBbh1vdHQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [80.245.79.168] ([80.245.79.168]) by web-mail.gmx.net
 (3c-app-gmx-bs42.server.lan [172.19.170.94]) (via HTTP); Wed, 4 May 2022
 17:33:20 +0200
MIME-Version: 1.0
Message-ID: <trinity-9f557027-8e00-4a4a-bc19-bc576e163f7b-1651678399970@3c-app-gmx-bs42>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Aw: Re: [RFC v2 4/4] arm64: dts: rockchip: Add mt7531 dsa node to
 BPI-R2-Pro board
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 4 May 2022 17:33:20 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20220504152450.cs2afa4hwkqp5b5m@skbuf>
References: <20220430130347.15190-1-linux@fw-web.de>
 <20220430130347.15190-5-linux@fw-web.de>
 <20220504152450.cs2afa4hwkqp5b5m@skbuf>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:jAByejol9CawH+bkRnuUTdbn5p4GE4zCHqo1YE3b+FDnUygKKnzA8wTqRLGS/CA/q7yLa
 sO8q+B5k6HDcTCTJzrvS+jYJeORboT9v2Hv5lKBTQWaanYNLdOPekeTa4+OFf+/s6Gnr5nNoSL//
 bSpaRibkotbH7leM710FyDgJHSBCkARi3FH29lSP+EMi9AYj623JdU/CHqex+fGr/TKclxKMa0L2
 IJkayqswiYtOoAUB+O7ClpSqhMz22rEgGHxD1565g2SzCoKFhMZU+TQWmU3WXt+0K1LR3C61Qy7I
 y4=
X-UI-Out-Filterresults: notjunk:1;V03:K0:dslsHgA9X8Y=:AIi6owLu7xaqkaZe7a9jI5
 Yvmry07cI2MyAwGQxbQFhcMiHuSypPwM+wfhSOXTDuycYVNyio2qEq00XiHaSniiepuq6ZSYz
 vtHcyrAvNULbNi/BsNkafYaEPuexpRxrtzjLXHKLm8G1dQ1vqG+uOB/5tFhqSm7rbhNyVg2IH
 E0DUNLndPzsEToX2zs/PuTcOyOI2SYmSBajqyftFBYRBkWXJIKQciHD6kdD3IG06mZ1ajX4Xj
 MDeCOgiIeSd0wf2snQD+79HsviSOQrNnfSeGxCky/zMunuQbJLqpvRVDq1ROegNjQc6wFbvSz
 Shhid+1+MO0Pv3dURxu1QfXMq4lctoCETYirb1f7+In6juJinrgE0CC8LITfyqSVcfeHqWfAC
 lFLmOlRld1y36OAgqX6qeuG0/4qH1nVSWyjgQeezbOBIJMTC4d5qdL+IdJ95L1N3/vhp8d8+c
 DsBccexmldhA8spRIJze0DNtWrgoFMQbHpMPyEJkmDLd8LhuIAwT5U9oSsyeKktKcxEz8YSvd
 enXvnjevbxZ0Sx9OgnZ2ZWHSD1v1qqU8nBnR7BpyE3KfeTzGwyCJ59OgeD1UO3HBlFiTrLO8z
 +E2k8EjwbCVoYGqYCoXwYxCeqaKKYTJIjB94/syugwhUSy4r6BExABIKjwKOxbB7DqSw+IM4i
 xbl6sLk5Vew0dE+5u3niEcw1QmJI7LscrGGuiDDnBrAvRd/qI0tMG9w2YP+e7ugh1oDisMxCG
 8adlgWsC3SrreyzEsiblf3gn0B/YgGFOig2GXsjsNCIAcRWfDN0/sg4M65I/zpMh2EjJAK/NX
 mW7SsPE
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

thanks for review

> Gesendet: Mittwoch, 04. Mai 2022 um 17:24 Uhr
> Von: "Vladimir Oltean" <olteanv@gmail.com>

> > +&mdio0 {
> > +	#address-cells =3D <1>;
> > +	#size-cells =3D <0>;
> > +
> > +	switch@0 {
>
> I think the preferable names are the newer "ethernet-switch@0",
> "ethernet-ports", "ethernet-port@0".
>
> Otherwise
>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

current device-tree nodes using "switch" and "ports"

see discussioon here about make it fixed to "ports" property instead of Pa=
tternProperties including optional "ethernet-"

https://patchwork.kernel.org/project/linux-mediatek/patch/20220502153238.8=
5090-1-linux@fw-web.de/#24843155

>
> > +		compatible =3D "mediatek,mt7531";
> > +		reg =3D <0>;
> > +
> > +		ports {
> > +			#address-cells =3D <1>;
> > +			#size-cells =3D <0>;
> > +
> > +			port@1 {
> > +				reg =3D <1>;
> > +				label =3D "lan0";
> > +			};
> > +
> > +			port@2 {
> > +				reg =3D <2>;
> > +				label =3D "lan1";
> > +			};
> > +
> > +			port@3 {
> > +				reg =3D <3>;
> > +				label =3D "lan2";
> > +			};
> > +
> > +			port@4 {
> > +				reg =3D <4>;
> > +				label =3D "lan3";
> > +			};
> > +
> > +			port@5 {
> > +				reg =3D <5>;
> > +				label =3D "cpu";
> > +				ethernet =3D <&gmac0>;
> > +				phy-mode =3D "rgmii";
> > +
> > +				fixed-link {
> > +					speed =3D <1000>;
> > +					full-duplex;
> > +					pause;
> > +				};
> > +			};
> > +		};
> > +	};

