Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB075520A5D
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 02:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233892AbiEJAv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 20:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232934AbiEJAvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 20:51:23 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC5926FA53
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 17:47:27 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 05B452C0657;
        Tue, 10 May 2022 00:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1652143644;
        bh=O62/MuB5DfIPCy/99w3PB/ZcJauwI7DwMNJ113L0YY8=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=sIyJG+i3WotUf8q+s3nTTzdgXxJaSSGGHFw3FLxspp6J7TnERS2nqcnOtoYwEi6Tn
         43WLTGraogS44F7O+s1LOW+WRKU+oUEkhvHiScXB+mFjDRJ8w2N5FlulnbDFXa3Jkf
         cgHxw67Jyd2hvgzDE7nVqhR+6t/0fFpwC7ObVQj/NSmI+e8PDzEBTVHExMHuV10tyQ
         kVuO42LIa68zYWD/k1koJmxzc/+p1QyioTvveDDIs5SGaHIcmVzVyjWKGHm5onulgl
         PBcAmM/aI5hGdr1uZrvulWXdFgHglG7s3O2E7JWeAtw0D1/9yEvu6f5pF4NV+UDH1A
         rJIWVreJDr7Pw==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B6279b61b0001>; Tue, 10 May 2022 12:47:23 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Tue, 10 May 2022 12:47:23 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.033; Tue, 10 May 2022 12:47:23 +1200
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] dt-bindings: net: orion-mdio: Convert to JSON schema
Thread-Topic: [PATCH v2] dt-bindings: net: orion-mdio: Convert to JSON schema
Thread-Index: AQHYYMP6mHcpllAtgkSisWTd5a/GH60WfvkAgAAFWoA=
Date:   Tue, 10 May 2022 00:47:23 +0000
Message-ID: <1eae77d7-300f-4356-c4f4-263c0d3f2bac@alliedtelesis.co.nz>
References: <20220505210621.3637268-1-chris.packham@alliedtelesis.co.nz>
 <20220509172814.31f83802@kernel.org>
In-Reply-To: <20220509172814.31f83802@kernel.org>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6DFE5E6DFC55B647B6A1C7869F4C2C6F@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=C7GXNjH+ c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=oKJsc7D3gJEA:10 a=IkcTkHD0fZMA:10 a=oZkIemNP1mAA:10 a=rT2x1fzD6ogiLAHi0b4A:9 a=QEXdDO2ut3YA:10
X-SEG-SpamProfiler-Score: 0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxMC8wNS8yMiAxMjoyOCwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IE9uIEZyaSwgIDYg
TWF5IDIwMjIgMDk6MDY6MjAgKzEyMDAgQ2hyaXMgUGFja2hhbSB3cm90ZToNCj4+IFN1YmplY3Q6
IFtQQVRDSCB2Ml0gZHQtYmluZGluZ3M6IG5ldDogb3Jpb24tbWRpbzogQ29udmVydCB0byBKU09O
IHNjaGVtYQ0KPiBKU09OIG9yIFlBTUw/DQoNCkkgYmFzZWQgdGhhdCBvbiBvdGhlciBjb21taXRz
IGF0IHRoYXQgZG8gc29tZXRoaW5nIHNpbWlsYXIgYW5kIHNheSANCiJDb252ZXJ0IHRvIEpTT04g
c2NoZW1hIiwgYWx0aG91Z2ggSSBtaWdodCBiZSBvcGVyYXRpbmcgb24gb2xkIGRhdGEuDQoNCkxv
b2tpbmcgYWdhaW4gbm93IHdpdGggYGdpdCBsb2cgLS1vbmVsaW5lIC0tbm8tbWVyZ2VzIC0tZ3Jl
cCBvbnZlcnQgLS0gDQpEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvYCBJIHNlZSAi
Q29udmVydCBiaW5kaW5nIHRvIFlBTUwiIGFuZCANCiJjb252ZXJ0IHRvIGR0c2NoZW1hIiAoc3Rp
bGwgYSBmZXcganNvbi1zY2hlbWEgaW4gdGhlcmUpLg0KDQpJIGd1ZXNzIHRlY2huaWNhbGx5IHRo
ZSBiaW5kaW5nIGlzIHdyaXR0ZW4gaW4gWUFNTCBidXQgZm9ybXMgcGFydCBvZiANCnNjaGVtYSB3
aGljaCBpcyB1bHRpbWF0ZWx5IGNvbnN1bWVkIGJ5IGpzb25zY2hlbWEgYnV0IHBlcmhhcHMgdGhl
IHVzZSBvZiANCmpzb25zY2hlbWEgaXMgYW4gaW1wbGVtZW50YXRpb24gZGV0YWlsIHRoYXQgZG9l
c24ndCByZXF1aXJlIG1lbnRpb25pbmcuDQoNCkknbSBoYXBweSB0byByZXdvcmQgdGhlIHN1Ympl
Y3QgYW5kIHNlbmQgYSB2MyBpZiBwZW9wbGUgZmVlbCBzdHJvbmdseSANCmFib3V0IGl0Lg0K
