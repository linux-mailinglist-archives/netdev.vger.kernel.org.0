Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0371CE8EFE
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 19:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727672AbfJ2SIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 14:08:13 -0400
Received: from mail-eopbgr60047.outbound.protection.outlook.com ([40.107.6.47]:5550
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730759AbfJ2SIM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 14:08:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iz6XNd0ww8OttYa3eC2yR04S++yz/n2Npa2tjuxsblSFvRJyoXe6RCTj7CndrOEw1ex5kBJkUeX8oIRyMJbb1ETiubq0qP6jFsJ/2suV2WE5+JXl4YjpKuzwTC8bot3/mhlkhWoAddM6X6gzE8TCihmKKFfdCEGNJqcIuph0AFwykLMjah1ZsuOvwlzij78OKO/fU7s6fowKrDOfGvHns5eUv3nfh7YTLSUWUhQE5Dq6CN871Jg6tOXn1nv3dnYutScc2CTZ8mFRDnEBxTDsBDNZj6aXU8P/IWJj8heS3JUiftKxJecRP4FAtOERMA2RYXmIRNrhK92Pq20ON+9xRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AK6ZZDJdsCcE78zFofMRaw22JME3RXGJRTHFDY+OtPo=;
 b=jMkHEvXeeVQn/UD9Aeugob+0lXB/doese1h03KXBr2aX6NoFBkIiBpCusLx2lemRi2F1XGiCW9iWmj+NOyftNA/BmP4fOSvK4e7iP8MrLTcsxKTgS7OBjPoF9q+ez4SiJ8H4rMltB29n2pF9o1k91Xe5AvTEJkHFNvvh3t4pnJ19kNVsgmf0HtEK/Gm7HkEfgKXl6cN8zzTGJdqg0ax7cMysFA1WlvPXj8m/w6kgAK1+wnO/X/Qv7kfwIxE2wDNG+tKZA0axLY6kV0vBDQ6AJo7+Wewp8FC1EJ8evkrm9xMazlmlFa4Xp1mM9YRYuvKbxknsRV16uu7Xkxy+/gD4Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AK6ZZDJdsCcE78zFofMRaw22JME3RXGJRTHFDY+OtPo=;
 b=ebJJqer7pRtsAa3wStAUss12WvKUdwc6r7TB/AomEu5sWubsoYae/4qcW5+/BC/JysaBaav0BVJjQqYlIxIb27ZU4FeL58Cprp8AgZrqlT7PdQ1VDLoIRJ+FJsZbELBoUPbmGtp9PuhcdICm8W/dChHZe9auZjES3uMogGBEiuo=
Received: from AM6PR05MB5142.eurprd05.prod.outlook.com (20.177.197.210) by
 AM6PR05MB6581.eurprd05.prod.outlook.com (20.179.18.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Tue, 29 Oct 2019 18:06:29 +0000
Received: from AM6PR05MB5142.eurprd05.prod.outlook.com
 ([fe80::a496:d0f4:e244:6fa1]) by AM6PR05MB5142.eurprd05.prod.outlook.com
 ([fe80::a496:d0f4:e244:6fa1%5]) with mapi id 15.20.2387.027; Tue, 29 Oct 2019
 18:06:29 +0000
From:   Yuval Avnery <yuvalav@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>
CC:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        Daniel Jurgens <danielj@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH net-next 0/9] devlink vdev
Thread-Topic: [PATCH net-next 0/9] devlink vdev
Thread-Index: AQHViQAxdm3AcnGT3UW1BqH92IiL86dollkAgAAG1ACAAC80gIAAINSAgAAst4CAAl1MAIAGbagAgAAQSgA=
Date:   Tue, 29 Oct 2019 18:06:28 +0000
Message-ID: <38f489d7-0c77-6470-35ff-8f86cf655495@mellanox.com>
References: <1571766190-23943-1-git-send-email-yuvalav@mellanox.com>
 <20191023120046.0f53b744@cakuba.netronome.com>
 <20191023192512.GA2414@nanopsycho>
 <20191023151409.75676835@cakuba.hsd1.ca.comcast.net>
 <9f3974a1-95e9-a482-3dcd-0b23246d9ab7@mellanox.com>
 <20191023195141.48775df1@cakuba.hsd1.ca.comcast.net>
 <20191025145808.GA20298@C02YVCJELVCG.dhcp.broadcom.net>
 <20191029100810.66b1695a@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191029100810.66b1695a@cakuba.hsd1.ca.comcast.net>
Accept-Language: he-IL, en-US
Content-Language: he-IL
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yuvalav@mellanox.com; 
x-originating-ip: [70.66.202.183]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 34b8687c-fda2-4bfa-3621-08d75c9ab8c3
x-ms-traffictypediagnostic: AM6PR05MB6581:|AM6PR05MB6581:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB6581C92B0F7BA3A1325B850AC5610@AM6PR05MB6581.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0205EDCD76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(376002)(396003)(346002)(366004)(189003)(199004)(31686004)(4326008)(81156014)(4001150100001)(64756008)(66946007)(229853002)(36756003)(5660300002)(66556008)(66066001)(81166006)(66446008)(478600001)(66476007)(76116006)(91956017)(6512007)(316002)(8936002)(54906003)(8676002)(6436002)(110136005)(25786009)(99286004)(3846002)(6116002)(102836004)(76176011)(256004)(14454004)(6486002)(14444005)(71190400001)(71200400001)(7736002)(6246003)(6506007)(11346002)(86362001)(2906002)(476003)(186003)(446003)(2616005)(31696002)(53546011)(26005)(486006)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6581;H:AM6PR05MB5142.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wIp/WeO6r4qh9JvA2LlFtZK3xgLH78+UX5rFblS3Y//QhCd2vZW99/1MrBomy4RpV6vV4yuFhY69hL/A9UlDjYZKDGe7yNu2Ihu99TG2uXH+qSCSI5tZ2RGQuyvJZgu7DFv2AXBrvsoS+AFPo29Pd6HQ3Ovy+0JSxj9GFY05idHpOQNZgDSx5ZWHYP5kBor8oQYXTwPu0NlcJbC/Kt3xLjff2XfE0ynB+vINmWGZyEAqIs/GwpVEGWhercwLplfluZbcvzmRzrPC38JHVc6amTBwuYAbSoUp3i0+EgA25KhF3sxt4PVxim03QH+YZeI7NpEKzXuMtXk5hnNK5/2Z1P5t28//P3yjeAOyFHtCNTC4uw5NQSKr7bN/n2zpPeROpgeQoY3LnJbIG26IZVAHG+TGuD6LWlvWnzupbo/VGE8souxnpvqQDWVQVeK66uzY
Content-Type: text/plain; charset="utf-8"
Content-ID: <84F8539316CA614082EBCBC0FA394C27@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34b8687c-fda2-4bfa-3621-08d75c9ab8c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2019 18:06:28.9195
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +fVDveQkGGISnwp+ZiT9pzWOY7n0jML/vFC376AQkwVc2g9G0mWXBE9tpvSkWAGKIwHX/LpHVkXe+rdqjg7XyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6581
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAxOS0xMC0yOSAxMDowOCBhLm0uLCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4gT24gRnJp
LCAyNSBPY3QgMjAxOSAxMDo1ODowOCAtMDQwMCwgQW5keSBHb3Nwb2RhcmVrIHdyb3RlOg0KPj4g
VGhhbmtzLCBKYWt1YiwgSSdtIGhhcHB5IHRvIGNoaW1lIGluIGJhc2VkIG9uIG91ciBkZXBsb3lt
ZW50IGV4cGVyaWVuY2UuDQo+PiBXZSBkZWZpbml0ZWx5IHVuZGVyc3RhbmQgdGhlIGRlc2lyZSB0
byBiZSBhYmxlIHRvIGNvbmZpZ3VyZSBwcm9wZXJ0aWVzDQo+PiBvZiBkZXZpY2VzIG9uIHRoZSBT
bWFydE5JQyAodGhlIGtpbmQgd2l0aCBnZW5lcmFsIHB1cnBvc2UgY29yZXMgbm90IHRoZQ0KPj4g
a2luZCB3aXRoIG9ubHkgZmxvdyBvZmZsb2FkKSBmcm9tIHRoZSBzZXJ2ZXIgc2lkZS4NCj4gVGhh
bmtzIQ0KPg0KPj4gSW4gYWRkaXRpb24gdG8gYWRkcmVzc2luZyBOVk1lIGRldmljZXMsIEknZCBh
bHNvIGxpa2UgdG8gYmUgYmUgYWJsZSB0bw0KPj4gY3JlYXRlIHZpcnR1YWwgb3IgcmVhbCBzZXJp
YWwgcG9ydHMgYXMgd2VsbCBhcyB0aGVyZSBpcyBhbiBpbnRlcmVzdCBpbg0KPj4gKnNvbWV0aW1l
cyogYmVpbmcgYWJsZSB0byBnYWluIGRpcmVjdCBhY2Nlc3MgdG8gdGhlIFNtYXJ0TklDIGNvbnNv
bGUgbm90DQo+PiBqdXN0IGEgc2hlbGwgdmlhIHNzaC4gIFNvIG15IHBvaW50IGlzIHRoYXQgdGhl
cmUgYXJlIG11bHRpcGxlIHVzZS1jYXNlcy4NCj4gU2hlbGxpbmcgaW50byBhIE5JQyBpcyB0aGUg
dWx0aW1hdGUgQVBJIGJhY2tkb29yLiBJTU8gd2Ugc2hvdWxkIHRyeSB0bw0KPiBhdm9pZCB0aGF0
IGFzIG11Y2ggYXMgcG9zc2libGUuDQo+DQo+PiBBcm0gYXJlIGFsc28gX2V4dHJlbWVseV8gaW50
ZXJlc3RlZCBpbiBkZXZlbG9waW5nIGEgbWV0aG9kIHRvIGVuYWJsZQ0KPj4gc29tZSBmb3JtIG9m
IFNtYXJ0TklDIGRpc2NvdmVyeSBtZXRob2QgYW5kIHdoaWxlIGxvdHMgb2YgaWRlYXMgaGF2ZSBi
ZWVuDQo+PiB0aHJvd24gYXJvdW5kLCBkaXNjb3ZlcnkgdmlhIGRldmxpbmsgaXMgYSByZWFzb25h
YmxlIG9wdGlvbi4gIFNvIHdoaWxlDQo+PiBkb2luZyBhbGwgdGhpcyB3aWxsIGJlIG11Y2ggbW9y
ZSB3b3JrIHRoYW4gc2ltcGx5IGhhbmRsaW5nIHRoaXMgY2FzZQ0KPj4gd2hlcmUgd2Ugc2V0IHRo
ZSBwZWVyIG9yIGxvY2FsIE1BQyBmb3IgYSB2ZGV2LCBJIHRoaW5rIGl0IHdpbGwgYmUgd29ydGgN
Cj4+IGl0IHRvIG1ha2UgdGhpcyBtb3JlIHVzYWJsZSBmb3IgYWxsXlcgbW9yZSB0eXBlcyBvZiBk
ZXZpY2VzLiAgSSBhbHNvDQo+PiBhZ3JlZSB0aGF0IG5vdCBldmVyeXRoaW5nIG9uIHRoZSBvdGhl
ciBzaWRlIG9mIHRoZSB3aXJlIHNob3VsZCBiZSBhDQo+PiBwb3J0Lg0KPj4NCj4+IFNvIGlmIHdl
IGFncmVlIHRoYXQgYWRkcmVzc2luZyB0aGlzIGRldmljZSBhcyBhIFBDSWUgZGV2aWNlIHRoZW4g
aXQNCj4+IGZlZWxzIGxpa2Ugd2Ugd291bGQgYmUgYmV0dGVyIHNlcnZlZCB0byBxdWVyeSBkZXZp
Y2UgY2FwYWJpbGl0aWVzIGFuZA0KPj4gZGVwZW5kaW5nIG9uIHdoYXQgY2FwYWJpbGl0aWVzIGV4
aXN0IHdlIHdvdWxkIGJlIGFibGUgdG8gY29uZmlndXJlDQo+PiBwcm9wZXJ0aWVzIGZvciB0aG9z
ZS4gIEluIGFuIGlkZWFsIHdvcmxkLCBJIGNvdWxkIHF1ZXJ5IGEgZGV2aWNlIHVzaW5nDQo+PiBk
ZXZsaW5rICgnZGV2bGluayBpbmZvJz8pIGFuZCBpdCB3b3VsZCBzaG93IG1lIGRpZmZlcmVudCBk
ZXZpY2VzIHRoYXQNCj4+IGFyZSBhdmFpbGFibGUgZm9yIGNvbmZpZ3VyYXRpb24gb24gdGhlIFNt
YXJ0TklDIGFuZCB3b3VsZCBhbHNvIGdpdmUgbWUgYQ0KPj4gd2F5IHRvIGFkZHJlc3MgdGhlbS4g
IFNvIHdoaWxlIEkgbGlrZSB0aGUgaWRlYSBvZiBiZWluZyBhYmxlIHRvIGFkZHJlc3MNCj4+IGFu
ZCBzZXQgcGFyYW1ldGVycyBhcyBzaG93biBpbiBwYXRjaCAwNSBvZiB0aGlzIHNlcmllcywgSSB3
b3VsZCBsaWtlIHRvDQo+PiBzZWUgYSBiaXQgbW9yZSBmbGV4aWJpbGl0eSB0byBkZWZpbmUgd2hh
dCB0eXBlIG9mIGRldmljZSBpcyBhdmFpbGFibGUNCj4+IGFuZCBob3cgaXQgbWlnaHQgYmUgY29u
ZmlndXJlZC4NCj4gV2Ugc2hhbGwgc2VlIGhvdyB0aGlzIGRldmVsb3BzLiBGb3Igbm93IHNvdW5k
cyBwcmV0dHkgaGlnaCBsZXZlbC4NCj4gSWYgdGhlIE5JQyBuZWVkcyB0byBleHBvc2UgbWFueSAi
ZGV2aWNlcyIgdGhhdCBhcmUgaW5kZXBlbmRlbnRseQ0KPiBjb250cm9sbGVkIHdlIHNob3VsZCBw
cm9iYWJseSBsb29rIGF0IHJlLXVzaW5nIHRoZSBzdGFuZGFyZCBkZXZpY2UNCj4gbW9kZWwgYW5k
IG5vdCByZWludmVudCB0aGUgd2hlZWwuDQo+IElmIHdlIG5lZWQgdG8gY29uZmlndXJlIHBhcnRp
Y3VsYXIgYXNwZWN0cyBhbmQgcmVzb3VyY2UgYWxsb2NhdGlvbiwNCj4gd2UgY2FuIGFkZCBkZWRp
Y2F0ZWQgQVBJcyBhcyBuZWVkZWQuDQo+DQo+IFdoYXQgSSBkZWZpbml0ZWx5IHdhbnQgdG8gYXZv
aWQgaXMgYWRkaW5nIGEgY2F0Y2gtYWxsIEFQSSB3aXRoIHVuY2xlYXINCj4gc2VtYW50aWNzIHdo
aWNoIHdpbGwgYmVjb21lIHRoZSBTbWFydE5JQyBkdW1waW5nIGdyb3VuZC4NCj4NCj4+IFNvIGlm
IHdlIHRvb2sgdGhlIGRldmxpbmsgaW5mbyBjb21tYW5kIGFzIGFuIGV4YW1wbGUgKHdoZXRoZXIg
aXRzIHRoZQ0KPj4gcHJvcGVyIHBsYWNlIGZvciB0aGlzIG9yIG5vdCksIGl0IGNvdWxkIGxvb2sg
X2xpa2VfIHRoaXM6DQo+Pg0KPj4gJCBkZXZsaW5rIGRldiBpbmZvIHBjaS8wMDAwOjAzOjAwLjAN
Cj4+IHBjaS8wMDAwOjAzOjAwLjA6DQo+PiAgICBkcml2ZXIgZm9vDQo+PiAgICBzZXJpYWxfbnVt
YmVyIDg2NzUzMDkNCj4+ICAgIHZlcnNpb25zOg0KPj4gWy4uLl0NCj4+ICAgIGNhcGFiaWxpdGll
czoNCj4+ICAgICAgICBzdG9yYWdlIDANCj4+ICAgICAgICBjb25zb2xlIDENCj4+ICAgICAgICBt
ZGV2IDEwMjQNCj4+ICAgICAgICBbc29tZXRoaW5nIGVsc2VdIFtsaW1pdF0NCj4+DQo+PiAoQWRk
aXRpb25hbGx5IHJhdGhlciB0aGFuIHB1dHRpbmcgdGhpcyBhcyBwYXJ0IG9mICdpbmZvJyB0aGUg
ZGV2aWNlDQo+PiBjYXBhYmlsaXRpZXMgYW5kIGxpbWl0cyBjb3VsZCBiZSBwYXJ0IG9mIHRoZSAn
cmVzb3VyY2UnIHNlY3Rpb24gYW5kDQo+PiBmcmFua2x5IG1heSBtYWtlIG1vcmUgc2Vuc2UgaWYg
dGhpcyBpcyBwYXJ0IG9mIHRoYXQuKQ0KPj4NCj4+IGFuZCB0aGVuIHRob3NlIGNhcGFiaWxpdGll
cyB3b3VsZCBiZSBzb21ldGhpbmcgdGhhdCBjb3VsZCBiZSBzZXQgdXNpbmcgdGhlDQo+PiAndmRl
dicgb3Igd2hhdGV2ZXItaXQtaXMtbmFtZWQgaW50ZXJmYWNlOg0KPj4NCj4+ICMgZGV2bGluayB2
ZGV2IHNob3cgcGNpLzAwMDA6MDM6MDAuMA0KPj4gcGNpLzAwMDA6MDM6MDAuMC9jb25zb2xlLzA6
IHNwZWVkIDExNTIwMCBkZXZpY2UgL2Rldi90dHlTTklDMA0KPiBUaGUgc3BlZWQgaW4gdGhpcyBj
b25zb2xlIGV4YW1wbGUgbWFrZXMgbm8gc2Vuc2UgdG8gbWUuDQo+DQo+IFRoZSBwYXRjaGVzIGFz
IHRoZXkgc3RhbmQgYXJlIGFib3V0IHRoZSBwZWVyIHNpZGUvb3RoZXIgc2lkZSBvZiB0aGUNCj4g
cG9ydC4gU28gd2hpY2ggc2lkZSBvZiB0aGUgc2VyaWFsIGRldmljZSBpcyB0aGUgc3BlZWQgc2V0
IG9uPyBPbmUgY2FuDQo+IGp1c3QgcmVhZCB0aGUgc3BlZWQgZnJvbSAvZGV2L3R0eVNOSUMwLiBB
bmQgbGluayB0aGF0IHNlcmlhbCBkZXZpY2UgdG8NCj4gdGhlIGFwcHJvcHJpYXRlIHBhcmVudCB2
aWEgc3lzZnMuIFRoaXMgaXMgcHVyZSB3aGVlbCByZWludmVudGlvbi4NCj4NClRoZSBwYXRjaGVz
IGFyZSBub3Qgb25seSBhYm91dCB0aGUgb3RoZXIgc2lkZSwNCg0KVGhleSBhcmUgYWJvdXQgYWxs
IHRoZSBkZXZpY2VzIHdoaWNoIGFyZSB1bmRlciB0aGUgY29udHJvbCBvZiBhIA0KcHJpdmlsZWdl
ZCB1c2VyLg0KDQpJbiB0aGUgY2FzZSBvZiBTbWFydE5pYywgdGhvc2UgZGV2aWNlcyAodmRldnMp
IGFyZSBvbiB0aGUgaG9zdCBzaWRlLCBhbmQgDQp0aGUgcHJpdmlsZWdlZCB1c2VyIHJ1bnMgb24g
dGhlIGVtYmVkZGVkIENQVS4NCg0KVGhlIHZkZXYgZGV2aWNlcyBkb24ndCBuZWNlc3NhcmlseSBo
YXZlIHJlbGF0aW9uc2hpcCB3aXRoIGEgcG9ydC4gQWxsIA0KYXR0cmlidXRlcyBhcmUgb3B0aW9u
YWwgZXhjZXB0IGZsYXZvdXIuDQoNCj4+IHBjaS8wMDAwOjAzOjAwLjAvbWRldi8wOiBod19hZGRy
IDAyOjAwOjAwOjAwOjAwOjAwDQo+PiBbLi4uXQ0KPj4gcGNpLzAwMDA6MDM6MDAuMC9tZGV2LzEw
MjM6IGh3X2FkZHIgMDI6MDA6MDA6MDA6MDM6ZmYNCj4+DQo+PiAjIGRldmxpbmsgdmRldiBzZXQg
cGNpLzAwMDA6MDM6MDAuMC9tZGV2LzAgaHdfYWRkciAwMDoyMjozMzo0NDo1NTowMA0KPj4NCj4+
IFNpbmNlIHRoZXNlIEFybS9SSVNDLVYgYmFzZWQgU21hcnROSUNzIGFyZSBnb2luZyB0byBiZSB1
c2VkIGluIGEgdmFyaWV0eQ0KPj4gb2YgZGlmZmVyZW50IHdheXMgYW5kIHdpbGwgaGF2ZSBhIHZh
cmlldHkgb2YgZGlmZmVyZW50IHBlcnNvbmFsaXRpZXMNCj4+IChub3QganVzdCBkaWZmZXJlbnQg
U0tVcyB0aGF0IHZlbmRvcnMgd2lsbCBvZmZlciBidXQgZGlmZmVyZW50IHdheXMgaW4NCj4+IHdo
aWNoIHRoZXNlIHdpbGwgYmUgZGVwbG95ZWQpLCBJIHRoaW5rIGl0J3MgY3JpdGljYWwgdGhhdCB3
ZSBjb25zaWRlcg0KPj4gbW9yZSB0aGFuIGp1c3QgdGhlIG1kZXYvcmVwcmVzZW50ZXIgY2FzZSBm
cm9tIHRoZSBzdGFydC4NCg0KDQo=
