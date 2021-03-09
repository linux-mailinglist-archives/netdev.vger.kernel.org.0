Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11AAF33258C
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 13:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhCIMgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 07:36:55 -0500
Received: from mail-eopbgr690070.outbound.protection.outlook.com ([40.107.69.70]:51587
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230122AbhCIMgU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 07:36:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DLYwAhL441cO5F66RyMLIoIyFKhGLKn5IibXwmorTeBLhsSchrgTbl3ylV0jYbW5Aqy/pQPS/GptaGng8fnMaUWdUpfEnuCtaVH/0rCYb3h8c4yxl8Nw1URhzjdvOTlEoqBXUEQGZN1Qi8fD8lcfgTneUfmlh5DhvtwoESkPeRxm9UqZI1XVBZTqnDGwDgaKoTvJlHdUPX4Ed24ZxF64N7drf94QABhM06Y81EzuQkX2aH6gRR/nrdHdwziz798w4nOwPR4rxYtakcPsT0WRv3KiyU2YB2UHDZpT4RfXGzH5Jj2+XMIQuuUoKvqfR8FXnCZOu0OUUW7PcrDbZ6Tlww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pXS5gjbneR0VJDhpWT+0ww/+tXtpB5k1MhfM2WKjPME=;
 b=YxZUKPU/EkJ/wTRAR38tgINC/MAgBVXBBpSHRX/9tzkB7fHezxoYjT1B5g9W246cvnUTyZOvq6/6GPE4BrFRjOVn2IKQlXf/ANJo4LxMrrEo9PLqmLIOAp0BcIOzdii2SAJ9ttR+z6LwHbxLqg789zlEv+qzO6L6z68fWV6RpN/2s6gnF5Bj66C7B+sW1fsvFlGRsAfxg7P6M0YnrBVggTqxUpC03EcVgEJTPfueyUpGIBVYdGV35CpErhPEon2Nc0OxCsIgCOkdjLl1Z1aMhvtCNioso8rqHUUToq81vHHEogg7eowUl5rrupKUTaohdFZWVH9yCHOaZ55xnIJq9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pXS5gjbneR0VJDhpWT+0ww/+tXtpB5k1MhfM2WKjPME=;
 b=iI4VgdnCaDw9YfLzlvMHvxZUmFpm9izmq3h96zRSVisvCH8a7FBXAF7E0CYShR13THJhPeK+jX66sPCiy87W2KBvd17MEp8UGwOeHLy7YsKwQW/x0bV0fW6R87ZN8KVe6nwbNnmu5KJMfXn+YhhbbNzdUpkGMVVl5el1F5NnN5CCVCn+M+AzGkWGG1YilPnbqqJXJaLU7p3cDmLidfDlJnZ8iY+jlX4PHvU6sH+Cbg0VdJqdlK+kIk41bPKxzz5icjCd/tboBARn2cRh38P0ID8WUZbyJZWBzpJO1b+0Wfi2seATmSHeueoTtBlxcHdPfQoiK9ktoBLN+6KuEr+nkA==
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB2648.namprd12.prod.outlook.com (2603:10b6:a03:69::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28; Tue, 9 Mar
 2021 12:36:19 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b0c7:dacb:8412:19e5]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b0c7:dacb:8412:19e5%5]) with mapi id 15.20.3912.029; Tue, 9 Mar 2021
 12:36:19 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     ze wang <wangze712@gmail.com>, David Ahern <dsahern@gmail.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: mlx5 sub function issue
Thread-Topic: mlx5 sub function issue
Thread-Index: AQHXE72y2+GYMtRR80igRDiiJTpnUap5iw/wgAAk5ICAAI11AIAAvOWAgACfSAA=
Date:   Tue, 9 Mar 2021 12:36:19 +0000
Message-ID: <BY5PR12MB4322F7A218F0C0D2BBF99EF1DC929@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <CANS1P8H8sDGUzQEh_LEFVi=6tUZzVxAty9_OKWAs4CU67wdLeg@mail.gmail.com>
 <BY5PR12MB43226FF17791F6365812D028DC939@BY5PR12MB4322.namprd12.prod.outlook.com>
 <CANS1P8E8uPpR+SN4Qs9so_3Lve3p2jxsRg_3Grg5JBK5m55=Tw@mail.gmail.com>
 <b026b2c8-fdd5-d0fc-f0a6-42aa7e9d26f8@gmail.com>
 <CANS1P8EHJ+ZSZT8MT43PzXH6bhZ6FVhrQ_sxxFWbWTvzyT+3rA@mail.gmail.com>
In-Reply-To: <CANS1P8EHJ+ZSZT8MT43PzXH6bhZ6FVhrQ_sxxFWbWTvzyT+3rA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [122.166.131.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4897c493-8c76-4d7c-df87-08d8e2f7f087
x-ms-traffictypediagnostic: BYAPR12MB2648:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB26481918AC78053957FEC59DDC929@BYAPR12MB2648.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xjGEQtT+sRd1sTIUBAnjlwpyQ4QfnWfDpP/TPoqEEjup8if3YfYXiA46Og2nwRuwzqYI4j/X+WEtX6V9FJ137jjUqiFXrK2n51CsIJs6pFDvHGKlq2AALsatZh0CDtBz54p1iG8fB7C4Yuc8kuOZs2yVLjCKCtQu9LMEsOMaC1OBOsCGepZ1l+0pfOMy9WWHvArYj5/i3LJopB3GNZQHbGE0PZNDGwUWODZ3ltpkuwFKuX7KU+4T9nRRgPg4K1Zt8E1tu+l7dziK/S8C+OqL8OI38YCX3pWaBwxBCnZ+yrfVi7kobyks7msFakG+E5WZa5Z4EObiQITlNSTQU7YxsCfcTxRp+XyQQhoEI6fdGl9edGc8v4LpobfEMmGMgsBz4/aN1Ami36LLJmu6YVDu6flPlo72d3UQtI9DB3Ezy4szQIAuhjja0mJJYO6cdSeHQkigGlCa50UsVTSfAKKiy/ryt+MvK+9KLyp/o0UwzZws+WHtZg7nQox1rbFWq5+zWwuiQ6BImz4VW5PSIYCTig==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(366004)(346002)(136003)(7696005)(64756008)(186003)(55016002)(66946007)(83380400001)(6506007)(4326008)(66556008)(53546011)(76116006)(5660300002)(86362001)(9686003)(71200400001)(110136005)(33656002)(478600001)(52536014)(8676002)(316002)(26005)(8936002)(66476007)(54906003)(66446008)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?MU9nWUNZRjN6bklPMnZjN2NIUFRpSHVmQ0hIU2E0eDQwSktPWkFtTW1Wckx5?=
 =?utf-8?B?c1R0S0YzelB0VldISktQUHF6WnlkWHJ2RTJOLzJYZE53NkNZb2ovMkhRSXQ1?=
 =?utf-8?B?ZWJ0ZVBlRVUrTzcxMEtubDN6UHBBRG4xckRDbjJaZWU1MWZFWE5wV0VEL2RU?=
 =?utf-8?B?SEU4eEh4ZDdZY3NtSlJONnZ1emR6TUVCQThCK3VTeExvV0pKTkRPSXRZZkpk?=
 =?utf-8?B?b0RQZnpwcVR3WWZtUzlhMFQ2bmZXZ29rTWxlejEwZEc1Y1RzRHFDU0ZvakE4?=
 =?utf-8?B?ZTRFaEtQbGFnRFFjazlXdCtJcFVWQjRJL2JwMVVPbnRkVlhzMXRLWDd0aFEy?=
 =?utf-8?B?UDh5dVo2S3hWNWlkU28xc2hmTWhmNDRiVFJHYkVRTURkZHFLMUNFdEdOWUJZ?=
 =?utf-8?B?anZCRHdpNkxsRzRWZ2RXSUdnMnZjT09UUk92bVVFdGtWUWxuem5nMlAwMHNs?=
 =?utf-8?B?TkJiVEFNbjNQWldhbjVXSXhXaGtSVmFzV3ZLWXR4K0w3OUFta3VIYkllUVo2?=
 =?utf-8?B?TlRubFIzN0JqeG9RYmF2NXA0aHZpV1ozbmhvMmZMaHZLd2RkbU5tb1lCUmR1?=
 =?utf-8?B?cVhadnNBYmcyUjNrSnA4SFNLWmxiRzd5aEZIUjQ0blZxdmpsMkJrVVRyYVRi?=
 =?utf-8?B?aGJYdnRpMG9yQWNFeXVyN1dTQ25Tb3ZLYTRvZ0FPeEwvdEZMZTA1UDJlMWIw?=
 =?utf-8?B?QlJ6a1ROc2hjZWhBOHJIbmdTR0taMktWdXVZemwvbFFDeXp6MkUyclEzRXZr?=
 =?utf-8?B?U2pjK3NRYzdpVXU3dUJrbUc2anhvcEdkR2VLSVBIa0UxVUNDYTB1QkxGMEIy?=
 =?utf-8?B?UWJsdkNnVXBUTnhZV0YzUTZQREJaQUlxT2hXRU9EMnF0NHhqNHcxanBYdmxr?=
 =?utf-8?B?RlVGaXNiakkwL1hUWGpORDR2SmlMZ29Qc0RVRHg0UVg1SnhueUo3MWtJckZp?=
 =?utf-8?B?SzhNaEtlcXBpSmRLY2VsRkdvZmJUbHJZRUtpOUFwNTVoRHlzZzRoZWdrcmZN?=
 =?utf-8?B?Q2xPNWtaTGVHeHVCNmRMbUFnT0VONjljSTZsRDN3dTRwMjJyd0FuQWo2bGNW?=
 =?utf-8?B?R3JjeHZNSCtTbUFnT0M4dUtBWXAwZ283VzRia3hPVXE3bEpKZUF2YzN5a0Mw?=
 =?utf-8?B?NTBCNVJvc3dTUHAxclpUdEVjV085MEU4V0pONEl6RFVuL0VNV3pQNGdOWWJP?=
 =?utf-8?B?NFlNb0JNUGsrN2lUNUE4OHZqM0tyODBsRXNWRzBLOHBsOWhYNjFURzF2ckVv?=
 =?utf-8?B?RzBhVjdpYlV1cU5yVEhqL0pwQ3FBang3c09LOXlXRVVtU21MRjAwNHV2OTYz?=
 =?utf-8?B?WFMzSURwM1lmT1ZSbEQ2Z1ViQzcxaGZFei9aaWNlS2hla201VUhMMXQ0enBQ?=
 =?utf-8?B?UzNweExJSUpmTFhGTkt5OUxvTHJGSVBBUVhXR1Zyb3llREthbExDNFM5ZVg0?=
 =?utf-8?B?eDlzT3BXT2dQQ2h6WlNoQW81bFdJb0ZYOGxvb1hDa3BOdVBJM2ViMVI3eXRT?=
 =?utf-8?B?aE9IaXRtVG5ReGZpWHE3UzlKTWEvMkljd2NReVNrQ1hTTW5uSmJtMG4xVVBS?=
 =?utf-8?B?bjVKbjFxWVNKcHovVHlJMTBWS1BMTWJUYjBvT3pWOGljRS81a0VMSVZETVR3?=
 =?utf-8?B?SFBrRkQyVU51UnlGY3pHMDdaS2M3REoxQXMrK2VNbUhaVEo3K1BvbHYvTVJV?=
 =?utf-8?B?QnNQeTcwbmFsYk1RVG54NU9EWHlsSDRvaXE4c2dSRXRyUnArUHNNK214eDZq?=
 =?utf-8?Q?XB3ay1JGQMW3mlNSvEXTgmgOzjP0IHPDasrWFrl?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4897c493-8c76-4d7c-df87-08d8e2f7f087
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2021 12:36:19.1787
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WJt6WH3rK6RdWH5ngDQwMkNQgXYZYIYOZqN1n72D9MX0GXwCJLkBVtpxYg/8eNglJA9Xy98AajfjctyBLfMSZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2648
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgWmUgV2FuZywNCg0KPiBGcm9tOiB6ZSB3YW5nIDx3YW5nemU3MTJAZ21haWwuY29tPg0KPiBT
ZW50OiBUdWVzZGF5LCBNYXJjaCA5LCAyMDIxIDg6MzQgQU0NCj4gDQo+IEhpIERhdmlkLA0KPiAg
ICAgICBJIGNhbiBzZWUgdGhhdCB0aGUgdmFyaWFibGUgc2V0dGluZ3MgYXJlIGluIGVmZmVjdO+8
mg0KPiAjIG1seGNvbmZpZyAtZCBiMzowMC4wIHMgUEZfQkFSMl9FTkFCTEU9MCBQRVJfUEZfTlVN
X1NGPTENCj4gUEZfU0ZfQkFSX1NJWkU9OCAjIG1seGNvbmZpZyAtZCBiMzowMC4wIHMgUEVSX1BG
X05VTV9TRj0xDQo+IFBGX1RPVEFMX1NGPTE5MiBQRl9TRl9CQVJfU0laRT04ICMgbWx4Y29uZmln
IC1kIGIzOjAwLjEgcw0KPiBQRVJfUEZfTlVNX1NGPTEgUEZfVE9UQUxfU0Y9MTkyIFBGX1NGX0JB
Ul9TSVpFPTgNCj4gDQo+IGFmdGVyIGNvbGQgcmVib290Og0KPiAjIG1seGNvbmZpZyAtZCBiMzow
MC4wIHF8Z3JlcCBCQVINCj4gUEZfQkFSMl9FTkFCTEUgICAgICAgICAgICAgICAgICAgICAgICAg
ICBGYWxzZSgwKQ0KPiAjIG1seGNvbmZpZyAtZCBiMzowMC4wIHF8Z3JlcCBTRg0KPiBEZXNjcmlw
dGlvbjogICAgQ29ubmVjdFgtNiBEeCBFTiBhZGFwdGVyIGNhcmQ7IDI1R2JFOyBEdWFsLXBvcnQg
U0ZQMjg7DQo+IFBDSWUgNC4wIHg4OyBDcnlwdG8gYW5kIFNlY3VyZSBCb290DQo+ICAgICAgICAg
IFBFUl9QRl9OVU1fU0YgICAgICAgICAgICAgICAgICAgVHJ1ZSgxKQ0KPiAgICAgICAgICBQRl9U
T1RBTF9TRiAgICAgICAgICAgICAgICAgICAgICAgICAxOTINCj4gICAgICAgICAgUEZfU0ZfQkFS
X1NJWkUgICAgICAgICAgICAgICAgICAgOA0KPiAjIG1seGNvbmZpZyAtZCBiMzowMC4xIHF8Z3Jl
cCBTRg0KPiBEZXNjcmlwdGlvbjogICAgQ29ubmVjdFgtNiBEeCBFTiBhZGFwdGVyIGNhcmQ7IDI1
R2JFOyBEdWFsLXBvcnQgU0ZQMjg7DQo+IFBDSWUgNC4wIHg4OyBDcnlwdG8gYW5kIFNlY3VyZSBC
b290DQo+ICAgICAgICAgIFBFUl9QRl9OVU1fU0YgICAgICAgICAgICAgICAgICBUcnVlKDEpDQo+
ICAgICAgICAgIFBGX1RPVEFMX1NGICAgICAgICAgICAgICAgICAgICAgICAgMTkyDQo+ICAgICAg
ICAgIFBGX1NGX0JBUl9TSVpFICAgICAgICAgICAgICAgICAgOA0KPiANCj4gSSB0cmllZCB0byBj
cmVhdGUgYXMgbWFueSBTRiBhcyBwb3NzaWJsZSwgdGhlbiBJIGZvdW5kIGVhY2ggUEYgY2FuIGNy
ZWF0ZSB1cCB0bw0KPiAxMzIgU0ZzLiBJIHdhbnQgdG8gY29uZmlybSB0aGUgbWF4aW11bSBudW1i
ZXIgb2YgU0ZzIHRoYXQNCj4gQ1g2IGNhbiBjcmVhdGUuIElmIHRoZSBtZnQgdmVyc2lvbiBpcyBj
b3JyZWN0LCBjYW4gSSB0aGluayB0aGF0IENYNiBjYW4gY3JlYXRlIHVwDQo+IHRvIDEzMiBTRnMg
cGVyIFBGPw0KRG8gIHlvdSBoYXZlIFZGcyBlbmFibGVkIG9uIHRoZSBzeXN0ZW0/IG1seGNvbmZp
ZyAtZCBiMzowMC4wIHEgfCBncmVwIFZGDQpJZiBzbywgcGxlYXNlIGRpc2FibGUgU1JJT1YuDQoN
Cj4gDQo+IERhdmlkIEFoZXJuIDxkc2FoZXJuQGdtYWlsLmNvbT4g5LqOMjAyMeW5tDPmnIg45pel
5ZGo5LiAIOS4i+WNiDExOjQ45YaZ6YGTDQo+IO+8mg0KPiA+DQo+ID4gT24gMy84LzIxIDEyOjIx
IEFNLCB6ZSB3YW5nIHdyb3RlOg0KPiA+ID4gbWx4Y29uZmlnIHRvb2wgZnJvbSBtZnQgdG9vbHMg
dmVyc2lvbiA0LjE2LjUyIG9yIGhpZ2hlciB0byBzZXQgbnVtYmVyIG9mDQo+IFNGLg0KPiA+ID4N
Cj4gPiA+IG1seGNvbmZpZyAtZCBiMzowMC4wICBQRl9CQVIyX0VOQUJMRT0wIFBFUl9QRl9OVU1f
U0Y9MQ0KPiA+ID4gUEZfU0ZfQkFSX1NJWkU9OCBtbHhjb25maWcgLWQgYjM6MDAuMCAgUEVSX1BG
X05VTV9TRj0xDQo+ID4gPiBQRl9UT1RBTF9TRj0xOTIgUEZfU0ZfQkFSX1NJWkU9OCBtbHhjb25m
aWcgLWQgYjM6MDAuMQ0KPiA+ID4gUEVSX1BGX05VTV9TRj0xIFBGX1RPVEFMX1NGPTE5MiBQRl9T
Rl9CQVJfU0laRT04DQo+ID4gPg0KPiA+ID4gQ29sZCByZWJvb3QgcG93ZXIgY3ljbGUgb2YgdGhl
IHN5c3RlbSBhcyB0aGlzIGNoYW5nZXMgdGhlIEJBUiBzaXplDQo+ID4gPiBpbiBkZXZpY2UNCj4g
PiA+DQo+ID4NCj4gPiBJcyB0aGF0IGNhcGFiaWxpdHkgZ29pbmcgdG8gYmUgYWRkZWQgdG8gZGV2
bGluaz8NCg==
