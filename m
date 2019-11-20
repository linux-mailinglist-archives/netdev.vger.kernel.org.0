Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18E10104016
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 16:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731420AbfKTPyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 10:54:17 -0500
Received: from mail-eopbgr720089.outbound.protection.outlook.com ([40.107.72.89]:31160
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728412AbfKTPyR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 10:54:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YqD2cznlrqUV0x49LqzVoMTrx7rh+EkW09iWBuXO3pZXQWunGct5QcNDJfttc0hKPsafhGyJ79OpqUTcOYGQeOopHG90bh8eZUFPIo6AmCC+GB34x04WAIQ6FwXqDQzblcJtjKWNMRFGiLlg6HRn1TyiKAYY/MIuexDY0xSVVFL9mVULmhUYvYz9gz0KYknIZJ7pddFk9BISITZJ7UFlqJSZYipxCss6q++DPi6RUZMvJS/mtYr0108DxZbNVeGw8Lyp96V2N4t+xgHEOkAdb+UgzVagjbRxlUsiGZ9dCr6fpmhRP5/FSF8m4uRmYuzaWD3hcUEudfcMUmjWWzi7wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lf7dPVuDhaZUiJRS47A1XJGZv3DlCLTx6vBVOc6mfYI=;
 b=NiXVYW1+se3ZScwSfRtYbZtV1uWYGc7UadbigUyl+YVxNr4MRpCik3AfvSBjEGcHnQLZREmmv69ycl3tzEuxUSBNZCwqNyPM31lBog0pfzrzyc6C3Ve5QuEBfZhtRE5Anb6NnaCDkjxDFNAJYTMQkXJiUOIF9e/+hZZoc/l+EEBzV7H+dhslElpwcRwf6LS366tLtchK6/a7P2xcrmxAVut2XQbZ8RJjQfi/tNUUlzycDHhKTGFJBfmlu8aFh0xvSnSs67bffLnVdcbR+7JN3Rm5Bm0dHwbWpiDwSKiItSqG7/HXZ+vtERvFB64lPQAnuy7MXovWrGO+a0eSeZARCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lf7dPVuDhaZUiJRS47A1XJGZv3DlCLTx6vBVOc6mfYI=;
 b=kSPyrNv1GqIENY7Ksk6PFjvrH+O3+ipmonhfweGdrM5oHeNtSjl5j6z04o/T9vqHcW1ysD7SBIAPdYaxbDO9LDaFupooo58esQ5EEYPTBPmp+KjKlHVLchdEgXWzrsVBpo57TsErxrUveyBQyiqrNIeOZumAxWPnOFjL/D/eDLY=
Received: from MN2PR02MB6400.namprd02.prod.outlook.com (52.132.173.155) by
 MN2PR02MB6815.namprd02.prod.outlook.com (52.135.49.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 20 Nov 2019 15:54:11 +0000
Received: from MN2PR02MB6400.namprd02.prod.outlook.com
 ([fe80::c413:7dde:1e89:f355]) by MN2PR02MB6400.namprd02.prod.outlook.com
 ([fe80::c413:7dde:1e89:f355%7]) with mapi id 15.20.2451.031; Wed, 20 Nov 2019
 15:54:11 +0000
From:   Appana Durga Kedareswara Rao <appanad@xilinx.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Srinivas Neeli <sneeli@xilinx.com>,
        Michal Simek <michals@xilinx.com>
CC:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        git <git@xilinx.com>,
        Naga Sureshkumar Relli <nagasure@xilinx.com>
Subject: RE: [PATCH 0/2] can: xilinx_can: Bug fixes on can driver
Thread-Topic: [PATCH 0/2] can: xilinx_can: Bug fixes on can driver
Thread-Index: AQHVn5uyLMKsi4xLzUa9hf24vHCkTKeUAJ6AgAA1G2A=
Date:   Wed, 20 Nov 2019 15:54:10 +0000
Message-ID: <MN2PR02MB64002F223821E7BD940B4E54DC4F0@MN2PR02MB6400.namprd02.prod.outlook.com>
References: <1574251865-19592-1-git-send-email-srinivas.neeli@xilinx.com>
 <e985fd5a-9b0c-f273-d28c-14515dc25e5c@pengutronix.de>
In-Reply-To: <e985fd5a-9b0c-f273-d28c-14515dc25e5c@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=appanad@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8a28c78f-40eb-4754-4f04-08d76dd1e279
x-ms-traffictypediagnostic: MN2PR02MB6815:|MN2PR02MB6815:
x-ms-exchange-purlcount: 1
x-ld-processed: 657af505-d5df-48d0-8300-c31994686c5c,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR02MB6815BD5AE9D6E3E778648EA3DC4F0@MN2PR02MB6815.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(189003)(199004)(498600001)(33656002)(107886003)(66556008)(66446008)(64756008)(66476007)(66946007)(6246003)(4326008)(486006)(3846002)(476003)(81156014)(81166006)(53546011)(6506007)(102836004)(6116002)(7696005)(8676002)(76176011)(8936002)(305945005)(7736002)(5660300002)(26005)(66066001)(52536014)(11346002)(4744005)(446003)(74316002)(110136005)(6636002)(186003)(14454004)(54906003)(966005)(2906002)(25786009)(14444005)(256004)(99286004)(55016002)(229853002)(76116006)(6306002)(71200400001)(71190400001)(9686003)(6436002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR02MB6815;H:MN2PR02MB6400.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XWb0sggiKvI4ccbdtWZt8eqFB/1G6+YTU609bOM8zAZ8Et/mGG2DpfqrqmEBNIh2QOhnd3//RuPuMAqWCnCsrY4w5A0EzG79Umrb55Cg4jyZDLBWdyR7s1wV9oXyUctwC7hKU0ZlYbFU+o3i2uUWcoS2Cg7pnL3mAV3xMrjT5r64dJCKQLOnZqi8HIgHmXJZJjzR00BOIqNx1O/zrw8cILgEgUHntw2Znbn7TkOY1ODq45GyD+FnK4VA2yQIelqattUlQ+wQaYZRJs/UU1nXe1LJkPdOXsP6acDrMqByNC50t8zD+SlRD1z32+Sh8kJICc4dhuipmq27WHggkBrYSFDPoemHulsNNo3PIXEKxbrSL6OXahzO60gex9Dml7ZTQKGmnvpqvMvpEB6Q5l6RGYCWWaeGTK8Q7y+OHLwEsWCY0nwNhMHGwnAVmqz4yjzMggW7C4PSTSaF06IOieObvI2cQzt5rvk4jgjrFigUDzI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a28c78f-40eb-4754-4f04-08d76dd1e279
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 15:54:10.8979
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cJPzW9nzmi2xxiGsK1rhL4WceVYrEUS0/dR+k+h/WIviAkpArOL2R63eWxbqGDEvdxFWfRjw1mW3246FG7N/Zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB6815
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyYywNCg0KPiANCj4gT24gMTEvMjAvMTkgMToxMSBQTSwgU3Jpbml2YXMgTmVlbGkgd3Jv
dGU6DQo+ID4gVGhpcyBwYXRjaCBzZXJpZXMgZG9lcyB0aGUgZm9sbG93aW5nOg0KPiA+IC1za2lw
IHByaW50aW5nIGVycm9yIG1lc3NhZ2Ugb24gZGVmZXJyZWQgcHJvYmUgLUZpeCB1c2FnZSBvZiBz
a2INCj4gPiBtZW1vcnkNCj4gDQo+IEJUVzogSSdtIGxvb2tpbmcgZm9yIGFuIG9mZmljaWFsIE1h
aW50YWluZXIgZm9yIHRoZSB4bGlueF9jYW4gZHJpdmVyLg0KPiANCj4gVGhlIE1haW50YWluZXIg
d2lsbCBnZXQgYW4gZW50cnkgaW4gdGhlIE1BSU5UQUlORVJTIGZpbGUsIHNob3VsZCB0ZXN0IG5l
dw0KPiBwYXRjaGVzIGFuZCBnaXZlIFJldmlld2VkLWJ5cy4NCj4gDQo+IElzIHRoZXJlIGEgdm9s
dW50ZWVyPw0KDQpTdXJlIHdpbGwgdm9sdW50ZWVyIHRoZSBtYWludGFpbmVyc2hpcCwgd2lsbCBz
ZW5kIHRoZSBtYWludGFpbmVyIGZyYWdtZW50IHBhdGNoLi4uIA0KDQpSZWdhcmRzLA0KS2VkYXIu
DQo+IA0KPiByZWdhcmRzLA0KPiBNYXJjDQo+IA0KPiAtLQ0KPiBQZW5ndXRyb25peCBlLksuICAg
ICAgICAgICAgICAgICB8IE1hcmMgS2xlaW5lLUJ1ZGRlICAgICAgICAgICB8DQo+IEVtYmVkZGVk
IExpbnV4ICAgICAgICAgICAgICAgICAgIHwgaHR0cHM6Ly93d3cucGVuZ3V0cm9uaXguZGUgIHwN
Cj4gVmVydHJldHVuZyBXZXN0L0RvcnRtdW5kICAgICAgICAgfCBQaG9uZTogKzQ5LTIzMS0yODI2
LTkyNCAgICAgfA0KPiBBbXRzZ2VyaWNodCBIaWxkZXNoZWltLCBIUkEgMjY4NiB8IEZheDogICAr
NDktNTEyMS0yMDY5MTctNTU1NSB8DQoNCg==
