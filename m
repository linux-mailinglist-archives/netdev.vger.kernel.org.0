Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22F69E2752
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 02:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392821AbfJXALx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 20:11:53 -0400
Received: from mail-eopbgr00062.outbound.protection.outlook.com ([40.107.0.62]:59738
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392153AbfJXALx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 20:11:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NsU+Ktrd0PXP3NEIAiU7yPNzOQLwJSFMsGC5dsWAkrKt+Po5Y3sgQFsQHc9GaYRlEf5NQ+5GR6GWYut+ClntAd8NIjfUFNRq7EeCQxEMomww7gsNgjdjr9pJgrLgRHZGEumcCb4Dqy/2ecMXS46HuFTmAfJuRkiBth8NHzWS+f3ktUzHEEBalJfElHCsobcUcL0yfYRXTsEbVjT/oJM+B7NLUmRuvFnIO221mh6YvBgsPoU6B/RsQ2MEDS3zeB83PZqhC1tns+5IltRMQrC81qA7X7x1uVJolL8+5mtK2emvRZ5HQe3k414SWYysXRpcp6yNJ0zUHQKTZuu3v1YvOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p3OvVd96J3f2j5+AWFSBXGbvkoamDh46NpbQzZUZvOg=;
 b=fmvDZFqT39UjAbGUh0Fytjl/R8LAWCjyJPAja0jzyg1rHbFRhR914anwOqdgemY/YLQ0WqeU1IEw2mobLxb01WRMShE6wAQPabjKXFY8vlu2J9nfhMwOE9UR9JvBL+XljIy36Tp54Jzz89xTpbIsKAJH80GUf8mjkBhJGhPKbkfry971SIl6fazZoI35zydLpSVzMU1V69Nv5CTDs65DWJSL2vp5tgUnv6ROPWJS5gY1s3C26aZ86bf59PE6z/tPnS6J7t3XqCM8AamWiotLeS0rx8SHJnzSNbrPr+Nbmx2njB0GMBavOeQiVweLVhtw+GVVrC7v20ayxyulYEdArQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p3OvVd96J3f2j5+AWFSBXGbvkoamDh46NpbQzZUZvOg=;
 b=jyt+udDmCE0Bcnxbe8k3WyZ4fMcFRdodaj0JtOzHPGJJVE4Ibb8Od9CaEMRc44NWlcPT/5B/mOhdpNA5PkY+ySIYHTKFzU2XQlfHSj+nXablJtGRXxFAgEUt276qmIOOn6toOhJVBD5xTzyUmx0yYHnOolu7paHGRk0obqztM9Y=
Received: from AM6PR05MB5142.eurprd05.prod.outlook.com (20.177.197.210) by
 AM6PR05MB6343.eurprd05.prod.outlook.com (20.179.18.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.20; Thu, 24 Oct 2019 00:11:49 +0000
Received: from AM6PR05MB5142.eurprd05.prod.outlook.com
 ([fe80::a496:d0f4:e244:6fa1]) by AM6PR05MB5142.eurprd05.prod.outlook.com
 ([fe80::a496:d0f4:e244:6fa1%5]) with mapi id 15.20.2387.021; Thu, 24 Oct 2019
 00:11:49 +0000
From:   Yuval Avnery <yuvalav@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        Daniel Jurgens <danielj@mellanox.com>
Subject: Re: [PATCH net-next 0/9] devlink vdev
Thread-Topic: [PATCH net-next 0/9] devlink vdev
Thread-Index: AQHViQAxdm3AcnGT3UW1BqH92IiL86dollkAgAAG1ACAAC80gIAAINSA
Date:   Thu, 24 Oct 2019 00:11:48 +0000
Message-ID: <9f3974a1-95e9-a482-3dcd-0b23246d9ab7@mellanox.com>
References: <1571766190-23943-1-git-send-email-yuvalav@mellanox.com>
 <20191023120046.0f53b744@cakuba.netronome.com>
 <20191023192512.GA2414@nanopsycho>
 <20191023151409.75676835@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191023151409.75676835@cakuba.hsd1.ca.comcast.net>
Accept-Language: he-IL, en-US
Content-Language: he-IL
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yuvalav@mellanox.com; 
x-originating-ip: [70.66.202.183]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 99852607-b425-45ae-7ddf-08d75816c3a3
x-ms-traffictypediagnostic: AM6PR05MB6343:|AM6PR05MB6343:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB6343573398C9F1E953DD1A7AC56A0@AM6PR05MB6343.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(396003)(346002)(366004)(199004)(189003)(305945005)(229853002)(316002)(7736002)(76176011)(14444005)(14454004)(256004)(446003)(4001150100001)(31696002)(11346002)(8676002)(5660300002)(478600001)(6116002)(3846002)(6486002)(99286004)(6436002)(110136005)(36756003)(54906003)(6512007)(76116006)(25786009)(66946007)(66476007)(64756008)(66446008)(66556008)(6246003)(186003)(91956017)(86362001)(486006)(71190400001)(71200400001)(102836004)(31686004)(2906002)(476003)(6506007)(2616005)(81166006)(81156014)(4326008)(53546011)(26005)(66066001)(8936002)(107886003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6343;H:AM6PR05MB5142.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PgilXDtzwmeaL3HaGSMPe8H1+06MWSs1XICnOpsih8RSF+Sd6T4Isaj227+XcPofVkZFXV5kiq9VvKv/KXncyMUnvp0XJ3dZFSuBRTDKAtXuYp0Ke7Uds/3qprfUMiP9xzqid/o84JwuhPVkh917Q/SZe7/jRLkHvTN54lqEL2nCxgrrcj9jmGpEZYDHR0DGANYIlh8A0ZYjF7uZaMOdm8KeU1ld6CZGp9eTjWL8QCGBG9N1Nune0rxBV1AjBujc+yCEf0RcjEzjTKB3UdcujTWeZc3oSXi2Wndj2KDTNXJmEOZRmbo1n5QJ6bNZze+ECuA4vCRDC5lBK29VzXVp3Lyk40IH3xGF8NzYeOmPrlCLNGvRgdzDr1ZFAcrtO/cL8ewsPEh+NgWHpo0jOMbCkUvM+WUp4nm657CLxgl2+gj8bqB0Wa9siVWgb/wSAuz0
Content-Type: text/plain; charset="utf-8"
Content-ID: <FADB7D9EA994FC44B7820AEC06D8CEA4@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99852607-b425-45ae-7ddf-08d75816c3a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 00:11:48.9032
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D9dIwahzHNawlqLZyFLQZwfXtww4ET3eEIhefK0q3xV8UlzhPxLnZ+XIOD4Ws4pez6b0mpTKNGEm2zaKmHASPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6343
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAxOS0xMC0yMyAzOjE0IHAubS4sIEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPiBPbiBXZWQs
IDIzIE9jdCAyMDE5IDIxOjI1OjEyICswMjAwLCBKaXJpIFBpcmtvIHdyb3RlOg0KPj4gV2VkLCBP
Y3QgMjMsIDIwMTkgYXQgMDk6MDA6NDZQTSBDRVNULCBqYWt1Yi5raWNpbnNraUBuZXRyb25vbWUu
Y29tIHdyb3RlOg0KPj4+IE9uIFR1ZSwgMjIgT2N0IDIwMTkgMjA6NDM6MDEgKzAzMDAsIFl1dmFs
IEF2bmVyeSB3cm90ZToNCj4+Pj4gVGhpcyBwYXRjaHNldCBpbnRyb2R1Y2VzIGRldmxpbmsgdmRl
di4NCj4+Pj4NCj4+Pj4gQ3VycmVudGx5LCBsZWdhY3kgdG9vbHMgZG8gbm90IHByb3ZpZGUgYSBj
b21wcmVoZW5zaXZlIHNvbHV0aW9uIHRoYXQgY2FuDQo+Pj4+IGJlIHVzZWQgaW4gYm90aCBTbWFy
dE5pYyBhbmQgbm9uLVNtYXJ0TmljIG1vZGUuDQo+Pj4+IFZkZXYgcmVwcmVzZW50cyBhIGRldmlj
ZSB0aGF0IGV4aXN0cyBvbiB0aGUgQVNJQyBidXQgaXMgbm90IG5lY2Vzc2FyaWx5DQo+Pj4+IHZp
c2libGUgdG8gdGhlIGtlcm5lbC4NCj4+Pj4NCj4+Pj4gVXNpbmcgZGV2bGluayBwb3J0cyBpcyBu
b3Qgc3VpdGFibGUgYmVjYXVzZToNCj4+Pj4NCj4+Pj4gMS4gVGhvc2UgZGV2aWNlcyBhcmVuJ3Qg
bmVjZXNzYXJpbHkgbmV0d29yayBkZXZpY2VzIChzdWNoIGFzIE5WTWUgZGV2aWNlcykNCj4+Pj4g
ICAgIGFuZCBkb2VzbuKAmXQgaGF2ZSBFLXN3aXRjaCByZXByZXNlbnRhdGlvbi4gVGhlcmVmb3Jl
LCB0aGVyZSBpcyBuZWVkIGZvcg0KPj4+PiAgICAgbW9yZSBnZW5lcmljIHJlcHJlc2VudGF0aW9u
IG9mIFBDSSBWRi4NCj4+Pj4gMi4gU29tZSBhdHRyaWJ1dGVzIGFyZSBub3QgbmVjZXNzYXJpbHkg
cHVyZSBwb3J0IGF0dHJpYnV0ZXMNCj4+Pj4gICAgIChudW1iZXIgb2YgTVNJWCB2ZWN0b3JzKQ0K
Pj4+PiAzLiBJdCBjcmVhdGVzIGEgY29uZnVzaW5nIGRldmxpbmsgdG9wb2xvZ3ksIHdpdGggbXVs
dGlwbGUgcG9ydCBmbGF2b3Vycw0KPj4+PiAgICAgYW5kIGluZGljZXMuDQo+Pj4+DQo+Pj4+IFZk
ZXYgd2lsbCBiZSBjcmVhdGVkIGFsb25nIHdpdGggZmxhdm91ciBhbmQgYXR0cmlidXRlcy4NCj4+
Pj4gU29tZSBuZXR3b3JrIHZkZXZzIG1heSBiZSBsaW5rZWQgd2l0aCBhIGRldmxpbmsgcG9ydC4N
Cj4+Pj4NCj4+Pj4gVGhpcyBpcyBhbHNvIGFpbWVkIHRvIHJlcGxhY2UgImlwIGxpbmsgdmYiIGNv
bW1hbmRzIGFzIHRoZXkgYXJlIHN0cm9uZ2x5DQo+Pj4+IGxpbmtlZCB0byB0aGUgUENJIHRvcG9s
b2d5IGFuZCBhbGxvdyBhY2Nlc3Mgb25seSB0byBlbmFibGVkIFZGcy4NCj4+Pj4gRXZlbiB0aG91
Z2ggY3VycmVudCBwYXRjaHNldCBhbmQgZXhhbXBsZSBpcyBsaW1pdGVkIHRvIE1BQyBhZGRyZXNz
DQo+Pj4+IG9mIHRoZSBWRiwgdGhpcyBpbnRlcmZhY2Ugd2lsbCBhbGxvdyB0byBtYW5hZ2UgUEYs
IFZGLCBtZGV2IGluDQo+Pj4+IFNtYXJ0TmljIGFuZCBub24gU21hcnROaWMgbW9kZXMsIGluIHVu
aWZpZWQgd2F5IGZvciBuZXR3b3JraW5nIGFuZA0KPj4+PiBub24tbmV0d29ya2luZyBkZXZpY2Vz
IHZpYSBkZXZsaW5rIGluc3RhbmNlLg0KPj4+Pg0KPj4+PiBFeGFtcGxlOg0KPj4+Pg0KPj4+PiBB
IHByaXZpbGVnZWQgdXNlciB3YW50cyB0byBjb25maWd1cmUgYSBWRidzIGh3X2FkZHIsIGJlZm9y
ZSB0aGUgVkYgaXMNCj4+Pj4gZW5hYmxlZC4NCj4+Pj4NCj4+Pj4gJCBkZXZsaW5rIHZkZXYgc2V0
IHBjaS8wMDAwOjAzOjAwLjAvMSBod19hZGRyIDEwOjIyOjMzOjQ0OjU1OjY2DQo+Pj4+DQo+Pj4+
ICQgZGV2bGluayB2ZGV2IHNob3cgcGNpLzAwMDA6MDM6MDAuMC8xDQo+Pj4+IHBjaS8wMDAwOjAz
OjAwLjAvMTogZmxhdm91ciBwY2l2ZiBwZiAwIHZmIDAgcG9ydF9pbmRleCAxIGh3X2FkZHIgMTA6
MjI6MzM6NDQ6NTU6NjYNCj4+Pj4NCj4+Pj4gJCBkZXZsaW5rIHZkZXYgc2hvdyBwY2kvMDAwMDow
MzowMC4wLzEgLWpwDQo+Pj4+IHsNCj4+Pj4gICAgICAidmRldiI6IHsNCj4+Pj4gICAgICAgICAg
InBjaS8wMDAwOjAzOjAwLjAvMSI6IHsNCj4+Pj4gICAgICAgICAgICAgICJmbGF2b3VyIjogInBj
aXZmIiwNCj4+Pj4gICAgICAgICAgICAgICJwZiI6IDAsDQo+Pj4+ICAgICAgICAgICAgICAidmYi
OiAwLA0KPj4+PiAgICAgICAgICAgICAgInBvcnRfaW5kZXgiOiAxLA0KPj4+PiAgICAgICAgICAg
ICAgImh3X2FkZHIiOiAiMTA6MjI6MzM6NDQ6NTU6NjYiDQo+Pj4+ICAgICAgICAgIH0NCj4+Pj4g
ICAgICB9DQo+Pj4+IH0NCj4+PiBJIGRvbid0IHRydXN0IHRoaXMgaXMgYSBnb29kIGRlc2lnbi4N
Cj4+Pg0KPj4+IFdlIG5lZWQgc29tZSBwcm9wZXIgb250b2xvZ3kgYW5kIGRlY2lzaW9ucyB3aGF0
IGdvZXMgd2hlcmUuIFdlIGhhdmUNCj4+PiBoYWxmIG9mIHBvcnQgYXR0cmlidXRlcyBkdXBsaWNh
dGVkIGhlcmUsIGFuZCBod19hZGRyIHdoaWNoIGhvbmVzdGx5DQo+Pj4gbWFrZXMgbW9yZSBzZW5z
ZSBpbiBhIHBvcnQgKHNpbmNlIHBvcnQgaXMgbW9yZSBvZiBhIG5ldHdvcmtpbmcNCj4+PiBjb25z
dHJ1Y3QsIHdoeSB3b3VsZCBlcCBzdG9yYWdlIGhhdmUgYSBod19hZGRyPykuIFRoZW4geW91IHNh
eSB5b3UncmUNCj4+PiBnb2luZyB0byBkdW1wIG1vcmUgUENJIHN0dWZmIGluIGhlcmUgOigNCj4+
IFdlbGwgYmFzaWNhbGx5IHdoYXQgdGhpcyAidmRldiIgaXMgaXMgdGhlICJwb3J0IHBlZXIiIHdl
IGRpc2N1c3NlZA0KPj4gY291cGxlIG9mIG1vbnRocyBhZ28uIEl0IHByb3ZpZGVzIHBvc3NpYmls
aXR5IGZvciB0aGUgdXNlciBvbiBiYXJlIG1ldGFsDQo+PiB0byBjb2ZpZ3VyZSB0aGluZ3MgZm9y
IHRoZSBWRiAtIGZvciBleGFtcGxlLg0KPj4NCj4+IFJlZ2FyZGluZyBod19hZGRyIHZzLiBwb3J0
IC0gaXQgaXMgbm90IGNvcnJlY3QgdG8gbWFrZSB0aGF0IGEgZGV2bGluaw0KPj4gcG9ydCBhdHRy
aWJ1dGUuIEl0IGlzIG5vdCBwb3J0J3MgaHdfYWRkciwgYnV0IHRoZSBwb3J0J3MgcGVlciBod19h
ZGRyLg0KPiBZZWFoLCBJIHJlbWVtYmVyIHVzIGFyZ3Vpbmcgd2l0aCBvdGhlcnMgdGhhdCAidGhl
IG90aGVyIHNpZGUgb2YgdGhlDQo+IHdpcmUiIHNob3VsZCBub3QgYmUgYSBwb3J0Lg0KPg0KPj4+
ICJ2ZGV2IiBzb3VuZHMgZW50aXJlbHkgbWVhbmluZ2xlc3MsIGFuZCBoYXMgYSBoaWdoIGNoYW5j
ZSBvZiBiZWNvbWluZw0KPj4+IGEgZHVtcGluZyBncm91bmQgZm9yIGF0dHJpYnV0ZXMuDQo+PiBT
dXJlLCBpdCBpcyBhIG1hZGV1cCBuYW1lLiBJZiB5b3UgaGF2ZSBhIGJldHRlciBuYW1lLCBwbGVh
c2Ugc2hhcmUuDQo+IElESy4gSSB0aGluayBJIHN0YXJ0ZWQgdGhlICJwZWVyIiBzdHVmZiwgc28g
aXQgbWFkZSBzZW5zZSB0byBtZS4NCj4gTm93IGl0IHNvdW5kcyBsaWtlIHlvdSdkIGxpa2UgdG8g
a2lsbCBhIGxvdCBvZiBwcm9ibGVtcyB3aXRoIHRoaXMNCj4gb25lIHN0b25lLiBGb3IgUENJZSAi
dmRldiIgaXMgZGVmIHdyb25nIGJlY2F1c2Ugc29tZSBvZiB0aGUgY29uZmlnDQo+IHdpbGwgYmUg
Zm9yIFBGICh3aGljaCBpcyBub3QgdmlydHVhbCkuIEFsc28gZm9yIFBDSWUgdGhlIGNvbmZpZyBo
YXMNCj4gdG8gYmUgZG9uZSB3aXRoIHBlcm1hbmVuY2UgaW4gbWluZCBmcm9tIGRheSAxLCBQQ0kg
b2Z0ZW4gcmVxdWlyZXMNCj4gSFcgcmVzZXQgdG8gcmVjb25maWcuDQo+DQpUaGUgUEYgaXMgInZp
cnR1YWwiIGZyb20gdGhlIFNtYXJ0TmljIGVtYmVkZGVkIENQVSBwb2ludCBvZiB2aWV3Lg0KDQpN
YXliZSBnZGV2IGlzIGJldHRlcj8gKGdlbmVyaWMpDQoNCj4+IEJhc2ljYWxseSBpdCBpcyBzb21l
dGhpbmcgdGhhdCByZXByZXNlbnRzIFZGL21kZXYgLSB0aGUgb3RoZXIgc2lkZSBvZg0KPj4gZGV2
bGluayBwb3J0LiBCdXQgaW4gc29tZSBjYXNlcywgbGlrZSBOVk1lLCB0aGVyZSBpcyBubyBhc3Nv
Y2lhdGVkDQo+PiBkZXZsaW5rIHBvcnQgLSB0aGF0IGlzIHdoeSAiZGV2bGluayBwb3J0IHBlZXIi
IHdvdWxkIG5vdCB3b3JrIGhlcmUuDQo+IFdoYXQgYXJlIHRoZSBOVk1lIHBhcmFtZXRlcnMgd2Un
ZCBjb25maWd1cmUgaGVyZT8gUXVldWVzIGV0Yy4gb3Igc29tZQ0KPiBJRHM/IFByZXN1bWFibHkg
dGhlcmUgd2lsbCBiZSBhIE5WTWUtc3BlY2lmaWMgd2F5IHRvIGNvbmZpZ3VyZSB0aGluZ3M/DQo+
IFNvbWV0aGluZyBoYXMgdG8gcG9pbnQgdGhlIE5WTWUgVkYgdG8gYSBiYWNrZW5kLCByaWdodD8N
Cj4NCj4gKEkgaGF2ZW4ndCBsb29rZWQgbXVjaCBpbnRvIE5WTWUgbXlzZWxmIGluIGNhc2UgdGhh
dCdzIG5vdCBvYnZpb3VzIDspKQ0KDQoNCg==
