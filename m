Return-Path: <netdev+bounces-7389-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9472971FFC3
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 12:52:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFA8D2817EC
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 10:52:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D69D610953;
	Fri,  2 Jun 2023 10:52:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC43107B1
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 10:52:03 +0000 (UTC)
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90270194
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 03:51:56 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-35-3yuN105PNGCVPWGL2SIudQ-1; Fri, 02 Jun 2023 11:51:53 +0100
X-MC-Unique: 3yuN105PNGCVPWGL2SIudQ-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 2 Jun
 2023 11:51:50 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Fri, 2 Jun 2023 11:51:50 +0100
From: David Laight <David.Laight@ACULAB.COM>
To: 'Kuniyuki Iwashima' <kuniyu@amazon.com>, "edumazet@google.com"
	<edumazet@google.com>
CC: "akihiro.suda.cz@hco.ntt.co.jp" <akihiro.suda.cz@hco.ntt.co.jp>,
	"akihirosuda@git.sr.ht" <akihirosuda@git.sr.ht>, "davem@davemloft.net"
	<davem@davemloft.net>, "kuba@kernel.org" <kuba@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "pabeni@redhat.com"
	<pabeni@redhat.com>, "segoon@openwall.com" <segoon@openwall.com>,
	"suda.kyoto@gmail.com" <suda.kyoto@gmail.com>
Subject: RE: [PATCH linux] net/ipv4: ping_group_range: allow GID from
 2147483648 to 4294967294
Thread-Topic: [PATCH linux] net/ipv4: ping_group_range: allow GID from
 2147483648 to 4294967294
Thread-Index: AQHZlBP3VDhY7Q4aa0O6DdrMSjDw/a93V+rg
Date: Fri, 2 Jun 2023 10:51:50 +0000
Message-ID: <b613cbaf569945e3811609a9f10fe0aa@AcuMS.aculab.com>
References: <CANn89iK13jkbKXv-rKiUbTqMrk3KjVPGYH_Vv7FtJJ5pTdUAYQ@mail.gmail.com>
 <20230531225947.38239-1-kuniyu@amazon.com>
In-Reply-To: <20230531225947.38239-1-kuniyu@amazon.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

RnJvbTogS3VuaXl1a2kgSXdhc2hpbWENCj4gU2VudDogMDEgSnVuZSAyMDIzIDAwOjAwDQouLi4u
DQo+ID4gPiAtLS0gYS9pbmNsdWRlL25ldC9waW5nLmgNCj4gPiA+ICsrKyBiL2luY2x1ZGUvbmV0
L3BpbmcuaA0KPiA+ID4gQEAgLTIwLDcgKzIwLDcgQEANCj4gPiA+ICAgKiBnaWRfdCBpcyBlaXRo
ZXIgdWludCBvciB1c2hvcnQuICBXZSB3YW50IHRvIHBhc3MgaXQgdG8NCj4gPiA+ICAgKiBwcm9j
X2RvaW50dmVjX21pbm1heCgpLCBzbyBpdCBtdXN0IG5vdCBiZSBsYXJnZXIgdGhhbiBNQVhfSU5U
DQo+ID4gPiAgICovDQo+ID4gPiAtI2RlZmluZSBHSURfVF9NQVggKCgoZ2lkX3QpfjBVKSA+PiAx
KQ0KPiA+ID4gKyNkZWZpbmUgR0lEX1RfTUFYICgoZ2lkX3QpfjBVKQ0KDQpEb2Vzbid0IHRoYXQg
Y29tbWVudCBuZWVkIHVwZGF0aW5nPw0KDQpJIGRvIHdvbmRlciBob3cgbXVjaCBjb2RlIGJyZWFr
cyBmb3IgZ2lkID4gTUFYSU5ULg0KSG93IG11Y2ggdGVzdGluZyBkb2VzIGl0IGFjdHVhbGx5IGdl
dD8/DQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkg
Um9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlv
biBObzogMTM5NzM4NiAoV2FsZXMpDQo=


