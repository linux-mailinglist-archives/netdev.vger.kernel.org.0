Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC5A47C1B3
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 15:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238543AbhLUOmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 09:42:21 -0500
Received: from mga04.intel.com ([192.55.52.120]:7038 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234970AbhLUOmV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 09:42:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640097740; x=1671633740;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8bQebb4JvMEedNk1eEdedORl4mq01d19lHCazvz7Akc=;
  b=RQijPbySKbIjjWxU3cU8mPLEYf1x1Ww+KjIXDkEFvj8XS5uJJuTUl963
   NO9avpruqjbbsDK3bqRuQdQPgrff4vXN1ePJjgpSOju3/jnFbnOtjyEEc
   kgw0Ok547twfylY4vJn9RfHrJ7GsqpFijWw4meuC5yKpy2qx0WbCDh7Gn
   Vq2OM+h3uKtEu9rpMI/8T2vtBbAfzce7PKnOZ4e1cyxgfOkQxPUPPquIw
   DVjf4ffZ80bioUWrfw8X/JAI9D1qXsFAW6UjTZpZqeP5WB01p4Mf5KdqX
   tVfPsh50A4SFCseraRNLosNCCheTJ6O4gKQ/tEDtQvVz29VBaxofD87gl
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="239151880"
X-IronPort-AV: E=Sophos;i="5.88,223,1635231600"; 
   d="scan'208";a="239151880"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 06:42:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,223,1635231600"; 
   d="scan'208";a="467811610"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 21 Dec 2021 06:42:20 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 06:42:19 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 06:42:19 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 21 Dec 2021 06:42:19 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 21 Dec 2021 06:42:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A64CaM/3vVZ8W6uMEZEAg7pbD2+AcvfmlWtqmeXDBdoR4gQ3opoKCcRWluZC2YXDWCoNo4D86O8Guaac+8Z9ItYFn23IiDmY0ed0ZkywjyUx4i6xOdw288pr46mp4A4dkHT4KgpP/TZLMcXQcAL3rajORoFy0mDEE6zhiiggBwZb/MNxiG/alN7m79zxz2eZc5Z03Zykl13Ka0Z1nsW5ur/T31VJtKx5fOHQ1t8zNVl3yMrk0HKCO9HQ+Jw+a9YOqL7SXvDIZ7ooDZX6gJUtbowv/BAxFMttA/0r/LK0k4Klck1p7BsPE0TZVVCMML7mouuzdAQxkaEyE4Ny6AnCPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8bQebb4JvMEedNk1eEdedORl4mq01d19lHCazvz7Akc=;
 b=NjJ2XmBIGnJjTD8dFXY/A35xN5C7eZf9wbP3LOrHRHFojqR3wAvIA3vVqO6M+YFmA97IHRusbg5iEWfw2xUaKYqiI+AjaPakGa2kLmhEjXgPi2RYDigqtXvBTJWiEpk1kVyT3L4yngL9JVZZCAW8GtaJuUg47sW6kvO9PwzSziuQoH/CimJaQbub1T63J+VqiXIKFbRdQ15I4MphpGa8s8bJsQyGhSQKUU1AA44SOBwoifFzH43toozlg8MevUB0SmcZwHr14ydCeGvgTnylaNb64Zn7iy5oab2oOlWC10dnwqDKaRwFPmGHiRrUiFjzWue/TfqSeEMmmxcz5SfCkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5170.namprd11.prod.outlook.com (2603:10b6:303:95::10)
 by CO1PR11MB4867.namprd11.prod.outlook.com (2603:10b6:303:9a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Tue, 21 Dec
 2021 14:42:10 +0000
Received: from CO1PR11MB5170.namprd11.prod.outlook.com
 ([fe80::4c2a:62a1:d6e5:b67b]) by CO1PR11MB5170.namprd11.prod.outlook.com
 ([fe80::4c2a:62a1:d6e5:b67b%6]) with mapi id 15.20.4801.022; Tue, 21 Dec 2021
 14:42:10 +0000
From:   "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
To:     "Chen, Mike Ximing" <mike.ximing.chen@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
Thread-Topic: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
Thread-Index: AQHX9jcKOP1y1O92CEC3pIeygh1pI6w8h6kAgAAdWQCAAFcgAIAACB8A
Date:   Tue, 21 Dec 2021 14:42:10 +0000
Message-ID: <CO1PR11MB5170FB6317CE0A8ECBD0436ED97C9@CO1PR11MB5170.namprd11.prod.outlook.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
 <20211221065047.290182-2-mike.ximing.chen@intel.com>
 <YcF+QIHKgNLJOxUh@kroah.com> <YcGW3lm4UBbDHURW@kroah.com>
 <CO1PR11MB51707B01007B77CEF4F1640BD97C9@CO1PR11MB5170.namprd11.prod.outlook.com>
In-Reply-To: <CO1PR11MB51707B01007B77CEF4F1640BD97C9@CO1PR11MB5170.namprd11.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: d2d6bca4-50a0-47c6-fa5f-08d9c49011f5
x-ms-traffictypediagnostic: CO1PR11MB4867:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <CO1PR11MB4867462574C56F5448C0FE37D97C9@CO1PR11MB4867.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NwrAnm9woIlhzZ/lQuwS/XDT7cpHgUUJDRAtP/y5m2CkMlIx1dHtRPOKE+UTbt1TxdrXYCQoS+hP/VOvZdxwk88v+O/F3flempXdIae59BgDyqwY9eZbDt2NIubu7mx28bqEDMhZRjPYonJxYMq6F50skuThBrBDYQfq8uPwvcksTAtF98gWuuy/cPFFBpNAAxb2ybXYDPjHFppqxUkcILBM8OqOlpTJ6lPirXKManqJ5QnAu3HIEivb5YgXliHdtZeVZjQ17Dg4oe6oVLkUM3ntAUkHKvxm0nu2/PUfkOihoCdlD4pI75VB/VaAFGqiYUNVFxA7om2hc/dBnET4dAymwSTHSOut7M8EA/58gRfO1LoIW+Xij3717L7eQSzjmfEYIoNPKsHcMjigl0L9LeZhxnjLMyWd6fMlOETYENhSju+5Q3MAYsS9L45PYfrvLpM98yNhoamLapg+FD3OYJaLva+bCswIACXQEIs3Awn8no44HvOxsyiPSpd7sBefapnlESA6cb6+CfMTRy47mGsMV46OS/5mASU+Im40HQbeCQdFS6L8y+9MWjPaGCN8zI4pxSuZeXSbwJgIh5AP6ctc417mMaC9aNmR6GsG8e8htPTqOtskoGGKgLCWW3Rdf/tfM3Ei1TnHu0vgVg8WmOvOOSUxY9fMD2c3w9sycY+Y4tborYXOhnGIO80RCoYIB5dttmUfd8ncGqsXAtdpTg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5170.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(52536014)(2940100002)(9686003)(316002)(186003)(26005)(7696005)(55016003)(110136005)(76116006)(5660300002)(54906003)(8936002)(71200400001)(8676002)(2906002)(6506007)(64756008)(38070700005)(53546011)(122000001)(82960400001)(33656002)(4326008)(66556008)(66946007)(66476007)(66446008)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SVZZUlZIUm14b3JrTGoxdUgyQ0dvS0svNStmaEFoV0d2dlVGbW1tb3pUdm5W?=
 =?utf-8?B?Zk8xUFYxK0ZtYUczN0tJUmFKSUUxK2MvWUtHN0Qvb3A5R2pXeDBPeDI4V1hh?=
 =?utf-8?B?R1Y0OEs5dXRaeE1rZWJMdlRFOFNaTVBqQlhITjB1aW9NSFZ3RkF2VFZJSXNq?=
 =?utf-8?B?S2dSQzIxV09ib1RKcUsveEtPaXArMkwwTm11YS80bTZ2bGVFajdjYU16N2VF?=
 =?utf-8?B?aTNUTm9kdlB5QmN2dUhWYVcwY0FmU3h4Snd2a3EvYW5iMGNkWmNhR0FaaG1O?=
 =?utf-8?B?eEF0eDhnREF3SXIwZTV0Vk5KWFg0V2lJYmQ1a21Sa25jLzZhR0pYREZSWjRE?=
 =?utf-8?B?UUN0bFNkblBKcFRWZWk1b0dGYnFPLzhRY3lqOUppdzBKQms3dWN3VmVQeS9Z?=
 =?utf-8?B?MEVkUXJwT0krTUh3YmIwRlI2bXdQN3ZSUjA1ajdYb0pqZyswRjhjOERrVThn?=
 =?utf-8?B?NHVzVTRBbi9ETlRqbEJ3MXlvR2Q2cjNTdklOQWVtT2FJMCtQdDdvazVvMnBE?=
 =?utf-8?B?WDhqS1NtemNRNVprSE5QT3RvU1dTQlVsbHdiQ2dpL2dUWmhHUVBSS2VhSmho?=
 =?utf-8?B?UVNJdHgxTmFnVHIxTW9PRkQ5WlRFOVlGTjVEM2c5ckExcFh6WWtxanpWUVdv?=
 =?utf-8?B?M2RMOFFwQ3Nzd1c0WUpabWpBS09oVGlYS3dNeVVKcFZvUFZZZmJVR1pPTEh4?=
 =?utf-8?B?a0cyR1RUY2xLdHZrUHRSanFWREdmQVdGK04xRHFNcUxKRzdqTS90dlpSN1NG?=
 =?utf-8?B?M1hFM1dXY0ljNHBpT096SHNZclV5L3p1MHM3cUhyWjJ5ejZWRm5ZTGc3c2Jq?=
 =?utf-8?B?VHFOWWkxMUZKYVhxeEwxZU9sRUtoMGlTNjVFK0kxN3hLY0NMSFlpc3JGUitG?=
 =?utf-8?B?aDc1MW12QkRrc0RjRTFVb2tjempDY3MyWUVLQVdIUHVWRzJiMFJEY1Y1OVhK?=
 =?utf-8?B?aTRBVHhQTTdPRGErN21YVWsvc1Ezc2NFdWpvZUxiUkpvenNlWjhLd05Rc21J?=
 =?utf-8?B?QmQyeEpneGZlMFE2dHZ4K0ZjZ0JmWnNmTzR1UHAySU40N2JKWS9IRDdVbmlD?=
 =?utf-8?B?RlJZM1dBWkUzRDlDSmFncm5CZCtETFhqVVRJcXYwMFVZOHFJeXo0SlVkNjVx?=
 =?utf-8?B?bEkwVHNHcTd5anhqaGlhOFMwcjZWWlo4MDVPZENwZnZuWGdxeEIwWkdSNVdK?=
 =?utf-8?B?Z0E1ekRwUnpHWHAwYXlSY09pT1J6M2l4NUhkOHRmZzJWRlN1R1M5VEZMYWc5?=
 =?utf-8?B?QmpIL1Joc2ZlaFVSVEdaRlFoTm1CQTJzbXBtYlBYNjdBVWJhbzBSc3lvMlpN?=
 =?utf-8?B?STVCZUF5Z1NPcTdnKzZyRDM4VFN0OC9aNVNIVCtoMVR4YVYvVjZMYlIxb3R1?=
 =?utf-8?B?MXpBbnROdm4zZVhTTm5pNUl5Qjl3cklIYXZlWFlIZ2czMjlvSnFoQ1hkdGkr?=
 =?utf-8?B?bHFQRm1YYWdYWUdCVkhIaFJ4RjVuOGc1YXl1M1dVWWk3ZVRrSCtOY0tUb1JK?=
 =?utf-8?B?bzNRUjNrMGdNMFhGUTh6WTIyWENrNkhQbDhVN2ZnNUVSbVEwT1ZFY2FKelJp?=
 =?utf-8?B?MjEzVS9rZ2dybjNWZ0J6ZXA5SEprTjg5WHdYTHYzSzc4a3VyY2lzSXpYc3V0?=
 =?utf-8?B?Zkt3ODJ4bDB2Z0ZJTU01S3lRRXdsOXM1U0ZzU2xmb3B1TS9uWHpqb0pST1ZY?=
 =?utf-8?B?aE9ZRzZuZDlKS2I1VEFRWi9hcmJ6SW5yTEFHL1hKbjV2QVd5V29ZV3BZSVVZ?=
 =?utf-8?B?dzVCZXdkVEhkUlhsNTBWL2txN2c0VGlaYVFySW5HUVRjZGVNdGVOakc2S1Q3?=
 =?utf-8?B?cE9XRWFHOWxxREhSVnJab0JvY2FVSnE1UE9mVFBLTnhGQkY5TndqY2RFNzRE?=
 =?utf-8?B?T2lMUUVqS0RoRnFUeE11cUZ2cGl6SVNYOW9tbWtHeUtyeVBTMHpkeXlJYjJW?=
 =?utf-8?B?ZUlHU0JZOUZBWVFRVm1oTEJVUEhybXFpa0p3akIraEsweC9wNmdnQ3NCUlk5?=
 =?utf-8?B?RGkrZVJmVmVSeTR4YnZQcFNYRUR5cEZiVTNBUkpIcjFaZUpqOXBXSVJQZTFk?=
 =?utf-8?B?U1oxR2UzekVLc1hiVnM3VjRRTm45eEg0UERMQkdSWEo5WWpoTmxrWlJRYjU5?=
 =?utf-8?B?dnYrS1ZucnJnWk5WY1RLVFdWL0ZsTVo0SFRTNHoyS0pQT3B3S1FSNVJ0aTJv?=
 =?utf-8?B?eG9PYmZObUxJYnFWeXBpa0pwRVpyWEtqM1BQbWJEaGVjaytOMGh4OVZhZ3hN?=
 =?utf-8?B?NmF6Y0FWQWVFd0dhblZVNC9SZ21BPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5170.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2d6bca4-50a0-47c6-fa5f-08d9c49011f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2021 14:42:10.3710
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OQ3fxKNLsaMlDyFREKGnK7bvp4Qo47TuBr6LgFVKDf5ruVfRh/69UydUyDcXS1QRbO4LX2m/cLV5Ayg0+ITSbx2qrvfcAQykx9VH0NABaKY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4867
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQ2hlbiwgTWlrZSBYaW1p
bmcgPG1pa2UueGltaW5nLmNoZW5AaW50ZWwuY29tPg0KPiBTZW50OiBUdWVzZGF5LCBEZWNlbWJl
ciAyMSwgMjAyMSA5OjI2IEFNDQo+IFRvOiBHcmVnIEtIIDxncmVna2hAbGludXhmb3VuZGF0aW9u
Lm9yZz4NCj4gQ2M6IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGFybmRAYXJuZGIuZGU7
IFdpbGxpYW1zLCBEYW4gSiA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPjsgcGllcnJlLQ0KPiBs
b3Vpcy5ib3NzYXJ0QGxpbnV4LmludGVsLmNvbTsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgZGF2
ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJFOiBbUkZDIFBB
VENIIHYxMiAwMS8xN10gZGxiOiBhZGQgc2tlbGV0b24gZm9yIERMQiBkcml2ZXINCj4gDQo+IA0K
PiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gRnJvbTogR3JlZyBLSCA8Z3JlZ2to
QGxpbnV4Zm91bmRhdGlvbi5vcmc+DQo+ID4gU2VudDogVHVlc2RheSwgRGVjZW1iZXIgMjEsIDIw
MjEgMzo1NyBBTQ0KPiA+IFRvOiBDaGVuLCBNaWtlIFhpbWluZyA8bWlrZS54aW1pbmcuY2hlbkBp
bnRlbC5jb20+DQo+ID4gQ2M6IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGFybmRAYXJu
ZGIuZGU7IFdpbGxpYW1zLCBEYW4gSg0KPiA+IDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+OyBw
aWVycmUtIGxvdWlzLmJvc3NhcnRAbGludXguaW50ZWwuY29tOw0KPiA+IG5ldGRldkB2Z2VyLmtl
cm5lbC5vcmc7IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZw0KPiA+IFN1Ympl
Y3Q6IFJlOiBbUkZDIFBBVENIIHYxMiAwMS8xN10gZGxiOiBhZGQgc2tlbGV0b24gZm9yIERMQiBk
cml2ZXINCj4gPg0KPiA+IE9uIFR1ZSwgRGVjIDIxLCAyMDIxIGF0IDA4OjEyOjAwQU0gKzAxMDAs
IEdyZWcgS0ggd3JvdGU6DQo+ID4gPiBPbiBUdWUsIERlYyAyMSwgMjAyMSBhdCAxMjo1MDozMUFN
IC0wNjAwLCBNaWtlIFhpbWluZyBDaGVuIHdyb3RlOg0KPiA+ID4gPiArLyogQ29weXJpZ2h0KEMp
IDIwMTYtMjAyMCBJbnRlbCBDb3Jwb3JhdGlvbi4gQWxsIHJpZ2h0cyByZXNlcnZlZC4NCj4gPiA+
ID4gKyovDQo+ID4gPg0KPiA+ID4gU28geW91IGRpZCBub3QgdG91Y2ggdGhpcyBhdCBhbGwgaW4g
MjAyMT8gIEFuZCBpdCBoYWQgYQ0KPiA+ID4gY29weXJpZ2h0YWJsZSBjaGFuZ2VkIGFkZGVkIHRv
IGl0IGZvciBldmVyeSB5ZWFyLCBpbmNsdXNpdmUsIGZyb20gMjAxNi0yMDIwPw0KPiA+ID4NCj4g
PiA+IFBsZWFzZSBydW4gdGhpcyBwYXN0IHlvdXIgbGF3eWVycyBvbiBob3cgdG8gZG8gdGhpcyBw
cm9wZXJseS4NCj4gPg0KPiA+IEFoLCB0aGlzIHdhcyBhICJ0aHJvdyBpdCBvdmVyIHRoZSBmZW5j
ZSBhdCB0aGUgY29tbXVuaXR5IHRvIGhhbmRsZSBmb3INCj4gPiBtZSBiZWZvcmUgSSBnbyBvbiB2
YWNhdGlvbiIgdHlwZSBvZiBwb3N0aW5nLCBiYXNlZCBvbiB5b3VyIGF1dG9yZXNwb25zZSBlbWFp
bCB0aGF0IGhhcHBlbmVkIHdoZW4gSQ0KPiBzZW50IHRoaXMuDQo+ID4NCj4gPiBUaGF0IHRvbyBp
c24ndCB0aGUgbW9zdCBraW5kIHRoaW5nLCB3b3VsZCB5b3Ugd2FudCB0byBiZSB0aGUgcmV2aWV3
ZXINCj4gPiBvZiB0aGlzIGlmIGl0IHdlcmUgc2VudCB0byB5b3U/ICBQbGVhc2UgdGFrZSBzb21l
IHRpbWUgYW5kIHN0YXJ0IGRvaW5nDQo+ID4gcGF0Y2ggcmV2aWV3cyBmb3IgdGhlIGNoYXIvbWlz
YyBkcml2ZXJzIG9uIHRoZSBtYWlsaW5nIGxpc3QgYmVmb3JlIHN1Ym1pdHRpbmcgYW55IG1vcmUg
bmV3IGNvZGUuDQo+ID4NCj4gPiBBbHNvLCB0aGlzIHBhdGNoIHNlcmllcyBnb2VzIGFnYWlucyB0
aGUgaW50ZXJuYWwgcnVsZXMgdGhhdCBJIGtub3cNCj4gPiB5b3VyIGNvbXBhbnkgaGFzLCB3aHkg
aXMgdGhhdD8gIFRob3NlIHJ1bGVzIGFyZSB0aGVyZSBmb3IgYSBnb29kDQo+ID4gcmVhc29uLCBh
bmQgYnkgaWdub3JpbmcgdGhlbSwgaXQncyBnb2luZyB0byBtYWtlIGl0IG11Y2ggaGFyZGVyIHRv
IGdldCBwYXRjaGVzIHRvIGJlIHJldmlld2VkLg0KPiA+DQo+IA0KPiBJIGFzc3VtZSB0aGF0IHlv
dSByZWZlcnJlZCB0byB0aGUgIlJldmlld2VkLWJ5IiBydWxlIGZyb20gSW50ZWwuIFNpbmNlIHRo
aXMgaXMgYSBSRkMgYW5kIHdlIGFyZSBzZWVraW5nIGZvcg0KPiBjb21tZW50cyBhbmQgZ3VpZGFu
Y2Ugb24gb3VyIGNvZGUgc3RydWN0dXJlLCB3ZSB0aG91Z2h0IGl0IHdhcyBhcHByb3ByaWF0ZSB0
byBzZW5kIG91dCBwYXRjaCBzZXQgb3V0DQo+IHdpdGggYSBmdWxsIGVuZG9yc2VtZW50IGZyb20g
b3VyIGludGVybmFsIHJldmlld2Vycy4gVGhlIHF1ZXN0aW9ucyBJIHBvc3RlZCBpbiB0aGUgY292
ZXIgbGV0dGVyIChwYXRjaA0KPiAwMC8xNykgYXJlIGZyb20gdGhlIGRpc2N1c3Npb25zIHdpdGgg
b3VyIGludGVybmFsIHJldmlld2Vycy4NCi4NCiJ3ZSB0aG91Z2h0IGl0IHdhcyBhcHByb3ByaWF0
ZSB0byBzZW5kIG91dCB0aGUgcGF0Y2ggc2V0IG91dCB3aXRob3V0KiBhIGZ1bGwgZW5kb3JzZW1l
bnQgZnJvbSBvdXINCkludGVybmFsIHJldmlld2VycyIgIC0tLSBzb3JyeSBmb3IgbWlzc3BlbGxp
bmcuDQo+IA0KPiBJIHdpbGwgdGFrZSBzb21lIGRheXMgb2ZmIGFzIG1hbnkgcGVvcGxlIHdvdWxk
IGRvIGR1cmluZyB0aGlzIHRpbWUgb2YgdGhlIHllYXIg8J+YiiwgYnV0IHdpbGwgY2hlY2sgbWFp
bHMNCj4gZGFpbHkgYW5kIHJlc3BvbnNlIHRvIHF1ZXN0aW9ucy9jb21tZW50cyBvbiB0aGUgc3Vi
bWlzc2lvbi4NCj4gDQo+IFRoYW5rcyBmb3IgeW91ciBoZWxwLg0KPiBNaWtlDQo=
