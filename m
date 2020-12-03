Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 682A42CCF8B
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 07:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387981AbgLCGeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 01:34:01 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:10476 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729226AbgLCGeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 01:34:00 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc886b00001>; Wed, 02 Dec 2020 22:33:20 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 3 Dec
 2020 06:33:20 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 3 Dec 2020 06:33:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lfcls+7nwitpzBTmji3S0TyuRdYttPy7kUEY0vwT/+uk+ctMZ2h8y8JhwIeIZCLMQ3yfqz+w7ImuyJlZy6BmYwJszS1Mr4n8J/QA/DYA37xUVttf0weyOQGND3l/xWmuZUAMAn6noG3nJmgXCbdsJ7d7FKzT9l/Ggjqvp1DASqSH8REbgXVRfq0c3T9AlCoYxmfcS3LZGsCd9d3ABYY+DLuu34NVuW7AFT4lu6xjDYOVWqmaZe+ulIeuzEsFELP/83ye/r5aVvcQoG6TMGEaA8vg+r5FKJWiMjSgHqcHWYGl7bo+fVwlGmChGE7PKZfAjNLa2FXNAroHdzEYyRlRXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WFH0pbYnyOJLQ4NkmJHvd2HrYeiNtC6585zlVnaiiDI=;
 b=ZBb/A7M3EvR2w7ssVVo7WcsR3pWcQC38FbpZxZeAEDcAO1IchARA+wXUHc+w/hSiF4Bw4oRfZW+8zGDRGnfZesUfV51Jb4Vx5jemRNXqmwhhZKvKEc1DYOAhfDjoWWrthITcdgp9EX8edEuTEsu/M0QVLguze0l+ya3m0zomDUObt0G3Ulb836zJYL0lKZ7/JZ5c1iw/Flh4XHLK+MtWIWZK7latVI+tOW03gxckBmNoxtDBpzqClkKQExEIbwUJUulnK9ta2DfSi96PUkwfr7abX8sfMRE2WNX1sVrVbD/Te5U5xmli3/2lPwfPNTa/mifN7QB/K++voFP0ok3qYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB4776.namprd12.prod.outlook.com (2603:10b6:a03:10d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20; Thu, 3 Dec
 2020 06:33:18 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%7]) with mapi id 15.20.3632.017; Thu, 3 Dec 2020
 06:33:18 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH iproute2-next] devlink: Extend man page for port function
 set command
Thread-Topic: [PATCH iproute2-next] devlink: Extend man page for port function
 set command
Thread-Index: AQHWxziC0yJzQbJgH0ObXkAlD8hQxankvg0AgAAuABA=
Date:   Thu, 3 Dec 2020 06:33:18 +0000
Message-ID: <BY5PR12MB43229F8C7D644A3EE7129002DCF20@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201130164712.571540-1-parav@nvidia.com>
 <dcabfc2d-d376-ca0f-55e9-983380636298@gmail.com>
In-Reply-To: <dcabfc2d-d376-ca0f-55e9-983380636298@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [136.185.130.106]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9396b806-17aa-49e4-4e83-08d8975552b1
x-ms-traffictypediagnostic: BYAPR12MB4776:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB4776389851B6CC6A763936FBDCF20@BYAPR12MB4776.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:317;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LRgCjdLGtLjvVRCBKEWa6nHMkbo3funZ2CSub1XjmLZ7xS0BuG8fonnjuowPUavNUBpUjcX5V23sAkfkVv990vwHoO0njukAHUVdii2isqziaABf0O9ffwMi30CvKs5LCkZZwyLLqV6/Mp6U6L2IpZr2ou2H6jJiWibZGjIZQ8md5Tj7A6e+C6RDHVt56yMhuNJYnir1Pz+63rdVwf5+Ez06yRxFty33nuCyZ1NXhMziBZq6x83MhUL4Fv3Nv2zT1NZhXceZSxKpKioQpAXB/n8XJQdc8GZaF7lOOYwpC7KCxrJqtx2mGRdsN8aK2ttMJvcYsmrizmI8DAUrZ0bXFw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(136003)(376002)(39860400002)(316002)(8676002)(2906002)(4744005)(110136005)(107886003)(52536014)(64756008)(66476007)(66446008)(66556008)(5660300002)(76116006)(66946007)(186003)(71200400001)(9686003)(7696005)(26005)(8936002)(478600001)(55016002)(4326008)(33656002)(86362001)(6506007)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?ZkQrWVNhNW1FbnZXZ3pIZmhXNVZSOFdPbDdVblFZaDJqNUYyOUJnU1M4R2dH?=
 =?utf-8?B?SEdEZmt0Rm1ucmlTRkhVclZ0TUFtRGFaNzhPVnNtd0NKRGZrTDVGczJ2TGVS?=
 =?utf-8?B?UE5ZUmEzM3VpK0lBK2JzRUZyeG1xdmpmbXJaUU1Xc3hSd3d5S3EvMGlRZXE0?=
 =?utf-8?B?b2VQTUhqc3krZTNTbUxBdGE4YnhkaTV5aXFSSytqWlRUMThnWkpRYlE5MTQx?=
 =?utf-8?B?enlWOFNsOWEvOHFtMjBqTzVsK0VRbkVJdGNKRStCeVVTK1YvVGJmUzZOazJD?=
 =?utf-8?B?bG5OeWtQVWQ4U3BuSEI4S3RxUjNzVzFFcENyazE3dFZ0SG5LdGEvVG9kdXJ2?=
 =?utf-8?B?NVdvVDJjcXo2T2ptUVdDandhbTdtbzlSMjk3cGhPN0IrRTl1ZGp5TmI4Z3Vt?=
 =?utf-8?B?YStSa1I3U2hCdXgvV0ZheEpVZDlIZzBIbHlwZWxxTWs5Z3JWWVlWUndKdi8v?=
 =?utf-8?B?NnpId3NNbkpIam42T1pyWUQ1UXZKMitOY3NBODVENXErdkdQck9uQ2NuQ0RQ?=
 =?utf-8?B?MitUZmRBR2VFTlpuSzlYb1pLUEpJRWszc2hVeDB4TFI0NGIvWnY5TDllUXBq?=
 =?utf-8?B?L1c1ZnNTU3Y4Tmt1ZmE1V0NLZGw4QWJETGZERENLMi94NG9peVQ4MDhpOGpF?=
 =?utf-8?B?Wm1nTnVJYmFwOW5WVTl1bFRBWFA5dUtYS1RabkVibmRUV2w3QU9nM2dqejZB?=
 =?utf-8?B?UnRnQmxnVnRXOEkvVW5qR096bFhTN3FXTkJwNG1IK1cyTzB6Vy9tSmtma3Jl?=
 =?utf-8?B?RHdabFk4Tkd1bFpwTFRHUCszaG5ZREs0OUJEWEtRZk1ENk85RVpFT1NrelF2?=
 =?utf-8?B?NVVpVWE5aTlzUmVjbnIwNmlTYzR2NSt2YnBsbjNnYjBFYTRRMXpCc2lwaFlz?=
 =?utf-8?B?U3dhT1Zvd0U5cndRdTVKMHV1QnZJMWR1OFZoM2pMUTA5Vys3TXJaZnZRMFYy?=
 =?utf-8?B?aXFTNWQxc1MxK2kyRERJcXlMUWpKV09EamNIVmdEZHA0TWd3NXcxMnNKTTFH?=
 =?utf-8?B?TDVuL3JmL0V2eFBBQ3c4UHlEV3RpSXZPcHNHUHdvWWtSemFjclJleEt6SU9o?=
 =?utf-8?B?L2J5VndPN05aUDhXQk9HbUpGQ1lnNzZKdGw2bGNmVDMwTFVoZ1BWNElSM2Ru?=
 =?utf-8?B?ZkpyamVoL3c3OVpPVDNPVkk1R28vdnYvNzk1dWMza0V2TWUrb2VsSkdSV291?=
 =?utf-8?B?U0hsbFZTeGRQUjJTYktXSG5yN3p6cjdoN0NoRm9ydVhmYkNsYmRmQmhHOHcr?=
 =?utf-8?B?M2h1dWY1ZWI4dzJtd1pDR1V5dkgrUm5Ea09qR0pEU3Y2ZXkzSGtWSS9QeHhQ?=
 =?utf-8?Q?OOZ/Pi5OZXXbxAzrvjYh9aLXpBEoTua2z4?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9396b806-17aa-49e4-4e83-08d8975552b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2020 06:33:18.6857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NWC8SYnT9Z70h6gM/UMB1oO+8eTeoZb2jEsELyoLA9vgnFRXw4/J2Hko6i3Vw6WP/a/BdHG1iRfVT3Q0xbZceg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4776
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606977200; bh=WFH0pbYnyOJLQ4NkmJHvd2HrYeiNtC6585zlVnaiiDI=;
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
        b=HOY5UOgNn1FijXZ0M+wnuLgnL0neuVmOmMh4XJ4Mow4orM8M8L0XFOh1UaW7ftfvF
         Cx/XEyUmwrrQ8m7m0P/2sdEcncDNqZvGxdXckYxycICpMAMhDKN+tPlZm/jVHPE8nt
         fasFs7V9+XIzzAfWzjsFz+R9tIeOI9zb5zEKpOzUY//lx6yWfkYIsEfsNTGuzvNGmP
         4RnRSxEIqgv8Szb5+WniT5XDY1yaI6Ix0M75NfwfXIirujDhYrkRwIxSsff4EC38Po
         XApGMVaDLHFh9CRUy+AhJyG/Vxb44jV0JRM/38JZWlgD66MWjcqPz/Nw7i9L31NIK5
         8KPTFhxyzGB3g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogRGF2aWQgQWhlcm4gPGRzYWhlcm5AZ21haWwuY29tPg0KPiBTZW50OiBUaHVy
c2RheSwgRGVjZW1iZXIgMywgMjAyMCA5OjEyIEFNDQo+IA0KPiBPbiAxMS8zMC8yMCA5OjQ3IEFN
LCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+ID4gRXh0ZW5kZWQgZGV2bGluay1wb3J0IG1hbiBwYWdl
IGZvciBzeW5vcHNpcywgZGVzY3JpcHRpb24gYW5kIGV4YW1wbGUNCj4gPiBmb3Igc2V0dGluZyBk
ZXZsaW5rIHBvcnQgZnVuY3Rpb24gYXR0cmlidXRlLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTog
UGFyYXYgUGFuZGl0IDxwYXJhdkBudmlkaWEuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBKaXJpIFBp
cmtvIDxqaXJpQG52aWRpYS5jb20+DQo+ID4gLS0tDQo+ID4gIG1hbi9tYW44L2RldmxpbmstcG9y
dC44IHwgMjEgKysrKysrKysrKysrKysrKysrKysrDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAyMSBp
bnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvbWFuL21hbjgvZGV2bGluay1wb3J0
LjggYi9tYW4vbWFuOC9kZXZsaW5rLXBvcnQuOCBpbmRleA0KPiA+IDk2NmZhYWU2Li43ZTJkYzEx
MCAxMDA2NDQNCj4gPiAtLS0gYS9tYW4vbWFuOC9kZXZsaW5rLXBvcnQuOA0KPiA+ICsrKyBiL21h
bi9tYW44L2RldmxpbmstcG9ydC44DQo+ID4gQEAgLTQ2LDYgKzQ2LDEyIEBAIGRldmxpbmstcG9y
dCBcLSBkZXZsaW5rIHBvcnQgY29uZmlndXJhdGlvbiAgLnRpIC04DQo+ID4gLkIgZGV2bGluayBw
b3J0IGhlbHANCj4gPg0KPiA+ICsudGkgLTgNCj4gPiArLkJSICJkZXZsaW5rIHBvcnQgZnVuY3Rp
b24gc2V0ICINCj4gDQo+IFRoZSBjb21tYW5kIGV4aXN0cyBpbiBpcHJvdXRlMiBtYWluIGJyYW5j
aCBjb3JyZWN0Pw0KWWVzLCB5b3UgYXJlIGNvcnJlY3QuDQo=
