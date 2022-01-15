Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C82548F41B
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 02:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbiAOBYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 20:24:24 -0500
Received: from mga06.intel.com ([134.134.136.31]:3847 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229610AbiAOBYX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jan 2022 20:24:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642209863; x=1673745863;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fMQPKDzvqSlU4Ft7jm3N7C31UhkH+LAQBcnjyWW4XeI=;
  b=ILi9LCTAYaEVDvrzXuliOswXqxz9Zddod20he1FFsR3noX+PlJvZ5c4Z
   J4SmWduyH3e8H89j3UNE64RTttV7ZTaB0Svh9Di37ygDuam7bfoJHszNi
   o+S4Mce25zNKRJLsZLBwZ/xbTBjh4nrvL+UxBvdIrqoEmSQ7tw/MZ20qE
   6VCSURDNjR2vkVedp5K/XVVBsLg0KAa7W3QkUNzJ2HdWRdhoxohNJflw+
   K9OHi6YKYPqfqThJR+g31EgGPuA4OLpJoKrujbYijmsFjtt9WxnMCCM3D
   jaf8Eph1r3fDaSNXybdxyT9TjEJBkB8rDeN7DlW3uGMkdmVS80bICZaPJ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10227"; a="305093125"
X-IronPort-AV: E=Sophos;i="5.88,290,1635231600"; 
   d="scan'208";a="305093125"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2022 17:24:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,290,1635231600"; 
   d="scan'208";a="763772333"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga006.fm.intel.com with ESMTP; 14 Jan 2022 17:24:22 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 14 Jan 2022 17:24:21 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 14 Jan 2022 17:24:21 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 14 Jan 2022 17:24:21 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 14 Jan 2022 17:24:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TDl41kcO6FV696a616Qr9GAhBOjOlGmxwoHCy9yJCkXMbUy6xQL/ol+QMYK5NWRYIj1pwINRP8c/wEy3o2Ob7KNR00EdQyrwwlwIScLnFs+wBRY755YDFJrul6eRfQi815KXppRSMN0RkcD5xm7tcFm7kme4EMy1lprtISLV6GjWRVknM9pU+gPNBk7Dh7l/i1dn6lBnNnujzrlxWpp5lobEt8GHDZjJUvIyIr/8nTXYGM+bGJKCReRXdPNNRlfReg6buP2pDfbPVjmNyxleMqeL4eg4+BUheCkGCpvx+yLx9YnC5H5PLipgqBWyinr0t2/ZoPASuoGpEtQS+hknSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fMQPKDzvqSlU4Ft7jm3N7C31UhkH+LAQBcnjyWW4XeI=;
 b=hVgwrFKdgHF0xjFb2G3Phix7D0ZrwJTAlyMf+VvfMg5DjlSZihd0wi1yTgHrydcclCZLCoMi/tvoqm5H7Tlk6zN09+RWvq8VUxPnXbv2oQ2EU1DOOc0Gdyf6tYSb7/OAYJIX5OV4zWQ6PHj7UVOkRIANYgoeU7icd9DfdoYMFFmVVJrff1VZ+q1dt9Xh4Qu6vM86vtp3ayAYVHiOD537XNpyLfv6UoKydJKQ96xJZBydO22A8nf55GkDsHOJ4PImbuD8LnUD/QhrxmtPr8shRDw9JYVuznhIJ++jH9EWm8YqJ2aY+BJWr7GDdbRCewbRecfkTxu3rz3dRTAPws+m+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by DM6PR11MB3468.namprd11.prod.outlook.com (2603:10b6:5:5c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Sat, 15 Jan
 2022 01:24:19 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::4843:15c6:62c1:d088]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::4843:15c6:62c1:d088%3]) with mapi id 15.20.4888.012; Sat, 15 Jan 2022
 01:24:19 +0000
From:   "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Russell King <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH net v3] net: phy: marvell: add Marvell specific PHY
 loopback
Thread-Topic: [PATCH net v3] net: phy: marvell: add Marvell specific PHY
 loopback
Thread-Index: AQHYCGPp94N5cs2TQUKXHHgRkeoabqxi+1uAgABQ1mA=
Date:   Sat, 15 Jan 2022 01:24:19 +0000
Message-ID: <CO1PR11MB4771EB057703E0B0982A8C97D5559@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20220113095604.31827-1-mohammad.athari.ismail@intel.com>
 <cdd16632-d9ea-3556-f7b4-6909289b593c@gmail.com>
In-Reply-To: <cdd16632-d9ea-3556-f7b4-6909289b593c@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9dfc1775-ef29-46a4-dbc0-08d9d7c5c11b
x-ms-traffictypediagnostic: DM6PR11MB3468:EE_
x-microsoft-antispam-prvs: <DM6PR11MB3468FBEFBAB39AFEA229F8B5D5559@DM6PR11MB3468.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +1t2YWuCEWUp0zULi6cw3zND9hxF1itx1lU3qd9xMNVNMGfkgdNQwPU2rHXfXYk4irknJTdxq/t0rbSmmnrUXrqtmuG7xdMSVupGPRtAM6vlLLyEz1PDkf1E2T0ffBDZIPNkRzR4JpUe/c8Oij/S6cXFg/a7Ny3FJWeeMmpwVMbnP6LmiAe0hBAhyDHZsdO7VwNM6KTgE581SWdnHQFkjSWgFraG8nzUPHOG4rCb8vKjqK2xMvUKSHCtv81nxYY3PPMX27J4euAJLg/bX/6rRVRAwIh5NZSsjhvnygNm6fBL3xZl00NWs0D9j+h1q+roclSRl+364MYvTgoENvXjUIgHAJb29v5Fl0AqnI303uGn4nipc0/4R0AITZPKYv/A4QBonMbVzwGUUrJY3tog0fPLL0qFMeCpLq6B827y4THzsEqGJ9X5hGrhrOE4x6R+BlhfYZgwMB9+W51jFYPm//aGjarnTtIZRQGCt76Yvt2JIWcAm0KtPM899UYbYcQQpxTZr9PRUoqPU7ilpsLBRfSWbuOWXpdolEr6Q1iQ/FYDKy5vLGJvLGv9MAm0zcbJtJWTJIUfI6IFvHXACpwcmad8h463NMlCGza9PivCLoGrX1JNmzx+93Vkqv0mroOOEAS/gchc9PYVopu59gVIOQf/N6UszkuflLr4S/XUxsmJbNcfUyqOoKTKUc+8J+5ivDPHm/gXZJpDKMPpCAO3+A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(110136005)(26005)(4326008)(55236004)(55016003)(9686003)(7696005)(6506007)(83380400001)(5660300002)(64756008)(66446008)(2906002)(53546011)(508600001)(316002)(66476007)(66946007)(76116006)(8936002)(38100700002)(186003)(122000001)(52536014)(54906003)(86362001)(66556008)(8676002)(33656002)(71200400001)(82960400001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T3pPbE9pNDFoRmZtUjNsRWt5Zjd4YzkrcHAyM09vckFMMU1uTEh1Z3RxRW9Y?=
 =?utf-8?B?TUxmQnZ4R1hJbG5qdU5kTnA1cjBZbWdOMHA0MkJQd0tJaUt2QnpFdE5FNjg3?=
 =?utf-8?B?NzIwNFVFUHNZUlo5WmdORmFOMmRRM1hxbEZkMDRwcktZcmc2dEsyQWliTDFS?=
 =?utf-8?B?RXppa2NVaG9pTzhKNFJHc0VMVXlBOGh6U1ZnQ09PM3JsYkdkaFp1aFNIN0hB?=
 =?utf-8?B?SkJKbjh6SWZIRVVpWS91LzV5OXVDUnk2dzd0RWRwYXRLWkluSHpVNlVQSXZU?=
 =?utf-8?B?dVFCL25wVit6ZC8yc0tMYm8wWGV3MlByZjE2dVRFeTZoemlZN3ZTc2Q5Vkt6?=
 =?utf-8?B?VXF6RHpDUDBvYU4rN3hDU2dGTHF0b1dYR2Q5MXE5OHRoUFNldlhOSUxzR3JO?=
 =?utf-8?B?MmlwRkF1emxRbTljZlZPRXlncHJaakpTeWpsTmx5Zkh5R0NDR2ErbUwzODMv?=
 =?utf-8?B?SXVMMHc4KzEvbzhVTzhPYmg0eWNGVWVURHUyQlljODVzMVpaaXVyYjBHYWVV?=
 =?utf-8?B?TndYc0U3dXdnVTB2UENCSDR6TUdiY29KRXpLM2lMSXZTVkI3S2FjOXJYU0U5?=
 =?utf-8?B?RWl2ZU5HaHdYU1JRbGZkYyt4NThicUNVamVjNVdmcmhhTVpkdm44VEJTbjV3?=
 =?utf-8?B?SmNYbDhzWUJBZkgwdkMycTdETGRlN3Q0R0dNUy9xakducURDVjdzUHhzU0hU?=
 =?utf-8?B?ZW1tOFJLNWRaa0EzY2NyWkJqa1I2aThFMmtWVmJjTWRNMWc3Skw2bVNoL3pn?=
 =?utf-8?B?RkVCbW1FUEVXNldKSUEvOXB4THp6N0M3UjNEKytvWnhYRlRWUlRTN0JDM2Yv?=
 =?utf-8?B?b1dBUjNYN1QwL3RRWGMzbENnZkx3Qm1CK2VhUDhJZHhHdlptR1BGNWUyUldu?=
 =?utf-8?B?aVQvanBBRzVCZVJ5MEEwWkF0Sm5QWWRrQUpUeXo1WUNITE54OFZ1MDYvaFBv?=
 =?utf-8?B?TXVOaS94c0lzSDJvclNVcHg4T0kwbUp3UWF4RHRoNXdIeEJpSGZNZjBHZHJD?=
 =?utf-8?B?VGoxdVBQZzJZTzdkSndxWkR4cUI2cW9HWU9rWGRvS0IveW51dnkvbXhTQ2Nw?=
 =?utf-8?B?MkY0UTN5ZFBWcWRJRFpRUGJZVmFQaytuT0ViK3hlK2ZSREdVWDlJYTRJb1dh?=
 =?utf-8?B?ZXI0QURRaThRUllMM3BiejdMWHUxZDNBalAxQW5aTHdDUnEvcy9nQ3VmVi9U?=
 =?utf-8?B?UVNjdUo0TEtDR1dnb3FDM3JRRVc0THFuak9MZU5QSFR3Z2V2bkFibnFDTkxh?=
 =?utf-8?B?NXVYT0lFU2RrMmNldUZHYTNoN00rN05SQ3JHSFExOUVvcWNtTFBwamg0eUsw?=
 =?utf-8?B?QVp0aGtkdzdhc0tqK2FQMkFNS1llenJJWThQKzVZUUg5dzcrTEQvV2xpVEdU?=
 =?utf-8?B?MGdYNjN2QmZ3NWdBODgzcTVITy8xUTRNVjJDQm01b01TOHFnR1ptMkc3b0lB?=
 =?utf-8?B?L0V2V0t5Y2ZEdWpKYVJ5ZnU4ak5SaHVTTDZwc2VjUER3ZFhqbDFpMkJZTWlQ?=
 =?utf-8?B?UTFGK0cxOG51L1V1dFBEOUVKYXlpUGZDZ3JIT2w4SXUycEFJSWNYMDQ1N2w2?=
 =?utf-8?B?SE9WVHkyQTY5Q01UbURFdExLdjl6OXovNm9Kam0rTXUzV09nVElUM21aZVpD?=
 =?utf-8?B?MnpqTTN5VU1DWjg4S1F2emtGWXAvdFVFK1V3dG5GdWlra08wTVdZc1gyRXo3?=
 =?utf-8?B?b2taZHduNWhMSmlrbjJkQWZXaUF1L3ZnV2kwNjZ1YUVJRjU2dVRNRU94bnZL?=
 =?utf-8?B?Zyt3aWxOaWdycEtzN3kwRWRqdW9mbk43ZStlNHpBa2lwSlQwRGZiUVdkQmZU?=
 =?utf-8?B?dnpINmhsSXpGYmgxenlKb0p4Z1BzMzluSmh1SWJ0MzUzaFVieGt1SDZQQ0Nt?=
 =?utf-8?B?UDBHZnp6QzV1R3IxWktpOFBXajdXazVEQ1pWM1J5TmJoVUtGWTRwbUxQQXBM?=
 =?utf-8?B?anNReitWQ3FldjZxOExoSzZJSkhrSG8zaDgvc3p2TG85RlZsdC9WVzFuQXpE?=
 =?utf-8?B?NlVqa1VwZ2ZQTEZJRGNWRldsRnQ0SnNtTE9BRm1ORGFhZStkVmUyYTZGd0Zq?=
 =?utf-8?B?aHJkdlFLQ2tjYVcxM2xjczhYcjRiM0tuRkc1Mk9GMVIvaGx2NFNsMlNYREJa?=
 =?utf-8?B?NjVyajVOV0JkamJQbHI1cTVjdCs1MFNaRWpCbWZ5NTVENkVBYnUwTUprY0hY?=
 =?utf-8?B?aC84ZmNCakZTZC9ZT2ZRdlNzbGNxOERKK2hFRzNrVU8rL2NINkJBaEdKK01w?=
 =?utf-8?B?akhQb1JqcGFlRFNvdzg3Tnpxc3d5TXZVT0dQVDlDM2Z6cmtBd1lvZVRwZlRr?=
 =?utf-8?B?STV4SE9CWVVWZkZYT2NYaEo0b1FubEtac2IvY1pwT0E3a1JIZXkrZz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dfc1775-ef29-46a4-dbc0-08d9d7c5c11b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2022 01:24:19.6743
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lf9G1qtZoIWTcGncdCeSxEAalKuVpnDpY/xUhJKttH0H3lGbuFFTbbm8SYWUPrPWoL8oPSASf2HA1ww5uOCqR+j7vsrdyHCxg8E83RVpQO+O+we4+rq2x8fOEUPyu7oV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3468
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSGVpbmVyIEthbGx3ZWl0
IDxoa2FsbHdlaXQxQGdtYWlsLmNvbT4NCj4gU2VudDogU2F0dXJkYXksIEphbnVhcnkgMTUsIDIw
MjIgNDozNCBBTQ0KPiBUbzogSXNtYWlsLCBNb2hhbW1hZCBBdGhhcmkgPG1vaGFtbWFkLmF0aGFy
aS5pc21haWxAaW50ZWwuY29tPjsNCj4gQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPjsgRGF2
aWQgUyAuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47DQo+IEpha3ViIEtpY2luc2tpIDxr
dWJhQGtlcm5lbC5vcmc+OyBPbGVrc2lqIFJlbXBlbCA8bGludXhAcmVtcGVsLQ0KPiBwcml2YXQu
ZGU+OyBSdXNzZWxsIEtpbmcgPGxpbnV4QGFybWxpbnV4Lm9yZy51az4NCj4gQ2M6IG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IHN0YWJsZUB2
Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQgdjNdIG5ldDogcGh5OiBt
YXJ2ZWxsOiBhZGQgTWFydmVsbCBzcGVjaWZpYyBQSFkNCj4gbG9vcGJhY2sNCj4gDQo+IE9uIDEz
LjAxLjIwMjIgMTA6NTYsIE1vaGFtbWFkIEF0aGFyaSBCaW4gSXNtYWlsIHdyb3RlOg0KPiA+IEV4
aXN0aW5nIGdlbnBoeV9sb29wYmFjaygpIGlzIG5vdCBhcHBsaWNhYmxlIGZvciBNYXJ2ZWxsIFBI
WS4gQmVzaWRlcw0KPiA+IGNvbmZpZ3VyaW5nIGJpdC02IGFuZCBiaXQtMTMgaW4gUGFnZSAwIFJl
Z2lzdGVyIDAgKENvcHBlciBDb250cm9sDQo+ID4gUmVnaXN0ZXIpLCBpdCBpcyBhbHNvIHJlcXVp
cmVkIHRvIGNvbmZpZ3VyZSBzYW1lIGJpdHMgIGluIFBhZ2UgMg0KPiA+IFJlZ2lzdGVyIDIxIChN
QUMgU3BlY2lmaWMgQ29udHJvbCBSZWdpc3RlciAyKSBhY2NvcmRpbmcgdG8gc3BlZWQgb2YNCj4g
PiB0aGUgbG9vcGJhY2sgaXMgb3BlcmF0aW5nLg0KPiA+DQo+ID4gVGVzdGVkIHdvcmtpbmcgb24g
TWFydmVsbDg4RTE1MTAgUEhZIGZvciBhbGwgc3BlZWRzICgxMDAwLzEwMC8xME1icHMpLg0KPiA+
DQo+ID4gRklYTUU6IEJhc2VkIG9uIHRyaWFsIGFuZCBlcnJvciB0ZXN0LCBpdCBzZWVtIDFHIG5l
ZWQgdG8gaGF2ZSBkZWxheQ0KPiA+IGJldHdlZW4gc29mdCByZXNldCBhbmQgbG9vcGJhY2sgZW5h
YmxlbWVudC4NCj4gPg0KPiA+IEZpeGVzOiAwMTQwNjhkY2I1YjEgKCJuZXQ6IHBoeTogZ2VucGh5
X2xvb3BiYWNrOiBhZGQgbGluayBzcGVlZA0KPiA+IGNvbmZpZ3VyYXRpb24iKQ0KPiA+IENjOiA8
c3RhYmxlQHZnZXIua2VybmVsLm9yZz4gIyA1LjE1LngNCj4gPiBTaWduZWQtb2ZmLWJ5OiBNb2hh
bW1hZCBBdGhhcmkgQmluIElzbWFpbA0KPiA+IDxtb2hhbW1hZC5hdGhhcmkuaXNtYWlsQGludGVs
LmNvbT4NCj4gPiAtLS0NCj4gPiB2MyBjaGFuZ2Vsb2c6DQo+ID4gLSBVc2UgcGh5X3dyaXRlKCkg
dG8gY29uZmlndXJlIHNwZWVkIGZvciBCTUNSLg0KPiA+IC0gQWRkIGVycm9yIGhhbmRsaW5nLg0K
PiA+IEFsbCBjb21tZW50ZWQgYnkgUnVzc2VsbCBLaW5nIDxsaW51eEBhcm1saW51eC5vcmcudWs+
DQo+ID4NCj4gPiB2MiBjaGFuZ2Vsb2c6DQo+ID4gLSBGb3IgbG9vcGJhY2sgZW5hYmxlZCwgYWRk
IGJpdC02IGFuZCBiaXQtMTMgY29uZmlndXJhdGlvbiBpbiBib3RoIFBhZ2UNCj4gPiAgIDAgUmVn
aXN0ZXIgMCBhbmQgUGFnZSAyIFJlZ2lzdGVyIDIxLiBDb21tZW50ZWQgYnkgSGVpbmVyIEthbGx3
ZWl0DQo+ID4gPGhrYWxsd2VpdDFAZ21haWwuY29tPi4NCj4gPiAtIEZvciBsb29wYmFjayBkaXNh
YmxlZCwgZm9sbG93IGdlbnBoeV9sb29wYmFjaygpIGltcGxlbWVudGF0aW9uDQo+ID4gLS0tDQo+
ID4gIGRyaXZlcnMvbmV0L3BoeS9tYXJ2ZWxsLmMgfCA1Ng0KPiA+ICsrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgNTUgaW5zZXJ0aW9u
cygrKSwgMSBkZWxldGlvbigtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3Bo
eS9tYXJ2ZWxsLmMgYi9kcml2ZXJzL25ldC9waHkvbWFydmVsbC5jDQo+ID4gaW5kZXggNGZjZmNh
NGUxNzAyLi41YzM3MWMyZGU5YTAgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvcGh5L21h
cnZlbGwuYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L3BoeS9tYXJ2ZWxsLmMNCj4gPiBAQCAtMTg5
LDYgKzE4OSw4IEBADQo+ID4gICNkZWZpbmUgTUlJXzg4RTE1MTBfR0VOX0NUUkxfUkVHXzFfTU9E
RV9SR01JSV9TR01JSQkweDQNCj4gPiAgI2RlZmluZSBNSUlfODhFMTUxMF9HRU5fQ1RSTF9SRUdf
MV9SRVNFVAkweDgwMDAJLyogU29mdCByZXNldA0KPiAqLw0KPiA+DQo+ID4gKyNkZWZpbmUgTUlJ
Xzg4RTE1MTBfTVNDUl8yCQkweDE1DQo+ID4gKw0KPiA+ICAjZGVmaW5lIE1JSV9WQ1Q1X1RYX1JY
X01ESTBfQ09VUExJTkcJMHgxMA0KPiA+ICAjZGVmaW5lIE1JSV9WQ1Q1X1RYX1JYX01ESTFfQ09V
UExJTkcJMHgxMQ0KPiA+ICAjZGVmaW5lIE1JSV9WQ1Q1X1RYX1JYX01ESTJfQ09VUExJTkcJMHgx
Mg0KPiA+IEBAIC0xOTMyLDYgKzE5MzQsNTggQEAgc3RhdGljIHZvaWQgbWFydmVsbF9nZXRfc3Rh
dHMoc3RydWN0IHBoeV9kZXZpY2UNCj4gKnBoeWRldiwNCj4gPiAgCQlkYXRhW2ldID0gbWFydmVs
bF9nZXRfc3RhdChwaHlkZXYsIGkpOyAgfQ0KPiA+DQo+ID4gK3N0YXRpYyBpbnQgbWFydmVsbF9s
b29wYmFjayhzdHJ1Y3QgcGh5X2RldmljZSAqcGh5ZGV2LCBib29sIGVuYWJsZSkNCj4gDQo+IE1h
cnZlbGwgUEhZJ3MgdXNlIGRpZmZlcmVudCBiaXRzIGZvciB0aGUgbG9vcGJhY2sgc3BlZWQsIGUu
Zy46DQo+IA0KPiA4OEUxNTEwIGJpdHMgMTMsIDYNCj4gODhFMTU0NSBiaXRzIDIuLjANCg0KVGhh
bmsgeW91IGZvciB0aGUgaW5mby4NCg0KPiANCj4gWW91ciBmdW5jdGlvbiBpcyB1c2FibGUgd2l0
aCBjZXJ0YWluIE1hcnZlbGwgUEhZJ3Mgb25seSwgdGhlcmVmb3JlIHRoZQ0KPiBmdW5jdGlvbiBu
YW1lIGlzIG1pc2xlYWRpbmcuIEF0IGEgZmlyc3QgZ2xhbmNlIEkgc2VlIHR3byBvcHRpb25zOg0K
PiANCj4gMS4gTGVhdmUgdGhlIGZ1bmN0aW9uIG5hbWUgYW5kIGFkZCBhIHZlcnNpb24tc3BlY2lm
aWMgc2VjdGlvbiB0aGF0IHJldHVybnMNCj4gICAgYW4gZXJyb3IgZm9yIChub3QgeWV0KSBzdXBw
b3J0ZWQgdmVyc2lvbnMuDQo+IDIuIE5hbWUgaXQgbTg4ZTE1MTBfbG9vcGJhY2soKQ0KDQpJJ2xs
IGdvIGZvciBvcHRpb24gMi4gVGhhbmsgeW91IGZvciB0aGUgc3VnZ2VzdGlvbi4NCg0KLUF0aGFy
aS0NCg0KPiANCj4gPiArew0KPiA+ICsJaW50IGVycjsNCj4gPiArDQo+ID4gKwlpZiAoZW5hYmxl
KSB7DQo+ID4gKwkJdTE2IGJtY3JfY3RsID0gMCwgbXNjcjJfY3RsID0gMDsNCj4gPiArDQo+ID4g
KwkJaWYgKHBoeWRldi0+c3BlZWQgPT0gU1BFRURfMTAwMCkNCj4gPiArCQkJYm1jcl9jdGwgPSBC
TUNSX1NQRUVEMTAwMDsNCj4gPiArCQllbHNlIGlmIChwaHlkZXYtPnNwZWVkID09IFNQRUVEXzEw
MCkNCj4gPiArCQkJYm1jcl9jdGwgPSBCTUNSX1NQRUVEMTAwOw0KPiA+ICsNCj4gPiArCQlpZiAo
cGh5ZGV2LT5kdXBsZXggPT0gRFVQTEVYX0ZVTEwpDQo+ID4gKwkJCWJtY3JfY3RsIHw9IEJNQ1Jf
RlVMTERQTFg7DQo+ID4gKw0KPiA+ICsJCWVyciA9IHBoeV93cml0ZShwaHlkZXYsIE1JSV9CTUNS
LCBibWNyX2N0bCk7DQo+ID4gKwkJaWYgKGVyciA8IDApDQo+ID4gKwkJCXJldHVybiBlcnI7DQo+
ID4gKw0KPiA+ICsJCWlmIChwaHlkZXYtPnNwZWVkID09IFNQRUVEXzEwMDApDQo+ID4gKwkJCW1z
Y3IyX2N0bCA9IEJNQ1JfU1BFRUQxMDAwOw0KPiA+ICsJCWVsc2UgaWYgKHBoeWRldi0+c3BlZWQg
PT0gU1BFRURfMTAwKQ0KPiA+ICsJCQltc2NyMl9jdGwgPSBCTUNSX1NQRUVEMTAwOw0KPiA+ICsN
Cj4gPiArCQllcnIgPSBwaHlfbW9kaWZ5X3BhZ2VkKHBoeWRldiwNCj4gTUlJX01BUlZFTExfTVND
Ul9QQUdFLA0KPiA+ICsJCQkJICAgICAgIE1JSV84OEUxNTEwX01TQ1JfMiwgQk1DUl9TUEVFRDEw
MDANCj4gfA0KPiA+ICsJCQkJICAgICAgIEJNQ1JfU1BFRUQxMDAsIG1zY3IyX2N0bCk7DQo+ID4g
KwkJaWYgKGVyciA8IDApDQo+ID4gKwkJCXJldHVybiBlcnI7DQo+ID4gKw0KPiA+ICsJCS8qIE5l
ZWQgc29mdCByZXNldCB0byBoYXZlIHNwZWVkIGNvbmZpZ3VyYXRpb24gdGFrZXMgZWZmZWN0DQo+
ICovDQo+ID4gKwkJZXJyID0gZ2VucGh5X3NvZnRfcmVzZXQocGh5ZGV2KTsNCj4gPiArCQlpZiAo
ZXJyIDwgMCkNCj4gPiArCQkJcmV0dXJuIGVycjsNCj4gPiArDQo+ID4gKwkJLyogRklYTUU6IEJh
c2VkIG9uIHRyaWFsIGFuZCBlcnJvciB0ZXN0LCBpdCBzZWVtIDFHIG5lZWQgdG8NCj4gaGF2ZQ0K
PiA+ICsJCSAqIGRlbGF5IGJldHdlZW4gc29mdCByZXNldCBhbmQgbG9vcGJhY2sgZW5hYmxlbWVu
dC4NCj4gPiArCQkgKi8NCj4gPiArCQlpZiAocGh5ZGV2LT5zcGVlZCA9PSBTUEVFRF8xMDAwKQ0K
PiA+ICsJCQltc2xlZXAoMTAwMCk7DQo+ID4gKw0KPiA+ICsJCXJldHVybiBwaHlfbW9kaWZ5KHBo
eWRldiwgTUlJX0JNQ1IsIEJNQ1JfTE9PUEJBQ0ssDQo+ID4gKwkJCQkgIEJNQ1JfTE9PUEJBQ0sp
Ow0KPiA+ICsJfSBlbHNlIHsNCj4gPiArCQllcnIgPSBwaHlfbW9kaWZ5KHBoeWRldiwgTUlJX0JN
Q1IsIEJNQ1JfTE9PUEJBQ0ssIDApOw0KPiA+ICsJCWlmIChlcnIgPCAwKQ0KPiA+ICsJCQlyZXR1
cm4gZXJyOw0KPiA+ICsNCj4gPiArCQlyZXR1cm4gcGh5X2NvbmZpZ19hbmVnKHBoeWRldik7DQo+
ID4gKwl9DQo+ID4gK30NCj4gPiArDQo+ID4gIHN0YXRpYyBpbnQgbWFydmVsbF92Y3Q1X3dhaXRf
Y29tcGxldGUoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikgIHsNCj4gPiAgCWludCBpOw0KPiA+
IEBAIC0zMDc4LDcgKzMxMzIsNyBAQCBzdGF0aWMgc3RydWN0IHBoeV9kcml2ZXIgbWFydmVsbF9k
cml2ZXJzW10gPSB7DQo+ID4gIAkJLmdldF9zc2V0X2NvdW50ID0gbWFydmVsbF9nZXRfc3NldF9j
b3VudCwNCj4gPiAgCQkuZ2V0X3N0cmluZ3MgPSBtYXJ2ZWxsX2dldF9zdHJpbmdzLA0KPiA+ICAJ
CS5nZXRfc3RhdHMgPSBtYXJ2ZWxsX2dldF9zdGF0cywNCj4gPiAtCQkuc2V0X2xvb3BiYWNrID0g
Z2VucGh5X2xvb3BiYWNrLA0KPiA+ICsJCS5zZXRfbG9vcGJhY2sgPSBtYXJ2ZWxsX2xvb3BiYWNr
LA0KPiA+ICAJCS5nZXRfdHVuYWJsZSA9IG04OGUxMDExX2dldF90dW5hYmxlLA0KPiA+ICAJCS5z
ZXRfdHVuYWJsZSA9IG04OGUxMDExX3NldF90dW5hYmxlLA0KPiA+ICAJCS5jYWJsZV90ZXN0X3N0
YXJ0ID0gbWFydmVsbF92Y3Q3X2NhYmxlX3Rlc3Rfc3RhcnQsDQoNCg==
