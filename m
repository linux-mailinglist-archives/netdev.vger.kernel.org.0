Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5902336BE6
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 07:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbhCKGNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 01:13:36 -0500
Received: from mail-dm6nam11on2075.outbound.protection.outlook.com ([40.107.223.75]:62619
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229686AbhCKGNG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 01:13:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OlK6lXXyIF5tAdSX4tfh1vVq+Irp9DEzW4EBmbDRu7iecoHcxa4lKzKpMeLf+5yzEgWhhlKN0rqFaU/IimbU/1aeSPwr0/N6vZO79crkQfg4DpqSkuIDfagaqk8rME4tTEXVpOjSJjcFNxcwmgQ5XeyVFhEkNHJDNIy2SSoEvVWW/1LDz4b9clbDM1R4+bLoIhTQbzOfMY4xaVUfzXdnrRLLtfVWchSHPG6RbEOwoiMJhTtDVfj/czK7FQmkImGqAWxb+U5cLJcpmT7Tvtfh47tADCj68KDout1WQbJ3WttN0pAzbjVSXOb3JgbbOc+hu32Y9A2r0CDlBRjGECwzQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PQslu04IcMLjqSJ/SnfXnBzneVDDJq1tiGbcYzbjs+A=;
 b=dlBYlaTKBojXyQX6AjLWUwzXJ+pUdMGnkwxgUTAR/ZyjL8ll2Gfp5DNqcn92sYkVO96t6pOZBxAVLz39UgE0+bjn0DehWpBnnheinhZXAAd809WIcDDnGKvZNDgWasSyynsy6haO+igjQrl+RZpsEF4v7AxKrt+ON9FZFM4ANiEor3EcOQNAuTvmI8VLcDZYbd57LMCcgikO4CGNXBNiFNNmfMQg8iNUf/XfDxvK5tYXSh9BN+yn1gXHcPYh7cAEayYZEIdJN+mOqc2OxQFz1yiQ949W5Z7yq3zHFE/VD3+ZzBGb0ojWjs3tI8stEvuRQ/DyMPUBlAacugMqKcwzRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PQslu04IcMLjqSJ/SnfXnBzneVDDJq1tiGbcYzbjs+A=;
 b=d4XNOJ500oGANdzi4Z0Ty3+OtQAUKQQxuapmdIU+JrMoobRpmPB0GsUrjrg/8PhK5Xv3YWwbGM0FfTmm50y4l5wqmfMDPeKCzTiUBaHYQktNfPUg9CJvzHsunW46laFfLKtiiKsrcLfnhPnDVOXEObJyRaSF3LPKfVNPeLA/ASEun7DeMCyweNriSFvrZPrL/xsPmaEDm7s2YItn5VrNpXxFz7yUGvIoVQWOcYDK/jAUbLFNEa0FrGIivcLt2rbxmNodfPZxeNR/11kp+yl0KYhKS9oyx+i6hYyFPY5mPWjpFF81a6P7cxzhaJueaVWHBODGKN8Gjcvj15wbVlxEIg==
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4180.namprd12.prod.outlook.com (2603:10b6:a03:213::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 11 Mar
 2021 06:13:04 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b0c7:dacb:8412:19e5]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b0c7:dacb:8412:19e5%5]) with mapi id 15.20.3912.031; Thu, 11 Mar 2021
 06:13:04 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     ze wang <wangze712@gmail.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: mlx5 sub function issue
Thread-Topic: mlx5 sub function issue
Thread-Index: AQHXE72y2+GYMtRR80igRDiiJTpnUap5iw/wgAAk5ICAAI11AIAAvOWAgACfSACAAV6HAIABWi1Q
Date:   Thu, 11 Mar 2021 06:13:04 +0000
Message-ID: <BY5PR12MB4322D16AEC0877440456CD50DC909@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <CANS1P8H8sDGUzQEh_LEFVi=6tUZzVxAty9_OKWAs4CU67wdLeg@mail.gmail.com>
 <BY5PR12MB43226FF17791F6365812D028DC939@BY5PR12MB4322.namprd12.prod.outlook.com>
 <CANS1P8E8uPpR+SN4Qs9so_3Lve3p2jxsRg_3Grg5JBK5m55=Tw@mail.gmail.com>
 <b026b2c8-fdd5-d0fc-f0a6-42aa7e9d26f8@gmail.com>
 <CANS1P8EHJ+ZSZT8MT43PzXH6bhZ6FVhrQ_sxxFWbWTvzyT+3rA@mail.gmail.com>
 <BY5PR12MB4322F7A218F0C0D2BBF99EF1DC929@BY5PR12MB4322.namprd12.prod.outlook.com>
 <CANS1P8ENKYGnRk44P7bT4fC4aZtfsdyPJ8hOv0CV9eXig03gJA@mail.gmail.com>
In-Reply-To: <CANS1P8ENKYGnRk44P7bT4fC4aZtfsdyPJ8hOv0CV9eXig03gJA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [122.166.131.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1b409cb7-6201-442b-54ff-08d8e454bb8f
x-ms-traffictypediagnostic: BY5PR12MB4180:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB4180D98CC43BFED0D93C3CB8DC909@BY5PR12MB4180.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AHcpPxvNDvREhVQTkUV85VT5DIFNvud7tRfwCHXTWi9rcWp9PYZfSmDPXK9b/CvZWZRdONTXJ2oTQPo2aEpRXYd0pjOKZmVbZVt/vPQ15LkGV41qqogI9zOidsU2k+hJPs5ttRh52yNOivb/OCcbpZ1WclzxK/ryx2YmxiAvuEnBMYzLf/qgvbCTju1IyZQErKIW5gPvi8S12XB2WrOV0NyK7YBbbnUSoTDG2I7qyDexPx96rI5EwOnX79KF9OSzB2QAMRLa08C7+zNyQnAzcN7HCDxM1NDhiVYa6vf+Q1P0h88J0NO6rq1A49RjkJuamk12bx357LE7WbFRVvXBIK82TKOYcUnAVmJ7ImfmjQeR9KT2CY8y0yG4yXItbxZHfO4/lhRu3c3TS629ukacleYBwDJhUD+JfHxqvaGDuoZLIibeBiBKV2m4NoSjgHhBYH1FGWcE8Ey1OopqZsmwbUZDGzAFPkrRrDzSRhbsGkMmiZ4yj8YkLp9nGEQ47KubSMl5KpHZGev62rwalYuh1Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(346002)(376002)(396003)(6916009)(186003)(53546011)(5660300002)(83380400001)(33656002)(478600001)(8676002)(6506007)(9686003)(4326008)(26005)(7696005)(71200400001)(76116006)(55016002)(54906003)(2906002)(8936002)(66446008)(64756008)(66556008)(66946007)(66476007)(86362001)(316002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 1ebDjUPkfNPk3qizbAZ5YGa0jY8QGresm7/KrbPRNc+HSFr0YQfGG9RcSNRsKN9cxt7UDSfHSS03+rpUpYzwlfOMhqVKxh44XgP1deJXqYYDEiySYrrQXt6t286dAWFyEntmPsHeE1HfQYLSXHkPudvKNEkfKZcle3hrnbQcOS1uliI/avNFR3VWv74Iim6vCQ5agxOjPRzu9Frh/2K8kZxD3UkUOGLLUkmywpB9K0Bl7znU20YvEuwygWcd1yFkG4poZylNXRIdSq/AOFxv66lOlOlXOSBwjNtkUbIFTf1i8c+5q9Lu8xBKdiBJG8GN1GR8ysyVecsRR5m/IOwJ3S2RA1taMLqIdXG+RLC7cztKHIaImDY/h7nSiclqE1lm2bt2UyVdcbKdTht0OFCxYdoUfPqwpulhlO0QKCBy6EikL0vRhaX8oMj/VctBs2qhV6THyFxpSxK3yWwNAO3Aujo0M20L7H4l4ZQrQq7IQplDjXkZh4zlZjC3gczKgr8lv3BJxyRD+oj7DFwDlTKAMhfyqvNyNBLNi2/f7zjcZZ/phlNbipLGc33d1pSToMkwrOSd5L3ovKJ7GElVLsS923Sw9N9owOHmwHkjL2Fm84ZyX4RxApKU4AWWM6zv1CLM/5S5GRZ7IvQl2uSYJ/OsST4ITY13Ks0gP2qhDplX7WLl9qia0RwJSF9tDAZ658Fk+uIGkJizu7xTIfLQm2z4ZS+4Nst6rwxmyKjo5Jyt/thfvyBzv+Nu20yDDmGlBYpF
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b409cb7-6201-442b-54ff-08d8e454bb8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2021 06:13:04.6540
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U02SfHr74eOjynscwk0+y4sglRCdL2K43BT5JbqJ3V6Icxw1DAYW98AHXnEXUipd+dvzPjcJ1L4hmudRGNiZUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgWmUgd2FuZywNCg0KPiBGcm9tOiB6ZSB3YW5nIDx3YW5nemU3MTJAZ21haWwuY29tPg0KPiBT
ZW50OiBXZWRuZXNkYXksIE1hcmNoIDEwLCAyMDIxIDI6NTkgUE0NCj4gDQo+IEhpIFBhcmF2LA0K
PiAgICAgICBUaGFua3MgZm9yIHlvdXIgaGVscC4gSSBkaWQgZW5hYmxlZCBWRnMsIGFuZCBhZnRl
ciB0dXJuaW5nIG9mZiBTUi1JT1YsIGl0DQo+IHdvcmtzLg0KSGFwcHkgdG8gaGVhciB0aGF0Lg0K
DQo+IE5vdyB0aGUgZWFjaCBQRiBjYW4gY3JlYXRlIDI1NSBTRnMsIHdoaWNoIGlzIHByb2JhYmx5
IGVub3VnaCBmb3IgdXMuDQo+IElzIGl0IGNvbnZlbmllbnQNCj4gdG8gcmV2ZWFsIGhvdyBtYW55
IFNGcyBjYW4gYmUgY3JlYXRlZCBhdCBtb3N0Pw0KPiANClllcywgaXQgaXMuIFdlIHdpbGwgYmUg
ZG9pbmcgdGhpcywgbW9zdGx5IGFzIGRldmxpbmsgcmVzb3VyY2UgYXMgZGlzY3Vzc2VkIGxhc3Qg
dGltZSB3aXRoIEphY29iLCBEYXZpZCwgU2FtdWRyYWxhIGluIHBhc3QuDQpJdCBpcyBpbiBteSB0
b2RvIGxpc3QgYWxyZWFkeS4gVW50aWwgaXRzIGF2YWlsYWJsZSwgcGxlYXNlIHVzZSB0aGUgZXhp
c3RpbmcgdG9vbGluZy4NCg0KPiBaZSBXYW5nDQo+IA0KPiBQYXJhdiBQYW5kaXQgPHBhcmF2QG52
aWRpYS5jb20+IOS6jjIwMjHlubQz5pyIOeaXpeWRqOS6jCDkuIvljYg4OjM25YaZ6YGT77yaDQo+
ID4NCj4gPiBIaSBaZSBXYW5nLA0KPiA+DQo+ID4gPiBGcm9tOiB6ZSB3YW5nIDx3YW5nemU3MTJA
Z21haWwuY29tPg0KPiA+ID4gU2VudDogVHVlc2RheSwgTWFyY2ggOSwgMjAyMSA4OjM0IEFNDQo+
ID4gPg0KPiA+ID4gSGkgRGF2aWQsDQo+ID4gPiAgICAgICBJIGNhbiBzZWUgdGhhdCB0aGUgdmFy
aWFibGUgc2V0dGluZ3MgYXJlIGluIGVmZmVjdO+8mg0KPiA+ID4gIyBtbHhjb25maWcgLWQgYjM6
MDAuMCBzIFBGX0JBUjJfRU5BQkxFPTAgUEVSX1BGX05VTV9TRj0xDQo+ID4gPiBQRl9TRl9CQVJf
U0laRT04ICMgbWx4Y29uZmlnIC1kIGIzOjAwLjAgcyBQRVJfUEZfTlVNX1NGPTENCj4gPiA+IFBG
X1RPVEFMX1NGPTE5MiBQRl9TRl9CQVJfU0laRT04ICMgbWx4Y29uZmlnIC1kIGIzOjAwLjEgcw0K
PiA+ID4gUEVSX1BGX05VTV9TRj0xIFBGX1RPVEFMX1NGPTE5MiBQRl9TRl9CQVJfU0laRT04DQo+
ID4gPg0KPiA+ID4gYWZ0ZXIgY29sZCByZWJvb3Q6DQo+ID4gPiAjIG1seGNvbmZpZyAtZCBiMzow
MC4wIHF8Z3JlcCBCQVINCj4gPiA+IFBGX0JBUjJfRU5BQkxFICAgICAgICAgICAgICAgICAgICAg
ICAgICAgRmFsc2UoMCkNCj4gPiA+ICMgbWx4Y29uZmlnIC1kIGIzOjAwLjAgcXxncmVwIFNGDQo+
ID4gPiBEZXNjcmlwdGlvbjogICAgQ29ubmVjdFgtNiBEeCBFTiBhZGFwdGVyIGNhcmQ7IDI1R2JF
OyBEdWFsLXBvcnQgU0ZQMjg7DQo+ID4gPiBQQ0llIDQuMCB4ODsgQ3J5cHRvIGFuZCBTZWN1cmUg
Qm9vdA0KPiA+ID4gICAgICAgICAgUEVSX1BGX05VTV9TRiAgICAgICAgICAgICAgICAgICBUcnVl
KDEpDQo+ID4gPiAgICAgICAgICBQRl9UT1RBTF9TRiAgICAgICAgICAgICAgICAgICAgICAgICAx
OTINCj4gPiA+ICAgICAgICAgIFBGX1NGX0JBUl9TSVpFICAgICAgICAgICAgICAgICAgIDgNCj4g
PiA+ICMgbWx4Y29uZmlnIC1kIGIzOjAwLjEgcXxncmVwIFNGDQo+ID4gPiBEZXNjcmlwdGlvbjog
ICAgQ29ubmVjdFgtNiBEeCBFTiBhZGFwdGVyIGNhcmQ7IDI1R2JFOyBEdWFsLXBvcnQgU0ZQMjg7
DQo+ID4gPiBQQ0llIDQuMCB4ODsgQ3J5cHRvIGFuZCBTZWN1cmUgQm9vdA0KPiA+ID4gICAgICAg
ICAgUEVSX1BGX05VTV9TRiAgICAgICAgICAgICAgICAgIFRydWUoMSkNCj4gPiA+ICAgICAgICAg
IFBGX1RPVEFMX1NGICAgICAgICAgICAgICAgICAgICAgICAgMTkyDQo+ID4gPiAgICAgICAgICBQ
Rl9TRl9CQVJfU0laRSAgICAgICAgICAgICAgICAgIDgNCj4gPiA+DQo+ID4gPiBJIHRyaWVkIHRv
IGNyZWF0ZSBhcyBtYW55IFNGIGFzIHBvc3NpYmxlLCB0aGVuIEkgZm91bmQgZWFjaCBQRiBjYW4N
Cj4gPiA+IGNyZWF0ZSB1cCB0bw0KPiA+ID4gMTMyIFNGcy4gSSB3YW50IHRvIGNvbmZpcm0gdGhl
IG1heGltdW0gbnVtYmVyIG9mIFNGcyB0aGF0DQo+ID4gPiBDWDYgY2FuIGNyZWF0ZS4gSWYgdGhl
IG1mdCB2ZXJzaW9uIGlzIGNvcnJlY3QsIGNhbiBJIHRoaW5rIHRoYXQgQ1g2DQo+ID4gPiBjYW4g
Y3JlYXRlIHVwIHRvIDEzMiBTRnMgcGVyIFBGPw0KPiA+IERvICB5b3UgaGF2ZSBWRnMgZW5hYmxl
ZCBvbiB0aGUgc3lzdGVtPyBtbHhjb25maWcgLWQgYjM6MDAuMCBxIHwgZ3JlcA0KPiA+IFZGIElm
IHNvLCBwbGVhc2UgZGlzYWJsZSBTUklPVi4NCj4gPg0KPiA+ID4NCj4gPiA+IERhdmlkIEFoZXJu
IDxkc2FoZXJuQGdtYWlsLmNvbT4g5LqOMjAyMeW5tDPmnIg45pel5ZGo5LiAIOS4i+WNiDExOjQ4
5YaZDQo+IOmBkw0KPiA+ID4g77yaDQo+ID4gPiA+DQo+ID4gPiA+IE9uIDMvOC8yMSAxMjoyMSBB
TSwgemUgd2FuZyB3cm90ZToNCj4gPiA+ID4gPiBtbHhjb25maWcgdG9vbCBmcm9tIG1mdCB0b29s
cyB2ZXJzaW9uIDQuMTYuNTIgb3IgaGlnaGVyIHRvIHNldA0KPiA+ID4gPiA+IG51bWJlciBvZg0K
PiA+ID4gU0YuDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBtbHhjb25maWcgLWQgYjM6MDAuMCAgUEZf
QkFSMl9FTkFCTEU9MCBQRVJfUEZfTlVNX1NGPTENCj4gPiA+ID4gPiBQRl9TRl9CQVJfU0laRT04
IG1seGNvbmZpZyAtZCBiMzowMC4wICBQRVJfUEZfTlVNX1NGPTENCj4gPiA+ID4gPiBQRl9UT1RB
TF9TRj0xOTIgUEZfU0ZfQkFSX1NJWkU9OCBtbHhjb25maWcgLWQgYjM6MDAuMQ0KPiA+ID4gPiA+
IFBFUl9QRl9OVU1fU0Y9MSBQRl9UT1RBTF9TRj0xOTIgUEZfU0ZfQkFSX1NJWkU9OA0KPiA+ID4g
PiA+DQo+ID4gPiA+ID4gQ29sZCByZWJvb3QgcG93ZXIgY3ljbGUgb2YgdGhlIHN5c3RlbSBhcyB0
aGlzIGNoYW5nZXMgdGhlIEJBUg0KPiA+ID4gPiA+IHNpemUgaW4gZGV2aWNlDQo+ID4gPiA+ID4N
Cj4gPiA+ID4NCj4gPiA+ID4gSXMgdGhhdCBjYXBhYmlsaXR5IGdvaW5nIHRvIGJlIGFkZGVkIHRv
IGRldmxpbms/DQo=
