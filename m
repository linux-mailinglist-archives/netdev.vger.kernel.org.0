Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58B6A529382
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 00:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349642AbiEPWTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 18:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiEPWTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 18:19:02 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C433FDB7
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 15:19:00 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id B2C492C022D;
        Mon, 16 May 2022 22:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1652739538;
        bh=ALoAtjkvG3VWMRlDeofGOgUz6gCiVuc3XJDtAKLROUY=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=oqzFt6LB+ctPMzuXV5POc0CkIGK2tD0hobkl2Wc0icHo3I1ACqDTCzzIEt7RC13rC
         8qG3SrS9oxKarVRw8HV0zblPICV7IyWMBw57ZqeUsK3VcSJcpoa+jakYf79QgtjlEw
         6ey6ykPOoU6TDe1uKNFfP/NQw02kiLa8PkJD7oIsBjcxKFu32tpI0dl4yCuJQSq0aF
         80iPQLYWfr69JT7jdVND14o/Nv5kFau5z5vdJGno+QHu7E23k2dUkJUDuWWIXEg777
         EDYbzmaVbKcW3H1NVE5grumX37PYA4He42pD91b1C21VaWWZViSoZJIUWSIbLzFAc7
         ibVYc98rI81AQ==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B6282cdd20001>; Tue, 17 May 2022 10:18:58 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.36; Tue, 17 May 2022 10:18:57 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.036; Tue, 17 May 2022 10:18:57 +1200
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
Thread-Index: AQHYYMP6mHcpllAtgkSisWTd5a/GH60hF3mAgABDs4A=
Date:   Mon, 16 May 2022 22:18:56 +0000
Message-ID: <0c67af76-df5e-1684-820c-f28aa6f50fe1@alliedtelesis.co.nz>
References: <20220505210621.3637268-1-chris.packham@alliedtelesis.co.nz>
 <20220516181639.GB2997786-robh@kernel.org>
In-Reply-To: <20220516181639.GB2997786-robh@kernel.org>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E2597CD1CC8C614EA28C36484B7683E5@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=U+Hs8tju c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=oKJsc7D3gJEA:10 a=IkcTkHD0fZMA:10 a=oZkIemNP1mAA:10 a=62ntRvTiAAAA:8 a=gEfo2CItAAAA:8 a=9ZP6MR3HTvLpxlA9O8QA:9 a=QEXdDO2ut3YA:10 a=pToNdpNmrtiFLRE6bQ9Z:22 a=sptkURWiP4Gy88Gu7hUp:22
X-SEG-SpamProfiler-Score: 0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUm9iLA0KDQpPbiAxNy8wNS8yMiAwNjoxNiwgUm9iIEhlcnJpbmcgd3JvdGU6DQo+IE9uIEZy
aSwgTWF5IDA2LCAyMDIyIGF0IDA5OjA2OjIwQU0gKzEyMDAsIENocmlzIFBhY2toYW0gd3JvdGU6
DQo+PiBDb252ZXJ0IHRoZSBtYXJ2ZWxsLG9yaW9uLW1kaW8gYmluZGluZyB0byBKU09OIHNjaGVt
YS4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBDaHJpcyBQYWNraGFtIDxjaHJpcy5wYWNraGFtQGFs
bGllZHRlbGVzaXMuY28ubno+DQo+PiAtLS0NCj4+DQo+PiBOb3RlczoNCj4+ICAgICAgVGhpcyBk
b2VzIHRocm93IHVwIHRoZSBmb2xsb3dpbmcgZHRic19jaGVjayB3YXJuaW5ncyBmb3IgdHVycmlz
LW1veDoNCj4+ICAgICAgDQo+PiAgICAgIGFyY2gvYXJtNjQvYm9vdC9kdHMvbWFydmVsbC9hcm1h
ZGEtMzcyMC10dXJyaXMtbW94LmR0YjogbWRpb0AzMjAwNDogc3dpdGNoMEAxMDpyZWc6IFtbMTZd
LCBbMF1dIGlzIHRvbyBsb25nDQo+PiAgICAgICAgICAgICAgRnJvbSBzY2hlbWE6IERvY3VtZW50
YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvbWFydmVsbCxvcmlvbi1tZGlvLnlhbWwNCj4+
ICAgICAgYXJjaC9hcm02NC9ib290L2R0cy9tYXJ2ZWxsL2FybWFkYS0zNzIwLXR1cnJpcy1tb3gu
ZHRiOiBtZGlvQDMyMDA0OiBzd2l0Y2gwQDI6cmVnOiBbWzJdLCBbMF1dIGlzIHRvbyBsb25nDQo+
PiAgICAgICAgICAgICAgRnJvbSBzY2hlbWE6IERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5k
aW5ncy9uZXQvbWFydmVsbCxvcmlvbi1tZGlvLnlhbWwNCj4+ICAgICAgYXJjaC9hcm02NC9ib290
L2R0cy9tYXJ2ZWxsL2FybWFkYS0zNzIwLXR1cnJpcy1tb3guZHRiOiBtZGlvQDMyMDA0OiBzd2l0
Y2gxQDExOnJlZzogW1sxN10sIFswXV0gaXMgdG9vIGxvbmcNCj4+ICAgICAgICAgICAgICBGcm9t
IHNjaGVtYTogRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9tYXJ2ZWxsLG9y
aW9uLW1kaW8ueWFtbA0KPj4gICAgICBhcmNoL2FybTY0L2Jvb3QvZHRzL21hcnZlbGwvYXJtYWRh
LTM3MjAtdHVycmlzLW1veC5kdGI6IG1kaW9AMzIwMDQ6IHN3aXRjaDFAMjpyZWc6IFtbMl0sIFsw
XV0gaXMgdG9vIGxvbmcNCj4+ICAgICAgICAgICAgICBGcm9tIHNjaGVtYTogRG9jdW1lbnRhdGlv
bi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9tYXJ2ZWxsLG9yaW9uLW1kaW8ueWFtbA0KPj4gICAg
ICBhcmNoL2FybTY0L2Jvb3QvZHRzL21hcnZlbGwvYXJtYWRhLTM3MjAtdHVycmlzLW1veC5kdGI6
IG1kaW9AMzIwMDQ6IHN3aXRjaDJAMTI6cmVnOiBbWzE4XSwgWzBdXSBpcyB0b28gbG9uZw0KPj4g
ICAgICAgICAgICAgIEZyb20gc2NoZW1hOiBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGlu
Z3MvbmV0L21hcnZlbGwsb3Jpb24tbWRpby55YW1sDQo+PiAgICAgIGFyY2gvYXJtNjQvYm9vdC9k
dHMvbWFydmVsbC9hcm1hZGEtMzcyMC10dXJyaXMtbW94LmR0YjogbWRpb0AzMjAwNDogc3dpdGNo
MkAyOnJlZzogW1syXSwgWzBdXSBpcyB0b28gbG9uZw0KPj4gICAgICAgICAgICAgIEZyb20gc2No
ZW1hOiBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L21hcnZlbGwsb3Jpb24t
bWRpby55YW1sDQo+PiAgICAgIA0KPj4gICAgICBJIHRoaW5rIHRoZXkncmUgYWxsIGdlbnVpbmUg
YnV0IEknbSBoZXNpdGFudCB0byBsZWFwIGluIGFuZCBmaXggdGhlbQ0KPj4gICAgICB3aXRob3V0
IGJlaW5nIGFibGUgdG8gdGVzdCB0aGVtLg0KPj4gICAgICANCj4+ICAgICAgSSBhbHNvIG5lZWQg
dG8gc2V0IHVuZXZhbHVhdGVkUHJvcGVydGllczogdHJ1ZSB0byBjYXRlciBmb3IgdGhlIEwyDQo+
PiAgICAgIHN3aXRjaCBvbiB0dXJyaXMtbW94IChhbmQgcHJvYmFibHkgb3RoZXJzKS4gVGhhdCBt
aWdodCBiZSBiZXR0ZXIgdGFja2xlZA0KPj4gICAgICBpbiB0aGUgY29yZSBtZGlvLnlhbWwgc2No
ZW1hIGJ1dCBJIHdhc24ndCBwbGFubmluZyBvbiB0b3VjaGluZyB0aGF0Lg0KPj4gICAgICANCj4+
ICAgICAgQ2hhbmdlcyBpbiB2MjoNCj4+ICAgICAgLSBBZGQgQW5kcmV3IGFzIG1haW50YWluZXIg
KHRoYW5rcyBmb3Igdm9sdW50ZWVyaW5nKQ0KPj4NCj4+ICAgLi4uL2JpbmRpbmdzL25ldC9tYXJ2
ZWxsLG9yaW9uLW1kaW8ueWFtbCAgICAgIHwgNjAgKysrKysrKysrKysrKysrKysrKw0KPj4gICAu
Li4vYmluZGluZ3MvbmV0L21hcnZlbGwtb3Jpb24tbWRpby50eHQgICAgICAgfCA1NCAtLS0tLS0t
LS0tLS0tLS0tLQ0KPj4gICAyIGZpbGVzIGNoYW5nZWQsIDYwIGluc2VydGlvbnMoKyksIDU0IGRl
bGV0aW9ucygtKQ0KPj4gICBjcmVhdGUgbW9kZSAxMDA2NDQgRG9jdW1lbnRhdGlvbi9kZXZpY2V0
cmVlL2JpbmRpbmdzL25ldC9tYXJ2ZWxsLG9yaW9uLW1kaW8ueWFtbA0KPj4gICBkZWxldGUgbW9k
ZSAxMDA2NDQgRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9tYXJ2ZWxsLW9y
aW9uLW1kaW8udHh0DQo+Pg0KPj4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJl
ZS9iaW5kaW5ncy9uZXQvbWFydmVsbCxvcmlvbi1tZGlvLnlhbWwgYi9Eb2N1bWVudGF0aW9uL2Rl
dmljZXRyZWUvYmluZGluZ3MvbmV0L21hcnZlbGwsb3Jpb24tbWRpby55YW1sDQo+PiBuZXcgZmls
ZSBtb2RlIDEwMDY0NA0KPj4gaW5kZXggMDAwMDAwMDAwMDAwLi5mZTNhMzQxMmYwOTMNCj4+IC0t
LSAvZGV2L251bGwNCj4+ICsrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9u
ZXQvbWFydmVsbCxvcmlvbi1tZGlvLnlhbWwNCj4+IEBAIC0wLDAgKzEsNjAgQEANCj4+ICsjIFNQ
RFgtTGljZW5zZS1JZGVudGlmaWVyOiAoR1BMLTIuMC1vbmx5IE9SIEJTRC0yLUNsYXVzZSkNCj4+
ICslWUFNTCAxLjINCj4+ICstLS0NCj4+ICskaWQ6IGh0dHA6Ly9zY2FubWFpbC50cnVzdHdhdmUu
Y29tLz9jPTIwOTg4JmQ9ajVXQzRyX3BabkRNSUxhakgxa2FLTEw5b0M3a1FqZ3ZfYmtEV0pPaEVR
JnU9aHR0cCUzYSUyZiUyZmRldmljZXRyZWUlMmVvcmclMmZzY2hlbWFzJTJmbmV0JTJmbWFydmVs
bCUyY29yaW9uLW1kaW8lMmV5YW1sJTIzDQo+PiArJHNjaGVtYTogaHR0cDovL3NjYW5tYWlsLnRy
dXN0d2F2ZS5jb20vP2M9MjA5ODgmZD1qNVdDNHJfcFpuRE1JTGFqSDFrYUtMTDlvQzdrUWpndl9l
NENEY2V0RXcmdT1odHRwJTNhJTJmJTJmZGV2aWNldHJlZSUyZW9yZyUyZm1ldGEtc2NoZW1hcyUy
ZmNvcmUlMmV5YW1sJTIzDQo+PiArDQo+PiArdGl0bGU6IE1hcnZlbGwgTURJTyBFdGhlcm5ldCBD
b250cm9sbGVyIGludGVyZmFjZQ0KPj4gKw0KPj4gK21haW50YWluZXJzOg0KPj4gKyAgLSBBbmRy
ZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+DQo+PiArDQo+PiArZGVzY3JpcHRpb246IHwNCj4+ICsg
IFRoZSBFdGhlcm5ldCBjb250cm9sbGVycyBvZiB0aGUgTWFydmVsIEtpcmt3b29kLCBEb3ZlLCBP
cmlvbjV4LCBNVjc4eHgwLA0KPj4gKyAgQXJtYWRhIDM3MCwgQXJtYWRhIFhQLCBBcm1hZGEgN2sg
YW5kIEFybWFkYSA4ayBoYXZlIGFuIGlkZW50aWNhbCB1bml0IHRoYXQNCj4+ICsgIHByb3ZpZGVz
IGFuIGludGVyZmFjZSB3aXRoIHRoZSBNRElPIGJ1cy4gQWRkaXRpb25hbGx5LCBBcm1hZGEgN2sg
YW5kIEFybWFkYQ0KPj4gKyAgOGsgaGFzIGEgc2Vjb25kIHVuaXQgd2hpY2ggcHJvdmlkZXMgYW4g
aW50ZXJmYWNlIHdpdGggdGhlIHhNRElPIGJ1cy4gVGhpcw0KPj4gKyAgZHJpdmVyIGhhbmRsZXMg
dGhlc2UgaW50ZXJmYWNlcy4NCj4+ICsNCj4+ICthbGxPZjoNCj4+ICsgIC0gJHJlZjogIm1kaW8u
eWFtbCMiDQo+PiArDQo+PiArcHJvcGVydGllczoNCj4+ICsgIGNvbXBhdGlibGU6DQo+PiArICAg
IGVudW06DQo+PiArICAgICAgLSBtYXJ2ZWxsLG9yaW9uLW1kaW8NCj4+ICsgICAgICAtIG1hcnZl
bGwseG1kaW8NCj4+ICsNCj4+ICsgIHJlZzoNCj4+ICsgICAgbWF4SXRlbXM6IDENCj4+ICsNCj4+
ICsgIGludGVycnVwdHM6DQo+PiArICAgIG1heEl0ZW1zOiAxDQo+PiArDQo+PiArICBjbG9ja3M6
DQo+PiArICAgIG1pbkl0ZW1zOiAxDQo+PiArICAgIG1heEl0ZW1zOiA0DQo+IFJlYWxseSB0aGlz
IHNob3VsZCBiZSBiZXR0ZXIgZGVmaW5lZCwgYnV0IHRoZSBvcmlnaW5hbCB3YXMgbm90Lg0KPg0K
Pj4gKw0KPj4gK3JlcXVpcmVkOg0KPj4gKyAgLSBjb21wYXRpYmxlDQo+PiArICAtIHJlZw0KPj4g
Kw0KPj4gK3VuZXZhbHVhdGVkUHJvcGVydGllczogdHJ1ZQ0KPiBUaGlzIG11c3QgYmUgZmFsc2Uu
DQoNClJpZ2h0IG5vdyB0aGVyZSBpcyBubyB3YXkgKHRoYXQgSSBoYXZlIGZvdW5kKSBvZiBkZWFs
aW5nIHdpdGggbm9uLVBIWSANCmRldmljZXMgbGlrZSB0aGUgZHNhIHN3aXRjaGVzIHNvIHNldHRp
bmcgdGhpcyB0byBmYWxzZSBnZW5lcmF0ZXMgDQp3YXJuaW5ncyBvbiB0dXJyaXMtbW94Og0KDQph
cmNoL2FybTY0L2Jvb3QvZHRzL21hcnZlbGwvYXJtYWRhLTM3MjAtdHVycmlzLW1veC5kdGI6IG1k
aW9AMzIwMDQ6IA0KVW5ldmFsdWF0ZWQgcHJvcGVydGllcyBhcmUgbm90IGFsbG93ZWQgKCcjYWRk
cmVzcy1jZWxscycsICcjc2l6ZS1jZWxscycsIA0KJ2V0aGVybmV0LXBoeUAxJywgJ3N3aXRjaDBA
MTAnLCAnc3dpdGNoMEAyJywgJ3N3aXRjaDFAMTEnLCAnc3dpdGNoMUAyJywgDQonc3dpdGNoMkAx
MicsICdzd2l0Y2gyQDInIHdlcmUgdW5leHBlY3RlZCkNCiDCoMKgwqDCoMKgwqDCoCBGcm9tIHNj
aGVtYTogDQovaG9tZS9jaHJpc3Avc3JjL2xpbnV4L0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9i
aW5kaW5ncy9uZXQvbWFydmVsbCxvcmlvbi1tZGlvLnlhbWwNCg0KVGhlcmUgYXJlIGFsc28gd2Fy
bmluZ3MgYWJvdXQgdGhlIHNpemUgb2YgdGhlIHJlZyBwcm9wZXJ0eSBidXQgdGhlc2UgDQpzZWVt
IHRvIGJlIGdlbnVpbmUgcHJvYmxlbXMgdGhhdCBNYXJlayBpcyBsb29raW5nIGF0Lg0KDQpUaGlz
IGNoYW5nZSBoYXMgYWxyZWFkeSBiZWVuIHBpY2tlZCB1cCBmb3IgbmV0LW5leHQgYnV0IGlmIHlv
dSBoYXZlIA0Kc3VnZ2VzdGlvbnMgZm9yIGltcHJvdmVtZW50IEknbSBoYXBweSB0byBzdWJtaXQg
dGhlbSBhcyBhZGRpdGlvbmFsIA0KY2hhbmdlcyBvbi10b3Agb2YgdGhhdC4NCg0KPg0KPj4gKw0K
Pj4gK2V4YW1wbGVzOg0KPj4gKyAgLSB8DQo+PiArICAgIG1kaW9AZDAwNzIwMDQgew0KPj4gKyAg
ICAgIGNvbXBhdGlibGUgPSAibWFydmVsbCxvcmlvbi1tZGlvIjsNCj4+ICsgICAgICByZWcgPSA8
MHhkMDA3MjAwNCAweDQ+Ow0KPj4gKyAgICAgICNhZGRyZXNzLWNlbGxzID0gPDE+Ow0KPj4gKyAg
ICAgICNzaXplLWNlbGxzID0gPDA+Ow0KPj4gKyAgICAgIGludGVycnVwdHMgPSA8MzA+Ow0KPj4g
Kw0KPj4gKyAgICAgIHBoeTA6IGV0aGVybmV0LXBoeUAwIHsNCj4+ICsgICAgICAgIHJlZyA9IDww
PjsNCj4+ICsgICAgICB9Ow0KPj4gKw0KPj4gKyAgICAgIHBoeTE6IGV0aGVybmV0LXBoeUAxIHsN
Cj4+ICsgICAgICAgIHJlZyA9IDwxPjsNCj4+ICsgICAgICB9Ow0KPj4gKyAgICB9Ow0KPj4gZGlm
ZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvbWFydmVsbC1v
cmlvbi1tZGlvLnR4dCBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvbWFy
dmVsbC1vcmlvbi1tZGlvLnR4dA0KPj4gZGVsZXRlZCBmaWxlIG1vZGUgMTAwNjQ0DQo+PiBpbmRl
eCAzZjNjZmMxZDhkNGQuLjAwMDAwMDAwMDAwMA0KPj4gLS0tIGEvRG9jdW1lbnRhdGlvbi9kZXZp
Y2V0cmVlL2JpbmRpbmdzL25ldC9tYXJ2ZWxsLW9yaW9uLW1kaW8udHh0DQo+PiArKysgL2Rldi9u
dWxsDQo+PiBAQCAtMSw1NCArMCwwIEBADQo+PiAtKiBNYXJ2ZWxsIE1ESU8gRXRoZXJuZXQgQ29u
dHJvbGxlciBpbnRlcmZhY2UNCj4+IC0NCj4+IC1UaGUgRXRoZXJuZXQgY29udHJvbGxlcnMgb2Yg
dGhlIE1hcnZlbCBLaXJrd29vZCwgRG92ZSwgT3Jpb241eCwNCj4+IC1NVjc4eHgwLCBBcm1hZGEg
MzcwLCBBcm1hZGEgWFAsIEFybWFkYSA3ayBhbmQgQXJtYWRhIDhrIGhhdmUgYW4NCj4+IC1pZGVu
dGljYWwgdW5pdCB0aGF0IHByb3ZpZGVzIGFuIGludGVyZmFjZSB3aXRoIHRoZSBNRElPIGJ1cy4N
Cj4+IC1BZGRpdGlvbmFsbHksIEFybWFkYSA3ayBhbmQgQXJtYWRhIDhrIGhhcyBhIHNlY29uZCB1
bml0IHdoaWNoDQo+PiAtcHJvdmlkZXMgYW4gaW50ZXJmYWNlIHdpdGggdGhlIHhNRElPIGJ1cy4g
VGhpcyBkcml2ZXIgaGFuZGxlcw0KPj4gLXRoZXNlIGludGVyZmFjZXMuDQo+PiAtDQo+PiAtUmVx
dWlyZWQgcHJvcGVydGllczoNCj4+IC0tIGNvbXBhdGlibGU6ICJtYXJ2ZWxsLG9yaW9uLW1kaW8i
IG9yICJtYXJ2ZWxsLHhtZGlvIg0KPj4gLS0gcmVnOiBhZGRyZXNzIGFuZCBsZW5ndGggb2YgdGhl
IE1ESU8gcmVnaXN0ZXJzLiAgV2hlbiBhbiBpbnRlcnJ1cHQgaXMNCj4+IC0gIG5vdCBwcmVzZW50
LCB0aGUgbGVuZ3RoIGlzIHRoZSBzaXplIG9mIHRoZSBTTUkgcmVnaXN0ZXIgKDQgYnl0ZXMpDQo+
PiAtICBvdGhlcndpc2UgaXQgbXVzdCBiZSAweDg0IGJ5dGVzIHRvIGNvdmVyIHRoZSBpbnRlcnJ1
cHQgY29udHJvbA0KPj4gLSAgcmVnaXN0ZXJzLg0KPj4gLQ0KPj4gLU9wdGlvbmFsIHByb3BlcnRp
ZXM6DQo+PiAtLSBpbnRlcnJ1cHRzOiBpbnRlcnJ1cHQgbGluZSBudW1iZXIgZm9yIHRoZSBTTUkg
ZXJyb3IvZG9uZSBpbnRlcnJ1cHQNCj4+IC0tIGNsb2NrczogcGhhbmRsZSBmb3IgdXAgdG8gZm91
ciByZXF1aXJlZCBjbG9ja3MgZm9yIHRoZSBNRElPIGluc3RhbmNlDQo+PiAtDQo+PiAtVGhlIGNo
aWxkIG5vZGVzIG9mIHRoZSBNRElPIGRyaXZlciBhcmUgdGhlIGluZGl2aWR1YWwgUEhZIGRldmlj
ZXMNCj4+IC1jb25uZWN0ZWQgdG8gdGhpcyBNRElPIGJ1cy4gVGhleSBtdXN0IGhhdmUgYSAicmVn
IiBwcm9wZXJ0eSBnaXZlbiB0aGUNCj4+IC1QSFkgYWRkcmVzcyBvbiB0aGUgTURJTyBidXMuDQo+
PiAtDQo+PiAtRXhhbXBsZSBhdCB0aGUgU29DIGxldmVsIHdpdGhvdXQgYW4gaW50ZXJydXB0IHBy
b3BlcnR5Og0KPj4gLQ0KPj4gLW1kaW8gew0KPj4gLQkjYWRkcmVzcy1jZWxscyA9IDwxPjsNCj4+
IC0JI3NpemUtY2VsbHMgPSA8MD47DQo+PiAtCWNvbXBhdGlibGUgPSAibWFydmVsbCxvcmlvbi1t
ZGlvIjsNCj4+IC0JcmVnID0gPDB4ZDAwNzIwMDQgMHg0PjsNCj4+IC19Ow0KPj4gLQ0KPj4gLUV4
YW1wbGUgd2l0aCBhbiBpbnRlcnJ1cHQgcHJvcGVydHk6DQo+PiAtDQo+PiAtbWRpbyB7DQo+PiAt
CSNhZGRyZXNzLWNlbGxzID0gPDE+Ow0KPj4gLQkjc2l6ZS1jZWxscyA9IDwwPjsNCj4+IC0JY29t
cGF0aWJsZSA9ICJtYXJ2ZWxsLG9yaW9uLW1kaW8iOw0KPj4gLQlyZWcgPSA8MHhkMDA3MjAwNCAw
eDg0PjsNCj4+IC0JaW50ZXJydXB0cyA9IDwzMD47DQo+PiAtfTsNCj4+IC0NCj4+IC1BbmQgYXQg
dGhlIGJvYXJkIGxldmVsOg0KPj4gLQ0KPj4gLW1kaW8gew0KPj4gLQlwaHkwOiBldGhlcm5ldC1w
aHlAMCB7DQo+PiAtCQlyZWcgPSA8MD47DQo+PiAtCX07DQo+PiAtDQo+PiAtCXBoeTE6IGV0aGVy
bmV0LXBoeUAxIHsNCj4+IC0JCXJlZyA9IDwxPjsNCj4+IC0JfTsNCj4+IC19DQo+PiAtLSANCj4+
IDIuMzYuMA0KPj4NCj4+
