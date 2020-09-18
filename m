Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDFE26F4D4
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 05:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgIRDyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 23:54:46 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:1035 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgIRDyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 23:54:45 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f642f2c0000>; Thu, 17 Sep 2020 20:53:16 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Sep
 2020 03:54:40 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 18 Sep 2020 03:54:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PZ4Lhjww+NosHGDekWnDuZEwspaq8yEWq7dzhlaroA7DTHAbkMgzCSCq64mpD+dE4NhISMZkErkSUoZlaJLv0/xrpcN1WTT5LrgWnURfue3g1Ms7c2j9/S4TLFZsRHvTwXB75SHWxVun8ZdYhioHaAuhyN2HxK0cDRHXO+GkJ5HNk9+EeIBJOj/VkBP2pE0kYVJjZF33vQ8bExAHr1Cd9VsrFcMge+k5kcAyqX2ics1hahoMiXDwmGhf3+QBKaJigSU3uduio3J8XW6JmimYlK9qVB7W1UcMeocRLENktCQ18LxtKkdsuNbCtvClxvNiMbAqoOYRR+5q0v8KDEx2XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uEsCN3Aqh/Z92x7EFGMf81ShSwjJk/zTYfgChdQEBmw=;
 b=Tfb1LVWQmmVn9rhT2ptXfJGU79GluM2jw6a2zmYpXimqbzQPL9yklkNXHUXvS7jzmsMYc3enS9OIlRDEcWUXz5WfkHDzXa4W8UMuFUyPeFQnB2l7bvTXSbMEPB+PR384mtwhEfusm/IH8LHxNxw51nDdwGNnDknIgaxOIEYa1M0VC38HwSenPTnGMUWb1Iafm31YkXlSYCofSoUBk96iRQ0Kqqe76QSiLpT6yZWpNwN8BHVtKyhog8QlOVS7cEGmj9rNW328dcdDX8bbklIqr/7AgFhu8H/bGab2phqJe7x2W8WNHzJJkwhzD0U6lsIjuW9065VKFnFC06/duO/gJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3366.namprd12.prod.outlook.com (2603:10b6:a03:db::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Fri, 18 Sep
 2020 03:54:39 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%6]) with mapi id 15.20.3370.019; Fri, 18 Sep 2020
 03:54:39 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jacob Keller <jacob.e.keller@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next v2 1/8] devlink: Introduce PCI SF port flavour
 and port attribute
Thread-Topic: [PATCH net-next v2 1/8] devlink: Introduce PCI SF port flavour
 and port attribute
Thread-Index: AQHWjRbfsBFsIsWtkkyNl1+R6ZtbG6ltJwsAgACYXQA=
Date:   Fri, 18 Sep 2020 03:54:39 +0000
Message-ID: <BY5PR12MB4322441DBA23EB8F5B8D3B90DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200917081731.8363-8-parav@nvidia.com>
 <20200917172020.26484-1-parav@nvidia.com>
 <20200917172020.26484-2-parav@nvidia.com>
 <fcb55cc1-3be3-3eaa-68d5-28b4d112e291@intel.com>
In-Reply-To: <fcb55cc1-3be3-3eaa-68d5-28b4d112e291@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eaf3f55e-3ca5-43f1-7351-08d85b869169
x-ms-traffictypediagnostic: BYAPR12MB3366:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3366525EEC4F5FCDE1AEF0D4DC3F0@BYAPR12MB3366.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:626;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lMzboflN1raOYxSUu2OjX2jymfoHV4w4cjcQlOjgsYRj0dg7Zu3FEmkYuuEjGptvZKz5LLH7s50MxjjQ58Bfv2V5HgXB2blwGmhCXMGrJCXpWOV/sj2nGPKOkFrFCFtWr3jSkhjNLvr6+EP/hj8OyEL3VvD9iY7K9eIOAGCCSxYJiVmWu4/XKHD0A+fHCm5Jrd3Oh/ErqSlzukLmQCte2CF4e0kaO82bQ7TOJVBGrES/cjBZXarIHXpPFZCeVaLZULGc3tjVCzyMtqMMkHR1K7sqRQYNn7F9k3SQRHBHVxN8L8c7Pka09OvpDgXu0oHYWrKjXGF/LXNigqw9tBmtNA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(366004)(396003)(346002)(66946007)(52536014)(55236004)(83380400001)(2906002)(5660300002)(8676002)(86362001)(55016002)(6506007)(71200400001)(53546011)(9686003)(316002)(33656002)(26005)(66476007)(76116006)(66446008)(64756008)(107886003)(66556008)(7696005)(8936002)(186003)(110136005)(4326008)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: z+iF9umerAkVsIVRlH1/+C7a1g/1PGjWqaB7K0Xjt3QzRMRxJe+6RNmWNE53KWP1RFSh2wgRLDnJbswc5e4mrOIC2Nuv5ztAEquzD5x8xlMV59jkfm96H/2E3aS2y1elLnQ4Mbck61TFDUZGyeMxBzgFhKYE1jm4qIxdmF+w+c4IbdHW7t8jxFyUh5LjQrA2Ng+3mqCI3bwlPoRyEghTSItzDVcGGK0L+ZpHdAPfvC4uYnf8udMce5w/vNTJxtL7BmtOqMvoBSDFeUCKyJmz+nohNQIBZuhswIqmAJPveOnvYvnOjWmpRLzEMjeaG4euzNXTGlyezcQMTfvctkgINHJUnNSMGg1TYbQwVBSXmtJqQ+vgvM6vJ1Y6EbAYNFjQSEwiGpcGHkl8pezlEc0UD+PS2I6/DM/XTEtYm43pKVc+BQRZSbb8EMwAf9HSH5NvOYKtrXtm+Dz2Y+JN0mQl4F2HKjEkbqVLwTKHF/LwKWooMYVYJ0m/pWlk/Pp9eqCkGNvCT0wd4j/kCMPVGIzL3B5z9XY0PhZvOx/WIKj/urx9YjILWKj6xpuLdiID6uUvu+DkewcnmtZ/XJkrAxYkTF781/+vjLQDzMNrr1NtK4NfdY1v2+vKYDiWYR1lQah5pIl8fHHVCbQ1kjL3qP59EQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eaf3f55e-3ca5-43f1-7351-08d85b869169
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2020 03:54:39.5152
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oEGPANpmbZIB79OKHMZhPJL3IOFhjzsgUq+7NQ8nMWTpsGFjNyDmOSaFdd47dpj/YkC80xkzVagB04QGaIuJAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3366
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600401196; bh=uEsCN3Aqh/Z92x7EFGMf81ShSwjJk/zTYfgChdQEBmw=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=pkD76eTblcuTQDfoPJG4AfRAZTPxRjrp0vhmNKmGC7unAWSa5EUkrdi9Fvf04Azj6
         Hz5GeD/6VGlj6PBBXRIDqp6Fzanny8ZmWyKbtbhZMXov8nRX9OyyxA6kj0NzdStuWk
         kJvqfcPTIWfBwQacjbqlLiDQu8jwYFG1iRPHwFG1OmnPsECfm6/faR1QDQ1J1wC7s0
         m4L6P45sGlf6vSMjzBcqdMP+7ILjcZH6sABtfYgW44/816Jn6xUh5iHimp8OLNMlvS
         S9w0vshIuR3IGscH/X2NRJbQFNfiSWxUPb22H3P6pB3lhKWmo99ufF0B+BGNrvxYQR
         OCPDutrlYvfCw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogSmFjb2IgS2VsbGVyIDxqYWNvYi5lLmtlbGxlckBpbnRlbC5jb20+DQo+IFNl
bnQ6IEZyaWRheSwgU2VwdGVtYmVyIDE4LCAyMDIwIDEyOjAwIEFNDQo+IA0KPiANCj4gT24gOS8x
Ny8yMDIwIDEwOjIwIEFNLCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+ID4gQSBQQ0kgc3ViLWZ1bmN0
aW9uIChTRikgcmVwcmVzZW50cyBhIHBvcnRpb24gb2YgdGhlIGRldmljZSBzaW1pbGFyIHRvDQo+
ID4gUENJIFZGLg0KPiA+DQo+ID4gSW4gYW4gZXN3aXRjaCwgUENJIFNGIG1heSBoYXZlIHBvcnQg
d2hpY2ggaXMgbm9ybWFsbHkgcmVwcmVzZW50ZWQNCj4gPiB1c2luZyBhIHJlcHJlc2VudG9yIG5l
dGRldmljZS4NCj4gPiBUbyBoYXZlIGJldHRlciB2aXNpYmlsaXR5IG9mIGVzd2l0Y2ggcG9ydCwg
aXRzIGFzc29jaWF0aW9uIHdpdGggU0YsDQo+ID4gYW5kIGl0cyByZXByZXNlbnRvciBuZXRkZXZp
Y2UsIGludHJvZHVjZSBhIFBDSSBTRiBwb3J0IGZsYXZvdXIuDQo+ID4NCj4gPiBXaGVuIGRldmxp
bmsgcG9ydCBmbGF2b3VyIGlzIFBDSSBTRiwgZmlsbCB1cCBQQ0kgU0YgYXR0cmlidXRlcyBvZiB0
aGUNCj4gPiBwb3J0Lg0KPiA+DQo+ID4gRXh0ZW5kIHBvcnQgbmFtZSBjcmVhdGlvbiB1c2luZyBQ
Q0kgUEYgYW5kIFNGIG51bWJlciBzY2hlbWUgb24gYmVzdA0KPiA+IGVmZm9ydCBiYXNpcywgc28g
dGhhdCB2ZW5kb3IgZHJpdmVycyBjYW4gc2tpcCBkZWZpbmluZyB0aGVpciBvd24NCj4gPiBzY2hl
bWUuDQo+IA0KPiBXaGF0IGRvZXMgdGhpcyBtZWFuPyBXaGF0J3MgdGhlIHNjaGVtZSB1c2VkPyAN
Cj4NClNjaGVtZSB1c2VkIGlzIGVxdWl2YWxlbnQgYXMgd2hhdCBpcyB1c2VkIGZvciBQQ0kgVkYg
cG9ydHMuIHBmTnZmTS4NCkl0IGlzIHBmTnNmTS4NCkJlbG93IGV4YW1wbGUgc2hvd3MgdGhlIHJl
cHJlc2VudG9yIG5ldGRldmljZSBuYW1lIGFzICdlbmkxMG5wZjBzZjQ0JyBidWlsdCBieSBzeXN0
ZW1kL3VkZXYgdXNpbmcgcGh5c19wb3J0X25hbWUuDQoNCj4gRG8gZHJpdmVycyBzdGlsbCBoYXZl
IHRoZSBvcHRpb24gdG8gbWFrZSB0aGVpciBvd24gc2NoZW1lPyBJZiBzbywgd2h5Pw0KVG9kYXkg
d2UgaGF2ZSB0d28gdHlwZXMgb2YgZHJpdmVycyAobWx4NV9jb3JlLCBuZXRkZXZzaW0pIHdoaWNo
IHVzZXMgZGV2bGluayBjb3JlIHdoaWNoIGNyZWF0ZXMgdGhlIG5hbWUuDQpPciBvdGhlciBkcml2
ZXJzIChibnh0LCBuZnApIHdoaWNoIGRvZXNuJ3QgeWV0IG1pZ3JhdGVkIHRvIHVzZSBkZXZsaW5r
IGluZnJhIGZvciBQQ0kgUEYsIFZGIHBvcnRzLg0KU3VjaCBkcml2ZXJzIGFyZSBwaHlzX3BvcnRf
bmFtZSBhbmQgb3RoZXIgbmRvcy4NCkl0IGlzIG5vdCB0aGUgcm9sZSBvZiB0aGlzIHBhdGNoIHRv
IGJsb2NrIHRob3NlIGRyaXZlcnMsIGJ1dCBhbnkgbmV3IGltcGxlbWVudGF0aW9uIGRvZXNuJ3Qg
bmVlZCB0byBoYW5kIGNvZGUgc3dpdGNoX2lkIGFuZCBwaHlzX3BvcnRfbmFtZSByZWxhdGVkIG5k
b3MgZm9yIFNGLg0KRm9yIGV4YW1wbGUsIGJueHRfdmZfcmVwX2dldF9waHlzX3BvcnRfbmFtZSgp
Lg0KDQo+IEl0J3Mgbm90IG9idmlvdXMgdG8gbWUgaW4gdGhpcyBwYXRjaCB3aGVyZSB0aGUgbnVt
YmVyaW5nIHNjaGVtZSBjb21lcyBmcm9tLiBJdA0KPiBsb29rcyBsaWtlIGl0J3Mgc3RpbGwgdXAg
dG8gdGhlIGNhbGxlciB0byBzZXQgdGhlIG51bWJlcnMuDQo+DQpOYW1pbmcgc2NoZW1lIGZvciBQ
Q0kgUEYgYW5kIFBDSSBWRiBwb3J0IGZsYXZvdXJzIGFscmVhZHkgZXhpc3QuDQpTY2hlbWUgaXMg
ZXF1aXZhbGVudCBmb3IgUENJIFNGIGZsYXZvdXIuDQoNCkkgdGhvdWdodCBleGFtcGxlIGlzIGdv
b2QgZW5vdWdoIHRvIHNob3cgdGhhdCwgYnV0IEkgd2lsbCB1cGRhdGUgY29tbWl0IG1lc3NhZ2Ug
dG8gZGVzY3JpYmUgdGhpcyBzY2hlbWUgdG8gbWFrZSBpdCBjbGVhci4gcGZOc2ZNLg0KIA0KPiA+
DQo+ID4gQW4gZXhhbXBsZSB2aWV3IG9mIGEgUENJIFNGIHBvcnQuDQo+ID4NCj4gPiAkIGRldmxp
bmsgcG9ydCBzaG93IG5ldGRldnNpbS9uZXRkZXZzaW0xMC8yDQo+ID4gbmV0ZGV2c2ltL25ldGRl
dnNpbTEwLzI6IHR5cGUgZXRoIG5ldGRldiBlbmkxMG5wZjBzZjQ0IGZsYXZvdXIgcGNpc2YNCj4g
Y29udHJvbGxlciAwIHBmbnVtIDAgc2ZudW0gNDQgZXh0ZXJuYWwgZmFsc2Ugc3BsaXR0YWJsZSBm
YWxzZQ0KPiA+ICAgZnVuY3Rpb246DQo+ID4gICAgIGh3X2FkZHIgMDA6MDA6MDA6MDA6MDA6MDAN
Cj4gPg0KPiA+IGRldmxpbmsgcG9ydCBzaG93IG5ldGRldnNpbS9uZXRkZXZzaW0xMC8yIC1qcCB7
DQo+ID4gICAgICJwb3J0Ijogew0KPiA+ICAgICAgICAgIm5ldGRldnNpbS9uZXRkZXZzaW0xMC8y
Ijogew0KPiA+ICAgICAgICAgICAgICJ0eXBlIjogImV0aCIsDQo+ID4gICAgICAgICAgICAgIm5l
dGRldiI6ICJlbmkxMG5wZjBzZjQ0IiwNCj4gPiAgICAgICAgICAgICAiZmxhdm91ciI6ICJwY2lz
ZiIsDQo+ID4gICAgICAgICAgICAgImNvbnRyb2xsZXIiOiAwLA0KPiA+ICAgICAgICAgICAgICJw
Zm51bSI6IDAsDQo+ID4gICAgICAgICAgICAgInNmbnVtIjogNDQsDQo+ID4gICAgICAgICAgICAg
ImV4dGVybmFsIjogZmFsc2UsDQo+ID4gICAgICAgICAgICAgInNwbGl0dGFibGUiOiBmYWxzZSwN
Cj4gPiAgICAgICAgICAgICAiZnVuY3Rpb24iOiB7DQo+ID4gICAgICAgICAgICAgICAgICJod19h
ZGRyIjogIjAwOjAwOjAwOjAwOjAwOjAwIg0KPiA+ICAgICAgICAgICAgIH0NCj4gPiAgICAgICAg
IH0NCj4gPiAgICAgfQ0KPiA+IH0NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFBhcmF2IFBhbmRp
dCA8cGFyYXZAbnZpZGlhLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogSmlyaSBQaXJrbyA8amlyaUBu
dmlkaWEuY29tPg0KPiA+IC0tLQ0KPiA+ICBpbmNsdWRlL25ldC9kZXZsaW5rLmggICAgICAgIHwg
MTcgKysrKysrKysrKysrKysrKysNCj4gPiAgaW5jbHVkZS91YXBpL2xpbnV4L2RldmxpbmsuaCB8
ICA3ICsrKysrKysNCj4gPiAgbmV0L2NvcmUvZGV2bGluay5jICAgICAgICAgICB8IDM3ICsrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ICAzIGZpbGVzIGNoYW5nZWQsIDYx
IGluc2VydGlvbnMoKykNCj4gPg0KDQoNCj4gPiAgc3RhdGljIGludCBfX2RldmxpbmtfcG9ydF9w
aHlzX3BvcnRfbmFtZV9nZXQoc3RydWN0IGRldmxpbmtfcG9ydA0KPiAqZGV2bGlua19wb3J0LA0K
PiA+ICAJCQkJCSAgICAgY2hhciAqbmFtZSwgc2l6ZV90IGxlbikNCj4gPiAgew0KPiA+IEBAIC03
ODU1LDYgKzc4ODksOSBAQCBzdGF0aWMgaW50DQo+IF9fZGV2bGlua19wb3J0X3BoeXNfcG9ydF9u
YW1lX2dldChzdHJ1Y3QgZGV2bGlua19wb3J0ICpkZXZsaW5rX3BvcnQsDQo+ID4gIAkJbiA9IHNu
cHJpbnRmKG5hbWUsIGxlbiwgInBmJXV2ZiV1IiwNCj4gPiAgCQkJICAgICBhdHRycy0+cGNpX3Zm
LnBmLCBhdHRycy0+cGNpX3ZmLnZmKTsNCj4gPiAgCQlicmVhazsNCj4gPiArCWNhc2UgREVWTElO
S19QT1JUX0ZMQVZPVVJfUENJX1NGOg0KPiA+ICsJCW4gPSBzbnByaW50ZihuYW1lLCBsZW4sICJw
ZiV1c2YldSIsIGF0dHJzLT5wY2lfc2YucGYsIGF0dHJzLQ0KPiA+cGNpX3NmLnNmKTsNCj4gPiAr
CQlicmVhazsNCj4gPiAgCX0NCj4gPg0KVGhpcyBpcyB3aGVyZSB0aGUgbmFtaW5nIHNjaGVtZSBp
cyBkb25lLCBsaWtlIHBjaXBmIGFuZCBwY2l2ZiBwb3J0IGZsYXZvdXJzLg0KDQo+ID4gIAlpZiAo
biA+PSBsZW4pDQo+ID4NCg==
