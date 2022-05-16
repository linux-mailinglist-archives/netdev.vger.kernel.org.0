Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D64C529398
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 00:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348650AbiEPW1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 18:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344361AbiEPW1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 18:27:48 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671D92BB3C
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 15:27:45 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id CAC512C022D;
        Mon, 16 May 2022 22:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1652740063;
        bh=vWRtTASbvm3R6/S84QiHt+3cZqxDTvW63qF8dtDudug=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=gESDsPVBwkreQzeP1zMTwS9FkMLMkdsvHkDXJFU2dsqMJHaA7sRasYkbvvwWbyitf
         3us4yseh7RwEHzD9GC74ZIcyAlJX5t9MypcrN0wN5qvqsD7ngT3fW4dyVTmj2GzCUD
         kMqr0PQPVyL4KQkGctSQ0vT1FBod0nzU5BWSUaqs9rkZ39Ddyl2EkNTtndfPcjMLBL
         Ru47LgHl0Z/NVgBhQbs2V9dra/oW0Hm2TgwMbKAm1/dOTqnGEDv0vd5ajtI3irKjJ1
         B7tFEElOvynU4yI2aYjIaPmOV3a7U+ZbnS3i0IQ0iauqTPdHrf8D+TrB62X6zl31ql
         gQu0D6aledEkA==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B6282cfdf0001>; Tue, 17 May 2022 10:27:43 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1497.36; Tue, 17 May 2022 10:27:42 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.036; Tue, 17 May 2022 10:27:42 +1200
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Rob Herring <robh@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>
Subject: Re: [PATCH v2] dt-bindings: net: orion-mdio: Convert to JSON schema
Thread-Topic: [PATCH v2] dt-bindings: net: orion-mdio: Convert to JSON schema
Thread-Index: AQHYYMP6mHcpllAtgkSisWTd5a/GH60hF3mAgABDs4CAAAJyAA==
Date:   Mon, 16 May 2022 22:27:42 +0000
Message-ID: <cf956c25-f505-6ec0-260c-496c7d1322a1@alliedtelesis.co.nz>
References: <20220505210621.3637268-1-chris.packham@alliedtelesis.co.nz>
 <20220516181639.GB2997786-robh@kernel.org>
 <0c67af76-df5e-1684-820c-f28aa6f50fe1@alliedtelesis.co.nz>
In-Reply-To: <0c67af76-df5e-1684-820c-f28aa6f50fe1@alliedtelesis.co.nz>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <5F1A3EF8F8EA6C49A514E30FD1D64276@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=U+Hs8tju c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=oKJsc7D3gJEA:10 a=IkcTkHD0fZMA:10 a=oZkIemNP1mAA:10 a=62ntRvTiAAAA:8 a=gEfo2CItAAAA:8 a=whBdIyEpE15o_pd2gCMA:9 a=QEXdDO2ut3YA:10 a=pToNdpNmrtiFLRE6bQ9Z:22 a=sptkURWiP4Gy88Gu7hUp:22
X-SEG-SpamProfiler-Score: 0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxNy8wNS8yMiAxMDoxOCwgQ2hyaXMgUGFja2hhbSB3cm90ZToNCj4gSGkgUm9iLA0KPg0K
PiBPbiAxNy8wNS8yMiAwNjoxNiwgUm9iIEhlcnJpbmcgd3JvdGU6DQo+PiBPbiBGcmksIE1heSAw
NiwgMjAyMiBhdCAwOTowNjoyMEFNICsxMjAwLCBDaHJpcyBQYWNraGFtIHdyb3RlOg0KPj4+IENv
bnZlcnQgdGhlIG1hcnZlbGwsb3Jpb24tbWRpbyBiaW5kaW5nIHRvIEpTT04gc2NoZW1hLg0KPj4+
DQo+Pj4gU2lnbmVkLW9mZi1ieTogQ2hyaXMgUGFja2hhbSA8Y2hyaXMucGFja2hhbUBhbGxpZWR0
ZWxlc2lzLmNvLm56Pg0KPj4+IC0tLQ0KPj4+DQo+Pj4gTm90ZXM6DQo+Pj4gwqDCoMKgwqAgVGhp
cyBkb2VzIHRocm93IHVwIHRoZSBmb2xsb3dpbmcgZHRic19jaGVjayB3YXJuaW5ncyBmb3IgDQo+
Pj4gdHVycmlzLW1veDoNCj4+PiBhcmNoL2FybTY0L2Jvb3QvZHRzL21hcnZlbGwvYXJtYWRhLTM3
MjAtdHVycmlzLW1veC5kdGI6IG1kaW9AMzIwMDQ6IA0KPj4+IHN3aXRjaDBAMTA6cmVnOiBbWzE2
XSwgWzBdXSBpcyB0b28gbG9uZw0KPj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBGcm9tIHNj
aGVtYTogDQo+Pj4gRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9tYXJ2ZWxs
LG9yaW9uLW1kaW8ueWFtbA0KPj4+IMKgwqDCoMKgIGFyY2gvYXJtNjQvYm9vdC9kdHMvbWFydmVs
bC9hcm1hZGEtMzcyMC10dXJyaXMtbW94LmR0YjogDQo+Pj4gbWRpb0AzMjAwNDogc3dpdGNoMEAy
OnJlZzogW1syXSwgWzBdXSBpcyB0b28gbG9uZw0KPj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBGcm9tIHNjaGVtYTogDQo+Pj4gRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25l
dC9tYXJ2ZWxsLG9yaW9uLW1kaW8ueWFtbA0KPj4+IMKgwqDCoMKgIGFyY2gvYXJtNjQvYm9vdC9k
dHMvbWFydmVsbC9hcm1hZGEtMzcyMC10dXJyaXMtbW94LmR0YjogDQo+Pj4gbWRpb0AzMjAwNDog
c3dpdGNoMUAxMTpyZWc6IFtbMTddLCBbMF1dIGlzIHRvbyBsb25nDQo+Pj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIEZyb20gc2NoZW1hOiANCj4+PiBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUv
YmluZGluZ3MvbmV0L21hcnZlbGwsb3Jpb24tbWRpby55YW1sDQo+Pj4gwqDCoMKgwqAgYXJjaC9h
cm02NC9ib290L2R0cy9tYXJ2ZWxsL2FybWFkYS0zNzIwLXR1cnJpcy1tb3guZHRiOiANCj4+PiBt
ZGlvQDMyMDA0OiBzd2l0Y2gxQDI6cmVnOiBbWzJdLCBbMF1dIGlzIHRvbyBsb25nDQo+Pj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIEZyb20gc2NoZW1hOiANCj4+PiBEb2N1bWVudGF0aW9uL2Rl
dmljZXRyZWUvYmluZGluZ3MvbmV0L21hcnZlbGwsb3Jpb24tbWRpby55YW1sDQo+Pj4gwqDCoMKg
wqAgYXJjaC9hcm02NC9ib290L2R0cy9tYXJ2ZWxsL2FybWFkYS0zNzIwLXR1cnJpcy1tb3guZHRi
OiANCj4+PiBtZGlvQDMyMDA0OiBzd2l0Y2gyQDEyOnJlZzogW1sxOF0sIFswXV0gaXMgdG9vIGxv
bmcNCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgRnJvbSBzY2hlbWE6IA0KPj4+IERvY3Vt
ZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvbWFydmVsbCxvcmlvbi1tZGlvLnlhbWwN
Cj4+PiDCoMKgwqDCoCBhcmNoL2FybTY0L2Jvb3QvZHRzL21hcnZlbGwvYXJtYWRhLTM3MjAtdHVy
cmlzLW1veC5kdGI6IA0KPj4+IG1kaW9AMzIwMDQ6IHN3aXRjaDJAMjpyZWc6IFtbMl0sIFswXV0g
aXMgdG9vIGxvbmcNCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgRnJvbSBzY2hlbWE6IA0K
Pj4+IERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvbWFydmVsbCxvcmlvbi1t
ZGlvLnlhbWwNCj4+PiDCoMKgwqDCoCDCoMKgwqDCoCBJIHRoaW5rIHRoZXkncmUgYWxsIGdlbnVp
bmUgYnV0IEknbSBoZXNpdGFudCB0byBsZWFwIGluIA0KPj4+IGFuZCBmaXggdGhlbQ0KPj4+IMKg
wqDCoMKgIHdpdGhvdXQgYmVpbmcgYWJsZSB0byB0ZXN0IHRoZW0uDQo+Pj4gwqDCoMKgwqAgwqDC
oMKgwqAgSSBhbHNvIG5lZWQgdG8gc2V0IHVuZXZhbHVhdGVkUHJvcGVydGllczogdHJ1ZSB0byBj
YXRlciANCj4+PiBmb3IgdGhlIEwyDQo+Pj4gwqDCoMKgwqAgc3dpdGNoIG9uIHR1cnJpcy1tb3gg
KGFuZCBwcm9iYWJseSBvdGhlcnMpLiBUaGF0IG1pZ2h0IGJlIA0KPj4+IGJldHRlciB0YWNrbGVk
DQo+Pj4gwqDCoMKgwqAgaW4gdGhlIGNvcmUgbWRpby55YW1sIHNjaGVtYSBidXQgSSB3YXNuJ3Qg
cGxhbm5pbmcgb24gdG91Y2hpbmcgDQo+Pj4gdGhhdC4NCj4+PiDCoMKgwqDCoCDCoMKgwqDCoCBD
aGFuZ2VzIGluIHYyOg0KPj4+IMKgwqDCoMKgIC0gQWRkIEFuZHJldyBhcyBtYWludGFpbmVyICh0
aGFua3MgZm9yIHZvbHVudGVlcmluZykNCj4+Pg0KPj4+IMKgIC4uLi9iaW5kaW5ncy9uZXQvbWFy
dmVsbCxvcmlvbi1tZGlvLnlhbWzCoMKgwqDCoMKgIHwgNjAgDQo+Pj4gKysrKysrKysrKysrKysr
KysrKw0KPj4+IMKgIC4uLi9iaW5kaW5ncy9uZXQvbWFydmVsbC1vcmlvbi1tZGlvLnR4dMKgwqDC
oMKgwqDCoCB8IDU0IC0tLS0tLS0tLS0tLS0tLS0tDQo+Pj4gwqAgMiBmaWxlcyBjaGFuZ2VkLCA2
MCBpbnNlcnRpb25zKCspLCA1NCBkZWxldGlvbnMoLSkNCj4+PiDCoCBjcmVhdGUgbW9kZSAxMDA2
NDQgDQo+Pj4gRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9tYXJ2ZWxsLG9y
aW9uLW1kaW8ueWFtbA0KPj4+IMKgIGRlbGV0ZSBtb2RlIDEwMDY0NCANCj4+PiBEb2N1bWVudGF0
aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L21hcnZlbGwtb3Jpb24tbWRpby50eHQNCj4+Pg0K
Pj4+IGRpZmYgLS1naXQgDQo+Pj4gYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3Mv
bmV0L21hcnZlbGwsb3Jpb24tbWRpby55YW1sIA0KPj4+IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0
cmVlL2JpbmRpbmdzL25ldC9tYXJ2ZWxsLG9yaW9uLW1kaW8ueWFtbA0KPj4+IG5ldyBmaWxlIG1v
ZGUgMTAwNjQ0DQo+Pj4gaW5kZXggMDAwMDAwMDAwMDAwLi5mZTNhMzQxMmYwOTMNCj4+PiAtLS0g
L2Rldi9udWxsDQo+Pj4gKysrIGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25l
dC9tYXJ2ZWxsLG9yaW9uLW1kaW8ueWFtbA0KPj4+IEBAIC0wLDAgKzEsNjAgQEANCj4+PiArIyBT
UERYLUxpY2Vuc2UtSWRlbnRpZmllcjogKEdQTC0yLjAtb25seSBPUiBCU0QtMi1DbGF1c2UpDQo+
Pj4gKyVZQU1MIDEuMg0KPj4+ICstLS0NCj4+PiArJGlkOiANCj4+PiBodHRwOi8vc2Nhbm1haWwu
dHJ1c3R3YXZlLmNvbS8/Yz0yMDk4OCZkPWo1V0M0cl9wWm5ETUlMYWpIMWthS0xMOW9DN2tRamd2
X2JrRFdKT2hFUSZ1PWh0dHAlM2ElMmYlMmZkZXZpY2V0cmVlJTJlb3JnJTJmc2NoZW1hcyUyZm5l
dCUyZm1hcnZlbGwlMmNvcmlvbi1tZGlvJTJleWFtbCUyMw0KPj4+ICskc2NoZW1hOiANCj4+PiBo
dHRwOi8vc2Nhbm1haWwudHJ1c3R3YXZlLmNvbS8/Yz0yMDk4OCZkPWo1V0M0cl9wWm5ETUlMYWpI
MWthS0xMOW9DN2tRamd2X2U0Q0RjZXRFdyZ1PWh0dHAlM2ElMmYlMmZkZXZpY2V0cmVlJTJlb3Jn
JTJmbWV0YS1zY2hlbWFzJTJmY29yZSUyZXlhbWwlMjMNCj4+PiArDQo+Pj4gK3RpdGxlOiBNYXJ2
ZWxsIE1ESU8gRXRoZXJuZXQgQ29udHJvbGxlciBpbnRlcmZhY2UNCj4+PiArDQo+Pj4gK21haW50
YWluZXJzOg0KPj4+ICvCoCAtIEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4NCj4+PiArDQo+
Pj4gK2Rlc2NyaXB0aW9uOiB8DQo+Pj4gK8KgIFRoZSBFdGhlcm5ldCBjb250cm9sbGVycyBvZiB0
aGUgTWFydmVsIEtpcmt3b29kLCBEb3ZlLCBPcmlvbjV4LCANCj4+PiBNVjc4eHgwLA0KPj4+ICvC
oCBBcm1hZGEgMzcwLCBBcm1hZGEgWFAsIEFybWFkYSA3ayBhbmQgQXJtYWRhIDhrIGhhdmUgYW4g
aWRlbnRpY2FsIA0KPj4+IHVuaXQgdGhhdA0KPj4+ICvCoCBwcm92aWRlcyBhbiBpbnRlcmZhY2Ug
d2l0aCB0aGUgTURJTyBidXMuIEFkZGl0aW9uYWxseSwgQXJtYWRhIDdrIA0KPj4+IGFuZCBBcm1h
ZGENCj4+PiArwqAgOGsgaGFzIGEgc2Vjb25kIHVuaXQgd2hpY2ggcHJvdmlkZXMgYW4gaW50ZXJm
YWNlIHdpdGggdGhlIHhNRElPIA0KPj4+IGJ1cy4gVGhpcw0KPj4+ICvCoCBkcml2ZXIgaGFuZGxl
cyB0aGVzZSBpbnRlcmZhY2VzLg0KPj4+ICsNCj4+PiArYWxsT2Y6DQo+Pj4gK8KgIC0gJHJlZjog
Im1kaW8ueWFtbCMiDQo+Pj4gKw0KPj4+ICtwcm9wZXJ0aWVzOg0KPj4+ICvCoCBjb21wYXRpYmxl
Og0KPj4+ICvCoMKgwqAgZW51bToNCj4+PiArwqDCoMKgwqDCoCAtIG1hcnZlbGwsb3Jpb24tbWRp
bw0KPj4+ICvCoMKgwqDCoMKgIC0gbWFydmVsbCx4bWRpbw0KPj4+ICsNCj4+PiArwqAgcmVnOg0K
Pj4+ICvCoMKgwqAgbWF4SXRlbXM6IDENCj4+PiArDQo+Pj4gK8KgIGludGVycnVwdHM6DQo+Pj4g
K8KgwqDCoCBtYXhJdGVtczogMQ0KPj4+ICsNCj4+PiArwqAgY2xvY2tzOg0KPj4+ICvCoMKgwqAg
bWluSXRlbXM6IDENCj4+PiArwqDCoMKgIG1heEl0ZW1zOiA0DQo+PiBSZWFsbHkgdGhpcyBzaG91
bGQgYmUgYmV0dGVyIGRlZmluZWQsIGJ1dCB0aGUgb3JpZ2luYWwgd2FzIG5vdC4NCj4+DQo+Pj4g
Kw0KPj4+ICtyZXF1aXJlZDoNCj4+PiArwqAgLSBjb21wYXRpYmxlDQo+Pj4gK8KgIC0gcmVnDQo+
Pj4gKw0KPj4+ICt1bmV2YWx1YXRlZFByb3BlcnRpZXM6IHRydWUNCj4+IFRoaXMgbXVzdCBiZSBm
YWxzZS4NCj4NCj4gUmlnaHQgbm93IHRoZXJlIGlzIG5vIHdheSAodGhhdCBJIGhhdmUgZm91bmQp
IG9mIGRlYWxpbmcgd2l0aCBub24tUEhZIA0KPiBkZXZpY2VzIGxpa2UgdGhlIGRzYSBzd2l0Y2hl
cyBzbyBzZXR0aW5nIHRoaXMgdG8gZmFsc2UgZ2VuZXJhdGVzIA0KPiB3YXJuaW5ncyBvbiB0dXJy
aXMtbW94Og0KPg0KPiBhcmNoL2FybTY0L2Jvb3QvZHRzL21hcnZlbGwvYXJtYWRhLTM3MjAtdHVy
cmlzLW1veC5kdGI6IG1kaW9AMzIwMDQ6IA0KPiBVbmV2YWx1YXRlZCBwcm9wZXJ0aWVzIGFyZSBu
b3QgYWxsb3dlZCAoJyNhZGRyZXNzLWNlbGxzJywgDQo+ICcjc2l6ZS1jZWxscycsICdldGhlcm5l
dC1waHlAMScsICdzd2l0Y2gwQDEwJywgJ3N3aXRjaDBAMicsIA0KPiAnc3dpdGNoMUAxMScsICdz
d2l0Y2gxQDInLCAnc3dpdGNoMkAxMicsICdzd2l0Y2gyQDInIHdlcmUgdW5leHBlY3RlZCkNCj4g
wqDCoMKgwqDCoMKgwqAgRnJvbSBzY2hlbWE6IA0KPiAvaG9tZS9jaHJpc3Avc3JjL2xpbnV4L0Rv
Y3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvbWFydmVsbCxvcmlvbi1tZGlvLnlh
bWwNCj4NCj4gVGhlcmUgYXJlIGFsc28gd2FybmluZ3MgYWJvdXQgdGhlIHNpemUgb2YgdGhlIHJl
ZyBwcm9wZXJ0eSBidXQgdGhlc2UgDQo+IHNlZW0gdG8gYmUgZ2VudWluZSBwcm9ibGVtcyB0aGF0
IE1hcmVrIGlzIGxvb2tpbmcgYXQuDQpBY3R1YWxseSBpdCBsb29rcyBpZiBJIGZpeCB0aGUgcmVn
IHByb2JsZW0gdGhlIG5lZWQgZm9yIA0KdW5ldmFsdWF0ZWRQcm9wZXJ0aWVzIGdvZXMgYXdheS4g
SSdsbCB3aGlwIHVwIGEgc21hbGwgcGF0Y2ggc2VyaWVzIG9uIA0KdG9wIG9mIG5ldC1uZXh0Lg0K
Pg0KPiBUaGlzIGNoYW5nZSBoYXMgYWxyZWFkeSBiZWVuIHBpY2tlZCB1cCBmb3IgbmV0LW5leHQg
YnV0IGlmIHlvdSBoYXZlIA0KPiBzdWdnZXN0aW9ucyBmb3IgaW1wcm92ZW1lbnQgSSdtIGhhcHB5
IHRvIHN1Ym1pdCB0aGVtIGFzIGFkZGl0aW9uYWwgDQo+IGNoYW5nZXMgb24tdG9wIG9mIHRoYXQu
DQo+DQo+Pg0KPj4+ICsNCj4+PiArZXhhbXBsZXM6DQo+Pj4gK8KgIC0gfA0KPj4+ICvCoMKgwqAg
bWRpb0BkMDA3MjAwNCB7DQo+Pj4gK8KgwqDCoMKgwqAgY29tcGF0aWJsZSA9ICJtYXJ2ZWxsLG9y
aW9uLW1kaW8iOw0KPj4+ICvCoMKgwqDCoMKgIHJlZyA9IDwweGQwMDcyMDA0IDB4ND47DQo+Pj4g
K8KgwqDCoMKgwqAgI2FkZHJlc3MtY2VsbHMgPSA8MT47DQo+Pj4gK8KgwqDCoMKgwqAgI3NpemUt
Y2VsbHMgPSA8MD47DQo+Pj4gK8KgwqDCoMKgwqAgaW50ZXJydXB0cyA9IDwzMD47DQo+Pj4gKw0K
Pj4+ICvCoMKgwqDCoMKgIHBoeTA6IGV0aGVybmV0LXBoeUAwIHsNCj4+PiArwqDCoMKgwqDCoMKg
wqAgcmVnID0gPDA+Ow0KPj4+ICvCoMKgwqDCoMKgIH07DQo+Pj4gKw0KPj4+ICvCoMKgwqDCoMKg
IHBoeTE6IGV0aGVybmV0LXBoeUAxIHsNCj4+PiArwqDCoMKgwqDCoMKgwqAgcmVnID0gPDE+Ow0K
Pj4+ICvCoMKgwqDCoMKgIH07DQo+Pj4gK8KgwqDCoCB9Ow0KPj4+IGRpZmYgLS1naXQgDQo+Pj4g
YS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L21hcnZlbGwtb3Jpb24tbWRp
by50eHQgDQo+Pj4gYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L21hcnZl
bGwtb3Jpb24tbWRpby50eHQNCj4+PiBkZWxldGVkIGZpbGUgbW9kZSAxMDA2NDQNCj4+PiBpbmRl
eCAzZjNjZmMxZDhkNGQuLjAwMDAwMDAwMDAwMA0KPj4+IC0tLSBhL0RvY3VtZW50YXRpb24vZGV2
aWNldHJlZS9iaW5kaW5ncy9uZXQvbWFydmVsbC1vcmlvbi1tZGlvLnR4dA0KPj4+ICsrKyAvZGV2
L251bGwNCj4+PiBAQCAtMSw1NCArMCwwIEBADQo+Pj4gLSogTWFydmVsbCBNRElPIEV0aGVybmV0
IENvbnRyb2xsZXIgaW50ZXJmYWNlDQo+Pj4gLQ0KPj4+IC1UaGUgRXRoZXJuZXQgY29udHJvbGxl
cnMgb2YgdGhlIE1hcnZlbCBLaXJrd29vZCwgRG92ZSwgT3Jpb241eCwNCj4+PiAtTVY3OHh4MCwg
QXJtYWRhIDM3MCwgQXJtYWRhIFhQLCBBcm1hZGEgN2sgYW5kIEFybWFkYSA4ayBoYXZlIGFuDQo+
Pj4gLWlkZW50aWNhbCB1bml0IHRoYXQgcHJvdmlkZXMgYW4gaW50ZXJmYWNlIHdpdGggdGhlIE1E
SU8gYnVzLg0KPj4+IC1BZGRpdGlvbmFsbHksIEFybWFkYSA3ayBhbmQgQXJtYWRhIDhrIGhhcyBh
IHNlY29uZCB1bml0IHdoaWNoDQo+Pj4gLXByb3ZpZGVzIGFuIGludGVyZmFjZSB3aXRoIHRoZSB4
TURJTyBidXMuIFRoaXMgZHJpdmVyIGhhbmRsZXMNCj4+PiAtdGhlc2UgaW50ZXJmYWNlcy4NCj4+
PiAtDQo+Pj4gLVJlcXVpcmVkIHByb3BlcnRpZXM6DQo+Pj4gLS0gY29tcGF0aWJsZTogIm1hcnZl
bGwsb3Jpb24tbWRpbyIgb3IgIm1hcnZlbGwseG1kaW8iDQo+Pj4gLS0gcmVnOiBhZGRyZXNzIGFu
ZCBsZW5ndGggb2YgdGhlIE1ESU8gcmVnaXN0ZXJzLsKgIFdoZW4gYW4gaW50ZXJydXB0IGlzDQo+
Pj4gLcKgIG5vdCBwcmVzZW50LCB0aGUgbGVuZ3RoIGlzIHRoZSBzaXplIG9mIHRoZSBTTUkgcmVn
aXN0ZXIgKDQgYnl0ZXMpDQo+Pj4gLcKgIG90aGVyd2lzZSBpdCBtdXN0IGJlIDB4ODQgYnl0ZXMg
dG8gY292ZXIgdGhlIGludGVycnVwdCBjb250cm9sDQo+Pj4gLcKgIHJlZ2lzdGVycy4NCj4+PiAt
DQo+Pj4gLU9wdGlvbmFsIHByb3BlcnRpZXM6DQo+Pj4gLS0gaW50ZXJydXB0czogaW50ZXJydXB0
IGxpbmUgbnVtYmVyIGZvciB0aGUgU01JIGVycm9yL2RvbmUgaW50ZXJydXB0DQo+Pj4gLS0gY2xv
Y2tzOiBwaGFuZGxlIGZvciB1cCB0byBmb3VyIHJlcXVpcmVkIGNsb2NrcyBmb3IgdGhlIE1ESU8g
aW5zdGFuY2UNCj4+PiAtDQo+Pj4gLVRoZSBjaGlsZCBub2RlcyBvZiB0aGUgTURJTyBkcml2ZXIg
YXJlIHRoZSBpbmRpdmlkdWFsIFBIWSBkZXZpY2VzDQo+Pj4gLWNvbm5lY3RlZCB0byB0aGlzIE1E
SU8gYnVzLiBUaGV5IG11c3QgaGF2ZSBhICJyZWciIHByb3BlcnR5IGdpdmVuIHRoZQ0KPj4+IC1Q
SFkgYWRkcmVzcyBvbiB0aGUgTURJTyBidXMuDQo+Pj4gLQ0KPj4+IC1FeGFtcGxlIGF0IHRoZSBT
b0MgbGV2ZWwgd2l0aG91dCBhbiBpbnRlcnJ1cHQgcHJvcGVydHk6DQo+Pj4gLQ0KPj4+IC1tZGlv
IHsNCj4+PiAtwqDCoMKgICNhZGRyZXNzLWNlbGxzID0gPDE+Ow0KPj4+IC3CoMKgwqAgI3NpemUt
Y2VsbHMgPSA8MD47DQo+Pj4gLcKgwqDCoCBjb21wYXRpYmxlID0gIm1hcnZlbGwsb3Jpb24tbWRp
byI7DQo+Pj4gLcKgwqDCoCByZWcgPSA8MHhkMDA3MjAwNCAweDQ+Ow0KPj4+IC19Ow0KPj4+IC0N
Cj4+PiAtRXhhbXBsZSB3aXRoIGFuIGludGVycnVwdCBwcm9wZXJ0eToNCj4+PiAtDQo+Pj4gLW1k
aW8gew0KPj4+IC3CoMKgwqAgI2FkZHJlc3MtY2VsbHMgPSA8MT47DQo+Pj4gLcKgwqDCoCAjc2l6
ZS1jZWxscyA9IDwwPjsNCj4+PiAtwqDCoMKgIGNvbXBhdGlibGUgPSAibWFydmVsbCxvcmlvbi1t
ZGlvIjsNCj4+PiAtwqDCoMKgIHJlZyA9IDwweGQwMDcyMDA0IDB4ODQ+Ow0KPj4+IC3CoMKgwqAg
aW50ZXJydXB0cyA9IDwzMD47DQo+Pj4gLX07DQo+Pj4gLQ0KPj4+IC1BbmQgYXQgdGhlIGJvYXJk
IGxldmVsOg0KPj4+IC0NCj4+PiAtbWRpbyB7DQo+Pj4gLcKgwqDCoCBwaHkwOiBldGhlcm5ldC1w
aHlAMCB7DQo+Pj4gLcKgwqDCoMKgwqDCoMKgIHJlZyA9IDwwPjsNCj4+PiAtwqDCoMKgIH07DQo+
Pj4gLQ0KPj4+IC3CoMKgwqAgcGh5MTogZXRoZXJuZXQtcGh5QDEgew0KPj4+IC3CoMKgwqDCoMKg
wqDCoCByZWcgPSA8MT47DQo+Pj4gLcKgwqDCoCB9Ow0KPj4+IC19DQo+Pj4gLS0gDQo+Pj4gMi4z
Ni4wDQo+Pj4NCj4+Pg==
