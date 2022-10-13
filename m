Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95ACA5FDB43
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 15:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiJMNnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 09:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiJMNnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 09:43:18 -0400
X-Greylist: delayed 7827 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 13 Oct 2022 06:43:08 PDT
Received: from 7.mo546.mail-out.ovh.net (7.mo546.mail-out.ovh.net [46.105.45.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF4112C8AF
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 06:43:08 -0700 (PDT)
Received: from ex2.mail.ovh.net (unknown [10.111.172.90])
        by mo546.mail-out.ovh.net (Postfix) with ESMTPS id F085C24EC0
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 11:17:31 +0000 (UTC)
Received: from EX10.indiv2.local (172.16.2.10) by EX10.indiv2.local
 (172.16.2.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.2507.12; Thu, 13
 Oct 2022 13:17:31 +0200
Received: from EX10.indiv2.local ([fe80::62:7b97:e069:79e]) by
 EX10.indiv2.local ([fe80::62:7b97:e069:79e%13]) with mapi id 15.01.2507.012;
 Thu, 13 Oct 2022 13:17:30 +0200
From:   =?utf-8?B?Q2hyaXN0aWFuIFDDtnNzaW5nZXI=?= <christian@poessinger.com>
To:     "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>
Subject: iproute2/tc invalid JSON in 6.0.0 for flowid
Thread-Topic: iproute2/tc invalid JSON in 6.0.0 for flowid
Thread-Index: Adje9WEIgR8xhBvHR5GtHVI8Qx4bPg==
Date:   Thu, 13 Oct 2022 11:17:30 +0000
Message-ID: <f4806731521546b0bb7011b8c570b52b@poessinger.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [217.249.217.176]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Ovh-Tracer-Id: 17567416249261566071
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvfedrfeektddggeduucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvffuthffkfhitgfgggesthgsjhdttddtjeenucfhrhhomhepvehhrhhishhtihgrnhcurfpnshhsihhnghgvrhcuoegthhhrihhsthhirghnsehpohgvshhsihhnghgvrhdrtghomheqnecuggftrfgrthhtvghrnhepudfhtddufffgueeijeehuefgheekvdfhheehvefggfejhfeuieeivdehvddtuddtnecukfhppeduvdejrddtrddtrddupddvudejrddvgeelrddvudejrddujeeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeotghhrhhishhtihgrnhesphhovghsshhinhhgvghrrdgtohhmqedpnhgspghrtghpthhtohepuddprhgtphhtthhopehnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheegiedpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_05,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGVhciBNYWludGFpbmVycywNCg0KSSBhbSBuZXcgdG8gdGhlIHJlcG9ydGluZyBwcm9jZXNzIGZv
ciBpcHJvdXRlMiBhbmQgdGhpcyBpcyBvbmx5IG15IHNlY29uZCBwb3N0DQp0aHVzIHBsZWFzZSBi
ZWFyIHdpdGggbWUgYW5kIG15IE1UQS4NCg0KICAkIHRjIC1WDQogIHRjIHV0aWxpdHksIGlwcm91
dGUyLTYuMC4wLCBsaWJicGYgMC4zLjANCg0KICAkIHRjIHFkaXNjIGFkZCBkZXYgZXRoMSBoYW5k
bGUgZmZmZjogaW5ncmVzcw0KICAkIHRjIGZpbHRlciBhZGQgZGV2IGV0aDEgcGFyZW50IGZmZmY6
IHByaW8gMjAgcHJvdG9jb2wgYWxsIHUzMiBtYXRjaCBpcCBkcG9ydCA4MCBcDQogICAgICAgMHhm
ZmZmIGFjdGlvbiBwb2xpY2UgcmF0ZSAxMDAwMDAgY29uZm9ybS1leGNlZWQgZHJvcCBidXJzdCAx
NWsgZmxvd2lkIGZmZmY6MQ0KDQogICQgdGMgcWRpc2Mgc2hvdyBkZXYgZXRoMQ0KICBxZGlzYyBt
cSAwOiByb290DQogIHFkaXNjIHBmaWZvX2Zhc3QgMDogcGFyZW50IDoyIGJhbmRzIDMgcHJpb21h
cCAxIDIgMiAyIDEgMiAwIDAgMSAxIDEgMSAxIDEgMSAxDQogIHFkaXNjIHBmaWZvX2Zhc3QgMDog
cGFyZW50IDoxIGJhbmRzIDMgcHJpb21hcCAxIDIgMiAyIDEgMiAwIDAgMSAxIDEgMSAxIDEgMSAx
DQogIHFkaXNjIGluZ3Jlc3MgZmZmZjogcGFyZW50IGZmZmY6ZmZmMSAtLS0tLS0tLS0tLS0tLS0t
DQogIA0KICAkIHRjIGZpbHRlciBzaG93IGRldiBldGgxIGluZ3Jlc3MNCiAgZmlsdGVyIHBhcmVu
dCBmZmZmOiBwcm90b2NvbCBhbGwgcHJlZiAyMCB1MzIgY2hhaW4gMA0KICBmaWx0ZXIgcGFyZW50
IGZmZmY6IHByb3RvY29sIGFsbCBwcmVmIDIwIHUzMiBjaGFpbiAwIGZoIDgwMDogaHQgZGl2aXNv
ciAxDQogIGZpbHRlciBwYXJlbnQgZmZmZjogcHJvdG9jb2wgYWxsIHByZWYgMjAgdTMyIGNoYWlu
IDAgZmggODAwOjo4MDAgb3JkZXIgMjA0OCBrZXkgaHQgODAwIGJrdCAwIGZsb3dpZCBmZmZmOjEg
bm90X2luX2h3DQogICAgbWF0Y2ggMDAwMDAwNTAvMDAwMGZmZmYgYXQgMjANCiAgICAgICAgICBh
Y3Rpb24gb3JkZXIgMTogIHBvbGljZSAweDEgcmF0ZSAxMDBLYml0IGJ1cnN0IDE1S2IgbXR1IDJL
YiBhY3Rpb24gZHJvcCBvdmVyaGVhZCAwYg0KICAgICAgICAgIHJlZiAxIGJpbmQgMQ0KICAgDQog
IFRoYXQgb3V0cHV0IGxvb2tzIGdvb2QgYnV0IG15IHVzZS1jYXNlIGlzIG1hY2hpbmUgcmVhZGlu
ZyAoSlNPTikgdGhlIG91dHB1dA0KICBvZiB0Yy4NCiAgDQogICQgdGMgLWpzb24gZmlsdGVyIHNo
b3cgZGV2IGV0aDEgaW5ncmVzcw0KICBbeyJwYXJlbnQiOiJmZmZmOiIsInByb3RvY29sIjoiYWxs
IiwicHJlZiI6MjAsImtpbmQiOiJ1MzIiLCJjaGFpbiI6MH0sDQogICB7InBhcmVudCI6ImZmZmY6
IiwicHJvdG9jb2wiOiJhbGwiLCJwcmVmIjoyMCwia2luZCI6InUzMiIsImNoYWluIjowLCJvcHRp
b25zIjp7ImZoIjoiODAwOiIsImh0X2Rpdmlzb3IiOjF9fSwNCiAgIHsicGFyZW50IjoiZmZmZjoi
LCJwcm90b2NvbCI6ImFsbCIsInByZWYiOjIwLCJraW5kIjoidTMyIiwiY2hhaW4iOjAsIm9wdGlv
bnMiOnsiZmgiOiI4MDA6OjgwMCIsIm9yZGVyIjoyMDQ4LCJrZXlfaHQiOiI4MDAiLCJia3QiOiIw
ImZsb3dpZCBmZmZmOjEgLCJub3RfaW5faHciOnRydWUsIm1hdGNoIjp7InZhbHVlIjoiNTAiLCJt
YXNrIjoiZmZmZiIsIm9mZm1hc2siOiIiLCJvZmYiOjIwfSwiYWN0aW9ucyI6W3sib3JkZXIiOjEs
ImtpbmQiOiJwb2xpY2UiLCJpbmRleCI6MSwiY29udHJvbF9hY3Rpb24iOnsidHlwZSI6ImRyb3Ai
fSwib3ZlcmhlYWQiOjAsInJlZiI6MSwiYmluZCI6MX1dfX1dDQogICANClRoaXMgYWN0dWFsbHkg
Y29udGFpbnMgaW52YWxpZCBKU09OIGhlcmUNCg0KLi4uICJia3QiOiIwImZsb3dpZCBmZmZmOjEg
LCJub3RfaW5faHciOnRydWUsIC4uLg0KDQpJdCBzaG91bGQgYWN0dWFsbHkgcmVhZDoNCg0KLi4u
ICJia3QiOiIwIiwiZmxvd2lkIjoiZmZmZjoxIiwibm90X2luX2h3Ijp0cnVlLCAuLi4NCg0KSWYg
eW91IGNhbiBwb2ludCBtZSB0byB0aGUgbG9jYXRpb24gd2hpY2ggY291bGQgYmUgcmVzcG9uc2li
bGUgZm9yIHRoaXMgaXNzdWUsIEkgYW0gaGFwcHkgdG8gc3VibWl0IGEgZml4IHRvIHRoZSBuZXQg
dHJlZS4NCg0KVGhhbmtzIGluIGFkdmFuY2UsDQpDaHJpc3RpYW4gUG9lc3Npbmdlcg0K
