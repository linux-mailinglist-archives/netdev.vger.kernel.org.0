Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686E51AFADC
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 15:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgDSNoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 09:44:46 -0400
Received: from mail-dm6nam12on2095.outbound.protection.outlook.com ([40.107.243.95]:11297
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725905AbgDSNoq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 09:44:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nwBCLZDzN6HmBaja+mPAuRYEYF+BaBmGp0TCOJbWpvGu5cxzzY9z5nDRj80VTHBgbktiP/Dj+WMs77VaZc3pPL6ggUpVozFiFFEbo9z48v/eOou97rENASluR5RTtGsyOuOAi06J3OwaHN7z/aVz44mE+c5pDaJGssSW8O3akJVC4TQ2QrRH0oMRBbouGbtylolX9/V4t5c7t3d7/tqiHywAWIMDINlj2XLrG3oH4c+9ajDUqUy2E7V7NAe8OBtKQl7C9JhDOTWA52gOioL/f8RZn1DR8aG+hmVRqsyhIkJdmqkQlLwETjy6TMYGApEJ5/Muh3tNjgT1PGpG/12V+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZDHXOG41cVE9u7h7E1VDqYq0qgAwe7WI1Fye/ZZ03+A=;
 b=iY27YWR5UilC0aN8i8fXZzrL5zFg8ch7eq8oQnNVBON6E8zExUNNqrZinB7T+HdK+orNm+eTAU0GqAOho7dqhSjj7BnyM3JUqwTABzIkZTVQzA5kowyIdVIvTRGEHN86cwKJrrtK3CQWHxXIGoWVF5xUPMLawKzf5a3UqC2pWv+ZnzF1PFS1uXbp/ojbk9ceFUMb7oQhaPi5AzWUSMLlybsaW8KP7FCDlwMEdO1uFoFnp1zaPbzxGph5mxHW4KFPz3JMjr0HbFUTjg3qd0/0+IlKpABCqZsHOu903IcwapXoBCF/98fPgM+XmKtKfd/sW0z11JRYG1Ck36CnGNkwbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZDHXOG41cVE9u7h7E1VDqYq0qgAwe7WI1Fye/ZZ03+A=;
 b=RAwe7AQoJfjlcx2MxSci9vbv74k4LfBjXK0VIet0XvwyFzncqbhn0Qi1RXSYULmZumKL7mLddEdLg3POJnqKYioxYgmzucdAGQBjGoSD0H3USCrRGhvkrTyvpAZvhGAlEgg6pGxeGjJEq+Ut4K2zr54H1C6m5lIthdjiba663Lo=
Received: from CH2PR13MB3398.namprd13.prod.outlook.com (2603:10b6:610:2a::33)
 by CH2PR13MB3367.namprd13.prod.outlook.com (2603:10b6:610:16::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.11; Sun, 19 Apr
 2020 13:44:42 +0000
Received: from CH2PR13MB3398.namprd13.prod.outlook.com
 ([fe80::49f6:ce9b:9803:2493]) by CH2PR13MB3398.namprd13.prod.outlook.com
 ([fe80::49f6:ce9b:9803:2493%6]) with mapi id 15.20.2937.011; Sun, 19 Apr 2020
 13:44:42 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "xulinsun@gmail.com" <xulinsun@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: net/sunrpc Bug ? Unable to handle kernel NULL pointer dereference
 at virtual address 0000000000000000 on kernel 5.2.37
Thread-Topic: net/sunrpc Bug ? Unable to handle kernel NULL pointer
 dereference at virtual address 0000000000000000 on kernel 5.2.37
Thread-Index: AQHWFhL0lLMpDgqZmUCUKP7pY/xExKiAdTIA
Date:   Sun, 19 Apr 2020 13:44:42 +0000
Message-ID: <c2e012c0dd9b4797872b06b136497ecf18149613.camel@hammerspace.com>
References: <CACiNFG4y9T8tjcpypyfFfOgPjRkc++rNhn85iuuWARA7dXemJA@mail.gmail.com>
In-Reply-To: <CACiNFG4y9T8tjcpypyfFfOgPjRkc++rNhn85iuuWARA7dXemJA@mail.gmail.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=trondmy@hammerspace.com; 
x-originating-ip: [68.36.133.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 622e1a77-aa14-49e3-b45a-08d7e467d05e
x-ms-traffictypediagnostic: CH2PR13MB3367:
x-microsoft-antispam-prvs: <CH2PR13MB336772B9128298C140E6C3A1B8D70@CH2PR13MB3367.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0378F1E47A
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR13MB3398.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(376002)(366004)(346002)(136003)(39830400003)(66556008)(8676002)(45080400002)(66946007)(8936002)(71200400001)(66446008)(6506007)(6512007)(81156014)(66476007)(186003)(4326008)(64756008)(76116006)(6486002)(2906002)(86362001)(36756003)(91956017)(478600001)(26005)(2616005)(5660300002)(316002)(110136005);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: hammerspace.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Gi1dAaadT9km3Er1hr7IxxuYPsh1J2vFzn6+i8Bz4CrJaBJb+1sOQneFUwMJEayCpjz4r493ojk4JzB+TIeXbfATxxI/TqmMLpCgnl5bJUUF16nd8vR5qnTH6qj62ECEPPwQRNx1Y4COp7mno+ziagKPnwlA1k5w84GrRyuVQrYcrrvh3QbKPfU4xeJHMSMGArsUhV+MdY94kLDKk7hG3O6CDplJSK4uEVdCPFulKPfRlrx+xyIr6aH+m3QLTPWW6Us2lAGJkZZ99oVtvWz5jSe8obxAFbTIsKzYgbmtaHIkeMIj6k996sNem6sBXQlYA9XGjWne2LV+6b6wAfZuPbt/g9lIX+1KPev6r7U7TSfCYcYad5XwiWhX1qpqYS0u2IyaNVCT5Lsy6NvlArZzcgziapQU1NS2H4Q4dPx8/XzxeJX1ao5Hct9E+xHeHyBW
x-ms-exchange-antispam-messagedata: Yo2fmg+lRkjlQKqZykPBbCbuRtEPJw/BejCe/5ocDjw5vZ13z2JziwL+cj6mdJyDPvvl3ZAmorhmULv7Xx350EpCqRK5Q0mmKwfIIfilvV8c+RoAUp7rZ1Zgga8Qc+gPnuxNfP2LqckUJ6ggzEtLSBGseXTe2UTu+HbZwAscHIP532MpQfYgRkOPs3VKlhEu4jQTS2LHH8H/lVakNUB/NIktOue1Iabu73ou/sO4kKTiS08nYZI4DrqeOi3WVEjtcvbAPwt7bdLKy1wwqbHKMIaJM0AiZnCQaiDpRcy9VCgdzG5Yz9HnsAlbDtVpniHpqAWjDiskA99CJ9eBnPpILkGSBJjl71mKLnDqYH3R+vZowEbnjR34QMnG4MbXI0fdJ+YucNFHnNcihseyIhGA+1aCSXwqJDaI+vS75OobYCdJ1idtOJDQeyzwVloQ2VAKa5xOZWlZSEe5qbb7Cwp6xixyfgjegoXQkZfnsAja1cIeYRAwskf+HVHjaexH1uFGfV70Bf46UtoH6eexA+qNrjFAybx6i0BcZms3trw46p6aHm/beAimeAE0xA9XQeW7SApaMwKgyxkMS7mDhfdbA0k8FJF/T98CWLv9Kc9Hea6Z8HJUkIEwitVMGOdXaonF8zR59uxLMSFYr7x/gcH0ivgXyL0/Cba+lTm19o1bfgYtD7qh81jnWEP73vMU3t7ipKTvRY079HD4qFeeRlxQtzGw4UW22ZHiQBIPf+WFhrhwrlLta+Z5yHX7Mm8ROhg2nSQFCsa7QncIXJXiejpzHfrJTszARJxw/khlOVUKQqo=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <FE53CABC0CA3CE4BA721EE1D3566FE7C@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 622e1a77-aa14-49e3-b45a-08d7e467d05e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2020 13:44:42.3767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l0l+o85iLwPf9MpWmEDw41FWJfrkAnO6PD1xajHUYeAzs1OO8J7p9Kb4+1zBGez9ZtDINtXO1Ye0jF6C40IvgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3367
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIwLTA0LTE5IGF0IDE0OjIyICswODAwLCBTdW4gVGVkIHdyb3RlOg0KPiBIaSBG
b3JrcywNCj4gDQo+IE9uIHRoZSBrZXJuZWwgdmVyc2lvbiA1LjIuMzcgb3IgYSBiaXQgZWFybGll
ciwgcnVubmluZyBwcmVzc3VyZQ0KPiB0ZXN0aW5nIHdpdGggbW9kdWxlIGluc2VydCAmIHJlbW92
ZSwgYWN0dWFsbHkgdGhlIGluc2VydGVkIG1vZHVsZSBpcw0KPiBub3Qgc3BlY2lhbCBhbmQgY291
bGQgYmUgYW55b25lLg0KPiBBZnRlciBkb3plbnMgb2YgdGVzdGluZywgdGhlcmUgd2lsbCBiZSB0
aHJvdyBiZWxvdyBjYWxsIHRyYWNlIGFuZCB0aGUNCj4gc3lzdGVtIGh1bmcuDQo+IA0KPiBUZXN0
aW5nIHNjcmlwdCBmb3IgaW5zZXJ0ICYgcmVtb3ZlIG1vZHVsZSBsaWtlIGJlbG93Og0KPiAgICAg
ICAgICAgICAgZm9yIGVhY2ggaW4gezEuLjEwMH0gOyBkbyBlY2hvICIkZWFjaCIgOyBpbnNtb2QN
Cj4gb3BlbnZzd2l0Y2gua28gOyAgcm1tb2QgIG9wZW52c3dpdGNoLmtvIDsgdXNsZWVwIDEwMDAw
MCA7IGRvbmUNCj4gVGhlIHRhcmdldCBtYWNoaW5lIGlzOiBhcm02NCwgY29ydGV4IGE1My4NCj4g
DQo+IERpc2Fzc2VtYmxlZCB0aGUgbGluZSAiIF9fd2FrZV91cF9jb21tb25fbG9jaysweDk4LzB4
ZTAgIiwgaXQgbG9jYXRlZA0KPiB0aGUgY29kZSAiaW5jbHVkZS9saW51eC9zcGlubG9jay5oIiAs
IGl0IHNob3VsZCBiZSB1c2luZyB0aGUgTlVMTA0KPiBwb2ludGVyICJsb2NrLT5ybG9jayAiDQo+
IA0KPiBzdGF0aWMgX19hbHdheXNfaW5saW5lIHZvaWQgc3Bpbl91bmxvY2tfaXJxcmVzdG9yZShz
cGlubG9ja190ICpsb2NrLA0KPiB1bnNpZ25lZCBsb25nIGZsYWdzKQ0KPiB7DQo+ICAgICAgICAg
cmF3X3NwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmxvY2stPnJsb2NrLCBmbGFncyk7DQo+IA0KPiBE
aWQgeW91IGV2ZXIgc2VlIHRoaXMgaXNzdWUgb3IgaGF2ZSBhIGZpeCBmb3IgdGhpcyBiYXNlZCBv
biBrZXJuZWwNCj4gNS4yLjM3IHZlcnNpb24/DQo+IA0KPiBDYWxsIHRyYWNlOg0KPiBvcGVudnN3
aXRjaDogT3BlbiB2U3dpdGNoIHN3aXRjaGluZyBkYXRhcGF0aA0KPiBVbmFibGUgdG8gaGFuZGxl
IGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQgdmlydHVhbCBhZGRyZXNzDQo+IDAw
MDAwMDAwMDAwMDAwMDANCj4gTWVtIGFib3J0IGluZm86DQo+ICAgRVNSID0gMHg4NjAwMDAwNQ0K
PiAgIEV4Y2VwdGlvbiBjbGFzcyA9IElBQlQgKGN1cnJlbnQgRUwpLCBJTCA9IDMyIGJpdHMNCj4g
ICBTRVQgPSAwLCBGblYgPSAwDQo+ICAgRUEgPSAwLCBTMVBUVyA9IDANCj4gdXNlciBwZ3RhYmxl
OiA0ayBwYWdlcywgMzktYml0IFZBcywgcGdkcD0wMDAwMDAwOGYyZWE5MDAwDQo+IFswMDAwMDAw
MDAwMDAwMDAwXSBwZ2Q9MDAwMDAwMDAwMDAwMDAwMCwgcHVkPTAwMDAwMDAwMDAwMDAwMDANCj4g
SW50ZXJuYWwgZXJyb3I6IE9vcHM6IDg2MDAwMDA1IFsjMV0gUFJFRU1QVCBTTVANCj4gTW9kdWxl
cyBsaW5rZWQgaW46IG9wZW52c3dpdGNoIGhzZSBzY2hfZnFfY29kZWwgbnNoIG5mX2Nvbm5jb3Vu
dA0KPiBuZl9uYXQgbmZfY29ubnRyYWNrIG5mX2RlZnJhZ19pcHY2IG5mX2RlZnJhZ19pcHY0IFts
YXN0IHVubG9hZGVkOg0KPiBvcGVudnN3aXRjaF0NCj4gQ1BVOiAyIFBJRDogMjA5IENvbW06IGt3
b3JrZXIvdTk6MyBOb3QgdGFpbnRlZCA1LjIuMzcteW9jdG8tc3RhbmRhcmQNCj4gIzENCj4gSGFy
ZHdhcmUgbmFtZTogRnJlZXNjYWxlIFMzMkcyNzUgKERUKQ0KPiBXb3JrcXVldWU6IHhwcnRpb2Qg
eHNfc3RyZWFtX2RhdGFfcmVjZWl2ZV93b3JrZm4NCj4gcHN0YXRlOiA4MDAwMDA4NSAoTnpjdiBk
YUlmIC1QQU4gLVVBTykNCj4gcGMgOiAweDANCj4gbHIgOiBfX3dha2VfdXBfY29tbW9uKzB4OTAv
MHgxNTANCj4gc3AgOiBmZmZmZmY4MDExNDZiYTYwDQo+IHgyOTogZmZmZmZmODAxMTQ2YmE2MCB4
Mjg6IGZmZmZmZjgwMTBkMzYwMDANCj4geDI3OiBmZmZmZmY4MDExNDZiYjkwIHgyNjogMDAwMDAw
MDAwMDAwMDAwMA0KPiB4MjU6IDAwMDAwMDAwMDAwMDAwMDMgeDI0OiAwMDAwMDAwMDAwMDAwMDAw
DQo+IHgyMzogMDAwMDAwMDAwMDAwMDAwMSB4MjI6IGZmZmZmZjgwMTE0NmJiMDANCj4geDIxOiBm
ZmZmZmY4MDEwZDM1MWU4IHgyMDogMDAwMDAwMDAwMDAwMDAwMA0KPiB4MTk6IGZmZmZmZjgwMTEy
YzM3YTAgeDE4OiAwMDAwMDAwMDAwMDAwMDAwDQo+IHgxNzogMDAwMDAwMDAwMDAwMDAwMCB4MTY6
IDAwMDAwMDAwMDAwMDAwMDANCj4geDE1OiAwMDAwMDAwMDAwMDAwMDAwIHgxNDogMDAwMDAwMDAw
MDAwMDAwMA0KPiB4MTM6IDAwMDAwMDMwMDIwMDAwMDAgeDEyOiAwMDAwOTAyODAyMDAwMDAwDQo+
IHgxMTogMDAwMDAwMDAwMDAwMDAwMCB4MTA6IDAwMDAwMTAwMDAwMGVkMDENCj4geDkgOiAwMDAw
MDEwMDAwMDAwMDAwIHg4IDogOWI1ZTAwMDAwMDAwNDhhNg0KPiB4NyA6IDAwMDAwMDAwMDAwMDAw
NjggeDYgOiBmZmZmZmY4MDExMmMzN2EwDQo+IHg1IDogMDAwMDAwMDAwMDAwMDAwMCB4NCA6IGZm
ZmZmZjgwMTE0NmJiOTANCj4geDMgOiBmZmZmZmY4MDExNDZiYjkwIHgyIDogMDAwMDAwMDAwMDAw
MDAwMA0KPiB4MSA6IDAwMDAwMDAwMDAwMDAwMDMgeDAgOiBmZmZmZmY4MDExMmMzN2EwDQo+IENh
bGwgdHJhY2U6DQo+ICAweDANCj4gIF9fd2FrZV91cF9jb21tb25fbG9jaysweDk4LzB4ZTANCj4g
IF9fd2FrZV91cCsweDQwLzB4NTANCj4gIHdha2VfdXBfYml0KzB4OGMvMHhiOA0KPiAgcnBjX21h
a2VfcnVubmFibGUrMHhjOC8weGQwDQo+ICBycGNfd2FrZV91cF90YXNrX29uX3dxX3F1ZXVlX2Fj
dGlvbl9sb2NrZWQrMHgxMTAvMHgyNzgNCj4gIHJwY193YWtlX3VwX3F1ZXVlZF90YXNrLnBhcnQu
MCsweDQwLzB4NTgNCj4gIHJwY193YWtlX3VwX3F1ZXVlZF90YXNrKzB4MzgvMHg0OA0KPiAgeHBy
dF9jb21wbGV0ZV9ycXN0KzB4NjgvMHgxMjgNCj4gIHhzX3JlYWRfc3RyZWFtLmNvbnN0cHJvcC4w
KzB4MmVjLzB4M2QwDQo+ICB4c19zdHJlYW1fZGF0YV9yZWNlaXZlX3dvcmtmbisweDYwLzB4MTkw
DQo+ICBwcm9jZXNzX29uZV93b3JrKzB4MWJjLzB4NDQwDQo+ICB3b3JrZXJfdGhyZWFkKzB4NTAv
MHg0MDgNCj4gIGt0aHJlYWQrMHgxMDQvMHgxMzANCj4gIHJldF9mcm9tX2ZvcmsrMHgxMC8weDFj
DQo+IENvZGU6IGJhZCBQQyB2YWx1ZQ0KPiBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogRmF0
YWwgZXhjZXB0aW9uIGluIGludGVycnVwdA0KPiBTTVA6IHN0b3BwaW5nIHNlY29uZGFyeSBDUFVz
DQo+IEtlcm5lbCBPZmZzZXQ6IGRpc2FibGVkDQo+IENQVSBmZWF0dXJlczogMHgwMDAyLDIwMDAy
MDBjDQo+IE1lbW9yeSBMaW1pdDogbm9uZQ0KPiANCg0KSSBkb24ndCBzZWUgd2h5IE5GUyB3b3Vs
ZCBjYXJlIGFib3V0IHRoZSBvcGVuc3dpdGNoIG1vZHVsZSBiZWluZyBsb2FkZWQNCm9yIG5vdCwg
YW5kIHNvIGdpdmVuIHlvdXIgc3RhY2sgZHVtcCwgSSBzdXNwZWN0IHRoaXMgaXMgbW9yZSBhYm91
dCBhDQpjb3JydXB0aW9uIG9mIHRoZSBnbG9iYWwgYml0X3dhaXRfdGFibGUuDQoNCkNjOiBuZXRk
ZXZAdmdlci5rZXJuZWwub3JnIHRvIHNlZSBpZiBhbnlvbmUgdGhlcmUgaXMgYXdhcmUgb2YgYW55
DQpyZWNlbnQgbW9kdWxlIGNsZWFudXAgaXNzdWVzIHdpdGggb3BlbnN3aXRjaC4NCg0KLS0gDQpU
cm9uZCBNeWtsZWJ1c3QNCkxpbnV4IE5GUyBjbGllbnQgbWFpbnRhaW5lciwgSGFtbWVyc3BhY2UN
CnRyb25kLm15a2xlYnVzdEBoYW1tZXJzcGFjZS5jb20NCg0KDQo=
