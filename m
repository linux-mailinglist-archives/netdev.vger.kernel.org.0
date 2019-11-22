Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCB41079DE
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 22:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfKVVLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 16:11:41 -0500
Received: from mail-eopbgr40042.outbound.protection.outlook.com ([40.107.4.42]:60686
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726568AbfKVVLk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 16:11:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AeXPf/dhfj9YJgcWEcW302EqQM55hSbHo6O3PdkMZkkNNvf35Tv52BEPbUNqXW3X+HlH1RRuG6Yvq1DB4cBq2m4XHCE7Sj9MC3ITuSo5+wv8RrIebAm7dzy/8K5Zb5Iea03fOsIe+UMUlQ0Q8V6PdPLFwedTibfYPqZ5H3oM/o6eHjTNVLV9a7F0nJM6Y4slmoRR3xy9XWZ2tSThJKXwIcbJTfUA063bVM8I2BVDgQ620xCIkcw7seMYWCfAPaW5wJpNzkcKGfibxDkIMgXETZwl95wPdNBV98LQCiHJoIC4SQtHmTLgQENuFy41mXDSOyBlAj8ZIc6qjLhv5S2uqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ESsMtwImGQ5xOZp4f2BGlNENoV7+BCcNK0gbADqK7vA=;
 b=LE32pBZH4jeqFO6RRFIYLAt9Knwzv6DVwJCEO56s6n55AFTsmACJKwu+gDB4STT2TTf5Z2km9j0z+yl6Od/+k0v+ibO/hl8M7FgaebbPuAJovbKrCPNQSJXKp0NG+X//Hr9qwjVXp0qvKhVsfoZFQk1v3FKEb+TSma8fG1wpo5+KBW+8ig27bI4Lky3SkIaIUpQbswF5F+O0OyMvH9otjvA/sVFaKHG4kGbLfElm0jpX2qAGJ8gfHpfz0ufMlOwiEvwDuMo+qJakM4nqmTlrJf5DZPVdn8XO0Dk8lfLHyJvQ30H1TQq2UyEz8gRE46TAv6Sim2dpbTboSkCzr9HpCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ESsMtwImGQ5xOZp4f2BGlNENoV7+BCcNK0gbADqK7vA=;
 b=gEOdRaT1R6zlyT47GlpRbF6wJFqJX4Sj9ThU09Ff32yRwadx7vMWrJfzQm9sR0yNjyWE5oWpCwxNSM9AMUzNJXZI2ym8obS+n/OiD0yAsATB6Gd4KKNdM3x+3ExRCCbgqtWHwMfVMz4FJvtjFhSqbA6PbN6qttm7tjdF/raFp2U=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6032.eurprd05.prod.outlook.com (20.178.127.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Fri, 22 Nov 2019 21:11:36 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.019; Fri, 22 Nov 2019
 21:11:36 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 0/5] Mellanox, mlx5-next updates 2019-11-20
Thread-Topic: [PATCH mlx5-next 0/5] Mellanox, mlx5-next updates 2019-11-20
Thread-Index: AQHVn/D5J01bRWykDkqcH1UDlc+PeaeXsvQA
Date:   Fri, 22 Nov 2019 21:11:36 +0000
Message-ID: <9fe0af7f6f207e96624b57f58641833609e51ad6.camel@mellanox.com>
References: <20191120222128.29646-1-saeedm@mellanox.com>
In-Reply-To: <20191120222128.29646-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 106bcc8d-ea07-4dc7-a447-08d76f908f30
x-ms-traffictypediagnostic: VI1PR05MB6032:|VI1PR05MB6032:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6032D56AAE42E41F2B3DD618BE490@VI1PR05MB6032.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(346002)(396003)(376002)(199004)(189003)(186003)(25786009)(81166006)(71190400001)(81156014)(36756003)(99286004)(5660300002)(15650500001)(256004)(478600001)(71200400001)(37006003)(8676002)(86362001)(14444005)(54906003)(6436002)(76176011)(58126008)(316002)(6246003)(14454004)(450100002)(6512007)(6116002)(6486002)(4001150100001)(6636002)(64756008)(8936002)(66446008)(66946007)(66476007)(4326008)(66556008)(66066001)(446003)(6862004)(76116006)(7736002)(91956017)(2616005)(26005)(11346002)(2906002)(305945005)(6506007)(118296001)(3846002)(102836004)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6032;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d391VN6UwLE/Aa1K+7hgGqF9/YByO+yvdbk8pntDVXccGkr+YJrwLXDngks8fk5EJ/ldmDLndjzCh6LTfI0GWyWbaKEXA35FzAyFxfueS9/K/idLtTzwB7nwLT6AzhBu3eYjaArzhudQjbWD5EmU3OSX46cCeQPjwPqV0zVoy9TC4mEUI/OEcf59+eI8NzMO/8d6oHy0Bj+3zHAt/3NT5qYEutgCF9ofLxUl70in/nQoiZW9xrenasgZ5TDtfwFqpASVLlVn6qkIiLEkxvPWrdXqnY77IMIwaB2xYoGOMj+b+rYU2R617n9HvfRxyFl6CqZRAnRJVKcjtDArG1eczCJ+2qMouwo/hWeFZDwtdcTqMX28CCSqqC9EpUngA7WB4gdCd42yfwyu0SUraE0xTDkHqk27JarHc2Qe3TyfCuwdsEqnexTMC5j++tEpzQ5+
Content-Type: text/plain; charset="utf-8"
Content-ID: <E408C7816F58DD429279818CDFFA0BAD@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 106bcc8d-ea07-4dc7-a447-08d76f908f30
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 21:11:36.3508
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WG1V0fYWGKoXB5Xdi5EJ7pRSvTK7yg2K2Oj19s5enWLTZmbBQkPtP00Hcauv1hvlTzv84KqAA0byCyTEPlnkTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6032
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTExLTIwIGF0IDIyOjIyICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gVGhpcyBzZXJpZXMgYWRkcyBtaXNjIHVwZGF0ZXMgdG8gbWx4NSBzaGFyZWQgaGVhZGVyIGZp
bGVzIGFuZCwgdG8NCj4gaW5jbHVkZQ0KPiBuZXcgSFcgbGF5b3V0cyBmb3IgcmVnaXN0ZXJzIHRo
YXQgYXJlIGdvaW5nIHRvIGJlIHVzZWQgaW4gdXBjb21pbmcNCj4gc3VibWlzc2lvbiB0byBuZXQt
bmV4dC4NCj4gDQo+IEZyb20gQXlhLCBSZXNvdXJjZSBkdW1wIHJlZ2lzdGVycyBmb3IgZGV2bGlu
ayBoZWFsdGggZHVtcC4NCj4gRnJvbSBFcmFuLCBNQ0FNIGFuZCBNSVJDIHJlZ2lzdGVycyBmb3Ig
ZmlybXdhcmUgZmxhc2ggcmUtYWN0aXZhdGUNCj4gZmxvdy4NCj4gRnJvbSBMZW9uLCBEb24ndCB3
cml0ZSByZWFkIG9ubHkgZmllbGRzIHRvIHZwb3J0IGNvbnRleHQuDQo+IA0KPiBJbiBjYXNlIG9m
IG5vIG9iamVjdGlvbiB0aGlzIHNlcmllcyB3aWxsIGJlIGFwcGxpZWQgdG8gbWx4NS1uZXh0IHRy
ZWUNCj4gYW5kIHNlbnQgbGF0ZXIgYXMgcHVsbCByZXF1ZXN0IHRvIGJvdGggbmV0LW5leHQgYW5k
IHJkbWEtbmV4dCB0cmVlcywNCj4gd2l0aCB0aGUgY29ycmVzcG9uZGluZyBmZWF0dXJlcyBvbiB0
b3AuDQo+IA0KPiBUaGFua3MsDQo+IFNhZWVkLg0KPiANCj4gLS0tDQo+IA0KPiBBeWEgTGV2aW4g
KDEpOg0KPiAgIG5ldC9tbHg1OiBFeHBvc2UgcmVzb3VyY2UgZHVtcCByZWdpc3RlciBtYXBwaW5n
DQo+IA0KPiBFcmFuIEJlbiBFbGlzaGEgKDMpOg0KPiAgIG5ldC9tbHg1OiBBZGQgc3RydWN0dXJl
cyBsYXlvdXQgZm9yIG5ldyBNQ0FNIGFjY2VzcyByZWcgZ3JvdXBzDQo+ICAgbmV0L21seDU6IFJl
YWQgTUNBTSByZWdpc3RlciBncm91cHMgMSBhbmQgMg0KPiAgIG5ldC9tbHg1OiBBZGQgc3RydWN0
dXJlcyBhbmQgZGVmaW5lcyBmb3IgTUlSQyByZWdpc3Rlcg0KPiANCg0KVGhlIGZlYXR1cmVzIHdo
aWNoIG5lZWQgdGhlIGFib3ZlIHBhdGNoZXMgYXJlIHN0aWxsIHN0dWNrIGluIGludGVybmFsDQpy
ZXZpZXcsIGkgd2lsbCBwb3N0cG9uZSBtZXJnaW5nIHRoZXNlIHBhdGNoZXMgdGlsbCBuZXh0IGtl
cm5lbCByZWxlYXNlLg0KDQo+IExlb24gUm9tYW5vdnNreSAoMSk6DQo+ICAgbmV0L21seDU6IERv
bid0IHdyaXRlIHJlYWQtb25seSBmaWVsZHMgaW4gTU9ESUZZX0hDQV9WUE9SVF9DT05URVhUDQo+
ICAgICBjb21tYW5kDQoNClRoaXMgb25lIHdpbGwgYmUgc3VibWl0dGVkIHRocm91Z2ggYSBwdWxs
IHJlcXVlc3QgdG8gbmV0LW5leHQuDQoNClRoYW5rcywNClNhZWVkLg0K
