Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09D62534A1A
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 07:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239122AbiEZFFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 01:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbiEZFFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 01:05:44 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128F4939F6
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 22:05:42 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 50C7B2C0480;
        Thu, 26 May 2022 05:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1653541540;
        bh=JijMDJ4PHwAnFlEKcep0RqrOwepzltfXlK77okUqbSQ=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=cYLXOxUrrCDZ1WyzB9Z8t8cHC5gEYZYzGC5QyVOINqvi67Ta+4RXsjMI9HWnLfKAg
         CmJCgzSNlasBSOL0g7obg9cxGa7Tx0l/QbXqmTTzlsdvB+G9suHkEtjjYRI1jprW/p
         VsHbAXqnG45Uj3oJAucsLvcyMsOKmzWx0ME7o8x/wL/G0T+5CScJsjpWfFY9jvItif
         baSrMzS/tb85TvPaT7+LTGfFTWFyY1RxRqVMBhRZPZB/+Bz4fliKnPybvgrcRY6tD4
         gHVNKNzyXRnGHJoaa3i9kfdp/LSqxzicIx8hdxLtMejJxkVYgWU9XN9v6fQKcEe9lo
         eHoUXETyqo/Sg==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B628f0aa40001>; Thu, 26 May 2022 17:05:40 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1497.36; Thu, 26 May 2022 17:05:39 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.036; Thu, 26 May 2022 17:05:39 +1200
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "josua@solid-run.com" <josua@solid-run.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dt-bindings: net: adin: use YAML block scalar to avoid
 parse issue
Thread-Topic: [PATCH] dt-bindings: net: adin: use YAML block scalar to avoid
 parse issue
Thread-Index: AQHYcL0kNrCuZ0OG70Kh1w213Fz9Dq0v0QmAgAAAzYA=
Date:   Thu, 26 May 2022 05:05:39 +0000
Message-ID: <82e28004-6501-8efd-6ad9-027961519f55@alliedtelesis.co.nz>
References: <20220526045740.4073762-1-chris.packham@alliedtelesis.co.nz>
 <20220525220247.3e7dfc0d@kernel.org>
In-Reply-To: <20220525220247.3e7dfc0d@kernel.org>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <5DF5536199515140815C109CA51BD0C8@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=U+Hs8tju c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=oKJsc7D3gJEA:10 a=IkcTkHD0fZMA:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=wxdlRhMu-4a_7-lpwucA:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
X-SEG-SpamProfiler-Score: 0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyNi8wNS8yMiAxNzowMiwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IE9uIFRodSwgMjYg
TWF5IDIwMjIgMTY6NTc6NDAgKzEyMDAgQ2hyaXMgUGFja2hhbSB3cm90ZToNCj4+IFlBTUwgZG9l
c24ndCBsaWtlIGNvbG9ucyAoOikgaW4gdGV4dC4gVXNlIGEgYmxvY2sgc2NhbGFyIHNvIHRoYXQg
dGhlDQo+PiBjb2xvbiBpbiB0aGUgZGVzY3JpcHRpb24gdGV4dCBkb2Vzbid0IGNhdXNlIGEgcGFy
c2UgZXJyb3IuDQo+Pg0KPj4gRml4ZXM6IDFmNzcyMDRlMTFmOCAoImR0LWJpbmRpbmdzOiBuZXQ6
IGFkaW46IGRvY3VtZW50IHBoeSBjbG9jayBvdXRwdXQgcHJvcGVydGllcyIpDQo+PiBTaWduZWQt
b2ZmLWJ5OiBDaHJpcyBQYWNraGFtIDxjaHJpcy5wYWNraGFtQGFsbGllZHRlbGVzaXMuY28ubno+
DQo+IEdvdCB0aGUgc2FtZSBmaXggZnJvbSBHZWVydCBhbHJlYWR5LCBhcHBseWluZyB0byBuZXRk
ZXYvbmV0IG5vdzoNCj4NCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzZmY2VmMjY2NWE2
Y2Q4NmEwMjE1MDlhODRjNTk1NmVjMmVmZDkzZWQuMTY1MzQwMTQyMC5naXQuZ2VlcnQrcmVuZXNh
c0BnbGlkZXIuYmUvDQoNCkdvb2QuIFNvcnJ5IGZvciB0aGUgbm9pc2UuDQo=
