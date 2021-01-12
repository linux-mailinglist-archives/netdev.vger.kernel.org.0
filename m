Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28BF02F25BC
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732977AbhALBtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 20:49:15 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:29956 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732842AbhALBtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 20:49:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610416154; x=1641952154;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=V1t4cRX4CwCWRm/JHcha4G+1G6+/pltRGpfHCjsebMI=;
  b=hAXWd+lZdt63vVfpqR9fNGrRx7OlhExSr9ynca8HoJstZWJFc1nkisl+
   tSV6PXUCtiN4XA/gZbLsFDTS1gGmbV3zEsaKYTsfZKKWAFwcoRYICyM7R
   NEaayqUQkjf44mR8qFaFhkCMEyEFlmNhAFzp+KWPK5gm9CfdjbShXOTlt
   UiBE0RTZaCI+pEB7mxrleO4hz3h9PNQaK4KTTZV0LEdMPh+j9qFco0/zi
   BUgaDjvIHuh9/mmQSulLXf1H3MJqM0FFMVsilb2mOJvHRKE0Dv7npkdmf
   JvPWL9FAZmW6XV3bcGr6a4tkC2Qc1ejiiafGdp6YYCpk4QKVPAoO+QlX0
   A==;
IronPort-SDR: vlQHw3rGX5L7VPwZuYMaqLpM9dTqDF8xOtvBTPUo33hxbsldxpUKZJ4/gcIe8zJWRKf9wbwh8/
 aRRwPm5CdudVDwNpzVBvll7Mr3CtCcOq3VZ4+CKDmHUWRF5PAD9O5NdPIVUMBtlsLLVPsbo7BH
 e+fpfZ950z1abY0zn14tJllPgsblC8WD3VAw9MEbUY3KthNuQHeZ6wX4fEEzE0n86fxN5VQaM9
 Ke1C4+rPEtWaZtV1EjTGOCbHoctk9z8z2gjGXZQVnerm8Zev6ekv7+qvVptgmZ3ikzA77LLBtk
 kUQ=
X-IronPort-AV: E=Sophos;i="5.79,340,1602518400"; 
   d="scan'208";a="161638137"
Received: from mail-dm6nam11lp2177.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.177])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jan 2021 09:48:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=joV9xCxIyYOunnMOL0Qx5n4rWmeuipWFswAdtRtdvUtm02ygqnq/GBDRy+JS9mUDkEbkpkBsVhBFPAoblGj8d/RAz+uKnRNbdm/G2xr0ubMVaUEP3O4bWSuH03hDmUGLDMx3r2P8XmMe/8t3NBDDMLD9JN5aw5dyiV71DrF/Ifb44tKQErhZqGJzSDxrBbAjZ8u79sfEnr1uiRGfIc/w4EkCLIMzO2NSbGLOqmN9VauRee3exzZU7kKb7gdyKp6NrH+2rfv3cMR5rssbyPD3q03yHsrfQi2LBCqqTIjla4IHYq9AyRzc3Z153IhQW6MtXsa8n/43f2/bVfqwElK6kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V1t4cRX4CwCWRm/JHcha4G+1G6+/pltRGpfHCjsebMI=;
 b=HfpFwZmmXhUogdREV5zM/9muORXWFV2pc7Pz2y6vMDUgob6GvkK65eVVdQxZUbgmgZYeLBPucxvd9A9mUXGLG4tn83hCWvZYx2EBq2dUqlb/y1p+YJzdIN8IS2nCIoE4z4l3NM+B34JEdg7unCHDH5jXYl/Y5g9Irm9KLvIrPdqgb98PBw+BkE0VNc6TAp4oQ3sTmbubLwlPUiuqjrCWIdnVKPegxjCKOTT2uwAFSb0mAY6k4WsQD8cnpN9UM5MIpfN4aTRW7D2/v823d+9Mi0uFUDNTmsXsJJ5TDT+nmHCC4HZpdqV9zgeFIHljNx05EJ93S7LeSc9StoE1HBIkJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V1t4cRX4CwCWRm/JHcha4G+1G6+/pltRGpfHCjsebMI=;
 b=bxxzlW2xBW8Ls0rOHmjGtKlyfCunEnPxpB/ihK55GLVlo/llz6QcGTy16NVr2D9FB2VAG9CBGuRtUEbz1XwYdPVLBqYTFzfg0uSZ7OirJNvD6O5hPt3WepUDVNzImV94czelvfFTAY2v1sZayLNY7yyeo5bGUp5RMsRDEsRA6Kk=
Received: from BY5PR04MB6724.namprd04.prod.outlook.com (2603:10b6:a03:219::15)
 by BYAPR04MB5768.namprd04.prod.outlook.com (2603:10b6:a03:101::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 01:48:06 +0000
Received: from BY5PR04MB6724.namprd04.prod.outlook.com
 ([fe80::ec3e:7abd:37a1:eb8b]) by BY5PR04MB6724.namprd04.prod.outlook.com
 ([fe80::ec3e:7abd:37a1:eb8b%8]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 01:48:06 +0000
From:   Atish Patra <Atish.Patra@wdc.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: macb: Add default usrio config to default gem config
Thread-Topic: [PATCH] net: macb: Add default usrio config to default gem
 config
Thread-Index: AQHW6FPIX7w2LdI4uE+CHUOcjWE+7qojDjQAgAArFIA=
Date:   Tue, 12 Jan 2021 01:48:06 +0000
Message-ID: <20f0b8567d27aead1f844ab863551d2a495474ce.camel@wdc.com>
References: <20210111195553.3745008-1-atish.patra@wdc.com>
         <20210111151354.7aec0780@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210111151354.7aec0780@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.2 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.44.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 15d322fc-42b7-4206-8cb1-08d8b69c1b64
x-ms-traffictypediagnostic: BYAPR04MB5768:
x-microsoft-antispam-prvs: <BYAPR04MB576851681B51B5A7FD15BD1FFAAA0@BYAPR04MB5768.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:549;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hk9PTKpaH+UhmYLU7TaocxMeuuFnWzSqe9NawufYQ8ryj3n5ua6gtX1dKYQMigYO701slcpLLFgR/9+QwV01IHVpJj+B1ibsa2gA3Kxx9DTOy9KfmhJDjGt1xYunQVRyFrIcbLrPGjmeIHwipY2+UafhUiANVbwMmwnBZMFvHiZ/GaIqQ+p5tSBwIdr++QQ9R8HPrL9RsJ+13fYT/EZmKxuCMkICTW633af2RYq9zv9qYhCx2CtKl3qTrue398P74XdQGetprPbvfBDuX0rim/AdRW02z8OUNY3zBvgzd4TV5FK3HQ9KU3pOKUz4IPnajwoZIGWiFAVVNHi5+uwvtEtpejAb5fVUG81kfxv0dgLZgDv59VQDc9dvs65vSC8y00crFeq2pwHYksL1cq7Lfw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6724.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(136003)(366004)(346002)(86362001)(6486002)(66476007)(2906002)(186003)(66556008)(2616005)(316002)(66446008)(6512007)(5660300002)(64756008)(4744005)(26005)(478600001)(6506007)(8676002)(54906003)(36756003)(8936002)(71200400001)(4326008)(6916009)(66946007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?ZkUxK1ZaNkV0WDRHMjRLSWoxOEVTdTNsamYzZm9NakRSNnZLemg5Y2FwMlJp?=
 =?utf-8?B?OHI5TTFDcTJWYWVYaHJFOFY0OHhPK3NvTUNPWkV5SUFZTHlMVWg2R1FtMHp6?=
 =?utf-8?B?NXBJUkR6d3VaK0FQS1dkdk81K2ZWcjVrRU9CSWloODdiVGRXQXZBVWlGZzdD?=
 =?utf-8?B?NWlmVGM5b1ZWand2SkhhU3RwY096VXdFSzdSaHVwalN4UlRGVmZMeFF6am1H?=
 =?utf-8?B?WnFlWnBBd2JFcXpaSUFZSTlEUDk4dVB5enk3cGRxS1JSZVZyTjhmMHVCUWI5?=
 =?utf-8?B?OFE0aCt2Z0R3U0Uvd1R1Vkt3WHBlYUhVUkZ2OElSWEdWQ0lBRHJIUFVqdTRU?=
 =?utf-8?B?ZGR3bDJyQkNJQ20yZlp6NDZMU3preGVtcWQ0L0lsbFV1RHFoaDI5MUFaRHBm?=
 =?utf-8?B?NmVBdjVvSlNFSm5rMmNibmsvNW1GdlJmaVhvN0NSMzlkRHlGenp6a1RPeHpy?=
 =?utf-8?B?a3VHQnJ0M0hxNGpIcHZPTmxhMWdqekhlQ3ErNm5oU2lNNFFrc2RGelRTMmtj?=
 =?utf-8?B?K2d2cWQ5ZklVWmFlSnBjYitxdGRGU3pCWjh5UGdwa0IxYWpKTEtHNDRkM2o3?=
 =?utf-8?B?dGh6alRUaSszQjQvSDlXT2pzY0NWcmE1V3RPcmxtV1haeEJ6YXJyVHlOWkFX?=
 =?utf-8?B?d2V3NEp1bmFKRkpWdWlPRHdnYmpocHJFeEVhSElwL1k0NmVNMjZ4eU9xVkxO?=
 =?utf-8?B?TW1Uci83OUFsYXRyVUwzWWFFZm1aUXFxUi9WaXdMUW1pUTNoNlNjaEV4eEYw?=
 =?utf-8?B?RkZtU3FPcG5DYnROTjJjSG5oYkRLZmovL1d3Nm1DVXNuV3F1dVI2eEN5R3Va?=
 =?utf-8?B?ZU84ZjIxekNhVUM1OGIrSXVvQitWSlZubVZsWW8yNStsN0ZQVzlSQzcwenpl?=
 =?utf-8?B?cEpvSjlER1lqaG1rRExKeDNRQnN2TUxLVWQ1b2VBeG1LMklPOXRXWi9jUldO?=
 =?utf-8?B?OHQwbTgzUjk0cW1XUzg5Y2tLV1plQTJXaEVJVk5RVXNkVnJiV3lYM0d3K2Ni?=
 =?utf-8?B?Yk9EQlE0dklobGdISm1LbUllZlBrTUowdnh4azNteVBocjgza2thZExXeCta?=
 =?utf-8?B?VHlyTCt4MjBLeGI1S1F1eTlJWUlnMWtkMHZOblFua3ZWSXE4WG15RllvZVhj?=
 =?utf-8?B?Wm43QUZpQU91WHZyZE1lU1VDWmpmZUxxSTU1Ky9FKzJ6QVhuUitzVUExU3Yr?=
 =?utf-8?B?OFA3TnBJcEtPa3l3cjZ3RDNnZXNRZnJqMWYwbFc5T0dRZzllVkljZGl0V3NW?=
 =?utf-8?B?alorWmlCVTI5NGpxdFdiQjl1SXVtdk9KZmp3YTJ6bTk3SUxLTjhjMGZxZ0lv?=
 =?utf-8?Q?xeB78NNzsydJjLPIyVpA55MOM9Yaqj6/Bi?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <0732398D2E8546458ED0657849075A05@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6724.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15d322fc-42b7-4206-8cb1-08d8b69c1b64
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2021 01:48:06.2727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5X6e/eZDFsRc/JwxvD500gk4BLLWue4jfkKGSZime4LRfyrQ//kHfa8QwrGe96Une0E3H8mDPXS4JERaPbNO2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5768
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIxLTAxLTExIGF0IDE1OjEzIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gTW9uLCAxMSBKYW4gMjAyMSAxMTo1NTo1MyAtMDgwMCBBdGlzaCBQYXRyYSB3cm90ZToN
Cj4gPiBUaGVyZSBpcyBubyB1c3JpbyBjb25maWcgZGVmaW5lZCBmb3IgZGVmYXVsdCBnZW0gY29u
ZmlnIGxlYWRpbmcgdG8NCj4gPiBhIGtlcm5lbCBwYW5pYyBkZXZpY2VzIHRoYXQgZG9uJ3QgZGVm
aW5lIGEgZGF0YS4gVGhpcyBpc3N1ZSBjYW4gYmUNCj4gPiByZXByZG91Y2VkIHdpdGggbWljcm9j
aGlwIHBvbGFyIGZpcmUgc29jIHdoZXJlIGNvbXBhdGlibGUgc3RyaW5nDQo+ID4gaXMgZGVmaW5l
ZCBhcyAiY2RucyxtYWNiIi4NCj4gPiANCj4gPiBGaXhlczogZWRhYzYzODYxZGI3ICgiYWRkIHVz
ZXJpbyBiaXRzIGFzIHBsYXRmb3JtIGNvbmZpZ3VyYXRpb24iKQ0KPiA+IA0KPiA+IFNpZ25lZC1v
ZmYtYnk6IEF0aXNoIFBhdHJhIDxhdGlzaC5wYXRyYUB3ZGMuY29tPg0KPiANCj4gRml4ZXMgdGFn
IG5lZWRzIHdvcms6DQo+IA0KPiBGaXhlcyB0YWc6IEZpeGVzOiBlZGFjNjM4NjFkYjcgKCJhZGQg
dXNlcmlvIGJpdHMgYXMgcGxhdGZvcm0NCj4gY29uZmlndXJhdGlvbiIpDQo+IEhhcyB0aGVzZSBw
cm9ibGVtKHMpOg0KPiDCoMKgwqDCoMKgwqDCoMKgLSBlbXB0eSBsaW5lIGFmdGVyIHRoZSB0YWcN
Cj4gwqDCoMKgwqDCoMKgwqDCoC0gU3ViamVjdCBkb2VzIG5vdCBtYXRjaCB0YXJnZXQgY29tbWl0
IHN1YmplY3QNCj4gwqDCoMKgwqDCoMKgwqDCoMKgIEp1c3QgdXNlDQo+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgZ2l0IGxvZyAtMSAtLWZvcm1hdD0nRml4ZXM6ICVoICgiJXMiKScN
Cj4gDQo+IFBsZWFzZSBwdXQgW1BBVENIIG5ldF0gYXMgc3ViamVjdCBwcmVmaXgsIHRvIGluZGlj
YXRlIHRoaXMgDQo+IGlzIGEgbmV0d29ya2luZyBmaXguDQo+IA0KPiBZb3UgY2FuIGFsc28gQ0Mg
QW5kcmV3IEx1bm4gbGlrZSBnZXRfbWFpbnRhaW5lci5wbCBzdWdnZXN0cywNCj4gYnV0IGRyb3Ag
bGludXgta2VybmVsIGZyb20gdGhlIENDL1RvLg0KDQpEb25lLiBUaGFua3MgZm9yIHRoZSBmZWVk
YmFjay4NCg0KLS0gDQpSZWdhcmRzLA0KQXRpc2gNCg==
