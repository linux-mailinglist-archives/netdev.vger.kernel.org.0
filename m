Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8DD1CC554
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 01:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbgEIXnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 19:43:14 -0400
Received: from mail-eopbgr60042.outbound.protection.outlook.com ([40.107.6.42]:20904
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726356AbgEIXnO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 19:43:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F8FdVNqP1iB2W3HN6gnrnXsKD+FffMNqqBpqh14n/ngZyBctdTM0Xf7WEfwtcBQAwihRODSEZknpkVJQuyvkXjnC4EI94VCzLSYDXkifaT0Y5Eu9eOBUQN+v/MMar6/NXaZZAkVzRA0o21YARaovVVC8p6tDLWf7tAkAMcLU010/M2WM9s8g2ocwDBx4z/VIgEbZcRFaSTPaAqyOy0JDTqv8+6082f116s97Z4tiuo5XLUzhdCJfyU+voa6J9vizwNrWuSlCbU0WSQG1eu99oq5lnzfpD4nlsJKEvQllx8LUt6kJKfFi7GOFAFRwZlvcKJbImdZYUjGrPTsskpM6BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pgYq6KM/P6IuNVr6mVZca5TaGpQXZFsn+CkVj+vPooY=;
 b=SQq5zTTow4QofblKBI5ZqJiJLTcVhoYgdMG/2mAhqMsnhiFUTXNQaSw1cESMRM0BBaQK3mNBM/dbAvFdIdvtkbllYf7Gv1ID2WmwPleClsxl1C/wIYWQ28WE4W0yf2MRpMaylf7eZnnG9lmvT/kHs0rGSwu4ZWi0p9yfNgcB6TBgLVUg39Uxh0/vmv5kb697o4YiqkdxkkSoTvdNX9xnAh+vniEa9S9YtUsxwT6bat5hHZbiXfA/LIlchnZjEax+C/oklPAeyFb+JnARvz8XLRZbz2ZRWOLFrnzZFZ1scVoRqYGrkFwvwQ3vQqnVSZcG1nkkgJ2tS1SCOtO+y2NMrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pgYq6KM/P6IuNVr6mVZca5TaGpQXZFsn+CkVj+vPooY=;
 b=MDAMVoXLNjFr47D74KB9FCV3ezB87Qkw32tMSNGKoHHip51pY3U0oNcEoVs1koN+14H9Rl8cVjssrKTn5hmLk2yIQQ3iFqT7FLwyRP7OBG2oK5KtrtkzedaBEDBhZvHVAOs96PLBOnR4hI7ioX30208oSiXeLRQ7620R6o+hFiw=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5054.eurprd05.prod.outlook.com (2603:10a6:803:56::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.33; Sat, 9 May
 2020 23:43:08 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2979.033; Sat, 9 May 2020
 23:43:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5: Replace zero-length array with flexible-array
Thread-Topic: [PATCH] net/mlx5: Replace zero-length array with flexible-array
Thread-Index: AQHWJKEJ3r6Bytxqlka8je+nQhb84qie2csAgAGUHQA=
Date:   Sat, 9 May 2020 23:43:08 +0000
Message-ID: <fb46eb601f979d5d8d95ec5749ae06c1bc86d469.camel@mellanox.com>
References: <20200507185935.GA15169@embeddedor>
         <20200508163642.273bda4f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200508163642.273bda4f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0ac06079-b72e-4615-6797-08d7f472ba2f
x-ms-traffictypediagnostic: VI1PR05MB5054:|VI1PR05MB5054:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB50542DA71CF84EC5D574929ABEA30@VI1PR05MB5054.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 03982FDC1D
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w38BkahU1nTzhmEe3sJAU+ej2Vl8JHvISOwNv1yjg0q57kyqYdJust6zTZxc62QDJZkP/unVnyvc/Kts1iRjwVncbdnH9is6MLDNMQrZBw5s57Qyv89BCrS9MkLKowzBoia26qpu6gfwTdA/bWdh56bxKEt0HBAJEQ1ylepgLVqmGOGgY3w8+Y4tDMug/rbfZ4ffcImi5YMkCFhCBaWN+bojISZ0brpAZ7pph+LexuFDqyrnxh9xVKKoPVo+qB+yGtFq/Sr8/0Omr7jwq99tX5lmuk5e3zmA2fB6wamj+XkLnzmYCMSt2pJWak17n7I9rsnLj0Eea92PhTFoGjNO/CxomUPkhkqMPNGYBtdmD5H820OA4XJUBm55pJKcF3j6si052nDh66l0jyt1RHgmvA5d+JvaF9Ourft4IGOyLvrzYqaNBlpA1oakGFBMekEVBlMW6BKS95/bfNFs3E7FhRVwLMtiGS8ieHfRJ3YfsBFXg133OZgvYhOXp6PJfkWtbXxEAMCt/Q/MGkIn9J7wIg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39850400004)(396003)(376002)(136003)(366004)(346002)(33430700001)(2906002)(6916009)(478600001)(6512007)(33440700001)(26005)(186003)(2616005)(91956017)(76116006)(6506007)(71200400001)(86362001)(4326008)(36756003)(54906003)(316002)(64756008)(66446008)(66946007)(66476007)(66556008)(6486002)(8676002)(4744005)(8936002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: cric7TTxQ3wnnbnE9cpabFn/ar4kxpVWbgCaNmFvEKE1efyufLT3IZLnB+EOLM2O64rBjOZ3DK7mFWVcOaAjLO5fjQQGFWcpoLt7G2Qawh4knJKzw/s1YFqK54FA9RTesUpNaW6lKX/d82MDlxiSaGaoqrlBF6BUY6zw9RjzPTBQtcaUcAgQZCmLHWwcPN/uiQ98q+NmrWSNOeGpIFmuEi04AlIZduZkzWmfj2sPjlFxuz/HeLO42A1BYcqfUPxs5oxFLW6FqjUW6G2aNocMB6HNe7G7RmuYpu3RdY95gIhIxJwB6qIRtlzlhQaBTFN8RwZV129QbRvdOXTpZTv3iqpNpNPmSGOAw88OGr2CGygHoSjq2pMjHhLfZvAU4E1OodzxIdmhh1jFw3T/hEcUMLKmGzr+yZ3XxK/PQ+rD6fZ4EHmOhRCqRpz94uhuUOCpw85hsuJN0ThPfIX2KrT8BSNLMztAmLWT4JZqJEjqpzA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A4B4BA085BE3AE4F9963737F65FF4EB9@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ac06079-b72e-4615-6797-08d7f472ba2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2020 23:43:08.1503
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IiLPdcM258buc4gLgg7KUwUe9FT1BUffzLn2TpKKrFlXPqcwSMsme95dblOqz5VsMDwQgr7eJInFf3nsSA+E3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5054
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA1LTA4IGF0IDE2OjM2IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LCA3IE1heSAyMDIwIDEzOjU5OjM1IC0wNTAwIEd1c3Rhdm8gQS4gUi4gU2lsdmEg
d3JvdGU6DQo+ID4gVGhlIGN1cnJlbnQgY29kZWJhc2UgbWFrZXMgdXNlIG9mIHRoZSB6ZXJvLWxl
bmd0aCBhcnJheSBsYW5ndWFnZQ0KPiA+IGV4dGVuc2lvbiB0byB0aGUgQzkwIHN0YW5kYXJkLCBi
dXQgdGhlIHByZWZlcnJlZCBtZWNoYW5pc20gdG8NCj4gPiBkZWNsYXJlDQo+ID4gdmFyaWFibGUt
bGVuZ3RoIHR5cGVzIHN1Y2ggYXMgdGhlc2Ugb25lcyBpcyBhIGZsZXhpYmxlIGFycmF5DQo+ID4g
bWVtYmVyWzFdWzJdLA0KPiA+IGludHJvZHVjZWQgaW4gQzk5Og0KPiA+IA0KPiA+IHN0cnVjdCBm
b28gew0KPiA+ICAgICAgICAgaW50IHN0dWZmOw0KPiA+ICAgICAgICAgc3RydWN0IGJvbyBhcnJh
eVtdOw0KPiA+IH07DQo+IA0KPiBTYWVlZCwgSSdtIGV4cGVjdGluZyB5b3UgdG8gdGFrZSB0aGlz
IGFuZCB0aGUgbWx4NCBwYXRjaCB2aWEgeW91cg0KPiB0cmVlcy4NCg0KWWVzIGZvciB0aGUgbWx4
NSBwYXRjaCwgYnV0IHVzdWFsbHkgRGF2ZSB0YWtlcyBtbHg0IHBhdGNoZXMgZGlyZWN0bHkuDQoN
CnNpbmNlIHRoZSB2b2x1bWUgb2YgbWx4NCBwYXRjaGVzIGlzIHZlcnkgc21hbGwsIGxldCdzIGFw
cGx5IHRoZW0NCmRpcmVjdGx5IHRvIG5ldC1uZXh0LCB1bmxlc3MgeW91IHdhbnQgbWUgdG8gaGFu
ZGxlIHRoZW0gZnJvbSBub3cgb24gYW5kDQptYWtlIHlvdXIgbGlmZSBlYXNpZXIsIHRoZW4gaSBk
b24ndCBoYXZlIGFueSBpc3N1ZSB3aXRoIHRoYXQuDQoNClNhZWVkLg0KDQoNCg==
