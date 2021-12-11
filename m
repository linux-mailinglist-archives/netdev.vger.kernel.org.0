Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4921E47141C
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 15:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbhLKODK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 09:03:10 -0500
Received: from mga12.intel.com ([192.55.52.136]:22084 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230511AbhLKODK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Dec 2021 09:03:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639231390; x=1670767390;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oH+f3HJX+mqkv+8wVdEufyRlZecMUxqhZHZuRtB1MEw=;
  b=FGJV+PTRhP3PpyWnP+BIGhrgRrFjzamT7d4n9t2HGEgNrPS2sQ2zELDe
   IMyXi+SGAWFNavF5T6D1T5Ec6cPpDjQd1InM3R+8s1pbVKZdhJiNV2gcX
   tVm1y70GYbYHHxpQhL2ayH9cAd8WkKkll7FRZk3s1vh7+IKggNpBuJO3a
   xfePt1rHnS7gCKXVkhiVCF863Zy9FwI9EXMUuq0wtNcw2PGNMdbNDiH3o
   DCLz+PoAlyd58rZKUrIXKqvV1d6Mahed23QaqaszwRda26wG3LDSdJcdc
   rRWCIZ7JFTzNA4M9sHAmijo5Q0lQ7ScJG2S6Kl+3+exfi9FEpnJIsGwZz
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10194"; a="218555158"
X-IronPort-AV: E=Sophos;i="5.88,198,1635231600"; 
   d="scan'208";a="218555158"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2021 06:03:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,198,1635231600"; 
   d="scan'208";a="613255166"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga004.jf.intel.com with ESMTP; 11 Dec 2021 06:03:09 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 11 Dec 2021 06:03:09 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 11 Dec 2021 06:03:09 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Sat, 11 Dec 2021 06:03:09 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Sat, 11 Dec 2021 06:03:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=An6a7/vALHKt9RwY12MzsftnOx/YPPty4XE+cPHbJtkf4yqvzm4gR6sHYNmfjbcu/KFckVQoD6LjNuhDuzAMNfS9NuMvt+urrvsEGQoulJvYsTUIDGiNR4qiZFyqdFeuEYYZqLNkX6SQ96gL2Opoqd7CUKspbl4kw/dtkVjMK7sVjdNrIY/c+r3+U6q0bJxavp5D/YwR6/GgnqzaiyXGGFytJfAK8iiKjgSECnGR6gcmaXlpFBTw31fu/XHsEcikpi7l74cgjLiKdnuu5WhhTHDubG9xnBIzo04t7kMMEpoBDE6fPjXTI3Y9ahu5AStL9yqqy7CI14a1ONvsovNGeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oH+f3HJX+mqkv+8wVdEufyRlZecMUxqhZHZuRtB1MEw=;
 b=RdIlEs6Jkn1nmtdU9SORVMOc7emqD+YKcsyBcyaWkzZCOLo4kq4IzEseoUvGV2DLR50y55O7L6e4KPNlrkVb9EOOBmGWXvt26tpnth9r2F/KlX4c/P7NS9ZazMCzFGtPTGH/yno1bRB7NhowmnObdpCAEzYocVWH1t59MnvhM16B0zB9p5iRFiW1x3un7ypJjiqTu/Xv46GFdAfSXpPXsBX1Jawi3lsRrrOKqnlEQ88xU/FgFX/L/Qch0CBrgxLlXEzh07C+qCeD6n65hNFNnXCBYnujOs97m8SvSUTOsc5LZpOtb8p7rnta79hCOyH2jEQdshN4NTOJ40zrHy4Q5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oH+f3HJX+mqkv+8wVdEufyRlZecMUxqhZHZuRtB1MEw=;
 b=B59XZmKcwyp201OECorxYVgQWSyoq7DBElxQuBPeX1ffoLprczbgpwpAQ2LrpHdd9di43O529peqknGw48VaVpwyz5RK2f0Egy4kLRgCL9GVLDsHX/m/Tm5FJrqGmMMOlku5wZ3lv7l11u2Y2jPeNEeM9hfhVOQVfmf0dI7k/vA=
Received: from DM6PR11MB2780.namprd11.prod.outlook.com (2603:10b6:5:c8::19) by
 DM6PR11MB4219.namprd11.prod.outlook.com (2603:10b6:5:14e::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.14; Sat, 11 Dec 2021 14:03:06 +0000
Received: from DM6PR11MB2780.namprd11.prod.outlook.com
 ([fe80::e08d:fd5a:f208:566d]) by DM6PR11MB2780.namprd11.prod.outlook.com
 ([fe80::e08d:fd5a:f208:566d%4]) with mapi id 15.20.4755.026; Sat, 11 Dec 2021
 14:03:06 +0000
From:   "Ong, Boon Leong" <boon.leong.ong@intel.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Kanzenbach, Kurt" <kurt.kanzenbach@linutronix.de>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Maxime Coquelin" <mcoquelin.stm32@gmail.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH net-next 2/2] net: stmmac: add tc flower filter for
 EtherType matching
Thread-Topic: [PATCH net-next 2/2] net: stmmac: add tc flower filter for
 EtherType matching
Thread-Index: AQHX7RBhnX+l/Z3pgUiTshD6FpbQWqwrghIAgAAeEgCAAbVJkA==
Date:   Sat, 11 Dec 2021 14:03:06 +0000
Message-ID: <DM6PR11MB2780AF6CA7085765EBA0C818CA729@DM6PR11MB2780.namprd11.prod.outlook.com>
References: <20211209151631.138326-1-boon.leong.ong@intel.com>
 <20211209151631.138326-3-boon.leong.ong@intel.com> <87fsr0zs77.fsf@kurt>
 <YbNAtugLvd83zP2W@linutronix.de>
In-Reply-To: <YbNAtugLvd83zP2W@linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.200.16
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33b4627d-50f5-4467-a63c-08d9bcaef4dd
x-ms-traffictypediagnostic: DM6PR11MB4219:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM6PR11MB42194302B57BFA03C63FB8B0CA729@DM6PR11MB4219.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PpTq5fhTR9IAGE1Wumr9noOjZGSmYWUc4hY+S5I3asrviprXlG/N8xafaodUun0lCuxZzNmHFioymDxT7/hZ94b+JdgC6D2t8F7KIVA7AYNZjc90Fsn2icGf+iafyAt7AVeNKxrRcdLTYWF1izuPlZkHiDiks710DSTaJJ6joyx9EJdGTSHS724v4eduQIDl3o2JGddx3nPsJUifN35VtvwSnPZQ280spdtRq53s5sDi4UuZ4xVqvo8cDcsq9NS2Zx3V2Y5GXBOXqxky4WjpSkzuIkA9hrovAG51Rihe6bKVtd3XVvFp+SN0fGDvE+NalN5Ww2qBOC8tS6gJZi8Omqztf1r+Vmtg8tgxHkJt/z/ZrkGXjJmeG9Q1/LmFs2wlpXgcI3GHrGdo+YE4LwvAGMB7MaJR2xxakSaYQ2aOG6Tlpr4h5ZysJl2g8S4TskacCaOWVL/M2RoxSR7vcgN740X6Tyubs7+7h5YnVUsxYyiwmG5aX3sLeFYIOX9c6gtHqzcjNu3lrUGOEtcZ0cNAhoxISEVZeuDeSqkD8iIUzUDlEL1d7hFBmLQUjv4e7EMsG0koBxefHCAV0NlOX/1i0y8f9CCuGt2RTJrqCJU3oS68eTomMiLdnQgxiM3zZEF/CepTjn3zeRobL7LsRX/qnCMWDfKdahyNN6wY6YDhL1vE7cXRrh/S4O66ZvGhedocgIWaQEqqXx3J6ev5QKNVfQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(76116006)(4326008)(52536014)(54906003)(4744005)(26005)(66556008)(66946007)(66476007)(64756008)(66446008)(86362001)(7416002)(38070700005)(4001150100001)(2906002)(9686003)(8676002)(110136005)(8936002)(508600001)(71200400001)(122000001)(82960400001)(186003)(7696005)(38100700002)(55016003)(33656002)(5660300002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MnoyVFU3a2twVjByZlo0OHZvbm5uRmhLQ3QwSzl4QzJUbUlvaHEreUNaSm5r?=
 =?utf-8?B?OVNocHkrbFlEQnNqK29IdmJYMmx6Z3pZRE5zazhpUkNnVzJoTjlabzF0aWxG?=
 =?utf-8?B?bUNVOVlMUTBrSE4xWXpIMmNQdmliZ3FIVUYvalovVWY1b3BzNTNyK2FteXFs?=
 =?utf-8?B?UGp0MGlkWUk3SWJrdWFxQWJOS2ZUNnM3eWtqUnR5ZjFJQVg3RndpSnpjajZW?=
 =?utf-8?B?ck5zY29UYmxUdzlUL0xkUmp1VldTNDhuU1Q2Sk05dEhGQlU4Sk03M09xbnhQ?=
 =?utf-8?B?YmNxUTJzblF0NGVYU2pQbXBVWnNHSXFIM3lwNGZhU3ZnVS9SR1FjdklUK2RJ?=
 =?utf-8?B?Y1RBNTluZXVqb2ZBOTlkdmp6dzFLeDd1OURGU0M2VmlTb09mL3dTN1ZlV3Zp?=
 =?utf-8?B?MWt6Q3BEcStGWWRFTmhYMXdNWHhiV2ZDV1hnMWtSdlFqZ085ZEhNRjR5Mm9R?=
 =?utf-8?B?NjVyUlZRREs1NW9TUENBMXRicXh3a2d0anFHMzZsWjd2SXFqblM3K3hNMFJ6?=
 =?utf-8?B?em4zTjd0ejd1TlVFc0xBLzdVOE45MDU2UWNUSUdYWWxlbEEyN2pjM0srcFd3?=
 =?utf-8?B?QTdBMUgrenFPa090TW1PMnh3Uzd2MnhNWnEreXNwcW11cUVrNEtybFRpOFUv?=
 =?utf-8?B?SWhneFZreDdnTW0xQnppakt0bU5xbDhwMGZRT0lqc3AvUmZMMkZkQ25wVzl6?=
 =?utf-8?B?cm9LREpNZm5zM2hYMnFqRjNrSWZrM3dzS0VCOEJFczlYQ280bDdzVWdhRU5R?=
 =?utf-8?B?SVdrVUhpRjJWUENIdStaL1doRk82SSsvWUxEY0ZvWnYyeXExejMvR2ptdGJW?=
 =?utf-8?B?MW1UMWVVbXQzYTNIZndDVmROdTI4VExJSjlWYlNhNmNINElKU2JSKzQzdnhG?=
 =?utf-8?B?YjR5VkZuREcxaVRXRWlmOEEwZzVaMHR1RnZQS2s0UGJzS0pMaWFZYmtHN1Mw?=
 =?utf-8?B?M3dwUDJpbTZFMkhRZ2hybmZEaDRTRWVWcDdEQVpZU3JoN0hpTmVkcUs5UnNn?=
 =?utf-8?B?eEFSdWhXN2tTTkppTE9QNzB5VDdpNkI1UHVKME5IS24rSTYrdlVZSTlDMTYw?=
 =?utf-8?B?WmJsYnRuSVljOU0vUzBCODFodmhiVTVrc3JFQWpDVm5CTUJQU2x4R0xpTDZ5?=
 =?utf-8?B?RnNSQVFTYm1GcTUrNy9VZTFURUVMSXFYYXlpWVdUY1drTzNwWGdTSWxaMzZM?=
 =?utf-8?B?WUdNVDNnM1NoaFBueUZYZ2xMQWM5enF5MlNDZjV1dm5RMklub2lvVFB4eVVj?=
 =?utf-8?B?MlpCejFTa3hTMzFaeDd3TFNiYlhKOTRBei9rL3k1U2pJUXoyeWhhS3p3dnYr?=
 =?utf-8?B?M0ZmbnkrbXBBeEV5V3BnUGhoUjB6UXlseFgwOWVtS0Y5akxObE44MS9Sc1V4?=
 =?utf-8?B?NHZLT2FXVHJGazBQeFJlMzFmazFHWkFORmk4MXJOdHdaQnF1VHM2SmZkT0VK?=
 =?utf-8?B?bE9ySGE0eGE0dlpNbWwwMlYrQnFUN1g0QWJOM2g3c3ZuaDNMUzhUS3VZWGd0?=
 =?utf-8?B?UUtKOFlwb2JMUnRJMEtJME1PdnBsY2xUQ202SlRkbUlSRWNqMnMrUkRNaWNE?=
 =?utf-8?B?dll4aGxiSFRJK1BMYUVsYWxVUVpKWlRoOVlSd1lFS2gwSHRwU0duM1ovMjJ0?=
 =?utf-8?B?aXFLYU82S0hwQ1I2RmhkOFpobTN2a0llLzlVQ1cwaGlYZ290a2FnOHRIN2tu?=
 =?utf-8?B?R0t6TXdkdkltckN4QnY1OGZhbWRkWDlkYXd4MkNJak9mckNWZnd0QWVHTHdD?=
 =?utf-8?B?ODFuYjZvUnpINTEzWlJ3TkFNRUpoRXFZcm1qMjUzeWtucnhIOXpZcGR6UTI1?=
 =?utf-8?B?TU5STyt3YlM0L3RyTG1vQ0lqQVVaV0dwRlYzYjFVZlJrMXdjU2VsUWJVdGlw?=
 =?utf-8?B?eC9oWWx5clV5NVZsQzZ2Z0x1dlMrUG4rUlN4OUpyb1ozUjhmZk9zT2U3djdX?=
 =?utf-8?B?T21YdTlKeFZXSDhIckgxV2Z2TDlkdHg2N0x1RmRhN0ZQUGlqczNoUy81Y0JF?=
 =?utf-8?B?b1VxdWFza2ZPRGo3MEwvYTZtemtVaWVFd0NuQi9sWXVkN2dDR1VnaFF4d0I0?=
 =?utf-8?B?Q21Nakt0cU1lcXJkMlE3Vjc5NTdkQjhPbmRIN3YxVFI5RGtpM2hLWmF0N01i?=
 =?utf-8?B?SXJTbGEvbmJuWjFLa0hvbXdLUllKamhLZVBjamlBVXZwYUNaYlBOd3NpYUJn?=
 =?utf-8?B?VHNONXoxcXdqcHpaSVpMT011dWhRaldGVEJOelA3ZDlhcytMSXpNNmJ3NUx6?=
 =?utf-8?B?ZThRTWpUUHo0MjJMUVdnM3ByL3ZRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33b4627d-50f5-4467-a63c-08d9bcaef4dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2021 14:03:06.7352
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l8q3iU3EsIQ914UPX0on3dlfPY1WIwoAg8PQ3KRjTKOQ4/XcaMcmrNrrhwE46X+5eKNfxiloH+Npv25fXnxXksV58RzIvFUhyEIMzz6/hRc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4219
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pk9uIDIwMjEtMTItMTAgMTE6MTA6MDQgWyswMTAwXSwgS3VydCBLYW56ZW5iYWNoIHdyb3RlOg0K
Pj4gPiArCWlmIChtYXRjaC5tYXNrLT5uX3Byb3RvKSB7DQo+PiA+ICsJCV9fYmUxNiBldHlwZSA9
IG50b2hzKG1hdGNoLmtleS0+bl9wcm90byk7DQo+Pg0KPj4gbl9wcm90byBpcyBiZTE2LiBUaGUg
bnRvaHMoKSBjYWxsIHdpbGwgcHJvZHVjZSBhbiB1MTYuDQo+DQo+V2hpbGUgYXQgaXQsIGNvdWxk
IHdlIGJlIHBsZWFzZSByZW1vdmUgdGhhdCBfX2ZvcmNlIGluDQo+RVRIRVJfVFlQRV9GVUxMX01B
U0sgYW5kIHVzZSBjcHVfdG9fYmUxNigpIG1hY3JvPw0KPg0KPj4gVGhhbmtzLA0KPj4gS3VydA0K
Pg0KPlNlYmFzdGlhbg0KDQpUaGFua3MuIFdpbGwgZG8uIA0K
