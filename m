Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D40348342D
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 16:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234002AbiACP2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 10:28:22 -0500
Received: from mga18.intel.com ([134.134.136.126]:3415 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231924AbiACP2V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jan 2022 10:28:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641223701; x=1672759701;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZDs61a2xsGaGz9psrS33X1/pKPPHW676aKBmcRZGaGg=;
  b=I+I7nEGzw/sxy5+IAEyHw3vZv2z3zCJ2TCKLCfGLkjaN4JOrmsTTU2Wj
   1bDH2g9FzsBbgIo3D7EfmzUMXosaNLtNuPNsXSz/UEDH0IaIut/3V6x2k
   AdyUiLLUPLSbwM7a88rSirF4thGAbnAc7s/qxd/TOh5VfcZEybKwGhVJA
   oP0gLAUQls+pVSCHj5K6xMvds3iSpVFo3iXPyYMrO/W7e50iTo22BRTf/
   p5LB/ToheB4bd3T3888cN9MyvY7nWLp/8G6ScO3lbQgpHQBIy11VjekBl
   isBBBDYMsOIeF/nvRIpj4Asq20/RQq6AKwwdrTWTj0eQU40kSHzf7IPWK
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10215"; a="228899025"
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="228899025"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2022 07:28:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="555888544"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 03 Jan 2022 07:28:20 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 3 Jan 2022 07:28:19 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 3 Jan 2022 07:28:19 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 3 Jan 2022 07:28:19 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 3 Jan 2022 07:28:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lm7FytPF/u0Ev+w98WO9Ce876LpeNHK7I0OyZ1hkMfDnV3xxvGxYqGP8tg6QFynCFwNT8baHEdSn+9veQopO0nQlG3S3jLtA3/x6m02OO/CjR5flYwm26qfGZASqd0wszYm1MeHgWb9BC2MGamTCmgnTfmXBkw0L6LZeNY2A2+Qhh1PkssJb4iTsV4tDvZraAP5esOLtfbAeIiN20Cx3GmuXftwjg49k+AzI09AMXeb1SgFWfhmx/p9Zb/isAOT4fp5BJPKO8169/K2wl3gyB5HmSAHzMMQAvrysUopgRIOhENFvX1K3mhAyTOpH4VKftYcuFBqk6zbWADWkEDeyRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZDs61a2xsGaGz9psrS33X1/pKPPHW676aKBmcRZGaGg=;
 b=T0A8lnlcuuAWJsXDJnKLzHdGTyY78+SsZBop7PnFJey5B2OOi061ZTA9EJBY1sWkPqlIqWNJNc/jHenk8GuE5ksHTDe7vUzIer6tE2hG3VH8Ude/ga8hjVxx7WJJcqKy3PaAj34Ur1ou+Wmqfj1uNY/GW4CROcTYPKq4MIMKY9g4951ak4vYZSEx0nEJblZHfKJcInZ//pbIz60hmOd1zUsV57h2KFFKYuh9QZJLWfQ7GM3ZaEOo1gcT8cTR74Ifqqr0H66Ly8gbWJOP+UPeWFQTsaDPZRhtRiHHFhTQ0eGn2rhOeMVj8k/DKe0wFGmidQUVXh+HnNxd3P0CAzBBUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com (2603:10b6:a03:2d5::17)
 by BYAPR11MB3767.namprd11.prod.outlook.com (2603:10b6:a03:fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Mon, 3 Jan
 2022 15:28:18 +0000
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::dde7:4708:f5c6:1a68]) by SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::dde7:4708:f5c6:1a68%5]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 15:28:18 +0000
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     linuxwwan <linuxwwan@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        "Sergey Ryazanov" <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>
Subject: RE: [PATCH 2/2] net: wwan: iosm: Keep device at D0 for s2idle case
Thread-Topic: [PATCH 2/2] net: wwan: iosm: Keep device at D0 for s2idle case
Thread-Index: AQHX+J8G4+q1atipB02AwsE8UkCH16xJ8SwAgABO3QCABx0P0A==
Date:   Mon, 3 Jan 2022 15:28:18 +0000
Message-ID: <SJ0PR11MB500869254A4E9DEEC1DF3B5DD7499@SJ0PR11MB5008.namprd11.prod.outlook.com>
References: <20211224081914.345292-2-kai.heng.feng@canonical.com>
 <20211229201814.GA1699315@bhelgaas>
 <CAAd53p74bHYmQJzKuriDrRWpJwXivfYCfNCsUjC47d1WKUZ=gQ@mail.gmail.com>
In-Reply-To: <CAAd53p74bHYmQJzKuriDrRWpJwXivfYCfNCsUjC47d1WKUZ=gQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 624b2c86-572d-4b1a-602a-08d9cecdaafc
x-ms-traffictypediagnostic: BYAPR11MB3767:EE_
x-microsoft-antispam-prvs: <BYAPR11MB3767B85A0A899331FF364125D7499@BYAPR11MB3767.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HxxOCBmd7lLN5NzaG84AOnOL4bWNc8DthEFBxuJJkAaBs8U3FuqxPhG0Z1/2in69kd3YOB46ur+en+CrGKpJj6gTL/tjwSnnLHffMskrq10emDL3o6uibSNJdHqnVzBf/sj4CvX+AKOIyS5tbpVAPfmqsWkqXrUYJOUTTNKSV3VpcikEG1PBwczD6cCtGctAslKNLYXQ0nj3ilOlq92F06PdcE24Q9+stlm2Lm9smx8GBaWnRlbcRoAThHCMRbxwqCGPTJFVq6AILTSIc45o8jL6wg3NnN3dqpBsZUmZxHDx+kHE9OvuO3lg5EQ7mPtpivtIo11uGo7eUCO8iV2HgDRI4u/ViWtKOHaK3RWkGQGqBkgowSGCjFlYPH4npf4TPSKpLMOt6YIDRIj2LDC5iA5g0U0ZmruW72BkInVMSQFsb3WRLa12A3mgXysswzB9qlCRkf6amVfihmp6ywvsysaKMpQLNq6+GXtV43xO8tzYM3ahtOZrjA6epPb8WPgszcDQUUIR8oiPzCAv8u14wY/5Qr15HzMgAf9vBZFRdHQNlRBk6w3XoWarGlwaJ4lHRCXjSSPhVmX39xxTtnYvJBq/5RTexOcEpZPSaSplPXE9eYqC24JEQXmvIVnkKpWx/TMkZVfNiFV4tl+0dNt2vSysZZRGjX3mtuIraMfkVKWtoajNqITGAH4nAA1E64SPpNwQQKU1UD0TmtTQ/yA8Og==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5008.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(8676002)(86362001)(316002)(55016003)(8936002)(66946007)(33656002)(5660300002)(110136005)(71200400001)(9686003)(186003)(508600001)(7416002)(53546011)(82960400001)(6506007)(26005)(4326008)(7696005)(64756008)(76116006)(38070700005)(2906002)(66446008)(66556008)(52536014)(122000001)(38100700002)(66476007)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WksyMStKZWswUFpCdlBKR2VjR3FZV3NzVGl0ZU5XalBPcFowOTNXc3BpT0x5?=
 =?utf-8?B?T1hBSUI1MXhURThhNXhqYXMzaHhoNzI3aUdtQmZiaitpWjN2U1RnaC9sUHh0?=
 =?utf-8?B?WEU3ZTIyZDJiVWdsaEVSZTlpWXUvZXBHOEZiVTRVanNpSnNudFBYRmk0YmtC?=
 =?utf-8?B?YWJ4ME5kK2FnTlNmdFhhclhXdXE4NXpNanRIaFhpZDB3bUNXdjVIeUxXRTd3?=
 =?utf-8?B?alMxcGVZcEh4KzZFK2pIZFhoMEZVdXY4Rk93MUxZQldHREQ3VU5tUnBhWStU?=
 =?utf-8?B?R2tVN016dGVvTStoVjRRSEVyaDBsWVE2d0FZU1Vwb3grQ2JmbktIUm5CQWtD?=
 =?utf-8?B?NThCakRyTWNvcmRCY3FVM0M4NFUrSzI2QjFudVIxWHZPU3VIdnpsZEhYeFh1?=
 =?utf-8?B?R2pUaVg0Mk1MNWRrRTBhV0w1bk5oNVJ5RjlpSU9vMEdPUloyQWx2ZkpXR3Nm?=
 =?utf-8?B?dGtKcVFObSsra09QY3dhbWp3Z2xGV3V4TUZHYWhwOThBbW1CUzJOYnk2RFFG?=
 =?utf-8?B?cDJ2TXpSaXBJRUpqdWpoRFV0U0FkUDNiMnNscFFvLzlyNmZuUEx6U3FvalN6?=
 =?utf-8?B?V1daUnRDbWN5UnE4bWdxRDlrRzNqUEs0ZUg2T0I0Y0syR2dDeGFGREVQS2Na?=
 =?utf-8?B?dXF1WndsbXlqUVVISWw5UkE5TUpENGlVTlFLOExaQ1hraWREMTlXNkVUUVdG?=
 =?utf-8?B?Tnd1cVdoSVVmTFBqN3ljQmJONjVUNEppdXNrazlmSW1aMjRnQ3d2TkFnRVNV?=
 =?utf-8?B?RytJbkkzN2RJeW05a3RyblBZaU5kNS9hQXVrK2loZnBmL1JkcERrL21kWVBa?=
 =?utf-8?B?SWFXcG1CY1d2UUpMcG9BYUF4VmRlOWlxQnN3ZGF0bUJlYmVZdkRlQzJ2Um1Y?=
 =?utf-8?B?M1lrOHRzUklLb0V2QWxyTkFYWGRXUFN3VUgxSmRYQ0tVRllHNFB0UmpIMUtK?=
 =?utf-8?B?NEhvK2pTWTB4M2VpNUJXT3ByY3I4YklaYmdZUlN3SjM0K3RvRmhEWWRIOVQ1?=
 =?utf-8?B?UEtVeitIWmxuei9XTTIwQ0c4THFpMGhtSkt6ZXp2TWxXQ0Q0Ym40enliMkZT?=
 =?utf-8?B?MVhOT3d1ZmVRWkgvVzhGaGd0WTBMeUVDS0k1Z3VQdkhaUzdJdHVzQnR1K3Mv?=
 =?utf-8?B?QzRaTEhlbVBLR0NqREg2cWR3TEViRFZsSHNoK1RZWkRGL1ZHKytZSUZRQ3pW?=
 =?utf-8?B?eG1wU0FBWmtPM3E3cDhIUysrWFFJMjdJYXB2ZGxTMy9kZG1CN1NpTTRHQi9G?=
 =?utf-8?B?Y1h3V096aWhnZFF4L0lsVXlieWVtbytoYmdTZ2IxNm9HcGc4THdSYWxVV0cw?=
 =?utf-8?B?aHZQaDFacG9CdVBpcUFtelhHaTZaRlJFeW5mcHVvMmVPMHhmS2c0eW1pOHdD?=
 =?utf-8?B?ZWxraGMrZ3hEUCtSSi9SeTgxbURwdGtVWXk0WHduUDBhYmJsZy9uR2VqRVMv?=
 =?utf-8?B?UVNQRVAyT2xEL09PU2IxK3NWUzRmbVMxVWFhT21HTDVPMGlIdlNEcGJJM2xH?=
 =?utf-8?B?K29USlVzSzFCNjBqcmYrcFVDOWhWb21MOUFLRzF5UXBtQnFVaTBDZVB2MW5z?=
 =?utf-8?B?RDMweVNhaHlYajZoenArM29QMWM4MTVtZUhFRXRjRUEzSWRkT0E1WTcvRnZ3?=
 =?utf-8?B?czU0cTNtd1R2NTZha2l1T3hlWjJPS1FGSXUzejdJZEloWUwxL2pCWnV5bjZm?=
 =?utf-8?B?OU5yVzJGcklTWnVkVzl3a0g0bG1TRkdsbk1TYzh3c05NWUIyOVhuTW5rNG1o?=
 =?utf-8?B?V3FhUzhxVEx2bWxkdzI1UDdBWVA0WWExa2puRDA4TUlqMmVnQ0lpT2Q3VERz?=
 =?utf-8?B?bG1IWS95ZG95bGs1NGhLNkk2OTRHQVlIbXdlK2FYNWdxdmZCQ3hnbFRyOWtI?=
 =?utf-8?B?Z3I1dTIvL1Nhb25keGY4SkowZ3h3ckNIMFJOd2hlRndZYzk3MVJxWHB3Y1Vn?=
 =?utf-8?B?U21SZzZOeDlvRXJmRXdwRnE2Syt5MC84YlZqbXlZcFF5NzdxdXlONEJubnBj?=
 =?utf-8?B?RWRNS0YxdTA3UDZmTUNFeGRNbytLQjFXOGl2NE11WHVuK1lTYkorRzlwdmpZ?=
 =?utf-8?B?alFtWTl6WjdoTXdHVGpCZWsyL3dYNzVEMXVJbWFIb3dzK28ycmRhbExWNjNh?=
 =?utf-8?B?eGlBMFZORkFYT1BCcDVyRjhVSjZORTJzOWVId0c1UVZGdnVrNzNZMWkwaUtY?=
 =?utf-8?B?cnNxWUM3VE53L3V5NGVTNlNQUDFoY2tCRFdoUkVWb3h5N0wzY3dQc0ljRDc4?=
 =?utf-8?B?VjFVdU9hNGg1Tnl0RXBnQlhnTVRBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5008.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 624b2c86-572d-4b1a-602a-08d9cecdaafc
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2022 15:28:18.0982
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iMipCulDSnlgZZEG3hWiJXzYhTeuTIggskpj6cAOoRKrndIH/CkF+VwdHsOHKcxQAP18G0wUY7bMlmvos9698UdEeKj879RZIe3dWWPYi8Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3767
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBLYWktSGVuZyBGZW5nIDxrYWku
aGVuZy5mZW5nQGNhbm9uaWNhbC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBEZWNlbWJlciAzMCwg
MjAyMSA2OjMxIEFNDQo+IFRvOiBCam9ybiBIZWxnYWFzIDxoZWxnYWFzQGtlcm5lbC5vcmc+DQo+
IENjOiBLdW1hciwgTSBDaGV0YW4gPG0uY2hldGFuLmt1bWFyQGludGVsLmNvbT47IGxpbnV4d3dh
bg0KPiA8bGludXh3d2FuQGludGVsLmNvbT47IGxpbnV4LXBjaUB2Z2VyLmtlcm5lbC5vcmc7IGxp
bnV4LQ0KPiBwbUB2Z2VyLmtlcm5lbC5vcmc7IExvaWMgUG91bGFpbiA8bG9pYy5wb3VsYWluQGxp
bmFyby5vcmc+OyBTZXJnZXkNCj4gUnlhemFub3YgPHJ5YXphbm92LnMuYUBnbWFpbC5jb20+OyBK
b2hhbm5lcyBCZXJnDQo+IDxqb2hhbm5lc0BzaXBzb2x1dGlvbnMubmV0PjsgRGF2aWQgUy4gTWls
bGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsNCj4gSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVs
Lm9yZz47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJu
ZWwub3JnOyBSYWZhZWwgSi4gV3lzb2NraSA8cmp3QHJqd3lzb2NraS5uZXQ+OyBWYWliaGF2DQo+
IEd1cHRhIDx2YWliaGF2Z3VwdGE0MEBnbWFpbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0gg
Mi8yXSBuZXQ6IHd3YW46IGlvc206IEtlZXAgZGV2aWNlIGF0IEQwIGZvciBzMmlkbGUgY2FzZQ0K
PiANCj4gT24gVGh1LCBEZWMgMzAsIDIwMjEgYXQgNDoxOCBBTSBCam9ybiBIZWxnYWFzIDxoZWxn
YWFzQGtlcm5lbC5vcmc+IHdyb3RlOg0KPiA+DQo+ID4gWytjYyBSYWZhZWwsIFZhaWJoYXZdDQo+
ID4NCj4gPiBPbiBGcmksIERlYyAyNCwgMjAyMSBhdCAwNDoxOToxNFBNICswODAwLCBLYWktSGVu
ZyBGZW5nIHdyb3RlOg0KPiA+ID4gV2UgYXJlIHNlZWluZyBzcHVyaW91cyB3YWtldXAgY2F1c2Vk
IGJ5IEludGVsIDc1NjAgV1dBTiBvbiBBTUQNCj4gbGFwdG9wcy4NCj4gPiA+IFRoaXMgcHJldmVu
dCB0aG9zZSBsYXB0b3BzIHRvIHN0YXkgaW4gczJpZGxlIHN0YXRlLg0KPiA+ID4NCj4gPiA+IEZy
b20gd2hhdCBJIGNhbiB1bmRlcnN0YW5kLCB0aGUgaW50ZW50aW9uIG9mIGlwY19wY2llX3N1c3Bl
bmQoKSBpcw0KPiA+ID4gdG8gcHV0IHRoZSBkZXZpY2UgdG8gRDNjb2xkLCBhbmQgaXBjX3BjaWVf
c3VzcGVuZF9zMmlkbGUoKSBpcyB0bw0KPiA+ID4ga2VlcCB0aGUgZGV2aWNlIGF0IEQwLiBIb3dl
dmVyLCB0aGUgZGV2aWNlIGNhbiBzdGlsbCBiZSBwdXQgdG8NCj4gPiA+IEQzaG90L0QzY29sZCBi
eSBQQ0kgY29yZS4NCj4gPiA+DQo+ID4gPiBTbyBleHBsaWNpdGx5IGxldCBQQ0kgY29yZSBrbm93
IHRoaXMgZGV2aWNlIHNob3VsZCBzdGF5IGF0IEQwLCB0bw0KPiA+ID4gc29sdmUgdGhlIHNwdXJp
b3VzIHdha2V1cC4NCg0KRGlkIHlvdSBnZXQgYSBjaGFuY2UgdG8gY2hlY2sgdGhlIGNhdXNlIG9m
IHNwdXJpb3VzIHdha2V1cCA/IFdhcyB0aGVyZSBhbnkNCmluZm9ybWF0aW9uIGRldmljZSBpcyB0
cnlpbmcgdG8gc2VuZCB3aGlsZSBwbGF0Zm9ybSBpcyBlbnRlcmluZyBzdXNwZW5kLw0KaG9zdCBz
dyBtaXNzZWQgdG8gdW5zdWJzY3JpYmUgY2VydGFpbiBub3RpZmljYXRpb25zIHdoaWNoIHJlc3Vs
dGVkIGluIHdha2UgZXZlbnQuDQoNCkluIG91ciBpbnRlcm5hbCB0ZXN0ICh4ODYgcGxhdGZvcm0p
IHdlIGhhZCBub3Qgbm90aWNlZCBzdWNoIHNwdXJpb3VzIHdha2V1cCBidXQgd291bGQNCmxpa2Ug
dG8gY3Jvc3MgY2hlY2sgYnkgcnVubmluZyBmZXcgbW9yZSB0ZXN0cy4NCg0KPiA+ID4NCj4gPiA+
IFNpZ25lZC1vZmYtYnk6IEthaS1IZW5nIEZlbmcgPGthaS5oZW5nLmZlbmdAY2Fub25pY2FsLmNv
bT4NCj4gPiA+IC0tLQ0KPiA+ID4gIGRyaXZlcnMvbmV0L3d3YW4vaW9zbS9pb3NtX2lwY19wY2ll
LmMgfCAzICsrKw0KPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykNCj4gPiA+
DQo+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd3dhbi9pb3NtL2lvc21faXBjX3BjaWUu
Yw0KPiA+ID4gYi9kcml2ZXJzL25ldC93d2FuL2lvc20vaW9zbV9pcGNfcGNpZS5jDQo+ID4gPiBp
bmRleCBkNzM4OTRlMmE4NGVkLi5hZjFkMGU4MzdmZTk5IDEwMDY0NA0KPiA+ID4gLS0tIGEvZHJp
dmVycy9uZXQvd3dhbi9pb3NtL2lvc21faXBjX3BjaWUuYw0KPiA+ID4gKysrIGIvZHJpdmVycy9u
ZXQvd3dhbi9pb3NtL2lvc21faXBjX3BjaWUuYw0KPiA+ID4gQEAgLTM0MCw2ICszNDAsOSBAQCBz
dGF0aWMgaW50IF9fbWF5YmVfdW51c2VkDQo+ID4gPiBpcGNfcGNpZV9zdXNwZW5kX3MyaWRsZShz
dHJ1Y3QgaW9zbV9wY2llICppcGNfcGNpZSkNCj4gPiA+DQo+ID4gPiAgICAgICBpcGNfaW1lbV9w
bV9zMmlkbGVfc2xlZXAoaXBjX3BjaWUtPmltZW0sIHRydWUpOw0KPiA+ID4NCj4gPiA+ICsgICAg
IC8qIExldCBQQ0kgY29yZSBrbm93IHRoaXMgZGV2aWNlIHNob3VsZCBzdGF5IGF0IEQwICovDQo+
ID4gPiArICAgICBwY2lfc2F2ZV9zdGF0ZShpcGNfcGNpZS0+cGNpKTsNCj4gPg0KPiA+IFRoaXMg
aXMgYSB3ZWlyZCBhbmQgbm9uLW9idmlvdXMgd2F5IHRvIHNheSAidGhpcyBkZXZpY2Ugc2hvdWxk
IHN0YXkgYXQNCj4gPiBEMCIuICBJdCdzIGFsc28gZmFpcmx5IGV4cGVuc2l2ZSBzaW5jZSBwY2lf
c2F2ZV9zdGF0ZSgpIGRvZXMgYSBsb3Qgb2YNCj4gPiBzbG93IFBDSSBjb25maWcgcmVhZHMuDQo+
IA0KPiBZZXMsIHNvIEkgd2FzIHdhaXRpbmcgZm9yIGZlZWRiYWNrIGZyb20gSU9TTSBkZXZzIHdo
YXQncyB0aGUgZXhwZWN0ZWQgUENJDQo+IHN0YXRlIGZvciB0aGUgczJpZGxlIGNhc2UuDQoNCkQz
IGlzIHRoZSBleHBlY3RlZCBzdGF0ZS4gDQoNCj4gRGF2ZSwgY2FuIHlvdSBkcm9wIGl0IGZyb20g
bmV0ZGV2IHVudGlsIElPU00gZGV2cyBjb25maXJtIHRoaXMgcGF0Y2ggaXMNCj4gY29ycmVjdD8N
Cg0KRGF2ZSwgcGxlYXNlIGRyb3AgdGhpcyBwYXRjaCBmcm9tIG5ldGRldi4NCg==
