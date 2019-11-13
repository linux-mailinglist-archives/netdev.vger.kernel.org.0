Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6C7EFBB45
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 23:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfKMWCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 17:02:02 -0500
Received: from mail-eopbgr30040.outbound.protection.outlook.com ([40.107.3.40]:56069
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726162AbfKMWCC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 17:02:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lpdZzlQl4QoZvnOrXclKDnfLNUgZ8SLlRTFFZrrb+dHCdJtCFJs1EivT36ZZTE77cKSuKCYG7T86mB1/H0tD1+HAB8KV86rmeYGh1nUYY+35hcYe7gjf56XpqOJCeAv7xro8AgvxuIC6Vsch+TQP082eHJgGsRFIBUBmYeZD7NfQYhHZm4klPs3KjUNhzMQbBzVVX4Onue2D4mIs9+0mSO6icR863grudR5eync++NkzRjOpCTN1nNIZKPzSCp8NPPIJBSxCx+bvV162pqcZkjbEiSMI1MzoefpDFVlCQPZvHG8ihIow5ju7gPY8J+fG5ausOtuu5UGVdIYtJokcpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ROkPFRwVz4d4fwvmDSItsRbv6DFdUFbSE7WABlgPVis=;
 b=Z6nmrOUPOF8mJwxjE+PiQXMaMoIJHYSMJj0PmkJOT6ioMbxcvbsfseY5VDWtPdPtzlm76lGwHgbA+hu6YuJ2bvhmb0g085sePBIs5CEPuaqBUUEXeSK1zspvDckdBgofGp7qHaksI8m50BIjykyTRbADei2eKE4PMceqyz0UtzJ2P23GCLXASV3W24xg4SOtXg93JfgCn31TFSZeh8FThYFV6sxIduqS+TD70xC1MuPMQgB6YbgZ7A+1uigPkdlNmibaB/8EvZG+VmxCqxQ41mrS/1FmwbGEwvRV6wkh6I21xBOyVdI26cR/0UtLI7FY3sFcLu89tnhsMLdmkM4W2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ROkPFRwVz4d4fwvmDSItsRbv6DFdUFbSE7WABlgPVis=;
 b=ApAEfn6VjX/2ZaVtXRxjart7gFjD9KSl0WWTBIo7/JvbQmU4o6KaCF365V0Vbo+d/E11WUuayC/yHQJKplGZq2Z4k9X4x6VoWcFojyjLf/Ofy4SgR0XlP9L/acP+OR67mG+s4Wk0Ck6zEZ+3AWv9xnAw3GRvy9Yy+qP+EAUpObQ=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5967.eurprd05.prod.outlook.com (20.178.127.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 13 Nov 2019 22:01:58 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2430.028; Wed, 13 Nov 2019
 22:01:58 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "pablo@netfilter.org" <pablo@netfilter.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 0/7] netfilter flowtable hardware offload
 support
Thread-Topic: [PATCH mlx5-next 0/7] netfilter flowtable hardware offload
 support
Thread-Index: AQHVmOiXJ5EaByu6vkSsp4vWgFxhbKeJqhwA
Date:   Wed, 13 Nov 2019 22:01:58 +0000
Message-ID: <9b0e071a9272ddfc95d9af181a6d2f564358859d.camel@mellanox.com>
References: <20191111233430.25120-1-pablo@netfilter.org>
In-Reply-To: <20191111233430.25120-1-pablo@netfilter.org>
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
x-ms-office365-filtering-correlation-id: 3e727c33-f93a-46a3-dc3d-08d768851ac0
x-ms-traffictypediagnostic: VI1PR05MB5967:
x-microsoft-antispam-prvs: <VI1PR05MB5967CA3C354F083A42555C38BE760@VI1PR05MB5967.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(136003)(366004)(346002)(396003)(199004)(189003)(81156014)(81166006)(8936002)(66446008)(3846002)(316002)(305945005)(6486002)(6436002)(6512007)(6116002)(6916009)(2906002)(8676002)(5640700003)(1730700003)(76116006)(99286004)(91956017)(5660300002)(256004)(14444005)(36756003)(66946007)(64756008)(4326008)(71200400001)(71190400001)(58126008)(86362001)(54906003)(66476007)(66556008)(4744005)(478600001)(4001150100001)(66066001)(102836004)(14454004)(76176011)(118296001)(229853002)(7736002)(25786009)(26005)(2616005)(476003)(446003)(6246003)(186003)(2351001)(6506007)(11346002)(2501003)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5967;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DDRwvuQMLM+uAs/UKd+fXkLa2+lukUNjSWI4QmbM5Ir08NQYJ3FDIWgoqxLL+Egz2fSdGRC+kKOw+InYbIXOKzj8LZa5l7iWmbDl6KAl9qqtp8mIlk+NOE/pZ54+LdC10OlPepe+CNoXM0hQYYr9TVtlOxTm6vBof408hKVJWFABl7RRBn4xqOk9DakS6GLU8uGn3cvRs0PZS/IPhZjhcklkXsS1SafQJuFb/MAz7ojnkN+Dwu+EwRuk5Kd33vXA35MOdM9FRUra3tzyA2zApzxCGo5PiuP+ri7eE5xVu01k+ORCBr3dPxdzaOyjcNn85bbz/kRq+aTy+JVJCijXSxBY74LEO6AAhOqLMCnS2yZyeTPmJprc4bfBEpAUa6IfJDF/Q/LyZu2ncIAKeeiffKiN6GSe/4YrxvlgICQQJbRJiKzbBHtZzklxWBXqKWzd
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <6AC50F883ED3E84A8E713137E5299544@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e727c33-f93a-46a3-dc3d-08d768851ac0
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 22:01:58.3311
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a7hnH5qwamyxBq1hK+ymfhOu4OS+DUAi4pf+tS7mNbgbXptkUZUlzrEccAwKtGLKpMbOyiqqMmyURB6mvr/+ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5967
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTExLTEyIGF0IDAwOjM0ICswMTAwLCBQYWJsbyBOZWlyYSBBeXVzbyB3cm90
ZToNCj4gSGkgU2FlZWQsDQo+IA0KPiBUaGlzIHBhdGNoc2V0IHVwZGF0ZXMgdGhlIG1seDUgZHJp
dmVyIHRvIHN1cHBvcnQgZm9yIHRoZSBuZXRmaWx0ZXINCj4gZmxvd3RhYmxlIGhhcmR3YXJlIG9m
ZmxvYWQgZnJvbSBQYXVsIEJsYWtleS4NCj4gDQo+IFBsZWFzZSByZXZpZXcgYW5kIGFwcGx5IGlm
IHlvdSdyZSBmaW5lIHdpdGggdGhpcy4NCj4gDQo+IFRoYW5rIHlvdS4NCj4gDQo+IFBhdWwgQmxh
a2V5ICg3KToNCj4gICBuZXQvbWx4NTogU2ltcGxpZnkgZmRiIGNoYWluIGFuZCBwcmlvIGVzd2l0
Y2ggZGVmaW5lcw0KPiAgIG5ldC9tbHg1OiBSZW5hbWUgRkRCXyogdGMgcmVsYXRlZCBkZWZpbmVz
IHRvIEZEQl9UQ18qIGRlZmluZXMNCj4gICBuZXQvbWx4NTogRGVmaW5lIGZkYiB0YyBsZXZlbHMg
cGVyIHByaW8NCj4gICBuZXQvbWx4NTogQWNjdW11bGF0ZSBsZXZlbHMgZm9yIGNoYWlucyBwcmlv
IG5hbWVzcGFjZXMNCj4gICBuZXQvbWx4NTogUmVmYWN0b3IgY3JlYXRpbmcgZmFzdCBwYXRoIHBy
aW8gY2hhaW5zDQo+ICAgbmV0L21seDU6IEFkZCBuZXcgY2hhaW4gZm9yIG5ldGZpbHRlciBmbG93
IHRhYmxlIG9mZmxvYWQNCj4gICBuZXQvbWx4NTogVEM6IE9mZmxvYWQgZmxvdyB0YWJsZSBydWxl
cw0KPiANCg0KcGF0Y2hlcyAjMS4uIzYgYXBwbGllZCB0byBtbHg1LW5leHQuDQpwYXRjaCAjNyB3
aWxsIGJlIHJlLXN1Ym1pdHRlZCBvbiB0b3Agb2YgbmV0LW5leHQgd2hlbiBtbHg1LW5leHQgZ2V0
cw0KbWVyZ2VkIG9uIG15IG5leHQgcHVsbCByZXF1ZXN0Lg0KDQpUaGFua3MsDQpTYWVlZC4NCg0K
