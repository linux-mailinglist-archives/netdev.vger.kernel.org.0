Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF57C75B47
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 01:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbfGYXhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 19:37:22 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:34347 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfGYXhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 19:37:21 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 45FE98066C;
        Fri, 26 Jul 2019 11:37:18 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1564097838;
        bh=nLh8CaW4kdmpDJF6BplbubaAtEuBgr01eqwIgkMyJa4=;
        h=From:To:CC:Subject:Date;
        b=VFMxkNkOpvV7TPih+wfBJ9rkmklFFFXCCe5D0EuIq3AdAJsk4weRcLiAD7T610FYT
         CcZ72oyJE7K99BEtGy7lLUoWgVck0aH0je/L66btKAclkbnHnX1P5pZ3Cfi3udFmAk
         +anPtP4Id4pilHZgGtaIUcPuj3g2yjffie8vnu6S0R1llnW+Mi704rt82oqUTeVTdv
         lEsXK4bV1WLUuPWerqZORkWeTwDUkD1SL71nBtOWVJh8wSxI1MrwUKIstNsaPNIz/g
         zgbQk5b7g3kLSZsWU52oCMliqLI7lCtYjkmcko0Z9kVIqM63ZSHDOBGjFCpyDy4Fds
         8jBBJVnwQ+/fA==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5d3a3d2d0000>; Fri, 26 Jul 2019 11:37:17 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1156.6; Fri, 26 Jul 2019 11:37:18 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1156.000; Fri, 26 Jul 2019 11:37:17 +1200
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Slowness forming TIPC cluster with explicit node addresses
Thread-Topic: Slowness forming TIPC cluster with explicit node addresses
Thread-Index: AQHVQ0Hkw5M86TmlWkazctTgG4cJIQ==
Date:   Thu, 25 Jul 2019 23:37:16 +0000
Message-ID: <1564097836.11887.16.camel@alliedtelesis.co.nz>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.18.5.2-0ubuntu3.2 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:df5:b000:22:3a2c:4aff:fe70:2b02]
Content-Type: text/plain; charset="utf-8"
Content-ID: <729525783EC36B4DBBC1460562BCD8DF@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCkknbSBoYXZpbmcgcHJvYmxlbXMgZm9ybWluZyBhIFRJUEMgY2x1c3RlciBiZXR3ZWVu
IDIgbm9kZXMuDQoNClRoaXMgaXMgdGhlIGJhc2ljIHN0ZXBzIEknbSBnb2luZyB0aHJvdWdoIG9u
IGVhY2ggbm9kZS4NCg0KbW9kcHJvYmUgdGlwYw0KaXAgbGluayBzZXQgZXRoMiB1cA0KdGlwYyBu
b2RlIHNldCBhZGRyIDEuMS41ICMgb3IgMS4xLjYNCnRpcGMgYmVhcmVyIGVuYWJsZSBtZWRpYSBl
dGggZGV2IGV0aDANCg0KVGhlbiB0byBjb25maXJtIGlmIHRoZSBjbHVzdGVyIGlzIGZvcm1lZCBJ
IHVzZcKgdGlwYyBsaW5rIGxpc3QNCg0KW3Jvb3RAbm9kZS01IH5dIyB0aXBjIGxpbmsgbGlzdA0K
YnJvYWRjYXN0LWxpbms6IHVwDQouLi4NCg0KTG9va2luZyBhdCB0Y3BkdW1wIHRoZSB0d28gbm9k
ZXMgYXJlIHNlbmRpbmcgcGFja2V0c8KgDQoNCjIyOjMwOjA1Ljc4MjMyMCBUSVBDIHYyLjAgMS4x
LjUgPiAwLjAuMCwgaGVhZGVybGVuZ3RoIDYwIGJ5dGVzLA0KTWVzc2FnZVNpemUgNzYgYnl0ZXMs
IE5laWdoYm9yIERldGVjdGlvbiBQcm90b2NvbCBpbnRlcm5hbCwgbWVzc2FnZVR5cGUNCkxpbmsg
cmVxdWVzdA0KMjI6MzA6MDUuODYzNTU1IFRJUEMgdjIuMCAxLjEuNiA+IDAuMC4wLCBoZWFkZXJs
ZW5ndGggNjAgYnl0ZXMsDQpNZXNzYWdlU2l6ZSA3NiBieXRlcywgTmVpZ2hib3IgRGV0ZWN0aW9u
IFByb3RvY29sIGludGVybmFsLCBtZXNzYWdlVHlwZQ0KTGluayByZXF1ZXN0DQoNCkV2ZW50dWFs
bHkgKGFmdGVyIGEgZmV3IG1pbnV0ZXMpIHRoZSBsaW5rIGRvZXMgY29tZSB1cA0KDQpbcm9vdEBu
b2RlLTbCoH5dIyB0aXBjIGxpbmsgbGlzdA0KYnJvYWRjYXN0LWxpbms6IHVwDQoxMDAxMDA2OmV0
aDItMTAwMTAwNTpldGgyOiB1cA0KDQpbcm9vdEBub2RlLTXCoH5dIyB0aXBjIGxpbmsgbGlzdA0K
YnJvYWRjYXN0LWxpbms6IHVwDQoxMDAxMDA1OmV0aDItMTAwMTAwNjpldGgyOiB1cA0KDQpXaGVu
IEkgcmVtb3ZlIHRoZSAidGlwYyBub2RlIHNldCBhZGRyIiB0aGluZ3Mgc2VlbSB0byBraWNrIGlu
dG8gbGlmZQ0Kc3RyYWlnaHQgYXdheQ0KDQpbcm9vdEBub2RlLTUgfl0jIHRpcGMgbGluayBsaXN0
DQpicm9hZGNhc3QtbGluazogdXANCjAwNTBiNjFiZDJhYTpldGgyLTAwNTBiNjFlNmRmYTpldGgy
OiB1cA0KDQpTbyB0aGVyZSBhcHBlYXJzIHRvIGJlIHNvbWUgZGlmZmVyZW5jZSBpbiBiZWhhdmlv
dXIgYmV0d2VlbiBoYXZpbmcgYW4NCmV4cGxpY2l0IG5vZGUgYWRkcmVzcyBhbmQgdXNpbmcgdGhl
IGRlZmF1bHQuIFVuZm9ydHVuYXRlbHkgb3VyDQphcHBsaWNhdGlvbiByZWxpZXMgb24gc2V0dGlu
ZyB0aGUgbm9kZSBhZGRyZXNzZXMuDQoNCltyb290QG5vZGUtNSB+XSMgdW5hbWUgLWENCkxpbnV4
IGxpbnV4Ym94IDUuMi4wLWF0MSsgIzggU01QIFRodSBKdWwgMjUgMjM6MjI6NDEgVVRDIDIwMTkg
cHBjDQpHTlUvTGludXgNCg0KQW55IHRob3VnaHRzIG9uIHRoZSBwcm9ibGVtPw0K
