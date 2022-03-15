Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58794DA3FF
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 21:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351718AbiCOU3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 16:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351714AbiCOU3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 16:29:31 -0400
X-Greylist: delayed 72030 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 15 Mar 2022 13:28:18 PDT
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [202.36.163.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FAEB32996
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 13:28:14 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id EBA2F2C02D7;
        Tue, 15 Mar 2022 20:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1647376091;
        bh=eZI2k1RiWyyrfBExA/IbaIvwwTldGAOYkJslcg+DGLI=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=BjuF/+EC3LO08/jwkjAo8mVlELMXT7XgdjL9mNpOPiGxTM9bN/cmcOz1UQO9O9vl1
         Vn2PJ+8XoQD3hwdHVujcwIgC8PU3mU+3/ZPLFIMglOYC9khqQ8eoqzWw9zk0u9/X5e
         jtyYivkXSd3TjQ1tIG5TcwVatD2rLTtM8RNMRBLzERygVLEcTw68oir+X678dqFgvv
         iiXp0N/zTOq8jD8L9BhIoEk/8h6Q3LyYwrW1h1eoq9nQ3WNqOXrZNJBkJOKuQUvHmc
         Eb1ZjesxJ6FmgWwPLcwFtRVGgWTevcAH9xOMI9ERbxo4sSwyTJeeTVcamwoR4XCZEd
         YtEjKvlNxZPjw==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B6230f6db0001>; Wed, 16 Mar 2022 09:28:11 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Wed, 16 Mar 2022 09:28:11 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.033; Wed, 16 Mar 2022 09:28:11 +1300
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 0/2] net: mvneta: Armada 98DX2530 SoC
Thread-Topic: [PATCH net-next v3 0/2] net: mvneta: Armada 98DX2530 SoC
Thread-Index: AQHYOAqCZ7ssWpsp5km7Bh3e8zXG5ay/EuMAgAD5c4A=
Date:   Tue, 15 Mar 2022 20:28:10 +0000
Message-ID: <ca07b0a6-bc9b-714b-82cf-f778341169c6@alliedtelesis.co.nz>
References: <20220315011742.2465356-1-chris.packham@alliedtelesis.co.nz>
 <20220314223516.000780cd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220314223516.000780cd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A8AFC5FD9DC1D2459BE745527AF43B19@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=Cfh2G4jl c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=oKJsc7D3gJEA:10 a=IkcTkHD0fZMA:10 a=o8Y5sQTvuykA:10 a=62ntRvTiAAAA:8 a=VwQbUJbxAAAA:8 a=WxQsor5ude-MpjZo5R0A:9 a=QEXdDO2ut3YA:10 a=pToNdpNmrtiFLRE6bQ9Z:22 a=AjGcO6oz07-iQ99wixmX:22
X-SEG-SpamProfiler-Score: 0
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SCC_BODY_URI_ONLY,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxNS8wMy8yMiAxODozNSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IE9uIFR1ZSwgMTUg
TWFyIDIwMjIgMTQ6MTc6NDAgKzEzMDAgQ2hyaXMgUGFja2hhbSB3cm90ZToNCj4+IFRoaXMgaXMg
c3BsaXQgb2ZmIGZyb20gWzFdIHRvIGxldCBpdCBnbyBpbiB2aWEgbmV0LW5leHQgcmF0aGVyIHRo
YW4gd2FpdGluZyBmb3INCj4+IHRoZSByZXN0IG9mIHRoZSBzZXJpZXMgdG8gbGFuZC4NCj4+DQo+
PiBbMV0gLSBodHRwczovL3NjYW5tYWlsLnRydXN0d2F2ZS5jb20vP2M9MjA5ODgmZD1uS1d3NG90
QlM4bm83MTEtbHkxRk5DNHVSMHYzTGt5c1J2ZHhZd20xUmcmdT1odHRwcyUzYSUyZiUyZmxvcmUl
MmVrZXJuZWwlMmVvcmclMmZsa21sJTJmMjAyMjAzMTQyMTMxNDMlMmUyNDA0MTYyLTEtY2hyaXMl
MmVwYWNraGFtJTQwYWxsaWVkdGVsZXNpcyUyZWNvJTJlbnolMmYNCj4gUGF0Y2h3b3JrIHNheXMg
aXQgZG9lc24ndCBhcHBseSBjbGVhbmx5IHRvIG5ldC1uZXh0IFsxXS4NCj4gQ291bGQgeW91IGRv
dWJsZSBjaGVjaz8NCj4NCj4gWzFdIGh0dHBzOi8vc2Nhbm1haWwudHJ1c3R3YXZlLmNvbS8/Yz0y
MDk4OCZkPW5LV3c0b3RCUzhubzcxMS1seTFGTkM0dVIwdjNMa3lzUnF4OGFGMjFRUSZ1PWh0dHBz
JTNhJTJmJTJmZ2l0JTJla2VybmVsJTJlb3JnJTJmcHViJTJmc2NtJTJmbGludXglMmZrZXJuZWwl
MmZnaXQlMmZuZXRkZXYlMmZuZXQtbmV4dCUyZWdpdCUyZg0KWWVhaCBzb3JyeSBsb29rcyBsaWtl
IHRoaXMgd2lsbCBjbGFzaCB3aXRoIDcyYmI5NTMxMTYyYSAoIm5ldDogbXZuZXRhOiANCnJlb3Jk
ZXIgaW5pdGlhbGlzYXRpb24iKS4gSSdsbCByZWJhc2UgbXkgYnJhbmNoIG9uIHRvcCBvZiANCm5l
dC1uZXh0L21hc3Rlci4gVGhlIGxvZ2ljYWwgY2hhbmdlIGlzIHNpbXBsZSBlbm91Z2ggYnV0IEkg
Y2FuIHNlZSB3aHkgDQpnaXQgYW0gd291bGQgb2JqZWN0Lg==
