Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37E43275D2
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 07:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbfEWF5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 01:57:15 -0400
Received: from mail-eopbgr00075.outbound.protection.outlook.com ([40.107.0.75]:7139
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725873AbfEWF5O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 01:57:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fmZLeXbawgcNxzQ5vvGNnZ7HRyiUWjG4I/Hwo7GC6VY=;
 b=jVZuMVAt2rOLBzk26VWRWUmJrjxj4WdqHQdQlUQG8HnodRwwm0mOXMzM6ClEQkna08v1LV30flcw4MYSv9TDmeHdunN8nts9pmY3rUAZR4EtCF87zBqo8595a23tcN4JxIpVenThNCY9PNoOFRtyOLAx9gVE3ARpVRo4YCy/y8k=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5930.eurprd05.prod.outlook.com (20.179.12.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Thu, 23 May 2019 05:57:11 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab%7]) with mapi id 15.20.1922.013; Thu, 23 May 2019
 05:57:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: LPC networking track?
Thread-Topic: LPC networking track?
Thread-Index: AQHVELyOxOqsF40Es0G0eO6sZsBYT6Z3YWuAgADV04A=
Date:   Thu, 23 May 2019 05:57:11 +0000
Message-ID: <37331f01535660bc306f3b82318c2a948e454fec.camel@mellanox.com>
References: <20190522093644.00004ef2@intel.com>
         <20190522.101151.21157392017235106.davem@davemloft.net>
In-Reply-To: <20190522.101151.21157392017235106.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.2 (3.32.2-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ce83634-cae6-4b30-a7d6-08d6df437f5b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB5930;
x-ms-traffictypediagnostic: DB8PR05MB5930:
x-microsoft-antispam-prvs: <DB8PR05MB5930A86CA1364562E1C82230BE010@DB8PR05MB5930.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(39860400002)(136003)(376002)(346002)(199004)(189003)(3480700005)(6116002)(6486002)(6512007)(229853002)(3846002)(5660300002)(118296001)(446003)(86362001)(11346002)(486006)(2906002)(53936002)(6436002)(7116003)(2616005)(476003)(2501003)(186003)(26005)(25786009)(7736002)(305945005)(478600001)(6246003)(4326008)(316002)(6506007)(76116006)(81156014)(14454004)(8676002)(66946007)(73956011)(91956017)(99286004)(66066001)(8936002)(14444005)(256004)(81166006)(36756003)(110136005)(66476007)(58126008)(66556008)(102836004)(68736007)(4744005)(66446008)(64756008)(76176011)(71200400001)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5930;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5rc0NDyeoEO+VulpyIPQvXsSHqFxvFSUjqQRQXjPoRCVJiOx10GB0dCeUBlnRNemuqYU7za3gOcV1IuOuIotzYqZo8//IFFhtI7wa1k/Wrzri6doWm54z7rix/Mb4/GbHW/vEfwH899tFSAmxAQD5EZhiqTIaj+3oA8v/ypBgXYJSJVz4g1G6Y5tToF2LV1NFXmiZCdxc+bk/QB33m0TfTiBs+z71NTLbzKdd+qJCqpevzIF2RMjsSbBVjd/DZ5Eoo3cf9rpRLd/OPslTH3G2odUfPWr/Y1QV90hrONgVOIvSY+TNYqEUQzxvQoaeH4mmBDUMweoCpQy1mIz/Eg9Ndjse0OHKqxTkLcdHmY0sOdgKYeefoLg0sgyy6b5ZuxKudM4N1hjebG72nBP41Z1X/6rSuYZj0KGLR9GpbIInsE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2DA18A49AE3DDF46ADEE82604A4F2FC9@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ce83634-cae6-4b30-a7d6-08d6df437f5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 05:57:11.0300
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5930
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTA1LTIyIGF0IDEwOjExIC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IEplc3NlIEJyYW5kZWJ1cmcgPGplc3NlLmJyYW5kZWJ1cmdAaW50ZWwuY29tPg0KPiBE
YXRlOiBXZWQsIDIyIE1heSAyMDE5IDA5OjM2OjQ0IC0wNzAwDQo+IA0KPiA+IEhpLCBpcyB0aGVy
ZSBhbnkgdXBkYXRlIG9uIHRoZSBwbGFuIGZvciB0aGUgbmV0d29ya2luZyB0cmFjayBhdA0KPiA+
IFBsdW1iZXJzIChMUEMpIGluIExpc2JvbiB0aGlzIHllYXI/ICBMYXN0IHllYXIgdGhlcmUgd2Fz
IGEgQ0ZQLCBidXQNCj4gPiBpZg0KPiA+IHRoZXJlIHdhcyBvbmUgdGhpcyB5ZWFyIEkgY2FuJ3Qg
ZmluZCBhbnkgbWVudGlvbiBvciBkZXRhaWxzLg0KPiANCj4gV2UgYXJlIGFzc2VtYmxpbmcgdGhl
IHRlY2ggY29tbWl0dGVlIGFzIEkgdHlwZSB0aGlzIGFuZCB3ZSdsbCBzZW5kDQo+IG91dA0KPiBh
IENGUCBhcyBzb29uIGFzIHRoYXQgaXMgdGFrZW4gY2FyZSBvZi4NCg0KSSBzZWUgdGhhdCB0aGVy
ZSBpcyBhbHJlYWR5IGxwYy1icGYgbWljcm8gY29uZi4uIGRvZXMgdGhpcyBtZWFuIGFsbCBYRFAN
CnJlbGF0ZWQgdGFsa3Mgc2hvdWxkIGdvIHRvIHRoZSBscGMtYnBmID8gd2hhdCB3aWxsIGJlIGxl
ZnQgZm9yIG5ldGRldg0KdGhlbiA/IDstKQ0KSSB2b3RlIHRvIGluY2x1ZGUgeGRwIHRhbGtzIGlu
IHRoZSBuZXR3b3JraW5nIHRyYWNrLi4gDQo=
