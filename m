Return-Path: <netdev+bounces-4879-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E3F070EF4A
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:24:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CEEA41C20B39
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 07:24:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C04A79FC;
	Wed, 24 May 2023 07:24:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E232229A0
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:24:07 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D869593;
	Wed, 24 May 2023 00:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684913045; x=1716449045;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/Zom2upbPzp4Ssy5xmb+FU935p85gP3czai+Qa6J0S4=;
  b=fvixJrjPAnQSUWv5VfHkkD57IFQEq9npb5e1q6s4alkP3b52I/GyT0uS
   PiBIRCjFMd7SqLh4XyAWVNq5AAauTFTcNVfGXwAFXjh5rdnYn4OR+oaKH
   6U2LGf9bq1brMxGm2/6S4EKspLHf0vfAsoZsBXrApSdHuFfpehApNdwv7
   G5JyLhh+12y8eKUVxz59BstGtqVkRlUMHVk7cFyIZJak7t9pGTBvRZRyq
   SBA+yXSpblj4OWI9BET9DsOc1BpT8ZiQOp8Xr89hHr2MCL7CfDam9v6qb
   jGkWNlG4lwwWU6OHN4XTJ/t26vbwMmupVkeR8aFVjFP0K+UxHH2gD7qEF
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="214649630"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 May 2023 00:24:05 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 24 May 2023 00:24:05 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 24 May 2023 00:24:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IOKMaO5shGxnDC/NrOaLEzENlhJaec4LCn9w87EyCepqHN6VPLiIskECD9zHW1jqBR+YP6ZVxN6C7S7NScmVrVY5KG9MzBa//sl7Nj99dqApBaNJ3AffSUf6mgsSXA+gi+LYZUKaf7mA/Z8YLIfBZB2Jxxe1I9Jf6gnWd09aQOgkZE2n2M8QoGVfbehyvZp/VuDp1QaScRChQAjzcTUOCXlsp3Hq4ZmsRFIM2OzBFXCv31K+3TpCjp5wQ9BlHlaPOaPnnDX2ux6AmMdI3kXmNtChevJY3OWR41Q9bFvsaPEkdkp/VNCGBgAZtQOq2wWrYTTVtDEId8kemj0uExNh9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Zom2upbPzp4Ssy5xmb+FU935p85gP3czai+Qa6J0S4=;
 b=LjTIfwEV0qR/GnetALCL7BUL6LqPbVYcLCjpQ+1zJMr00g2bZno3UphW2TmQTzPcpK6lpgvj2S/Prex8HGWizrp+ZiSYouNN/R1S3lFLJYYkCTcMPAUmWztSEuHBaP3LK2w9Q2fcpEk4lM89VrWI2gFxkkDmTBDCBziq/MZfDfqxp3Ck+5ww8fLiV0U43AQDsTyw59rMpucS1xJ7XjDx+A8dto1GBl/stNWUMCVTCzx3EMgd/S7Xbzf9qM3Tp4PoRkdGoL+KK80F5rbuGFMiVd8Qjv55bN0slsnDfgYX3knVCbjRMot9iW3xATNJEz2/u5Vt4HWtt7gIzQZiiIz/4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Zom2upbPzp4Ssy5xmb+FU935p85gP3czai+Qa6J0S4=;
 b=Pj6y7hNeKuzg6rEpZup1XOMmy4kGiFXv40Mblw6f149lPdxzIEFaxhcTLuBSBdhrJxnCFNPIvhopV88JYHML7sMdCg6rN/JbLo5iMB2P4BmOWQ21nic01flyoZs/ieh3LaM2lLa9SW+zDj2uUbZGO2P1rMyolsKDnJrhstlBEjg=
Received: from DM6PR11MB3532.namprd11.prod.outlook.com (2603:10b6:5:70::25) by
 CH0PR11MB8236.namprd11.prod.outlook.com (2603:10b6:610:184::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 07:24:03 +0000
Received: from DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::ba23:4a94:b951:f570]) by DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::ba23:4a94:b951:f570%7]) with mapi id 15.20.6411.027; Wed, 24 May 2023
 07:24:03 +0000
From: <Parthiban.Veerasooran@microchip.com>
To: <andrew@lunn.ch>
CC: <hkallweit1@gmail.com>, <linux@armlinux.org.uk>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ramon.nordin.rodriguez@ferroamp.se>, <Horatiu.Vultur@microchip.com>,
	<Woojung.Huh@microchip.com>, <Nicolas.Ferre@microchip.com>,
	<Thorsten.Kummermehr@microchip.com>
Subject: Re: [PATCH net-next v2 4/6] net: phy: microchip_t1s: fix reset
 complete status handling
Thread-Topic: [PATCH net-next v2 4/6] net: phy: microchip_t1s: fix reset
 complete status handling
Thread-Index: AQHZjKFISJBP+UyLBEKuwTcTckxbq69mPN6AgAEZewCAAHNJAIABPuKA
Date: Wed, 24 May 2023 07:24:03 +0000
Message-ID: <2e01f3b0-037e-a8a1-19e9-dd4e8d5f40d1@microchip.com>
References: <20230522113331.36872-1-Parthiban.Veerasooran@microchip.com>
 <20230522113331.36872-5-Parthiban.Veerasooran@microchip.com>
 <f0769755-6d04-4bf5-a273-c19b1b76f7f6@lunn.ch>
 <b226c865-d4a7-c126-9e54-60498232b5a5@microchip.com>
 <e9db9ce6-dee8-4a78-bfa4-aace4ae88257@lunn.ch>
In-Reply-To: <e9db9ce6-dee8-4a78-bfa4-aace4ae88257@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB3532:EE_|CH0PR11MB8236:EE_
x-ms-office365-filtering-correlation-id: 55e79ab4-7a88-4385-8233-08db5c27d9f6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Pt9PhH9NZNt7okQRCKy0iU69Xh/0v6wUbc/E7uioeD+AdVOT+bJ83260+AtEZnul/lnnX8HCEgHvWLfObsuVnCs3D4d7XqDDkch2zuJ+tqZVgqLdHVSW3/Nf9DKDbZJJZk5rcQkcd5a0SFqLBhK3stjgItDV4bKycQ2JvdAJlegwAaq+bXDIkyfyl7bSuf0rHtxA1DxQ74iF1IstGWn1PDWstLtenKKopA3gYlJ1l1RJ2LjBBAJe2kbvttwDgNIE1r+vzh8u8FwpAnQGuB+n2TJuOA81rBBtFiUnCUO4ZSi/rF4p8p1NbwmkLMDzKwWkzZZhtzSDsVXgr1CDsccXSEiiBekPszZq2bg2mfOlSkfeaC+S+aKtPX5g6bZMLlsJbW2Xw+jKUWVO1Nc7Y0Wgo5ZINRI0Fk8yos92vGOH9GLbvDuKGVYytNCL3lQHEsLbcHTXq1xC/dLf6fqk3YOXYBQ5f/xj1gywFFW60p3BbxVx1mgaPmgnFu4ZZuTD9fvK9C+ER/K8w8N+w33OeNWgysT0B6rGARfijDVcwXPndwPHRvcnJyddo+ApcEVwMAt661RiIft4QH5ib1r+2A0RNrYjY8p9fTruUKHeLGA5/Gx9kEZuPv03woq98SKWFVqBSzvD/4MzL9YHh2bJeW9Ix4NVMlnvGWNwFWdCME8N6ow=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3532.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(136003)(39860400002)(376002)(346002)(451199021)(54906003)(91956017)(31686004)(2906002)(5660300002)(7416002)(36756003)(8676002)(8936002)(6916009)(41300700001)(4326008)(66446008)(66476007)(66946007)(66556008)(64756008)(478600001)(76116006)(316002)(71200400001)(6486002)(38070700005)(107886003)(6506007)(26005)(86362001)(31696002)(53546011)(186003)(122000001)(83380400001)(38100700002)(2616005)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?THdqb3BkbGVFK0tWdUJ4a3pnZTAxM3o4SUNWNjR0Mm0rVDE2Qk1xZ3QrMEEr?=
 =?utf-8?B?QWs4dFRQMTJFRGlFdFdrSHU3Y3daRXlhTk1wR1JZa3NGYWdpM3pSc2NxZTd2?=
 =?utf-8?B?ZkRXTWVPb2JRamc3SG1QVGtWSzdQV2ZXaU1pYkVrNnRxemxmSHJUMzZpTStD?=
 =?utf-8?B?b0JlL0ZtZVN1WHFyZjV0SElyWTczT0VpT3hmWlczdk5GWGgwOVhlWjcvNlh6?=
 =?utf-8?B?cFcwaEhwTXNteGd3bnVGUU5jaS9nTWREbm5Cd0NobWNacFRsa0t1S25hZkdX?=
 =?utf-8?B?cnNnL1V0RkovcWVSTXZFRlg3UVAwSHBCNVAycldoTWZnSXBTYWNweUlza2NZ?=
 =?utf-8?B?Rmc5a0tVcG5IUjc1cEFmL3N5UHE1SjhwZ3dnc1FGMkV6NXgrYjFRdGp3MXRw?=
 =?utf-8?B?RW5TdGc1c25yRXVNMVU4WnlXMkljdWxtRmtkdk8xcDd0L1ZrMzc1NWt5eWwv?=
 =?utf-8?B?M09Kb1lvaVl3TzJLSkQ0U0RuRnp2bjJBUzJFaTl3cFhRWDM4WXpjd1hIdytp?=
 =?utf-8?B?Yngwb0FuYWtxZkNiYUJrYmpMMUFjc2J1Yi92TnVhSDNlYUZ4czNFRzg5WStB?=
 =?utf-8?B?elRIanZWUnIzMnhwbi9wb1pCY25hTEZpWU9TM0FMSTVSY0hmL3FidHo4alBY?=
 =?utf-8?B?UmsrUWVOOXc0MUdXWktWdXFJcElqVElJd01CdmJEWmlBeCt6ckdWVWNSWURk?=
 =?utf-8?B?OENFR09XVXVWY1pobzlxdGU5L0lwTnNsWmxlUFBHbFFxVDNUSlZNVUxMdkpv?=
 =?utf-8?B?L3NqZHg4Y2VidmNsZktoa2U5eU5xRFVYNjZZRnNveTBqbnhrcCsxbFhyZUZJ?=
 =?utf-8?B?UHordERrUmJxbUZGYmtOeFp4YXR5TUFuL0EzSklxNklCbDZYM0h5a1B4cWgw?=
 =?utf-8?B?d2J2SWpWcEpVT01vNUV3NWI1LzdCeEMxYU52VkRsQkkrSVVxQVBsbjBsa0ZN?=
 =?utf-8?B?alE0TGw5Z0RhOUs1R3l6NzZacFVPMmVCc0sva2JmcTE4aW84NTdjOWNBT1Q0?=
 =?utf-8?B?UDdzSHl0SURCKzNCdUZtRDJBbjZsQ1g0N1hCZlJqL3JPTW5VZXhzdUtjeDE5?=
 =?utf-8?B?cmd1enBkWnZkTUMvK3MwenVNMXRlK1dBSjVyRTdXSWdtQkh1T3YvM3BuZDFH?=
 =?utf-8?B?dVM5VWRwMXp4OUUwOHkzOHloOEhTTUo1TktIZHRLZ29CdEZiNTgwZ3VUVXcw?=
 =?utf-8?B?emd5dU9uMTNhUDNyWnhpeXhnT3VRYTNZVENOcHRxcXVneGtXY3M4R2FKdmJm?=
 =?utf-8?B?dEI4UXVlT294MGtERGZQQVNjVTFGRko3dThQNndUL0RXVmpMdTdrTHJrcmIw?=
 =?utf-8?B?V3NKZ3kzN285aGRyTDJBRTM4OFJmM2Y1UHg1b0xwZjBSSkRhSTRPdGcyNHQx?=
 =?utf-8?B?d09wTExwYVo1YjNEcEdhdjlNc3FtblpRUTZWaWJuUG5aMHU0bW4zcHVjQUpT?=
 =?utf-8?B?a05DVWwxZFR1NkdtdVdDdXFRYWxBSkRaOGp4K0VLNUE3TUJ3TlQyRnFZRW45?=
 =?utf-8?B?ZHhhZFNQY0tKZTFmQ1Y5Ykc0Vng0V1J4ME1kQUJ4ZmZBOEJLOTQ2NGQvWS9B?=
 =?utf-8?B?aDI5QjdVSzh3ZnE5aWtGRnMxWVJUS3M2aXZOMmpKQllFT3hSWmZwUmtOVTVC?=
 =?utf-8?B?ZklQNC8weHFBTkx6dU1FR2h6c1BRaXJSVEJDS3U4bmZncmJBcE5ON014aHhk?=
 =?utf-8?B?eC9vRk12blF6Y2pYZlIraG5xaGJ2RDNIcmZTWXFBazVuNy8weS90R1R3T2pt?=
 =?utf-8?B?UTdEQ2hTcEFFTzVoemtEOXZrM2xNVkI1eUl2SW9vQ2F1MFQya3VQenI5bG5j?=
 =?utf-8?B?UWdsQWlNNytuWVFZS1MyL3dPYTVBa2tDcW5wS2hUVUYyREx1bldKdWdWNUo2?=
 =?utf-8?B?anVuSFRzTnZqMW9ycEhBaTlDSXl3eHZ3YmpoOW1vNk5sTW40YW43Y0J1LzFh?=
 =?utf-8?B?MzVvSzRZRHhub3JsTU04K0laeDJXQitvSlRRSE0ralJLWWFidXZlT2xLS2Qy?=
 =?utf-8?B?bWkwcHgxZFF5MGJiUTFwRktUU1cyQmJ6NG1qSTl5TXVDRFNnd3VocnRKS3VV?=
 =?utf-8?B?cXo1VlJJWGx2czZvNURiWUFRbHJ3bi91YnNiZ0c4U1E5eWhWb1ZhdE9Wb0pN?=
 =?utf-8?B?MlN2Q1BmLzhtOVhpc25xRXpQd3VERkR4azJYcGlxZGFOUUtaR1hmcHIweVln?=
 =?utf-8?B?cXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B641D7F7045F3249ACD4DD6C4B349C21@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3532.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55e79ab4-7a88-4385-8233-08db5c27d9f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2023 07:24:03.2869
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W+rY2BebSTu3/ZVAfDT3pU5OAkAqYfy1e2h7ZL3IahBYhvU+v2GJz2ZbGhCj/1ZMVj8+UL1CsTDNfDrjgLIPx0NwjaI+C80QIHkg3QZJWC8kPnWQ+5rvPtRpT6QeRdqP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8236
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGkgQW5kcmV3LA0KDQpPbiAyMy8wNS8yMyA1OjUzIHBtLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
RVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVu
bGVzcyB5b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiBUdWUsIE1heSAyMywg
MjAyMyBhdCAwNTozMDowNkFNICswMDAwLCBQYXJ0aGliYW4uVmVlcmFzb29yYW5AbWljcm9jaGlw
LmNvbSB3cm90ZToNCj4+IEhpIEFuZHJldywNCj4+DQo+PiBPbiAyMi8wNS8yMyA2OjEzIHBtLCBB
bmRyZXcgTHVubiB3cm90ZToNCj4+PiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtz
IG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUN
Cj4+Pg0KPj4+IE9uIE1vbiwgTWF5IDIyLCAyMDIzIGF0IDA1OjAzOjI5UE0gKzA1MzAsIFBhcnRo
aWJhbiBWZWVyYXNvb3JhbiB3cm90ZToNCj4+Pj4gQXMgcGVyIHRoZSBkYXRhc2hlZXQgRFMtTEFO
ODY3MC0xLTItNjAwMDE1NzNDLnBkZiwgdGhlIFJlc2V0IENvbXBsZXRlDQo+Pj4+IHN0YXR1cyBi
aXQgaW4gdGhlIFNUUzIgcmVnaXN0ZXIgdG8gYmUgY2hlY2tlZCBiZWZvcmUgcHJvY2VlZGluZyBm
b3IgdGhlDQo+Pj4+IGluaXRpYWwgY29uZmlndXJhdGlvbi4NCj4+Pg0KPj4+IElzIHRoaXMgdGhl
IHVubWFza2FibGUgaW50ZXJydXB0IHN0YXR1cyBiaXQgd2hpY2ggbmVlZHMgY2xlYXJpbmc/DQo+
PiBZZXMsIGl0IGlzIG5vbi1tYXNrYWJsZSBpbnRlcnJ1cHQuDQo+Pj4gVGhlcmUgaXMgbm8gbWVu
dGlvbiBvZiBpbnRlcnJ1cHRzIGhlcmUuDQo+PiBUaGUgZGV2aWNlIHdpbGwgYXNzZXJ0IHRoZSBS
ZXNldCBDb21wbGV0ZSAoUkVTRVRDKSBiaXQgaW4gdGhlIFN0YXR1cyAyDQo+PiAoU1RTMikgcmVn
aXN0ZXIgdG8gaW5kaWNhdGUgdGhhdCBpdCBoYXMgY29tcGxldGVkIGl0cyBpbnRlcm5hbA0KPj4g
aW5pdGlhbGl6YXRpb24gYW5kIGlzIHJlYWR5IGZvciBjb25maWd1cmF0aW9uLiBBcyB0aGUgUmVz
ZXQgQ29tcGxldGUNCj4+IHN0YXR1cyBpcyBub24tbWFza2FibGUsIHRoZSBJUlFfTiBwaW4gd2ls
bCBhbHdheXMgYmUgYXNzZXJ0ZWQgYW5kIGRyaXZlbg0KPj4gbG93IGZvbGxvd2luZyBhIGRldmlj
ZSByZXNldC4gVXBvbiByZWFkaW5nIG9mIHRoZSBTdGF0dXMgMiByZWdpc3RlciwgdGhlDQo+PiBw
ZW5kaW5nIFJlc2V0IENvbXBsZXRlIHN0YXR1cyBiaXQgd2lsbCBiZSBhdXRvbWF0aWNhbGx5IGNs
ZWFyZWQgY2F1c2luZw0KPj4gdGhlIElSUV9OIHBpbiB0byBiZSByZWxlYXNlZCBhbmQgcHVsbGVk
IGhpZ2ggYWdhaW4uDQo+Pg0KPj4gRG8geW91IHRoaW5rIGl0IG1ha2VzIHNlbnNlIHRvIGFkZCB0
aGVzZSBleHBsYW5hdGlvbiByZWdhcmRpbmcgdGhlIHJlc2V0DQo+PiBhbmQgaW50ZXJydXB0IGJl
aGF2aW9yIHdpdGggdGhlIGFib3ZlIGNvbW1lbnQgZm9yIGEgYmV0dGVyIHVuZGVyc3RhbmRpbmc/
DQo+IA0KPiBDb21tZW50cyBzaG91bGQgZXhwbGFpbiAnV2h5PycuIEF0IHRoZSBtb21lbnQsIGl0
IGlzIG5vdCBjbGVhciB3aHkgeW91DQo+IGFyZSByZWFkaW5nIHRoZSBzdGF0dXMuIFRoZSBkaXNj
dXNzaW9uIHNvIGZhciBoYXMgYmVlbiBhYm91dCBjbGVhcmluZw0KPiB0aGUgaW50ZXJydXB0LCBu
b3QgYWJvdXQgY2hlY2tpbmcgaXQgaGFzIGFjdHVhbGx5IGZpbmlzaGVkIGl0cw0KPiBpbnRlcm5h
bCByZXNldC4gU28gaSB0aGluayB5b3Ugc2hvdWxkIGJlIG1lbnRpb25pbmcgaW50ZXJydXB0cw0K
PiBzb21ld2hlcmUuIEVzcGVjaWFsbHkgc2luY2UgdGhpcyBpcyBhIHJhdGhlciBvZGQgYmVoYXZp
b3VyLg0KU2hhbGwgSSB1cGRhdGUgdGhlIGFib3ZlIGNvbW1pdCBtZXNzYWdlIGxpa2UgYmVsb3cs
DQoNCkFzIHBlciB0aGUgZGF0YXNoZWV0IERTLUxBTjg2NzAtMS0yLTYwMDAxNTczQy5wZGYsIGR1
cmluZyB0aGUgUG93ZXIgT04gDQpSZXNldCAoUE9SKSwgdGhlIFJlc2V0IENvbXBsZXRlIHN0YXR1
cyBiaXQgaW4gdGhlIFNUUzIgcmVnaXN0ZXIgdG8gYmUgDQpjaGVja2VkIGJlZm9yZSBwcm9jZWVk
aW5nIGZvciB0aGUgaW5pdGlhbCBjb25maWd1cmF0aW9uLiBSZWFkaW5nIFNUUzIgDQpyZWdpc3Rl
ciB3aWxsIGFsc28gY2xlYXIgdGhlIFJlc2V0IENvbXBsZXRlIGludGVycnVwdCB3aGljaCBpcyBu
b24tbWFza2FibGUuDQoNCk9yIHN0aWxsIEkgaGF2ZSBhIG1pc3VuZGVyc3RhbmRpbmcgaGVyZT8N
Cg0KQmVzdCBSZWdhcmRzLA0KUGFydGhpYmFuIFYNCj4gDQo+ICAgICAgICAgICAgIEFuZHJldw0K
DQo=

