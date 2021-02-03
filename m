Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D86530E3F2
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 21:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbhBCUPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 15:15:51 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:47081 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232076AbhBCUPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 15:15:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1612383338; x=1643919338;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oWW/0a0TRKdHla7Ql7JEyPWxq42jERQK19mGDMKG1ns=;
  b=1qkbpnYd07r+WPG+ywtJI/zvvPiGG7OqKdaEPNZRPgsHYAvNy11ZCMOf
   g2+t+JPOIbav6CxcwOUuBmm/IPK54TxCQujCt288xgpD/xuYgJa/Y10lh
   SRdt193UU/ItjCLF6bbnXyb1NUM4vnUiprvPqHc2Ede6NLMxKy9r6PW1V
   dPdeNnq8A7+For/NHb7Q2U2qrT5RYyQaJ8YB61us5lkDlHe1Z282xb45k
   ccKfYnfRDx232u8MnKssouVv2s8Nfvl/FI8bim008+znoyY+O7FK/SI88
   QL+UxaYMLxa7Lh374tNjs5XUFnqo6+7a0j3/QEMYjOlUhUT5kgcXbLmic
   w==;
IronPort-SDR: RrH5Ahm9OA8L1c4MPUvDjuZo/8ELZPZb6rCC+RfiGwIYzQpoj8S2Cu4o1kEEzKBe7k8CXJPtF+
 6un8h+6b9bPLBQq1ScIaxxnC2kVMkfWffR+X/SJHVJW8A1WUpterE7+Z9pvrRo+JDepc6O+XAN
 m8B9nkefD2ShOahmAuDVn6TIUP607Nkm3SU2FUXspdPh14xwzHjldkn64+hWhUke7fCSINXXyh
 +9Bu7QepPH1ke/ITR4Ite/kurOKOWSQbIxN68lCVvojWxEljeAR43sEvkcf42C8Qx/FrerCfZr
 Tkc=
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="107914353"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Feb 2021 13:14:22 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 3 Feb 2021 13:14:21 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Wed, 3 Feb 2021 13:14:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B5TEmW45wk28SoxVvJIXAGnC2IrBY5u2ZDxwYGQNIk+8iLGbqMugLlBFZCbn8BAIwR3TXTxEDvG9S2+MLkRA8UDs1eoNo3XUNqkuoyXcg6bDX1WV9aFpSWqNLFS6BJEoBXKcRxxFL2ZpxUsKkAsxMjGvHAXU5jg0Qoi7eHuy2kQEz0W344QFMwg0sdoi0zQJb4TI0W3Ptf7yLJ1rsxCpBLthvfeUOsSoW2sIl9Xjj0lFEZ3qSmX3Dqz1GRBqDv7Fo9S1C4pRcfXdtL2OxVEWhxwHKDU4W8X7tLWMwOHT26FsPDeBK6dMrcrUi3e9gr2Sul5xq+Y2ayQ3qNG0rKuHmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oWW/0a0TRKdHla7Ql7JEyPWxq42jERQK19mGDMKG1ns=;
 b=SKztv/PW4a66VzMb57/zrGIlgL4TqkIaq4LnMpW0AsY8rIrBia58dDEspuJT/0n4JKDE64JnHI11xgfiZi2SfnWCnLtD+ykNqYOwoGnRrdFOykIyPK8Fjx2gU6IHde2je8zNwfULxZTzap1dGiW2HMvPT68ub05NX+uJnCZhkjwiDu2kigQhgtxinWtji70TIkmJoFf1U94qHucSDpDd3QQRCvgyGDLtBx4pq02MQ/6MCT28+/+7lFlUT6rP/tj6edNBNrzsW3PXA1ubjVQB/CjmLUOp8b5esmisDDiIYVodiGaepy3FRehp/vA8iLGLB7WqKddWT2QwEf8+u/fsOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oWW/0a0TRKdHla7Ql7JEyPWxq42jERQK19mGDMKG1ns=;
 b=gTdTe00gBlTg0ZHp5OUONJYVsOAAPBmy9w8xnLPgTdAHCELW/hajwxKQFEJAQuvzUeiiEnUIQ0t5Nu9YgtivlMePIwD5Yww/o5nWsUEruE9jkyeY+tBfEfYMZ9hmirA92bPALUUXRmInOLbTuN31lNCR5sZiw02OHFevEAlE3y0=
Received: from MN2PR11MB3662.namprd11.prod.outlook.com (2603:10b6:208:ee::11)
 by MN2PR11MB3821.namprd11.prod.outlook.com (2603:10b6:208:f7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Wed, 3 Feb
 2021 20:14:19 +0000
Received: from MN2PR11MB3662.namprd11.prod.outlook.com
 ([fe80::20a8:8a27:a512:d584]) by MN2PR11MB3662.namprd11.prod.outlook.com
 ([fe80::20a8:8a27:a512:d584%2]) with mapi id 15.20.3805.025; Wed, 3 Feb 2021
 20:14:19 +0000
From:   <Bryan.Whitehead@microchip.com>
To:     <thesven73@gmail.com>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <andrew@lunn.ch>, <rtgbnm@gmail.com>,
        <sbauer@blackbox.su>, <tharvey@gateworks.com>,
        <anders@ronningen.priv.no>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v1 2/6] lan743x: support rx multi-buffer packets
Thread-Topic: [PATCH net-next v1 2/6] lan743x: support rx multi-buffer packets
Thread-Index: AQHW9nhaCkvjLk51A0iB0GiaIb00V6pBUlxwgACLTYCAAbrREIADNkSAgAAVk+A=
Date:   Wed, 3 Feb 2021 20:14:19 +0000
Message-ID: <MN2PR11MB366281CC0DE98F16FE1F1D62FAB49@MN2PR11MB3662.namprd11.prod.outlook.com>
References: <20210129195240.31871-1-TheSven73@gmail.com>
 <20210129195240.31871-3-TheSven73@gmail.com>
 <MN2PR11MB3662C081B6CDB8BC1143380FFAB79@MN2PR11MB3662.namprd11.prod.outlook.com>
 <CAGngYiVvuNYC4WPCRfPOfjr98S_BGBNGjPze11AiHY9Pq1eJsA@mail.gmail.com>
 <MN2PR11MB3662E5A8E190F8F43F348E72FAB69@MN2PR11MB3662.namprd11.prod.outlook.com>
 <CAGngYiVK5=vggym5LiqvjiRVTSWscc=CgX6UPOBkZpknuLC62Q@mail.gmail.com>
In-Reply-To: <CAGngYiVK5=vggym5LiqvjiRVTSWscc=CgX6UPOBkZpknuLC62Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [47.19.18.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5224ca7a-7a26-45ee-550c-08d8c8804a21
x-ms-traffictypediagnostic: MN2PR11MB3821:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB382118E85BCFB5AEDF3085CDFAB49@MN2PR11MB3821.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 79PhF+KBws7kdO2JLWxgKBDBwwM1MnxyrJyyT/HR+Cqt5BTjX2T7qAS+qBRDOgTjaPrllmA8Xdvr73XSUghHH5SqsLLIwdyIbl1VVgyaAdR1WsqK4ZADtmUYvPVO6dXkMx7PwBowj8oW0uYWNtcJR3pAoyRMauBq2RjcHcj/HddiIQ8Z0tRJgenzoEar0O53PkcBM/vHmPGzi3lWm72Hmnu6q/eySCMN2t7ujw9jTyhdHiO7B/peArOwIdpGz1oWnCpB6hspyx6RsVVgrgQM/wq841ER/E8d0sglX7d0JatQRnSBDDZAX47TEUmTnWjSBzb6NSg+Sk70xnP7x3WfjBo4Y4XUhyKWz0tMng0yGb2B5dGhSOkBSwS6a6B6HRoA1IROKUsCQQWNrR8aoI59C4Za+yleFKLjSwdIN19gxdbyNOuVHSzGyNQsMWdLkrQ+b/e8wQPFdUKdXgX0LGxBXj6P14jl6WxTNLlk70peHmH+66UfrYbYSucHMTFlQc7Q5j0ysYtq1YK2mARxlnXDCw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3662.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(39840400004)(136003)(366004)(186003)(8676002)(86362001)(7416002)(33656002)(2906002)(66574015)(83380400001)(53546011)(26005)(71200400001)(6506007)(8936002)(478600001)(5660300002)(66476007)(316002)(64756008)(54906003)(52536014)(66446008)(7696005)(66946007)(66556008)(6916009)(4326008)(9686003)(55016002)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?VGhFSGhWMlA1L3pnOEc1TURJa2xndkRuYTcrYmk2M2ZyWVBuMkFLVVY3aG9J?=
 =?utf-8?B?Qm1GWHQrMEc4c3M4ZWppa3YwazhFLy9tOWhkWW8venIzd0NDSlNlb0pVWjk3?=
 =?utf-8?B?Zm5sWFpvQzVEL3djcWU5R3FFMlh6aUYrWEgrdThIMDk2R3pVREsvWkhXYmw2?=
 =?utf-8?B?YnBvdkNDUlczdFVqS3RvbGRWN1ZxWEVqNCtrYkxQbGU4cjZHN2ZTNzVDZUdk?=
 =?utf-8?B?NmpRdklJVlJGZmpjTFJXQ043elJJT2dFeEpqYXhVbDdOTEZOdStqc1NiMGRK?=
 =?utf-8?B?UlhwUDgwREwxZ3pVcnNMWVZqTm9xZFR2UVFUMWJxdnM2UzNta1ZacE51UWk3?=
 =?utf-8?B?QU5kcHBoYzlLY0VaTVUrR3FzNkpNdDBvYWV0K2FBTTZ1dk11MGtPdHV3RGpZ?=
 =?utf-8?B?TFNvNkNhMFQ1TjRON1FCVG1LTW9mcWlYUlJZQlVHRElKWmhtYmdXeDRiRk9s?=
 =?utf-8?B?bHhSdEFjSVRieUFHdkwzSVkxWTdXYTNzUW13eFYwVmpOWENseXo5TE1tY1Yv?=
 =?utf-8?B?bjBLOHJWM3BCYjVob2VHMUt3SWhMZHMvYlNGcE8zelE2V3FhdnJ6UUpJSUVO?=
 =?utf-8?B?Y1pNRGdpSFltaU55Ky83aDZ2UjFMM0o2bXQ2VStvZDE3MitFdmw3alVTQnVj?=
 =?utf-8?B?VVkyQkREZC82aVMvaUl3Nyswa2xYS1hsbU5iVm9QTlhTSXlZQm1HalRSV3JE?=
 =?utf-8?B?ZHpXZU0rN2pMcGxCZUlDdHIwVzFaSnkxTDQ4L1RFLzZVQ2lnZGRBOFJBNHNU?=
 =?utf-8?B?eUx1WEVCTG9vMTVwTmxsTmphY3YyN1YrMlZ2QUs3YVplN2lCS1pBN25KQVRP?=
 =?utf-8?B?NDE2QUI1M3hUSmhNWlVFOWJiOERBeU9QbWI3cUdBZzVEVVRjMlJrRnpwdlFr?=
 =?utf-8?B?a1lzeUhWczkrcDBNR3RCc1JpenBRSC9XbXFOSkdIcFRsR3lzY1REV3BESmRD?=
 =?utf-8?B?VGVNaHVUeDg2Rjc4VnZRT3pmb1I1Y3FleUtPcHIrR0t0eHorZlVhbmY3N1Jo?=
 =?utf-8?B?Rmg4dmZxZnNyeEE1UE1CdG92aWZhRnRtWXJVQ3FPdldncFRrZmNvSTlMWC9y?=
 =?utf-8?B?NWlVSWZBcjNvRVA2eFBlSERLay9QTlRIejcwTkJUQ0JHWDdWUUpuU0RsOFpJ?=
 =?utf-8?B?V1MzZVVpVHdCNTRKb0JMREtUTGw4WmZ5MitHVktvRDI4MkkzM0Qwa21ONUZr?=
 =?utf-8?B?V3RXcDVhUytCeUZHMWkraEwyeHh2ckdxamRjK0dKSVZ0dksxZytDS0hqeDhi?=
 =?utf-8?B?N2pwZ2hmM0pHc1p3YXJpRDdodFB2K0dBbVZQV0p6b2ZTL1FGcVdpdUdpY3Jj?=
 =?utf-8?B?eWZPTm5adHorM1A2bkFsNGhYL3RRTU94RllqWEFyN1dYTmZnZ29OSnFqWWdS?=
 =?utf-8?B?S1hnR056OHJmeTZyNTkrdExiVk9pZzUzajI4NUhxVXEzRTExVEJWOGU2dXph?=
 =?utf-8?B?c0ZjVTNpNjBCSGthSFB3U21oSFBNQTd6OURzYk4wQngzZ0I5VzNFZVp1MitG?=
 =?utf-8?B?ekVsdVhGL3B3UFB4L0h4OFhNNHY0cGoyWkszbkw3cjJnczRrbEF0UnlQa2hz?=
 =?utf-8?B?cWgzS2J3LzZYVG95Ukdkc0FQa1VCZ3E2bzdUN3ZMRXhlQ2VBSTBCNWZmNEZG?=
 =?utf-8?B?ZytoTmxCbG9wc1VVazRxQlF2M3VrSFQyKzZNZjhVeXc5eG80aWpQTFNmQklm?=
 =?utf-8?B?OURBZ3lnbXVNQXFIZXNQbW10Nnl5UHdTK0d4Q0NrV2l3K080S2hsdHRRMTZs?=
 =?utf-8?Q?RDT3nMslzfhm2gAi9o=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3662.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5224ca7a-7a26-45ee-550c-08d8c8804a21
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2021 20:14:19.7193
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z9H6/An77ir0OQXbvvy4tPWIsmUeDKQFX1KMg6t1rRpgg79QKw2nfArgkENTSceBim263fzZFGxG4wPsxTkQmnbY9x4cJ9/8g0CuA4yT0dE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3821
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU3ZlbiwNCg0KV2UgY2FuIHRlc3Qgb24geDg2IFBDLiBXZSB3aWxsIGp1c3QgbmVlZCBhYm91
dCBhIHdlZWsgYWZ0ZXIgeW91IHJlbGVhc2UgeW91ciBuZXh0IHZlcnNpb24uDQoNClRoYW5rcywN
CkJyeWFuDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU3ZlbiBWYW4g
QXNicm9lY2sgPHRoZXN2ZW43M0BnbWFpbC5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwgRmVicnVh
cnkgMywgMjAyMSAxOjUzIFBNDQo+IFRvOiBCcnlhbiBXaGl0ZWhlYWQgLSBDMjE5NTggPEJyeWFu
LldoaXRlaGVhZEBtaWNyb2NoaXAuY29tPg0KPiBDYzogVU5HTGludXhEcml2ZXIgPFVOR0xpbnV4
RHJpdmVyQG1pY3JvY2hpcC5jb20+OyBEYXZpZCBNaWxsZXINCj4gPGRhdmVtQGRhdmVtbG9mdC5u
ZXQ+OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgQW5kcmV3IEx1bm4NCj4gPGFu
ZHJld0BsdW5uLmNoPjsgQWxleGV5IERlbmlzb3YgPHJ0Z2JubUBnbWFpbC5jb20+OyBTZXJnZWog
QmF1ZXINCj4gPHNiYXVlckBibGFja2JveC5zdT47IFRpbSBIYXJ2ZXkgPHRoYXJ2ZXlAZ2F0ZXdv
cmtzLmNvbT47IEFuZGVycw0KPiBSw7hubmluZ2VuIDxhbmRlcnNAcm9ubmluZ2VuLnByaXYubm8+
OyBuZXRkZXYNCj4gPG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+OyBMaW51eCBLZXJuZWwgTWFpbGlu
ZyBMaXN0IDxsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVsLm9yZz4NCj4gU3ViamVjdDogUmU6
IFtQQVRDSCBuZXQtbmV4dCB2MSAyLzZdIGxhbjc0M3g6IHN1cHBvcnQgcnggbXVsdGktYnVmZmVy
DQo+IHBhY2tldHMNCj4gDQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cgdGhlDQo+IGNvbnRlbnQgaXMgc2FmZQ0K
PiANCj4gVGhhbmsgeW91IEJyeWFuLiBJIHdpbGwgcHJlcGFyZSBhIHYyIGVhcmx5IG5leHQgd2Vl
ay4NCj4gDQo+IFdvdWxkIE1pY3JvY2hpcCBiZSBhYmxlIHRvIGRvbmF0ZSBzb21lIHRpbWUgdG8g
dGVzdCB2Mj8gTXkgb3duIHRlc3RzIGFyZQ0KPiBjZXJ0YWlubHkgbm90IHBlcmZlY3QuIFZhcmlv
dXMgc3RyZXNzIHRlc3RzIGFjcm9zcyBhcmNoaXRlY3R1cmVzDQo+IChpbnRlbC9hcm0pIHdvdWxk
IGhlbHAgY3JlYXRlIGNvbmZpZGVuY2UgaW4gdGhlIG11bHRpLWJ1ZmZlciBmcmFtZQ0KPiBpbXBs
ZW1lbnRhdGlvbi4gUGVyaGFwcyBNaWNyb2NoaXAgaGFzIHZhcmlvdXMgdGVzdCByaWdzIGFscmVh
ZHkgc2V0IHVwPw0KPiANCj4gQWZ0ZXIgYWxsLCBhYnNlbmNlIG9mIGJ1Z3MgaXMgbW9yZSBpbXBv
cnRhbnQgdGhhbiBzcGVlZCBpbXByb3ZlbWVudHMuDQo=
