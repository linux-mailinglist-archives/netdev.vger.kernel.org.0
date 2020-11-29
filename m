Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E78E52C7A0E
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 17:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgK2Qnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 11:43:41 -0500
Received: from mail-bn7nam10on2136.outbound.protection.outlook.com ([40.107.92.136]:62496
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725468AbgK2Qnk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Nov 2020 11:43:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GiuG6HbuulheH5VczQpQjosUU9N3JByHmyh+XgDLkKtZ+X65T27AaMnH7/d3miI8JanD3UzjN1KEjjVG2p4ummrIPvDOMTMkO64wI3jwTVo4yzS4Q2JK0kyjXAI5dBQ8snOFU/owNS8i/SZFl2hkWd95MXcbJ758OLW6ZCZaWO9BkTf/EfhHXhHG29HAHdznHEYk1tpEMJLi+4xTs9sq8qNof7f9CTVgnq15YGcwGIEBOa/wpObInaM4iQ7NqOFpPAdrsamX+GwDj380d8+/O6uus7MVl4blaGlxnQsWruGHOCtMhVywrW0GA92ntoNQVbREfhaBN0iJW9ltYwIPPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NG0KVunj880vyPNf6ikZjL0GkwjPWI2jN7kI/OMG66M=;
 b=FgoeblIA+xqVXD2dlwvpAH3DFlimDsn5/w+b4eAfX+Q4fifsHC9dn8cfUeWu1e+r1Oil9WMY5CuKSSf4ec0+Xon33jJo7JBHi/OVxxzEn+AIH2/lNirjrXLnUogeIrc2NIpYYnl0Nc82YuMDn7bJaLLB0j862Jc9l+mTbtV6RFI/uTBvF5jkLJfGdxc0wqMlTsDzZe8HZR/boTrvpML68KvvFVvRfZ3uW2fNPLurlErRHhLn2OQCap9kRqTNu2ri1kK33o5HXek2WvZrAliJ8U984udSRz12tlIGnF7gvvwrYLbReUzLruP4m2SqG48G/KCZRxgIKZHnXNPDKxU0LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NG0KVunj880vyPNf6ikZjL0GkwjPWI2jN7kI/OMG66M=;
 b=cMwv0hpbooRWGSFIj+pzJIYYnrHErmV2cNafDEqNOipyEl6goa5FGL6urxAqSYqnr/qooA7FfUTkOYQ6Q3V3d/M2cQxVCjO0pOc+oO8uf0D90w3roU6gZLVx0XIIOFLJvdZcYR7gAWZL8C3q896xlfCCMu6mPFLPOZ0JotQvcYs=
Received: from MN2PR13MB3957.namprd13.prod.outlook.com (2603:10b6:208:263::11)
 by MN2PR13MB2991.namprd13.prod.outlook.com (2603:10b6:208:154::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.8; Sun, 29 Nov
 2020 16:42:46 +0000
Received: from MN2PR13MB3957.namprd13.prod.outlook.com
 ([fe80::e989:f666:131a:e210]) by MN2PR13MB3957.namprd13.prod.outlook.com
 ([fe80::e989:f666:131a:e210%9]) with mapi id 15.20.3632.016; Sun, 29 Nov 2020
 16:42:46 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "bfields@fieldses.org" <bfields@fieldses.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "trix@redhat.com" <trix@redhat.com>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] NFS: remove trailing semicolon in macro definition
Thread-Topic: [PATCH] NFS: remove trailing semicolon in macro definition
Thread-Index: AQHWxPWbldOlJ73hwU20MDIpyx86PanfU2iA
Date:   Sun, 29 Nov 2020 16:42:46 +0000
Message-ID: <96657eff83195fba1762cb046b3f15d337e5daad.camel@hammerspace.com>
References: <20201127194325.2881566-1-trix@redhat.com>
In-Reply-To: <20201127194325.2881566-1-trix@redhat.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: fieldses.org; dkim=none (message not signed)
 header.d=none;fieldses.org; dmarc=none action=none
 header.from=hammerspace.com;
x-originating-ip: [68.36.133.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d571ca62-afdc-4819-6200-08d89485cd4a
x-ms-traffictypediagnostic: MN2PR13MB2991:
x-microsoft-antispam-prvs: <MN2PR13MB299178B6D846A0F3253E271CB8F60@MN2PR13MB2991.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9TM4tt8n/UK7sYYsOypyOI/kU4Sywucg3rbdLjLgSjSP9WPs2TECq4NtZc6JSAhdfY5E7FI0OATfvUBIMvOenrVPNolCq8U00vlvLe31G54OZQWBrNYpGPaB9UgGxxh5BfZ7sTeD+MvPnDk9McMWhpyPxG6BhUx211MRcrMQO/j8Uuw0V+0K/Zkp/5kKM49o/iSxXHnVsqmBB8HQ/65BspKptQNOg8OkFBlr79VPGL465v6/u87m6W+1GDBMEGFg6Nn1sV+rD1jfGxLvrlvG/l0P9hehorILlCAATe6GY+Ds42po2BoBWoCVecf0RasvLmlPhfRlN2OvsYcJg9u95A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR13MB3957.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(366004)(136003)(39830400003)(64756008)(66946007)(66476007)(66556008)(76116006)(36756003)(6506007)(86362001)(83380400001)(66446008)(5660300002)(71200400001)(91956017)(2616005)(4326008)(316002)(54906003)(6486002)(6512007)(110136005)(186003)(478600001)(4001150100001)(2906002)(8936002)(26005)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?cm9Fd3g3Q1EwVkFGcElJdnB1cVQrMmcvRnozVjF6QkNpYVZqdFE5Q3BXV2NR?=
 =?utf-8?B?c0E4aXV0V2ExU2lXbnJVTHFJcFhSVFpTczNFS1hKOTZPSXA1TlZFVlNZZnJL?=
 =?utf-8?B?bHhScXhvdWYvZ28xNDlyNElyRm9BQlp2cGlHUjliYkEwMnJNcTI0NjN2d2tk?=
 =?utf-8?B?S1RtS3NBaTBRWms5K3IxMFdBMUpYTitwaXNtMC9XOEJWQzdNQlUrbEtNcTE3?=
 =?utf-8?B?OVhac1FDRmNNZ0VyZWtidGw0K0YxUTBZU2dUU0ZVbzh1bE5TclRoVjlWSXRs?=
 =?utf-8?B?Y29VQlpOVHRTOEJaMWtpVWcrakt1M2pPcEMwK292T2VsKzZUQ3RMY2JjZzNF?=
 =?utf-8?B?bVRwT05SbGdCNzJGRTd1OFIxQXdaUGxTSFhOUmRpdUNPQ0FUekRPOEEwdkN0?=
 =?utf-8?B?VU5SU2QvQldzQ3F1NGJHNXA2NWRZMVVFbVBkK0ZhbG4wa1RzYUYyWm5MRk83?=
 =?utf-8?B?U1VXWThkcmFIeVM1N0hvQVFTUjhLelV3QW1HRVU3akJVRC9XWGRRWTlOOENv?=
 =?utf-8?B?Ynp5aVB6YWo3RE5wUDREaGdNSWtodTBhVzBYeVRBakdjR1ZOQjFubGFqODQv?=
 =?utf-8?B?emZUclE2UkQ4SmxabXZIV2xsWEUya0swTGhzVThJSUxja3REZkdPbGthYzZ3?=
 =?utf-8?B?R0tPd0c2cEg5OFMxWXJsSVgvNUtNTlBSaTJ4YWE2UmcycXQ1TWQrbmpqdC9E?=
 =?utf-8?B?MDBFam5nRjRrYlpBL2dSTEVLNnVRdERHL0RzS0FEbG1lWHAxR25oZ09NM1lw?=
 =?utf-8?B?MC9zOUp3Ukk3R3BkWmMzMzFjNG1SeHgwREJjVHZHdytJM1lQU0RlcUZFbkQy?=
 =?utf-8?B?SVZnSUplWmR5R2o1M1pKOXFSMVE5NERNNVN1Q2ppQlhack43WW1nMDJ4a3pE?=
 =?utf-8?B?aG0zYnVTZWxOL1NNOFZyR3NPdnVUY05maXcvSTIrcno4WllWR3dlN1BGRUVB?=
 =?utf-8?B?LzU4YkR6SXJTUHZFQXNNQW90OXd6Y2FEQmlnblQwaldReXZhNjdoNjUvWHFP?=
 =?utf-8?B?SlpIbnhQNlNveFBvZy9kZHV0MTkzTkZBWTljOXFkWGZpemFUQS9aVVhDR0NY?=
 =?utf-8?B?REI4TWFqZVBrb1ZIZkxsRkNXenl6MUZtOVpmb1g0Z3FxVjA1Z2VQYzNIbkx1?=
 =?utf-8?B?MTJUM0JtbGV3ellQM2lSTk4zUUVMRUFHSm9Cd3E3VjdhRTBnbHBvbWdDNDA0?=
 =?utf-8?B?M3hLZzRlTlBiTzU5V3hmTlZubjlXZUp3TmJ3S0Q0YjNTNXVBTGdWQkMzNnF4?=
 =?utf-8?B?TWpiMkU3aHJ0KzQyN0ZyVkU4NGdYbHpWRzd1cGVzNTNVYmVKcnc1aDBRbFBO?=
 =?utf-8?Q?wlKj7x/nmayA8Kslobqhh84Q1mjaoxS9hX?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <CDBE5E000C87184182F7F0756B238CF1@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR13MB3957.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d571ca62-afdc-4819-6200-08d89485cd4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2020 16:42:46.7615
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2LTks/ZqNkzQdu3SIGJ3xn0rtFSb5KRp3tKllSzrS3h6F4myotFmor+lZnx2c86opkQZwPkSc3/BKRM9GhczIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB2991
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVG9tLA0KDQpPbiBGcmksIDIwMjAtMTEtMjcgYXQgMTE6NDMgLTA4MDAsIHRyaXhAcmVkaGF0
LmNvbSB3cm90ZToNCj4gRnJvbTogVG9tIFJpeCA8dHJpeEByZWRoYXQuY29tPg0KPiANCj4gVGhl
IG1hY3JvIHVzZSB3aWxsIGFscmVhZHkgaGF2ZSBhIHNlbWljb2xvbi4NCj4gDQo+IFNpZ25lZC1v
ZmYtYnk6IFRvbSBSaXggPHRyaXhAcmVkaGF0LmNvbT4NCj4gLS0tDQo+IMKgbmV0L3N1bnJwYy9h
dXRoX2dzcy9nc3NfZ2VuZXJpY190b2tlbi5jIHwgMiArLQ0KPiDCoDEgZmlsZSBjaGFuZ2VkLCAx
IGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL25ldC9zdW5y
cGMvYXV0aF9nc3MvZ3NzX2dlbmVyaWNfdG9rZW4uYw0KPiBiL25ldC9zdW5ycGMvYXV0aF9nc3Mv
Z3NzX2dlbmVyaWNfdG9rZW4uYw0KPiBpbmRleCBmZTk3ZjMxMDY1MzYuLjlhZTIyZDc5NzM5MCAx
MDA2NDQNCj4gLS0tIGEvbmV0L3N1bnJwYy9hdXRoX2dzcy9nc3NfZ2VuZXJpY190b2tlbi5jDQo+
ICsrKyBiL25ldC9zdW5ycGMvYXV0aF9nc3MvZ3NzX2dlbmVyaWNfdG9rZW4uYw0KPiBAQCAtNDYs
NyArNDYsNyBAQA0KPiDCoC8qIFRXUklURV9TVFIgZnJvbSBnc3NhcGlQX2dlbmVyaWMuaCAqLw0K
PiDCoCNkZWZpbmUgVFdSSVRFX1NUUihwdHIsIHN0ciwgbGVuKSBcDQo+IMKgwqDCoMKgwqDCoMKg
wqBtZW1jcHkoKHB0ciksIChjaGFyICopIChzdHIpLCAobGVuKSk7IFwNCj4gLcKgwqDCoMKgwqDC
oMKgKHB0cikgKz0gKGxlbik7DQo+ICvCoMKgwqDCoMKgwqDCoChwdHIpICs9IChsZW4pDQo+IMKg
DQo+IMKgLyogWFhYWCB0aGlzIGNvZGUgY3VycmVudGx5IG1ha2VzIHRoZSBhc3N1bXB0aW9uIHRo
YXQgYSBtZWNoIG9pZA0KPiB3aWxsDQo+IMKgwqDCoCBuZXZlciBiZSBsb25nZXIgdGhhbiAxMjcg
Ynl0ZXMuwqAgVGhpcyBhc3N1bXB0aW9uIGlzIG5vdCBpbmhlcmVudA0KPiBpbg0KDQpUaGVyZSBp
cyBleGFjdGx5IDEgdXNlIG9mIHRoaXMgbWFjcm8gaW4gdGhlIGNvZGUgQUZBSUNTLiBDYW4gd2Ug
cGxlYXNlDQpqdXN0IGdldCByaWQgb2YgaXQsIGFuZCBtYWtlIHRoZSBjb2RlIHRyaXZpYWxseSBl
YXNpZXIgdG8gcmVhZD8NCg0KVGhhbmtzDQogIFRyb25kDQoNCi0tIA0KVHJvbmQgTXlrbGVidXN0
DQpMaW51eCBORlMgY2xpZW50IG1haW50YWluZXIsIEhhbW1lcnNwYWNlDQp0cm9uZC5teWtsZWJ1
c3RAaGFtbWVyc3BhY2UuY29tDQoNCg0K
