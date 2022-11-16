Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B48B562C72D
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 19:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbiKPSD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 13:03:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238951AbiKPSCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 13:02:45 -0500
X-Greylist: delayed 596 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 16 Nov 2022 10:02:43 PST
Received: from 2.mo619.mail-out.ovh.net (2.mo619.mail-out.ovh.net [178.33.254.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98DF63159
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 10:02:43 -0800 (PST)
Received: from ex2.mail.ovh.net (unknown [10.111.172.35])
        by mo619.mail-out.ovh.net (Postfix) with ESMTPS id BCE01215D4
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 17:46:10 +0000 (UTC)
Received: from DAG17EX3.indiv2.local (172.16.2.173) by DAG17EX1.indiv2.local
 (172.16.2.171) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Wed, 16 Nov
 2022 18:46:10 +0100
Received: from DAG17EX3.indiv2.local ([fe80::ac31:2b29:cb2d:aef6]) by
 DAG17EX3.indiv2.local ([fe80::ac31:2b29:cb2d:aef6%2]) with mapi id
 15.01.2507.016; Wed, 16 Nov 2022 18:46:10 +0100
From:   =?utf-8?B?Q2hyaXN0aWFuIFDDtnNzaW5nZXI=?= <christian@poessinger.com>
To:     "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>
Subject: iproute2/tc invalid JSON in v6.0.0-42-g49c63bc7 for "tc filter"
Thread-Topic: iproute2/tc invalid JSON in v6.0.0-42-g49c63bc7 for "tc filter"
Thread-Index: Adj54owLkDIeVJIPTS+lVCSTPJKKkw==
Date:   Wed, 16 Nov 2022 17:46:09 +0000
Message-ID: <e1fa5169db254301bc3b5b766c2df76a@poessinger.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [217.249.217.176]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Ovh-Tracer-Id: 2441513951329265783
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvgedrgeeigddutdefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvffuthffkfhitgfgggesthgsjhdttddtjeenucfhrhhomhepvehhrhhishhtihgrnhcurfpnshhsihhnghgvrhcuoegthhhrihhsthhirghnsehpohgvshhsihhnghgvrhdrtghomheqnecuggftrfgrthhtvghrnhepudfhtddufffgueeijeehuefgheekvdfhheehvefggfejhfeuieeivdehvddtuddtnecukfhppeduvdejrddtrddtrddupddvudejrddvgeelrddvudejrddujeeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeotghhrhhishhtihgrnhesphhovghsshhinhhgvghrrdgtohhmqedpnhgspghrtghpthhtohepuddprhgtphhtthhopehnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoieduledpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGVhciBNYWludGFpbmVycywNCg0KdXNpbmcgcmV2aXNpb24gdjYuMC4wLTQyLWc0OWM2M2JjNyBJ
IG5vdGljZWQgYW4gaW52YWxpZCBKU09OIG91dHB1dCB3aGVuIGludm9raW5nIHRjIC1qc29uIGZp
bHRlci4NCg0KVG8gcmVwcm9kdWNlIHRoZSBpc3N1ZToNCg0KJCB0YyBxZGlzYyBhZGQgZGV2IGV0
aDEgaGFuZGxlIGZmZmY6IGluZ3Jlc3MNCiQgdGMgZmlsdGVyIGFkZCBkZXYgZXRoMSBwYXJlbnQg
ZmZmZjogcHJpbyAyMCBwcm90b2NvbCBhbGwgdTMyIG1hdGNoIGlwIGRwb3J0IDIyIFwNCiAgICAw
eGZmZmYgYWN0aW9uIHBvbGljZSBjb25mb3JtLWV4Y2VlZCBkcm9wL29rIHJhdGUgMTAwMDAwIGJ1
cnN0IDE1ayBmbG93aWQgZmZmZjoxDQoNCiQgdGMgZmlsdGVyIGFkZCBkZXYgZXRoMSBwYXJlbnQg
ZmZmZjogcHJpbyAyNTUgcHJvdG9jb2wgYWxsIGJhc2ljIGFjdGlvbiBwb2xpY2UgXA0KICAgIGNv
bmZvcm0tZXhjZWVkIGRyb3Avb2sgcmF0ZSAxMDAwMDAgYnVyc3QgMTVrIGZsb3dpZCBmZmZmOjMN
Cg0KDQokIHRjIC1kZXRhaWwgLWpzb24gZmlsdGVyIHNob3cgZGV2IGV0aDEgaW5ncmVzcw0KW3si
cGFyZW50IjoiZmZmZjoiLCJwcm90b2NvbCI6ImFsbCIsInByZWYiOjIwLCJraW5kIjoidTMyIiwi
Y2hhaW4iOjB9LHsicGFyZW50IjoiZmZmZjoiLCJwcm90b2NvbCI6ImFsbCIsInByZWYiOjIwLCJr
aW5kIjoidTMyIiwiY2hhaW4iOjAsDQoib3B0aW9ucyI6eyJmaCI6IjgwMDoiLCJodF9kaXZpc29y
IjoxfX0seyJwYXJlbnQiOiJmZmZmOiIsInByb3RvY29sIjoiYWxsIiwicHJlZiI6MjAsImtpbmQi
OiJ1MzIiLCJjaGFpbiI6MCwib3B0aW9ucyI6eyJmaCI6IjgwMDo6ODAwIiwNCiJvcmRlciI6MjA0
OCwia2V5X2h0IjoiODAwIiwiYmt0IjoiMCIsImZsb3dpZCI6ImZmZmY6MSIsIm5vdF9pbl9odyI6
dHJ1ZSwibWF0Y2giOnsidmFsdWUiOiIxNiIsIm1hc2siOiJmZmZmIiwib2ZmbWFzayI6IiIsIm9m
ZiI6MjB9LA0KImFjdGlvbnMiOlt7Im9yZGVyIjoxLCJraW5kIjoicG9saWNlIiwiaW5kZXgiOjEs
ImNvbnRyb2xfYWN0aW9uIjp7InR5cGUiOiJkcm9wIn0sIm92ZXJoZWFkIjowLCJsaW5rbGF5ZXIi
OiJldGhlcm5ldCIsInJlZiI6MSwiYmluZCI6MX1dfX0sDQp7InBhcmVudCI6ImZmZmY6IiwicHJv
dG9jb2wiOiJhbGwiLCJwcmVmIjoyNTUsImtpbmQiOiJiYXNpYyIsImNoYWluIjowfSx7InBhcmVu
dCI6ImZmZmY6IiwicHJvdG9jb2wiOiJhbGwiLCJwcmVmIjoyNTUsImtpbmQiOiJiYXNpYyIsImNo
YWluIjowLA0KIm9wdGlvbnMiOntoYW5kbGUgMHgxIGZsb3dpZCBmZmZmOjMgImFjdGlvbnMiOlt7
Im9yZGVyIjoxLCJraW5kIjoicG9saWNlIiwiaW5kZXgiOjIsImNvbnRyb2xfYWN0aW9uIjp7InR5
cGUiOiJkcm9wIn0sIm92ZXJoZWFkIjowLCJsaW5rbGF5ZXIiOiJldGhlcm5ldCIsInJlZiI6MSwi
YmluZCI6MX1dfX1dDQoNCg0KPj4+IGpzb24ubG9hZHModG1wKQ0KVHJhY2ViYWNrIChtb3N0IHJl
Y2VudCBjYWxsIGxhc3QpOg0KICBGaWxlICI8c3RkaW4+IiwgbGluZSAxLCBpbiA8bW9kdWxlPg0K
ICBGaWxlICIvdXNyL2xpYi9weXRob24zLjkvanNvbi9fX2luaXRfXy5weSIsIGxpbmUgMzQ2LCBp
biBsb2Fkcw0KICAgIHJldHVybiBfZGVmYXVsdF9kZWNvZGVyLmRlY29kZShzKQ0KICBGaWxlICIv
dXNyL2xpYi9weXRob24zLjkvanNvbi9kZWNvZGVyLnB5IiwgbGluZSAzMzcsIGluIGRlY29kZQ0K
ICAgIG9iaiwgZW5kID0gc2VsZi5yYXdfZGVjb2RlKHMsIGlkeD1fdyhzLCAwKS5lbmQoKSkNCiAg
RmlsZSAiL3Vzci9saWIvcHl0aG9uMy45L2pzb24vZGVjb2Rlci5weSIsIGxpbmUgMzUzLCBpbiBy
YXdfZGVjb2RlDQogICAgb2JqLCBlbmQgPSBzZWxmLnNjYW5fb25jZShzLCBpZHgpDQpqc29uLmRl
Y29kZXIuSlNPTkRlY29kZUVycm9yOiBFeHBlY3RpbmcgcHJvcGVydHkgbmFtZSBlbmNsb3NlZCBp
biBkb3VibGUgcXVvdGVzOiBsaW5lIDEgY29sdW1uIDY5OCAoY2hhciA2OTcpDQoNClRoaXMgYWN0
dWFsbHkgY29udGFpbnMgaW52YWxpZCBKU09OIGhlcmUNCg0KLi4uICJvcHRpb25zIjp7aGFuZGxl
IDB4MSBmbG93aWQgZmZmZjozICJhY3Rpb25zIjpbeyJvcmRlciIgLi4uDQoNCkl0IHNob3VsZCBh
Y3R1YWxseSByZWFkOg0KDQouLi4gIm9wdGlvbnMiOnsiaGFuZGxlIjoiMHgxIiwiZmxvd2lkIjoi
ZmZmZjozIiwiYWN0aW9ucyI6W3sib3JkZXIiIC4uLg0KDQpJZiB5b3UgY2FuIHBvaW50IG1lIHRv
IHRoZSBsb2NhdGlvbiB3aGljaCBjb3VsZCBiZSByZXNwb25zaWJsZSBmb3IgdGhpcyBpc3N1ZSwg
SSBhbSBoYXBweSB0byBzdWJtaXQgYSBmaXggdG8gdGhlIG5ldCB0cmVlLg0KDQpUaGFua3MgaW4g
YWR2YW5jZSwNCkNocmlzdGlhbiBQb2Vzc2luZ2VyDQo=
