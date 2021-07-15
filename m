Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431E93C9DF3
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 13:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbhGOLrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 07:47:23 -0400
Received: from mail-eopbgr60056.outbound.protection.outlook.com ([40.107.6.56]:64242
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229710AbhGOLrX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 07:47:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OGv8be+56qnuU8gHQGRlbiEp2mqEv8sT+kHQPk7fH+h5ITwty1c4OLmGWeBIIZx1dF4a+eF6Br+1SkCgLUVDWlDz2qGE/AMFVJfz7vCzXrabmVdHgrTtDGcdt641nq3raFg0KwPt7QNqcfF/6j5kUVcbWNC5C+FsvMgz2p2FBgwVAnX8SugvOWhvalPI3oS8r/biTlJqv13e60ONV9mDZUgjOjCBAlEXmPzpX+yTvjxPiTM7snJmEkj3u1lHiT8SATGXB+mdvVGWlCgR0Nq8fpiLUrLkDMR+OQtp5Y3xrluTqzLA1Enr/KctE7KGMAkqeaYMoiMwAJ3A+YKtUeZfig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=77x8S9V+D3USBD8U0s/ux51kDGNf7dT/t5UNCTAijlw=;
 b=FYp8/uodmF94RTaCUaZ/8UTqqQEQlXJTN3Wu+3cIQNuj0We4i0YMy63lQpP8Gh/PsxOqjTbXQeAX3ohEf00bWUchCFmKX6PXhKHToIkyzNYr5k2CezmJn9xV56tXeh2GJAQCstz/+5QBb/fc4lnaYRbFTix31ZHk4gxqr1bFL38EQIOrwuuPhxZQiyhxtlq1fgno93PsnEuVXnt6gDr+tvSC/YuP+pZouwCHNEb0QmtyrH798nzwLXxVmEKZDoQFDQgcPgZpNSqLmIQWWbRRMGcMTB1uhnZbgdCu2AzPaFTICSYVCyewBLnh3Dm9PHjhwHToW6W3qS4eIEQq3zdmgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=77x8S9V+D3USBD8U0s/ux51kDGNf7dT/t5UNCTAijlw=;
 b=m3MROLNTspu0byNnovI4WLpBrxsn26UJqIn6tRZ2iGH7ly5j1vVxjf3dl0FooswNRpHiYnDGdrWpPAGu0LaBbMgk+F3umXejFkIaQvMcg/AyR4AC1zTfMGvDKPkCwJVuPMf8CZprDwpwltx7WEQcgDo9jSfgko2u+fFCqFuLlCE=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6794.eurprd04.prod.outlook.com (2603:10a6:10:11b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Thu, 15 Jul
 2021 11:44:28 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4331.021; Thu, 15 Jul 2021
 11:44:28 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Dong Aisheng <dongas86@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
CC:     Aisheng Dong <aisheng.dong@nxp.com>,
        devicetree <devicetree@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 1/7] dt-bindings: can: flexcan: fix imx8mp compatbile
Thread-Topic: [PATCH 1/7] dt-bindings: can: flexcan: fix imx8mp compatbile
Thread-Index: AQHXeVMe6xPSccZQPEq2Cy9PpYaNf6tDwFGAgAAaOQCAAAEH4IAABOAAgAAIGwCAAAG2IA==
Date:   Thu, 15 Jul 2021 11:44:28 +0000
Message-ID: <DB8PR04MB679513E50585817AF8E2C7E7E6129@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210715082536.1882077-1-aisheng.dong@nxp.com>
 <20210715082536.1882077-2-aisheng.dong@nxp.com>
 <20210715091207.gkd73vh3w67ccm4q@pengutronix.de>
 <CAA+hA=QDJhf_LnBZCiKE-FbUNciX4bmgmrvft8Y-vkB9Lguj=w@mail.gmail.com>
 <DB8PR04MB6795ACFCCB64354C8E810EE8E6129@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210715110706.ysktvpzzaqaiimpl@pengutronix.de>
 <CAA+hA=RBysrM5qXC=gve5n8-Rm7w_Nvsf+qurYJTkWQWPmGobw@mail.gmail.com>
In-Reply-To: <CAA+hA=RBysrM5qXC=gve5n8-Rm7w_Nvsf+qurYJTkWQWPmGobw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8cab42fe-e04d-4401-d935-08d94785e708
x-ms-traffictypediagnostic: DB8PR04MB6794:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB6794D31073B6409CD596FB8DE6129@DB8PR04MB6794.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xMPz/Sh8cI8q8Gh6UftSWCwDY9y/u/MpavhW1tglqC5HM/j08qvSDHLm0rBm2GRk5deX11FBX2WS41GXxQA1W9fISr6iZdeIzqEM9f22sANH/PYrx1ahz2gqEDRi6PkM0tvHnblw3I5v9t/blj2gVM97CPH61/zofiMW3VEVR3mWyynUB8nZyQqwsKIq++RSq663pCSlwsH+kkajqiLNfA7pYweLXRw7/yxDCJgjzOrmdx2hiYNBRj0PeKP+QEKuSGvlgQXLOTYxf4ohmRmd7rNCV++WJQGuwF81MmdjaoZbQBPSnKzUpQzQBA15tlQ5FM4yr+yqHdNhc6UxD/LLPSf4KPYSBYfV/TE+KepVHix2OewdKHCLjK5KBCL6cT9GNSzMzIipLCIsgn6ta3DAWEYbB45+IcfdDjdHCRbt44BZpXSK7rbCbILi9S3kllglfnoUF2eHAxRmM70fMMzYjH93P25WnfxvuKaKEOmwIfQSRDvL1U5K7GQiDULEpj8aVnEOiMCL4uvvt+sVgpNe73ejCyxd67Luo7gmJ0h24KNidAaZQaPk/KR8b3PHcNofIPq38tjLYLV5p4+apF+8fMRKy49hBtmWxHw4eo+NfaxsGJ7RnhFTaA0wPYwYN11PeEnVUic5bpScs41HIGCE7SqwZPMtUCQ/HZ6P5fnZusq3F/F2ChFhPd67WyuY69BCF9uD0vmHmpa5apWNvutKoI7AVMdz9gnPxcmkTLuoBwEY4hWm8YcvBSwF098ZLLiVwAerQyeqa9dGlTSENJHyPpZG0XUw0FRn53R/LzJLRMMO779OEwY0Dd6SINX4J57u
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(39850400004)(396003)(366004)(45080400002)(52536014)(122000001)(38100700002)(966005)(6506007)(55016002)(110136005)(71200400001)(478600001)(316002)(54906003)(2906002)(86362001)(33656002)(8936002)(9686003)(83380400001)(66946007)(4326008)(66446008)(76116006)(66556008)(8676002)(26005)(64756008)(5660300002)(7696005)(53546011)(186003)(66476007)(32563001)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?YTZpaWx5WDNGeU5xUHYyWnFGZjF0Vi90d1dka1VDN1NSVzBvb29JdTVBU1dS?=
 =?gb2312?B?Yk5HVFlacUJCdFBsZmxGYlhxMkVvbmFCb25RRnRXWGJtUlo1U0QrNjI1S21Z?=
 =?gb2312?B?STlEM2FPVU1CVkhmb1VLL2dNTm5MblN4R2pZMnFhUDIrU3ZyQ3E2MlVjc3N5?=
 =?gb2312?B?Q1NzTEp1NjJHNVBOUnBuWDNQTVpTeWhSaFVVbnBnNnVDQ1NTbTNhaGNGdnVK?=
 =?gb2312?B?MHJabTZ1VjhRVit6NXBlTHZuQUxFWWd1V043M2NKYzdCbCthZGhYMzhqQW5E?=
 =?gb2312?B?VFI2em0vaHgvRHBFV1hNNjdSeUpXK0RzVUpXMEEyYXk4NXd0aEt4Q1p0cUlw?=
 =?gb2312?B?ZjNMRUhmUVBYajR2MmFkYWpqV3UzallkRlo5WGV4dElUdGQ4WEdldGQ3Skhm?=
 =?gb2312?B?S1VPTnJiaDM4QitkZ283UW9kQjFYM3pQSDlZSzNvZW4wWk5XWUU1SXE4Z2RO?=
 =?gb2312?B?dnNnSXVsOVNQYmo4MVNZWEtuVmFmZXIvZy95bXM0Q2tVTllMR2pRQm54K0k1?=
 =?gb2312?B?amdRZkFWYmVhUmZWYmJuZzhuWFlyVVlDVTZTNk8rNlcram5XWnhQajlrSUJy?=
 =?gb2312?B?NCt5Tm05RzFTZU5TUVY3K1gzazJlSEhpMG1SN0ZVeXFlZ2ZuR1M4K0ZVOGZw?=
 =?gb2312?B?OUhWRGdSMG40dW03TzlvclpoSFJiRnpKdzYvKzhRN0RwYVFqcjQ1VWRVM2tm?=
 =?gb2312?B?Qnh0b0R2QzdSWEFTOTlSZFRDSjcxSithNi8yQUhqTytXUG9UY1ZuaVZ0MVVy?=
 =?gb2312?B?ajd3bHNSNGdFbWJvUXduejdWQVU3VXdJdU0vNEdla1FSTjZXazZ6Nm84REVx?=
 =?gb2312?B?YmpPU2U1UW1OQTdsVnVDUmFpY2ZZeEtGbDR5R0JSRXE0c1IyUEd5TFdwdkRh?=
 =?gb2312?B?ck9vcnVrc3lkN3lSV1A4QU10eE8xZi9xQ0hyakw5cnlNYk56WE1nR0VDMXFt?=
 =?gb2312?B?bjNjN25VWkFIMmZjZUtOeUZMdzBudWxISlZCb1BvSUdHMzlxZUFSbmNjdU1i?=
 =?gb2312?B?UWxKZVNtZ2RGYXVycTM5eTlSRmp6NVpWZWFxYmdVOTdjL2xtVnFjMVFZR1cx?=
 =?gb2312?B?ZWlGc3AyN2tIZ1l0dDh5WXhZZ3pCTUdhTHVNN2JGQUhGUVlSSUsvOU53Tmx2?=
 =?gb2312?B?NXNqN3YvY1FHdlBvT2Jtc3B1L1I2Qm56dFNaYThvWEFRNHo5ZVpwVkNIV1kz?=
 =?gb2312?B?UncwZnFPUG51NzhBYVByZTVmS0tLWWhrYkNRUTJBS1lwMnpzLzlrMDBiL3Vn?=
 =?gb2312?B?ZHB2WHBRd2dadUJhcHFzRElpMGIzbmI4Y1hqSXFXa0NQaytNV0cxT1ZGZmdr?=
 =?gb2312?B?RjlGV0JrQ0lpVk5vTTFPc1ZYaXFoTFcwMDJiaUpGV1FQQ3lsTG10clNWWkNs?=
 =?gb2312?B?aGd2VWkyaFFLbTVUZjlWU0JqTnFTUVZXNSthbUhEUmJQd2gzcDluNWpFY1gx?=
 =?gb2312?B?b0hYaTZaU0VnSVZJRHBPcGE1bFQyTWtjV3VBNGxMaGU0UlVCRVRHdnZkbU12?=
 =?gb2312?B?VnM1RWxWN3U3ZkVjaEFMZklsMWk1U1ljRlJFMHUvb3VLZmc1YnByQktYZ0gy?=
 =?gb2312?B?aThybFpyK3VwcEpIM25VWkNIellxS0VDNzI5bHM3S2x1bC9CbmluUTJ6Nksw?=
 =?gb2312?B?c0htTnpNMXJqUkJleGladElFaGlPS0xEdTQyY0VES00yeTJjNUp4d0pyb1hq?=
 =?gb2312?B?ZVhXemxKODlzamtWOVNPV2h5R0hvb1BzdFdxdTJ2QmNUN2ljaCtDdHc3Y1Vw?=
 =?gb2312?Q?dpD1oNNCU003nNqjQyeSO6fnFSCCt0+cCXV16Wm?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cab42fe-e04d-4401-d935-08d94785e708
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2021 11:44:28.0501
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ESs5H3whNsbyM0znrMfutpTaCPK2xzPQYRqIbwz21DHatrZT5XWatGx1I0yXBULyhTfjHwPYiECnseGSyY8Yug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6794
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IERvbmcgQWlzaGVuZyA8ZG9u
Z2FzODZAZ21haWwuY29tPg0KPiBTZW50OiAyMDIxxOo31MIxNcjVIDE5OjM2DQo+IFRvOiBNYXJj
IEtsZWluZS1CdWRkZSA8bWtsQHBlbmd1dHJvbml4LmRlPg0KPiBDYzogSm9ha2ltIFpoYW5nIDxx
aWFuZ3FpbmcuemhhbmdAbnhwLmNvbT47IEFpc2hlbmcgRG9uZw0KPiA8YWlzaGVuZy5kb25nQG54
cC5jb20+OyBkZXZpY2V0cmVlIDxkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZz47DQo+IG1vZGVy
YXRlZCBsaXN0OkFSTS9GUkVFU0NBTEUgSU1YIC8gTVhDIEFSTSBBUkNISVRFQ1RVUkUNCj4gPGxp
bnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZz47IGRsLWxpbnV4LWlteCA8bGludXgt
aW14QG54cC5jb20+Ow0KPiBTYXNjaGEgSGF1ZXIgPGtlcm5lbEBwZW5ndXRyb25peC5kZT47IFJv
YiBIZXJyaW5nIDxyb2JoK2R0QGtlcm5lbC5vcmc+Ow0KPiBTaGF3biBHdW8gPHNoYXduZ3VvQGtl
cm5lbC5vcmc+OyBsaW51eC1jYW5Admdlci5rZXJuZWwub3JnOw0KPiBuZXRkZXZAdmdlci5rZXJu
ZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMS83XSBkdC1iaW5kaW5nczogY2FuOiBmbGV4
Y2FuOiBmaXggaW14OG1wIGNvbXBhdGJpbGUNCj4gDQo+IE9uIFRodSwgSnVsIDE1LCAyMDIxIGF0
IDc6MDcgUE0gTWFyYyBLbGVpbmUtQnVkZGUgPG1rbEBwZW5ndXRyb25peC5kZT4NCj4gd3JvdGU6
DQo+ID4NCj4gPiBPbiAxNS4wNy4yMDIxIDExOjAwOjA3LCBKb2FraW0gWmhhbmcgd3JvdGU6DQo+
ID4gPiA+IEkgY2hlY2tlZCB3aXRoIEpvYWtpbSB0aGF0IHRoZSBmbGV4Y2FuIG9uIE1YOE1QIGlz
IGRlcml2ZWQgZnJvbQ0KPiA+ID4gPiBNWDZRIHdpdGggZXh0cmEgRUNDIGFkZGVkLiBNYXliZSB3
ZSBzaG91bGQgc3RpbGwga2VlcCBpdCBmcm9tIEhXIHBvaW50DQo+IG9mIHZpZXc/DQo+ID4gPg0K
PiA+ID4gU29ycnksIEFpc2hlbmcsIEkgZG91YmxlIGNoZWNrIHRoZSBoaXN0b3J5LCBhbmQgZ2V0
IHRoZSBiZWxvdyByZXN1bHRzOg0KPiA+ID4NCj4gPiA+IDhNUCByZXVzZXMgOFFYUCg4UU0pLCBl
eGNlcHQgRUNDX0VODQo+ID4gPiAoaXB2X2ZsZXhjYW4zX3N5bl8wMDYvRF9JUF9GbGV4Q0FOM19T
WU5fMDU3IHdoaWNoIGNvcnJlc3BvbmRzIHRvDQo+ID4gPiB2ZXJzaW9uIGRfaXBfZmxleGNhbjNf
c3luLjAzLjAwLjE3LjAxKQ0KPiA+DQo+ID4gQWxzbyBzZWUgY29tbWl0IG1lc3NhZ2Ugb2Y6DQo+
ID4NCj4gPiBodHRwczovL2V1cjAxLnNhZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2suY29tLz91
cmw9aHR0cHMlM0ElMkYlMkZsb3JlDQo+ID4gLmtlcm5lbC5vcmclMkZsaW51eC1jYW4lMkYyMDIw
MDkyOTIxMTU1Ny4xNDE1My0yLXFpYW5ncWluZy56aGFuZyU0MG4NCj4geHANCj4gPiAuY29tJTJG
JmFtcDtkYXRhPTA0JTdDMDElN0NxaWFuZ3FpbmcuemhhbmclNDBueHAuY29tJTdDZjVjZDg3MQ0K
PiBlMTNiMzRlOQ0KPiA+DQo+IDU4MTdiMDhkOTQ3ODUwNGFmJTdDNjg2ZWExZDNiYzJiNGM2ZmE5
MmNkOTljNWMzMDE2MzUlN0MwJTdDMSU3Qw0KPiA2Mzc2MTk0DQo+ID4NCj4gNTg4OTM2ODAxNDYl
N0NVbmtub3duJTdDVFdGcGJHWnNiM2Q4ZXlKV0lqb2lNQzR3TGpBd01EQWlMQ0pRSWoNCj4gb2lW
Mmx1TXoNCj4gPg0KPiBJaUxDSkJUaUk2SWsxaGFXd2lMQ0pYVkNJNk1uMCUzRCU3QzMwMDAmYW1w
O3NkYXRhPVl3SDN2RCUyRnRJb2w1DQo+IE9YUEhQTQ0KPiA+IFZiaVZDTFRDN2dvd09kSVAzSWgx
bEJIaDAlM0QmYW1wO3Jlc2VydmVkPTANCj4gPg0KPiA+ID4gSSBwcmVmZXIgdG8gY2hhbmdlIHRo
ZSBkdHNpIGFzIE1hYyBzdWdnZXN0ZWQgaWYgcG9zc2libGUsIHNoYWxsIEkNCj4gPiA+IHNlbmQg
YSBmaXggcGF0Y2g/DQo+ID4NCj4gPiBNYWtlIGl0IHNvIQ0KPiANCj4gVGhlbiBzaG91bGQgaXQg
YmUgImZzbCxpbXg4bXAtZmxleGNhbiIsICJmc2wsaW14OHF4cC1mbGV4Y2FuIiByYXRoZXIgdGhh
biBvbmx5DQo+IGRyb3AgImZzbCxpbXg2cS1mbGV4Y2FuIj8NCg0KTm8sIEkgd2lsbCBvbmx5IHVz
ZSAiIGZzbCxpbXg4bXAtZmxleGNhbiIgdG8gYXZvaWQgRUNDIGltcGFjdC4NCg0KQmVzdCBSZWdh
cmRzLA0KSm9ha2ltIFpoYW5nDQo+IFJlZ2FyZHMNCj4gQWlzaGVuZw0KPiANCj4gPg0KPiA+IHJl
Z2FyZHMsDQo+ID4gTWFyYw0KPiA+DQo+ID4gLS0NCj4gPiBQZW5ndXRyb25peCBlLksuICAgICAg
ICAgICAgICAgICB8IE1hcmMgS2xlaW5lLUJ1ZGRlICAgICAgICAgICB8DQo+ID4gRW1iZWRkZWQg
TGludXggICAgICAgICAgICAgICAgICAgfA0KPiBodHRwczovL2V1cjAxLnNhZmVsaW5rcy5wcm90
ZWN0aW9uLm91dGxvb2suY29tLz91cmw9aHR0cHMlM0ElMkYlMkZ3d3cucA0KPiBlbmd1dHJvbml4
LmRlJTJGJmFtcDtkYXRhPTA0JTdDMDElN0NxaWFuZ3FpbmcuemhhbmclNDBueHAuY29tJTdDZg0K
PiA1Y2Q4NzFlMTNiMzRlOTU4MTdiMDhkOTQ3ODUwNGFmJTdDNjg2ZWExZDNiYzJiNGM2ZmE5MmNk
OTljNWMzMDE2Mw0KPiA1JTdDMCU3QzElN0M2Mzc2MTk0NTg4OTM2ODAxNDYlN0NVbmtub3duJTdD
VFdGcGJHWnNiM2Q4ZXlKV0kNCj4gam9pTUM0d0xqQXdNREFpTENKUUlqb2lWMmx1TXpJaUxDSkJU
aUk2SWsxaGFXd2lMQ0pYVkNJNk1uMCUzRCU3QzMNCj4gMDAwJmFtcDtzZGF0YT1zb0xkNTNoR0Rj
eHRGNDJBako3dTVrOVRUJTJGc1p0NlRHJTJCbGp3NHJ2dGR5NCUzRCYNCj4gYW1wO3Jlc2VydmVk
PTAgIHwNCj4gPiBWZXJ0cmV0dW5nIFdlc3QvRG9ydG11bmQgICAgICAgICB8IFBob25lOiArNDkt
MjMxLTI4MjYtOTI0ICAgICB8DQo+ID4gQW10c2dlcmljaHQgSGlsZGVzaGVpbSwgSFJBIDI2ODYg
fCBGYXg6ICAgKzQ5LTUxMjEtMjA2OTE3LTU1NTUgfA0K
