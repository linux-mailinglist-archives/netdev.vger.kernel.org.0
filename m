Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4CB5B6E89
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 15:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbiIMNpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 09:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbiIMNpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 09:45:18 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D490275E7
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 06:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1663076706;
        bh=91Bl+tuVj/8AQ7QmfZGkgMNtlc8tOwDknSx8fOF1txA=;
        h=X-UI-Sender-Class:Date:From:To:CC:Subject:Reply-to:In-Reply-To:
         References;
        b=bybnj6YpOIFGKqYk05V2fhw89r+WdabEbQzqkqVUpLYy7Ru9hcBnH2h5BYj7yTDq+
         2VSrlPFFV+1Embyq/AyXP3WGwXIcYrxtGbTsNBTsEZ10S+cReHZFf4C5d79RhhzwRo
         ZbQnQR5+JG6qnpudRpXSlJVPnkhZHvAsd8PYr/KI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [127.0.0.1] ([80.245.76.82]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MFbVu-1oXbBc0Fvq-00H4DA; Tue, 13
 Sep 2022 15:45:06 +0200
Date:   Tue, 13 Sep 2022 15:45:05 +0200
From:   Frank Wunderlich <frank-w@public-files.de>
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        netdev <netdev@vger.kernel.org>
CC:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Subject: =?US-ASCII?Q?Re=3A_gmac1_issues_with_mtk=5Feth=5Fsoc_=26_?= =?US-ASCII?Q?port_5_issues_with_MT7530_DSA_driver?=
User-Agent: K-9 Mail for Android
Reply-to: frank-w@public-files.de
In-Reply-To: <e75cece2-b0d5-89e3-b1dc-cd647986732f@arinc9.com>
References: <146b9607-ba1e-c7cf-9f56-05021642b320@arinc9.com> <e75cece2-b0d5-89e3-b1dc-cd647986732f@arinc9.com>
Message-ID: <84BAEBE0-0026-45A4-89AB-FB20E9F9063B@public-files.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:/ktzAebFFSm2bblEroLEWi17pm4JXzMjBkHLOS++akffL72FQ4a
 oAuB/i+6SeutHHKCqsf5Vl2hh1vdsFnAY44+Weq6zNMcgB5lQmtOLMfyO44RU2AIdpiCxGA
 /Ec5RAdn4/+24/mPQHXCrkPCk+lctGL4TNGMfT3ZT8vifdmGIexJNCD2U+aPKw7EhKVCMjE
 ol9F6m0aVi57SPb+v1n3A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:3+TO2EqFtG0=:Wibh4jqSwAYhpANjVeJx24
 nPiXsXD4ytx9XeT1sRZ9ev9sY7ktYNWykY03TehmNr7Gx5kaEBW7iiSK14AAUGlTEY9d5VSOL
 3GVajz2IjFpnyWF7Kx21A1Nk3SlQlDNjQWfQa/xFffMOPrLwM8WYBJ/aHSNSXchWLO+hHrR4z
 t2G9d0adyl3flWaS1sA96jfley41NIutOAucoVqx9fSu9aMO6HRc7a1H0ynXOn6FdfWdLv2PN
 E4J9wg7QVYjc3r9SNTcpTcFdNToJRjKdlpR4ETA1ZgGluSOQLA/SH5KM+knshjHFdr1z6TMnT
 oC10Bk82KR5OJ4LJtqCFlaAI3x18DSRckx/QHyK4ruhRbjfT/Rddc3Efx1wn8bbmOguHbvnvu
 7X9q8bLNOKx91ChqCHMwGC6SFn88w8s9wMc6bs+kyKSWOwEiSywe4JhQhYJigoxSkfPRlk/ap
 RZ4gunjTPamleKgRrLIsrYRtSVm3PV40MDCCQVdmAoqy5NZK6FFLEOTZX0jM4uUdL7eJGukfT
 DdUKY0DayIa1ekJKQQlM3hmoyG3n2OO57WMoTw+1oB8KMThXl99hPwqkUk/sjnT8mhe+cg5Ix
 ZRr4n3jhccDKW3tczBgtsGKrEgY+zJ/2W9TfyLXljJ0LhuYaKTMCd2GsCvGKXkX+lzwmvfOHq
 fyHan2y+qm1ZdwnaB7KoZ8v+74hEOk2N70+ibjhBUFKCO5jRLsQ7k5dxKfhOOOHEs9hYCdQHB
 iTh4qTLv1XcjiiuoIkZAanccsTh30Fn6YmhrRc2PdQHDm4ZRf5B081oBo3oKBopdcJdDVMck0
 tcuY+L38mKyFlnGGeDUK2jTnE1tXnAu0RC6RgHO8BkCn1k4Q74vlZRyqbKPyXXgPlMn6SsK+T
 V125JIYvlMuuQOVb0H6iYNw4T0F+FQJ2O43l1JayYTkSNbxRP2Ak5Zy4zCTMHvgYa5QA3C/bt
 a6KhxoiLIKBmhCWxzRRtr+Xl/ZZCoFNJkeq3lWsa14/ZvVERdEuEg87jhZuqhngpud8nYOPIp
 w+Tl3EilWjDyKSM5kHsbnkjW3EKYQ4IKT5P/ZC9gCt18xLqXRQ7deyhWQC+xjnimFyEJ7K5/a
 fsdThQbUkQxlGkFwk3ZS6+IHyY2h305qx/jx/mvo7E0/9AWqOC/OMceHbgW7AXw90xhQJCvqh
 U8AE1loNTncgr76mJDAnqHsE7M
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 13=2E September 2022 14:54:20 MESZ schrieb "Ar=C4=B1n=C3=A7 =C3=9CNAL" <=
arinc=2Eunal@arinc9=2Ecom>:
>I'd like to post a few more issues I stumbled upon on mtk_eth_soc and MT7=
530 DSA drivers=2E All of this is tested on vanilla 6=2E0-rc5 on GB-PC2=2E
>
>## MT7621 Ethernet gmac1 won=E2=80=99t work when gmac1 is used as DSA mas=
ter for MT7530 switch
>
>There=E2=80=99s recently been changes on the MT7530 DSA driver by Frank t=
o support using port 5 as a CPU port=2E
>
>The MT7530 switch=E2=80=99s port 5 is wired to the MT7621 SoC=E2=80=99s g=
mac1=2E
>
>Master eth1 and slave interfaces initialise fine=2E Packets are sent out =
from eth1 fine but won't be received on eth1=2E
>
>This issue existed before Lorenzo=E2=80=99s changes on 6=2E0-rc1=2E
>
>I=E2=80=99m not sure if this is an issue with mtk_eth_soc or the MT7530 D=
SA driver=2E
>
>---
>
>## MT7530 sends malformed packets to/from CPU at port 5 when port 6 is no=
t defined on devicetree
>
>In this case, I can see eth1 receiving traffic as the receive counter on =
ifconfig goes up with the ARP packets sent to the mt7621 CPU=2E
>
>I see the mt7621 CPU not responding to the ARP packets (no malformed pack=
ets or anything), which likely means ARP packets received on the mt7621 CPU=
 side are also malformed=2E
>
>I think this confirms that the above issue is related to the MT7530 DSA d=
river as I can see eth1 receiving traffic in this case=2E
>
>Packet capture of the malformed packets are in the attachments=2E
>
>---
>
>## MT7621 Ethernet gmac1 won=E2=80=99t work when gmac0 is not defined on =
devicetree
>
>eth0 interface is initalised even though it=E2=80=99s not defined on the =
devicetree, eth1 interface is not created at all=2E
>
>This is likely not related to the MT7530 DSA driver=2E
>
>Ar=C4=B1n=C3=A7
There are some patches fixing ethernet and dsa driver for getting sfps to =
work=2E

https://git=2Eopenwrt=2Eorg/?p=3Dopenwrt/staging/dangole=2Egit;a=3Dcommit;=
h=3D9469ba3568d7d9de31dc63de5269c848a1cc1dc7

And on dsa side imho only to support sfp

https://github=2Ecom/openwrt/openwrt/commit/bd6783f4fb8f6171927e9067c0005a=
6d69fc13fe

Hope the first patches help you with your issue

regards Frank
