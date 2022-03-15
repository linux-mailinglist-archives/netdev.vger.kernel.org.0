Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 448AD4D9131
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 01:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245514AbiCOAXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 20:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbiCOAXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 20:23:52 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06064131B
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 17:22:40 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id BC9AF2C081A;
        Tue, 15 Mar 2022 00:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1647303757;
        bh=3BSMiHNhv46WFnBP4H9DcMtsy+ZIbf5DT5ijSgV4nkM=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=RAbMNgxEbeyjaLeWDmSQTldnquZFxFikwmj6iYfWiwuilnOdid2UU0rozyRzVq5nw
         tlZoOhdUfi7iuGpqOa7y5Xpb0COWbbdGoHvd++W6NeoYpQhSEZdq64eUEUKgHTlCK7
         ET1ps2a/RQSI87DFbIFhxiPGxza0V+OjQBY66ydI7B4TLNpj53jUQ9zJl/diWtP0G6
         j7vn+jG3PHF8a/BAewB0gRz+B4xf9J6OOe778BJvJhdLhVu5bif2PZh2xRIq0LKqDQ
         /GHI/mCc/W0z8Qbvb31izuq8wuJ6qYWpbu7X9XVahDY0JyH1Ar4RBfnG2FY2Kz/JrH
         ku9GzJ6cSAGGQ==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B622fdc4d0001>; Tue, 15 Mar 2022 13:22:37 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 15 Mar 2022 13:22:37 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.033; Tue, 15 Mar 2022 13:22:37 +1300
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "huziji@marvell.com" <huziji@marvell.com>,
        "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "kostap@marvell.com" <kostap@marvell.com>,
        "robert.marko@sartura.hr" <robert.marko@sartura.hr>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/8] dt-bindings: pinctrl: mvebu: Document bindings for
 AC5
Thread-Topic: [PATCH v2 1/8] dt-bindings: pinctrl: mvebu: Document bindings
 for AC5
Thread-Index: AQHYN+r1YarBXjvcwESVFtaA5OJaJay+t6EAgAAEIoA=
Date:   Tue, 15 Mar 2022 00:22:36 +0000
Message-ID: <16fa529e-b1ca-11d0-f068-628c7f25a7fa@alliedtelesis.co.nz>
References: <20220314213143.2404162-1-chris.packham@alliedtelesis.co.nz>
 <20220314213143.2404162-2-chris.packham@alliedtelesis.co.nz>
 <Yi/Y0iynQbIOo8C0@lunn.ch>
In-Reply-To: <Yi/Y0iynQbIOo8C0@lunn.ch>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <61514E2EEEF5B74DB1EDF70FAB50577C@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=Cfh2G4jl c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=oKJsc7D3gJEA:10 a=IkcTkHD0fZMA:10 a=o8Y5sQTvuykA:10 a=rFZ7NDpQmFnp1uEtdQsA:9 a=QEXdDO2ut3YA:10
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

DQpPbiAxNS8wMy8yMiAxMzowNywgQW5kcmV3IEx1bm4gd3JvdGU6DQo+PiArICAgIHByb3BlcnRp
ZXM6DQo+PiArICAgICAgbWFydmVsbCxmdW5jdGlvbjoNCj4+ICsgICAgICAgICRyZWY6ICIvc2No
ZW1hcy90eXBlcy55YW1sIy9kZWZpbml0aW9ucy9zdHJpbmciDQo+PiArICAgICAgICBkZXNjcmlw
dGlvbjoNCj4+ICsgICAgICAgICAgSW5kaWNhdGVzIHRoZSBmdW5jdGlvbiB0byBzZWxlY3QuDQo+
PiArICAgICAgICBlbnVtOiBbIGdwaW8sIGkyYzAsIGkyYzEsIG5hbmQsIHNkaW8sIHNwaTAsIHNw
aTEsIHVhcnQwLCB1YXJ0MSwgdWFydDIsIHVhcnQzIF0NCj4+ICsNCj4+ICsgICAgICBtYXJ2ZWxs
LHBpbnM6DQo+PiArICAgICAgICAkcmVmOiAvc2NoZW1hcy90eXBlcy55YW1sIy9kZWZpbml0aW9u
cy9zdHJpbmctYXJyYXkNCj4+ICsgICAgICAgIGRlc2NyaXB0aW9uOg0KPj4gKyAgICAgICAgICBB
cnJheSBvZiBNUFAgcGlucyB0byBiZSB1c2VkIGZvciB0aGUgZ2l2ZW4gZnVuY3Rpb24uDQo+PiAr
ICAgICAgICBtaW5JdGVtczogMQ0KPiBOb3cgdGhhdCBpJ3ZlIGxvb2tlZCBhdCB0aGUgLnR4dCBm
aWxlcywgaSdtIHdvbmRlcmluZyBpZiB0aGlzIHNob3VsZA0KPiBiZSBzcGxpdCBpbnRvIGEgbWFy
dmVsbCxtdmVidS1waW5jdHJsLnlhbWwgYW5kDQo+IG1hcnZlbGwsYWM1LXBpbmN0cmwueWFtbD8N
Cj4NCj4gSSBkb24ndCBrbm93IHlhbWwgd2VsbCBlbm91Z2ggdG8ga25vdyBpZiB0aGlzIGlzIHBv
c3NpYmxlLiBBbGwgdGhlDQo+IG12ZWJ1IHBpbmN0cmwgZHJpdmVycyBoYXZlIG1hcnZlbGwsZnVu
Y3Rpb24gYW5kIG1hcnZlbGwscGlucy4gVGhlIGVudW0NCj4gd2lsbCBkaWZmZXIsIHRoaXMgZXRo
ZXJuZXQgc3dpdGNoIFNvQyBkb2VzIG5vdCBoYXZlIHNhdGEsIGF1ZGlvIGV0YywNCj4gd2hlcmUg
YXMgdGhlIGdlbmVyYWwgcHVycG9zZSBTb2NzIGRvLiBDYW4gdGhhdCBiZSByZXByZXNlbnRlZCBp
biB5YW1sPw0KDQpJIHRoaW5rIGl0IGNhbi4gSSB2YWd1ZWx5IHJlbWVtYmVyIHNlZWluZyBjb25k
aXRpb25hbCBjbGF1c2VzIGJhc2VkIG9uIA0KY29tcGF0aWJsZSBzdHJpbmdzIGluIG90aGVyIHlh
bWwgYmluZGluZ3MuDQoNCkkgc3RhcnRlZCBhIG5ldyBiaW5kaW5nIGRvY3VtZW50IGJlY2F1c2Ug
SSBleHBlY3RlZCBhZGRpbmcgc2lnbmlmaWNhbnQgDQphZGRpdGlvbnMgdG8gdGhlIGV4aXN0aW5n
IC50eHQgZmlsZXMgd291bGQgYmUgcmVqZWN0ZWQuIElmIEkgZ2V0IHNvbWUgDQpjeWNsZXMgSSBj
b3VsZCBsb29rIGF0IGNvbnZlcnRpbmcgdGhlIGV4aXN0aW5nIGRvY3MgZnJvbSB0eHQgdG8geWFt
bC4NCg0KSSdtIG5vdCBzdXJlIHRoYXQgdGhlcmUgd2lsbCBiZSBtdWNoIGluIHRoZSB3YXkgb2Yg
YSBjb21tb24gDQptdmVidS1waW5jdHJsLnlhbWwgYXMgeW91J2QgZW5kIHVwIHJlcGVhdGluZyBt
b3N0IG9mIHRoZSBjb21tb24gc3R1ZmYgdG8gDQptYWtlIHRoaW5ncyBjb25kaXRpb25hbCBhbnl3
YXkuDQoNCj4NCj4gICAgICAgIEFuZHJldw==
