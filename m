Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A37C34E6E61
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 07:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349176AbiCYGyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 02:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239394AbiCYGyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 02:54:10 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5DB10C6EEC
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 23:52:37 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-308-OWCTSVYVNPyn1nCTkduS5Q-1; Fri, 25 Mar 2022 06:52:34 +0000
X-MC-Unique: OWCTSVYVNPyn1nCTkduS5Q-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Fri, 25 Mar 2022 06:52:33 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Fri, 25 Mar 2022 06:52:33 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'NeilBrown' <neilb@suse.de>, Haowen Bai <baihaowen@meizu.com>
CC:     "trond.myklebust@hammerspace.com" <trond.myklebust@hammerspace.com>,
        "anna@kernel.org" <anna@kernel.org>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haowen Bai <baihaowen@meizu.com>
Subject: RE: [PATCH] SUNRPC: Increase size of servername string
Thread-Topic: [PATCH] SUNRPC: Increase size of servername string
Thread-Index: AQHYP+2Bp/ily4quQUeZW4BP4EodNKzPqMOg
Date:   Fri, 25 Mar 2022 06:52:33 +0000
Message-ID: <8723baf426ff4c7fb2027b86aa01fe70@AcuMS.aculab.com>
References: <1648103566-15528-1-git-send-email-baihaowen@meizu.com>
 <164817399413.6096.7103093569920914714@noble.neil.brown.name>
In-Reply-To: <164817399413.6096.7103093569920914714@noble.neil.brown.name>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogTmVpbEJyb3duDQo+IFNlbnQ6IDI1IE1hcmNoIDIwMjIgMDI6MDcNCj4gDQo+IE9uIFRo
dSwgMjQgTWFyIDIwMjIsIEhhb3dlbiBCYWkgd3JvdGU6DQo+ID4gVGhpcyBwYXRjaCB3aWxsIGZp
eCB0aGUgd2FybmluZyBmcm9tIHNtYXRjaDoNCj4gPg0KPiA+IG5ldC9zdW5ycGMvY2xudC5jOjU2
MiBycGNfY3JlYXRlKCkgZXJyb3I6IHNucHJpbnRmKCkgY2hvcHMgb2ZmDQo+ID4gdGhlIGxhc3Qg
Y2hhcnMgb2YgJ3N1bi0+c3VuX3BhdGgnOiAxMDggdnMgNDgNCj4gPg0KPiA+IFNpZ25lZC1vZmYt
Ynk6IEhhb3dlbiBCYWkgPGJhaWhhb3dlbkBtZWl6dS5jb20+DQo+ID4gLS0tDQo+ID4gIG5ldC9z
dW5ycGMvY2xudC5jIHwgMiArLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyks
IDEgZGVsZXRpb24oLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9uZXQvc3VucnBjL2NsbnQuYyBi
L25ldC9zdW5ycGMvY2xudC5jDQo+ID4gaW5kZXggYzgzZmU2MS4uNmUwMjA5ZSAxMDA2NDQNCj4g
PiAtLS0gYS9uZXQvc3VucnBjL2NsbnQuYw0KPiA+ICsrKyBiL25ldC9zdW5ycGMvY2xudC5jDQo+
ID4gQEAgLTUyNiw3ICs1MjYsNyBAQCBzdHJ1Y3QgcnBjX2NsbnQgKnJwY19jcmVhdGUoc3RydWN0
IHJwY19jcmVhdGVfYXJncyAqYXJncykNCj4gPiAgCQkuc2VydmVybmFtZSA9IGFyZ3MtPnNlcnZl
cm5hbWUsDQo+ID4gIAkJLmJjX3hwcnQgPSBhcmdzLT5iY194cHJ0LA0KPiA+ICAJfTsNCj4gPiAt
CWNoYXIgc2VydmVybmFtZVs0OF07DQo+ID4gKwljaGFyIHNlcnZlcm5hbWVbMTA4XTsNCj4gDQo+
IEl0IHdvdWxkIGJlIG11Y2ggbmljZXIgdG8gdXNlIFVOSVhfUEFUSF9NQVgNCg0KTm8gb24tc3Rh
Y2suLi4uDQoNCkdpdmVuIHRoZSB1c2U6DQoNCglpZiAoeHBydGFyZ3Muc2VydmVybmFtZSA9PSBO
VUxMKSB7DQoJCXN0cnVjdCBzb2NrYWRkcl91biAqc3VuID0NCgkJCQkoc3RydWN0IHNvY2thZGRy
X3VuICopYXJncy0+YWRkcmVzczsNCgkJc3RydWN0IHNvY2thZGRyX2luICpzaW4gPQ0KCQkJCShz
dHJ1Y3Qgc29ja2FkZHJfaW4gKilhcmdzLT5hZGRyZXNzOw0KCQlzdHJ1Y3Qgc29ja2FkZHJfaW42
ICpzaW42ID0NCgkJCQkoc3RydWN0IHNvY2thZGRyX2luNiAqKWFyZ3MtPmFkZHJlc3M7DQoNCgkJ
c2VydmVybmFtZVswXSA9ICdcMCc7DQoJCXN3aXRjaCAoYXJncy0+YWRkcmVzcy0+c2FfZmFtaWx5
KSB7DQoJCWNhc2UgQUZfTE9DQUw6DQoJCQlzbnByaW50ZihzZXJ2ZXJuYW1lLCBzaXplb2Yoc2Vy
dmVybmFtZSksICIlcyIsDQoJCQkJIHN1bi0+c3VuX3BhdGgpOw0KCQkJYnJlYWs7DQoJCWNhc2Ug
QUZfSU5FVDoNCgkJCXNucHJpbnRmKHNlcnZlcm5hbWUsIHNpemVvZihzZXJ2ZXJuYW1lKSwgIiVw
STQiLA0KCQkJCSAmc2luLT5zaW5fYWRkci5zX2FkZHIpOw0KCQkJYnJlYWs7DQoJCWNhc2UgQUZf
SU5FVDY6DQoJCQlzbnByaW50ZihzZXJ2ZXJuYW1lLCBzaXplb2Yoc2VydmVybmFtZSksICIlcEk2
IiwNCgkJCQkgJnNpbjYtPnNpbjZfYWRkcik7DQoJCQlicmVhazsNCgkJZGVmYXVsdDoNCgkJCS8q
IGNhbGxlciB3YW50cyBkZWZhdWx0IHNlcnZlciBuYW1lLCBidXQNCgkJCSAqIGFkZHJlc3MgZmFt
aWx5IGlzbid0IHJlY29nbml6ZWQuICovDQoJCQlyZXR1cm4gRVJSX1BUUigtRUlOVkFMKTsNCgkJ
fQ0KCQl4cHJ0YXJncy5zZXJ2ZXJuYW1lID0gc2VydmVybmFtZTsNCgl9DQoNCkl0IGxvb2tzIGxp
a2UgdGhlIEFGX0xPQ0FMIGNhc2UgY291bGQgYmU6DQoJCXhwcnRhcmdzLnNlcnZlcm5hbWUgPSBz
dW4tPnN1bl9wYXRoOw0KVGhlbiB0aGUgYnVmZmVyIG9ubHkgbmVlZHMgdG8gYmUgYmlnIGVub3Vn
aCBmb3IgdGhlIElQdjYgYWRkcmVzcy4NCkZvciB3aGljaCA0MCBpcyBlbm91Z2guDQoNCglEYXZp
ZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQg
RmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4
NiAoV2FsZXMpDQo=

