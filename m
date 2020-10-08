Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED5B287B41
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 19:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729665AbgJHRzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 13:55:20 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:19621 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730112AbgJHRzN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 13:55:13 -0400
Received: from HKMAIL103.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7f527e0004>; Fri, 09 Oct 2020 01:55:10 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 8 Oct
 2020 17:55:10 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 8 Oct 2020 17:55:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QC8LabGoWH6fGKRP+k8ymOK96tEq1paY3PMa2zAh1kONsMJ7qfrM7GleXB4O6FqnTnzelPnY6DtRp6OVVt5cH7fw7BaV3g8hjlR8yFPAmQZgXHRcBo92Wvki0DXdmpTBQUUgSe1bzoIZyuOlcG/nVY51/pJ7u5BJestXpOeLqpzndGgj86wFpNDVODxIqvqCEISJ0CRLb8ofo0snB1KRihQ0pfOrPcaCdjrihTut8T8k+fPwc5tARecu/H4aKo3K/76i+dJ8Yil0ymfmay6lalsYOaeu3Mp6lsgtCUgTM3j7kArDmdcQkgQnej4CP+zLmB48wJ/ct5U3PaWjuBwLPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mbd8mTHSWEsXWlezFORpjy2Fdh3v90dlI9gbl+Trhxs=;
 b=dcYKWeEjRE4K5VJokVfdkYoGg+sFF85K0BJvvuDR0eNuWpb0EDS2JPI8JndNc9QoNiV9su8kaETDMTBbr3Ni7mQWmJBh2TBjSYsBqtuBsF3REmMCb64njm/cuvlSGf4tV2aqeyBYbbk9ON47mzeTsYRtkjpT/h/Aav9qNhSpKTMV+7x0LEeKTDRzZlM/4BJ+NNqROecp8Ggr7vih8QZ+ba+CmqNSocAVHvOF98s4vaLJEuW98mJTC6DRcAPg5kWxDb2af8YMfsVcjAGIyuz+ub4GKLDA9fXhKtlUKjIn/TV62twX7oSxsXlhJ1oBLTFnNq6NfXpsE9/mQXWxm1SLUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com (2603:10b6:3:e3::23)
 by DM6PR12MB3676.namprd12.prod.outlook.com (2603:10b6:5:1c7::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Thu, 8 Oct
 2020 17:54:41 +0000
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62]) by DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62%9]) with mapi id 15.20.3455.024; Thu, 8 Oct 2020
 17:54:40 +0000
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "henrik.bjoernlund@microchip.com" <henrik.bjoernlund@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net] bridge: Netlink interface fix.
Thread-Topic: [PATCH net] bridge: Netlink interface fix.
Thread-Index: AQHWnKKpyTxrd+oPIUur9lgPN8/sf6mMOMkAgAFGlACAAHLvAIAADJ2A
Date:   Thu, 8 Oct 2020 17:54:40 +0000
Message-ID: <a7a0f63afdcd30ec89692781b5804d0cb28e7ee8.camel@nvidia.com>
References: <20201007120700.2152699-1-henrik.bjoernlund@microchip.com>
         <32183f25a3d7ee8c148db42fbed9dd2a6e0a1f92.camel@nvidia.com>
         <585c251204d3c09150e9fcb60f560c599567688a.camel@nvidia.com>
         <20201008100930.1e5fca41@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201008100930.1e5fca41@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Reply-To: Nikolay Aleksandrov <nikolay@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [84.238.136.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ada921fd-f31b-40f7-8207-08d86bb33b36
x-ms-traffictypediagnostic: DM6PR12MB3676:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3676783F25B5BD1E4CBF1DF1DF0B0@DM6PR12MB3676.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 46tT82Mm0xsW8wyeXWlMMcgqw37adk8YyVXGaDsxsGVWwi+qGQI/bXaB3H1ucIr1OiESC3e2G+MhHakVY9r7cmhJ6RQrzoKeZIboMP30ZdwV903fZyLqegjvi8zNGXjKyCsOnORY7dlqQb2tpac4uIlJR/wNP3RCx/44+qKJujyo4awD9cBTIlkBBe0HA9lHHelSdX98Ue86TyvTqVHqJAEJTxOvi5IYC/db7mIXe9OAZdJhPZj68r9eZTUJ5/7kYhhCQa+bpNp9TGdtdn3gHhcXUfE/9+HhmPjNm5rkwqkzPC9XZCRWHAgwQ0JcVu/pyBgeEYFRQFKuG4bJlnsweQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0010.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(396003)(136003)(346002)(6506007)(316002)(4326008)(76116006)(6486002)(478600001)(54906003)(6916009)(91956017)(71200400001)(36756003)(64756008)(66446008)(83380400001)(8676002)(2616005)(66556008)(66946007)(66476007)(2906002)(26005)(3450700001)(186003)(86362001)(5660300002)(6512007)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 21yuos7KE6tWnACXgHuMgoVXBVpOme7v/nKzTFxz0Blr7ngPnnsOLPkWYVrJFNQgqGBWcMPomLVgjkF0fRk3YMecLOtx1fThyEueH+UuUr/dC3D4dgvLXOdZUnQtOZQCYYzSneO00CW/x3plGU/km5tilLpidons0VaRkRJpXJeiy/dqZ0X4yw+XUF8+8a6XsIZBAzj1wHPGA18l0iZbgcvkFvVATy2ME7SL1lZUsdfAI78q00FLJtklNFonxs2Y/QWZ9rsD8aG5W31lE7yh6q55HvCEqdHBSygekBZfOqFyVPRIqcFeJMRdTlAid9sCLYlIwEaJ0wePFHIfKUUhkFDIMykTuEn6M1oBiKNeNANKHtX4gWkLqDMJzGDMvM32GHg1rG608ljzEipc5WQwBNPzCPiK4MjE4NXCt2QNRQOogjW2g59wod/4CBW+ptnerCPm1GHgIajohZM8zTamGXjcRZBv0oO57VHM8/evzuuNsNd/iXfSYHcQJWXi8Thmy8atOVWu8v1aE1oTivBVWCw/xtX2kiQSrCacYzEWF6AdAufHZobyC2UIh0P7lWX1NcglUjaVTnSwnvE/iJF94rxVnoE+s1ZTJzfuoEdEnsX4HZjX5CqlJEXOaw+R50aS7GZJbIztqzpYgXW1oO7xnA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E2017FD1D522346A6A26A05E87301B3@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0010.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ada921fd-f31b-40f7-8207-08d86bb33b36
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2020 17:54:40.8181
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KNU7N43gPil589+ybsNAHKi5KyIc6LIQs6mi5RoHjqbw/PCzjjWnzgg5IZvq0H7+iId8MbaDgRHP5hP23Vh/5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3676
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602179710; bh=mbd8mTHSWEsXWlezFORpjy2Fdh3v90dlI9gbl+Trhxs=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Reply-To:Accept-Language:Content-Language:
         X-MS-Has-Attach:X-MS-TNEF-Correlator:user-agent:
         authentication-results:x-originating-ip:x-ms-publictraffictype:
         x-ms-office365-filtering-correlation-id:x-ms-traffictypediagnostic:
         x-ms-exchange-transport-forked:x-microsoft-antispam-prvs:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         Content-Type:Content-ID:Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=Fp7qktllAmY8p3heE1yWQgkFsneOoWNTcwpOIUnmWWTMPAxNGcYecj+RFK7mDmW0E
         aAk3c28/MBL4h+OqoTsDtUOqKvtmCJ+J4GeQaIphg4T1FJ2w41bEjneECty3vpuq68
         HYJ7KRrBAlNF/WKL/2pa5KUKkZmOznKE7eQ7/dbKPcbq+u3OCjd+jCP7rtxWgpzzQz
         Bm/diEmw5ZIZ0n79fE3+/ud47r6jymuR91e0n+ihbxj9QXVYeFSK8F5BVVH+scsC7F
         sxRb89olr5dBwrKMvsDrcPxZbYAN24LVKgUKpv0j7ZwUzzOFCRvF0e7MQkU0htrwtQ
         RoYMFjNIw7ajQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTEwLTA4IGF0IDEwOjA5IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LCA4IE9jdCAyMDIwIDEwOjE4OjA5ICswMDAwIE5pa29sYXkgQWxla3NhbmRyb3Yg
d3JvdGU6DQo+ID4gT24gV2VkLCAyMDIwLTEwLTA3IGF0IDE0OjQ5ICswMDAwLCBOaWtvbGF5IEFs
ZWtzYW5kcm92IHdyb3RlOg0KPiA+ID4gT24gV2VkLCAyMDIwLTEwLTA3IGF0IDEyOjA3ICswMDAw
LCBIZW5yaWsgQmpvZXJubHVuZCB3cm90ZTogIA0KPiA+ID4gPiBUaGlzIGNvbW1pdCBpcyBjb3Jy
ZWN0aW5nIE5FVExJTksgYnJfZmlsbF9pZmluZm8oKSB0byBiZSBhYmxlIHRvDQo+ID4gPiA+IGhh
bmRsZSAnZmlsdGVyX21hc2snIHdpdGggbXVsdGlwbGUgZmxhZ3MgYXNzZXJ0ZWQuDQo+ID4gPiA+
IA0KPiA+ID4gPiBGaXhlczogMzZhOGU4ZTI2NTQyMCAoImJyaWRnZTogRXh0ZW5kIGJyX2ZpbGxf
aWZpbmZvIHRvIHJldHVybiBNUFIgc3RhdHVzIikNCj4gPiA+ID4gDQo+ID4gPiA+IFNpZ25lZC1v
ZmYtYnk6IEhlbnJpayBCam9lcm5sdW5kIDxoZW5yaWsuYmpvZXJubHVuZEBtaWNyb2NoaXAuY29t
Pg0KPiA+ID4gPiBSZXZpZXdlZC1ieTogSG9yYXRpdSBWdWx0dXIgPGhvcmF0aXUudnVsdHVyQG1p
Y3JvY2hpcC5jb20+DQo+ID4gPiA+IFN1Z2dlc3RlZC1ieTogTmlrb2xheSBBbGVrc2FuZHJvdiA8
bmlrb2xheUBudmlkaWEuY29tPg0KPiA+ID4gPiBUZXN0ZWQtYnk6IEhvcmF0aXUgVnVsdHVyIDxo
b3JhdGl1LnZ1bHR1ckBtaWNyb2NoaXAuY29tPg0KPiA+ID4gPiAtLS0NCj4gPiA+ID4gIG5ldC9i
cmlkZ2UvYnJfbmV0bGluay5jIHwgMjYgKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0NCj4gPiA+
ID4gIDEgZmlsZSBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspLCAxNSBkZWxldGlvbnMoLSkNCj4g
PiA+ID4gICANCj4gPiA+IA0KPiA+ID4gVGhlIHBhdGNoIGxvb2tzIGdvb2QsIHBsZWFzZSBkb24n
dCBzZXBhcmF0ZSB0aGUgRml4ZXMgdGFnIGZyb20gdGhlIG90aGVycy4NCj4gPiA+IEFja2VkLWJ5
OiBOaWtvbGF5IEFsZWtzYW5kcm92IDxuaWtvbGF5QG52aWRpYS5jb20+DQo+ID4gPiAgIA0KPiA+
IA0KPiA+IFRCSCwgdGhpcyBkb2VzIGNoYW5nZSBhIHVzZXIgZmFjaW5nIGFwaSAodGhlIGF0dHJp
YnV0ZSBuZXN0aW5nKSwgYnV0IEkgdGhpbmsNCj4gPiBpbiB0aGlzIGNhc2UgaXQncyBhY2NlcHRh
YmxlIGR1ZSB0byB0aGUgZm9ybWF0IGJlaW5nIHdyb25nIGFuZCBNUlAgYmVpbmcgbmV3LCBzbw0K
PiA+IEkgZG91YnQgYW55b25lIGlzIHlldCBkdW1waW5nIGl0IG1peGVkIHdpdGggdmxhbiBmaWx0
ZXJfbWFzayBhbmQgY2hlY2tpbmcgZm9yDQo+ID4gdHdvIGlkZW50aWNhbCBhdHRyaWJ1dGVzLCBp
LmUuIGluIHRoZSBvbGQvYnJva2VuIGNhc2UgcGFyc2luZyB0aGUgYXR0cmlidXRlcw0KPiA+IGlu
dG8gYSB0YWJsZSB3b3VsZCBoaWRlIG9uZSBvZiB0aGVtIGFuZCB5b3UnZCBoYXZlIHRvIHdhbGsg
b3ZlciBhbGwgYXR0cmlidXRlcw0KPiA+IHRvIGNhdGNoIHRoYXQuDQo+IA0KPiBUbyBiZSBjbGVh
ciAtIHRoaXMgY2hhbmdlcyB0aGUgdUFQSSBhcyBmYXIgYXMgNS45LXJjcyBhcmUgY29uY2VybmVk
LiANCj4gU28gaWYgdGhpcyBjaGFuZ2Ugd2FzIHRvIGhpdCA1LjkgZmluYWwgdGhlcmUgd291bGQg
YmUgbm8gdUFQSSBicmVha2FnZSwNCj4gcmlnaHQ/DQoNClllcywgY29ycmVjdC4NCg==
