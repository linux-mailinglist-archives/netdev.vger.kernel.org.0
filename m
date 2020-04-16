Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2141AB5B2
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 04:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729105AbgDPB6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 21:58:41 -0400
Received: from mail-eopbgr50060.outbound.protection.outlook.com ([40.107.5.60]:7041
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728397AbgDPB6e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 21:58:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JAq0dt38IiOuZ5fUo4tVC88zaUWbYe1cq+5h5p3H1/NdHrazhPMxJwNgPPQbRgVxiDuBDv9KZQ1TJfPt9McM+pq2JNKF4YLolM7iVXlq3efDyErNY0lKEAAoSDRaMTVAyWSSVcpj+uPiWcQ1p3//lBPHbmJXwsuXkxHdUp81sFnDNLCu+qKyc8BSTiIB8VqHBJNe2MlHpOC7i8fQLlVQkmTMdB2q2zEoz6+fqKduQvjbVncNbkAZbbCRSoN5FvvrLpOI3M66fr2lERhIXnHQHpWEc1muUHaDlxO9z+2ll7hEgAz4R0hX8g1ujzymewOZLJ2bH6izOkdVzK3TP1nWng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uIfQSujFUZnE0VXH1h/Y1b9bxNSosfPgOTRfzypkSBo=;
 b=n8PJFcX/HPetrbrsXqJxJB1vXJ+uPtCjT3GfVO+/YLfmpGApoP+buuTV2kgdPzOJh0P2P/sv9iL5cHfECpHa4BRCCj9i2pZiZhfhPffzWQHx61/Pvhxe+MyBIpgjk5yn1eV6amBTsaA7BL2qfa3Udmmt7iizIswexyHDzlxWVwgQ11ahiIttQ8IMSZ1batVFGfIfIXrwW0VmRyKTOIe3JfUg97W98fmlHvU00/zXKuKtf/5XfGi84A00tUZkt2Kq4QTmQwPfqafqhZlTi1ojcxevUtYDFVsQUvksPcBaV/9/g8+vJF8OtiQ2log3Om4SMpcrxG+MhZeX7J8szVISNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uIfQSujFUZnE0VXH1h/Y1b9bxNSosfPgOTRfzypkSBo=;
 b=tXmDNkILWkNvVm8Jjq7AwywuO+puvZwZ0NosyrhnJFN8ynpME5tpX/ErQmMUU2WC69s/QFdEaVpzbx2E5W2sc2x97UmnAZf4keWNO0vHOD9o+cTzhZTqs6s0z/Id5I2Onvm4SUs5eegACGu5ioBH/GPD3XLZ+hERfhYLxHWykQk=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6862.eurprd05.prod.outlook.com (2603:10a6:800:18e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.26; Thu, 16 Apr
 2020 01:58:30 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2900.028; Thu, 16 Apr 2020
 01:58:30 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>
CC:     "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Signed-off-by missing for commits in the net-next
 tree
Thread-Topic: linux-next: Signed-off-by missing for commits in the net-next
 tree
Thread-Index: AQHV9sLlUkLYzArmsEq8vpUsvhtdFahCgcgAgDPfMwCABNaJgA==
Date:   Thu, 16 Apr 2020 01:58:30 +0000
Message-ID: <0f7e01568ecda727b75fd417865a72767258fd3b.camel@mellanox.com>
References: <20200310210130.04bd5e2f@canb.auug.org.au>
         <ace96f9842592c35458e970af900ec7a43029ae5.camel@mellanox.com>
         <20200413100534.057a688e@canb.auug.org.au>
In-Reply-To: <20200413100534.057a688e@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6b0bd75e-2efe-4008-ec17-08d7e1a9a986
x-ms-traffictypediagnostic: VI1PR05MB6862:
x-microsoft-antispam-prvs: <VI1PR05MB68624CFCA14CA876D0FB2420BED80@VI1PR05MB6862.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0375972289
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(6486002)(64756008)(2906002)(71200400001)(8676002)(6512007)(4326008)(6506007)(54906003)(36756003)(4744005)(81156014)(8936002)(316002)(5660300002)(76116006)(66476007)(91956017)(6916009)(2616005)(86362001)(66946007)(186003)(26005)(66556008)(478600001)(66446008);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2tILOHwXGJWN4rd/orfvr4NEbS7MYiLJgF+cScDPsc475sfoH0hnSKyvpRT7h5RE/DKJpNv1w1BfxYXEVbhgZj6O4CvqNPSfudKJ5n094jICVRM8eL57crReH6wOFDp7OEIcrE88sH2mIDQyekSOpfuA2s7vWYedksjpU+wdeb8gJ82xpQY2aYqpfQcCu5biqWXOczHNajvl00g+Ik23oOQIKSLFDIvOGU2+0iIP5OlQbCeXZbu9p/c2mvzDqn1amDWNcSExM30RhAO3S7G5gCpV8IC1gRI9KlNoHqIZb6gYIeVkEwk01FX98spNl/JEkls4gj5WhVlPeqOXw1GVymzOGbMaa/A4TwME+wB+u3Mam9g9hIQHs2/fzAZLY2Xq0MQO0iExBboU7fmR6BzNsZZc7c6Pl+kU648dDkxcQR6IfydmHJ5FCJ5GPg7AYj6U
x-ms-exchange-antispam-messagedata: IqU8NTC1z/dfY6kDDvmKi0/akyNt9T0MKkqE3v31FvE51BFwPxepnCxqu3KVgKc6ADCwobFjnKl4LCV86oaIc4qMOlwoyR3EeS3tP6liNmKURBsoTHuA8aQ/daq61+8vO35bVWzusRA6PSD8/X2ZTg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <D98E7EDA4C06524A89227587677DF3A7@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b0bd75e-2efe-4008-ec17-08d7e1a9a986
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2020 01:58:30.4429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tdY6VU6uTTTq3JeRTo19Zi245pswtmGb0l929kbAPadS4up1LnM4bm9i9+VhGJPYdvcyubRLE8hMEoEcr/65QQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6862
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTA0LTEzIGF0IDEwOjA1ICsxMDAwLCBTdGVwaGVuIFJvdGh3ZWxsIHdyb3Rl
Og0KPiBIaSBTYWVlZCwNCj4gDQo+IE9uIFR1ZSwgMTAgTWFyIDIwMjAgMjM6NTc6MzEgKzAwMDAg
U2FlZWQgTWFoYW1lZWQgPA0KPiBzYWVlZG1AbWVsbGFub3guY29tPiB3cm90ZToNCj4gPiBPbiBU
dWUsIDIwMjAtMDMtMTAgYXQgMjE6MDEgKzExMDAsIFN0ZXBoZW4gUm90aHdlbGwgd3JvdGU6DQo+
ID4gPiBIaSBhbGwsDQo+ID4gPiANCj4gPiA+IENvbW1pdHMNCj4gPiA+IA0KPiA+ID4gICBiNjMy
OTNlNzU5YTEgKCJuZXQvbWx4NWU6IFNob3cvc2V0IFJ4IG5ldHdvcmsgZmxvdw0KPiA+ID4gY2xh
c3NpZmljYXRpb24NCj4gPiA+IHJ1bGVzIG9uIHVsIHJlcCIpDQo+ID4gPiAgIDY3ODNlOGIyOWY2
MyAoIm5ldC9tbHg1ZTogSW5pdCBldGh0b29sIHN0ZWVyaW5nIGZvcg0KPiA+ID4gcmVwcmVzZW50
b3JzIikNCj4gPiA+ICAgMDEwMTNhZDM1NWQ2ICgibmV0L21seDVlOiBTaG93L3NldCBSeCBmbG93
IGluZGlyIHRhYmxlIGFuZCBSU1MNCj4gPiA+IGhhc2gNCj4gPiA+IGtleSBvbiB1bCByZXAiKQ0K
PiA+ID4gICANCj4gPiANCj4gPiBIaSBTdGVwaGVuLCANCj4gPiANCj4gPiBjaGVja3BhdGNoIGRv
ZXNuJ3Qgc2VlbSB0byBjYXRjaCBzdWNoIHByb2JsZW1zLi4gDQo+ID4gDQo+ID4gSSBjb3VudCBv
biBvdXIgQ0kgdG8gZG8gc3VjaCBjaGVja3MgZm9yIG1lLCBzbyBpbnN0ZWFkIG9mIG1lDQo+ID4g
d3JpdGluZyBhIA0KPiA+IG5ldyBzY3JpcHQgZXZlcnkgdGltZSB3ZSBoaXQgYSBuZXcgdW5mb3Jl
c2VlbiBpc3N1ZSwgaSB3YXMNCj4gPiB3b25kZXJpbmcNCj4gPiB3aGVyZSBjYW4gaSBmaW5kIHRo
ZSBzZXQgb2YgdGVzdC9zY3JpcHRzIHlvdSBhcmUgcnVubmluZyA/IA0KPiANCj4gSSBoYXZlIGF0
dGFjaGVkIG15IHNjcmlwdHMgLi4uDQo+IA0KDQpUaGFua3MgU3RlcGhlbiAhIG11Y2ggYXBwcmVj
aWF0ZWQuDQoNClNhZWVkLg0K
