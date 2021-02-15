Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F58231B692
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 10:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbhBOJjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 04:39:47 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:18082 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbhBOJjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 04:39:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613381978; x=1644917978;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=F3+ZfG9KhNRKY8vPTGbZ0g6LGe6UFFNTfBH52yxXNiA=;
  b=E6FaDOuKLu8lw/p5JyUfpSr/mD1IjghIPeTaOJ3FXRe/toY/g59SBHxi
   kMIxSysaPy2wTgpuUmMAoYn4muUyugzAP6w32LjtPYhcqI2uSqea+ghkP
   OdFbIqiJZYQirVUI6exub4bxCWJViFK+ahl0VKFydjMCHZMmA9uiBGTHg
   HHP19Adp2QjyVt0gr3YYCmgIywsAOr/s5/4CrNV9e1RMwyQPL2OC/rtNh
   zPu/PhBD5XwmTBPGvaZOeSOIg4e+l5sqnFvzmoDyqws3S9wr26Kxfudt5
   MSdhZvhuPjBDWucusCDww3lc8oMf22kmHJE8Brya3rhno94pqvoiqjeNi
   w==;
IronPort-SDR: uUtsDyxurNS9ZVQ2DcI7A9kog2akk54fn2lUCEuvxJABvatE2ryYWsN5zOle0W4rxVRiNiPPsI
 ODZtYYl2KjTD6HUg9vJ3Ck61CYcJ2y7RmaZf+bgR3HfOEGpHT6l+07nc6zXwd3JpJgEQ/p0w7A
 ++mb1uzskP4mdQh+Tt88NF7+QAevNu0EyQe/a4bFS/y6Fgunv62S8t5nUHay/RKj1oq/EXWIOI
 0GbECrDHc9eQqgKBHkx2EcJTMLRDsbcywoqh3XTRLG6xk2fjfSbkUkgA8S4Tp1bWYvZzbHhN+x
 Hsk=
X-IronPort-AV: E=Sophos;i="5.81,180,1610434800"; 
   d="scan'208";a="103764301"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Feb 2021 02:38:22 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 15 Feb 2021 02:38:22 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Mon, 15 Feb 2021 02:38:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NPa+lX+zGH2GBwwWxuxvAMzASEJw0V4B+pCCNQoPMkeyaCo+7suO0HmDuA5NaUw+b0bH4PhQrT7deXJlMCrDEmMnqfa5kPrvbmC/mWv9aV7QMcaberuMjpJXTmEJGF1CEhJp9VbT84t+GJrn8NIfWX24/6tVsZ0SdAHQdJxfFaZBk9d6ak8BptRjiDq326ZrEfJ2Bd3JCpS+/SLUHOHDp1FP1b6VGrBEJKXUy/o/jFv+iMZ5JrOJwXwUlaWn3GDLrQW3SYtHFvVlCLMZqhtBEisGgF4zr+UmR0d0Y15ZE+kiIuZeeJvaRq+GsjGfwenSQ4wIJ1j7pKCZIHZOk9TdzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F3+ZfG9KhNRKY8vPTGbZ0g6LGe6UFFNTfBH52yxXNiA=;
 b=PFtGQhYklBb7OVpmDd+l0037Ylmt+Zqlox/Awl/bQF0t2fFR+a95YO4GfnuAzRUv/pL4Js/1JQhQ5Eqp68S5HJjxWanGgM83mD+d9rs66H/pQq2mAEfU8+LKQBoqBcmSa2oIF/9Rf4TMDyqHHvU67ev+L5WGLK+fSmWKgR4LVJDi5U0et8OphVAomEm7wvuja50L97NdxYHXwmuyLb+hHVhF6LdljIrHKFvyLL33v0/4qm72Gsg594Nmzyh56Pm1LxyWBNGP79yYt52YBywfZq5/Z0AxvQZkdvKiaDcdry/Cx0SecdnMPAs2q7bW174+MNhi+XGtATn/Sck66UYvlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F3+ZfG9KhNRKY8vPTGbZ0g6LGe6UFFNTfBH52yxXNiA=;
 b=DGtcgMdjAyZtkYaIZlBd32kUtOWN1+U6bf0Zn8PabyJupF8yYyNKpkX35O7spm0U2FmBaqRyiYQmW1G8rP+VU79w5ZZVckYkfKNsdqr3DXNvEQUakDxgKL5uQlIIWhyHvJiM4sldmldjo3XRLZFG8ngekaqRkhO6VFuTukvhXho=
Received: from DM5PR1101MB2329.namprd11.prod.outlook.com (2603:10b6:3:9e::23)
 by DM6PR11MB4364.namprd11.prod.outlook.com (2603:10b6:5:201::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.38; Mon, 15 Feb
 2021 09:38:20 +0000
Received: from DM5PR1101MB2329.namprd11.prod.outlook.com
 ([fe80::e048:33b3:3453:5a9]) by DM5PR1101MB2329.namprd11.prod.outlook.com
 ([fe80::e048:33b3:3453:5a9%11]) with mapi id 15.20.3846.042; Mon, 15 Feb 2021
 09:38:20 +0000
From:   <Bjarni.Jonasson@microchip.com>
To:     <kuba@kernel.org>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <Steen.Hegelund@microchip.com>,
        <linux@armlinux.org.uk>, <f.fainelli@gmail.com>,
        <netdev@vger.kernel.org>, <vladimir.oltean@nxp.com>,
        <davem@davemloft.net>, <hkallweit1@gmail.com>,
        <atenart@kernel.org>, <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net v1 1/3] net: phy: mscc: adding LCPLL reset to VSC8514
Thread-Topic: [PATCH net v1 1/3] net: phy: mscc: adding LCPLL reset to VSC8514
Thread-Index: AQHXAUhdJHjYZpRQGkCBgBTJu+lKnapU3gSAgAQcAYA=
Date:   Mon, 15 Feb 2021 09:38:20 +0000
Message-ID: <f526323e0a15f2d5ade272a99a806e58a3571112.camel@microchip.com>
References: <20210212140643.23436-1-bjarni.jonasson@microchip.com>
         <20210212105303.5c653799@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210212105303.5c653799@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [82.163.121.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 59255449-32b4-4452-cdd7-08d8d1956e9c
x-ms-traffictypediagnostic: DM6PR11MB4364:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB4364410DBD3DD19B677F78E8E4889@DM6PR11MB4364.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1751;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FngvKh+6TMWnJvbf9Kie5O6YeW4mnUMCAQQSHGgrS0WXv9sMVWybSI/JdfZOZnk2KDMGh7g+M56t5k4bn1MnmNSfiNJDdzHK9HaIVh4KBdBtEs5aZvf3QkyQ7Og5GtjgeXKBk6OJFaPm6+rskCQHk7gT6G/qYtoumsJbkZ2vtzUgZVh96jiW2ltGN665BIJW5JwDs1XsPuk8pbwd2wQw6yVFlv8iwYmUR75PW2NfHqFWtVnUfvwNmvwZs39CDeNpbaJsiJoyNSuA8vXZuAmCLEkHfk1mxVDy+esRwCiQxgAbHaMgDitJYTF61fDB04mX7juOOk2qnL8AyupPBbNNCNNt+AHsZ8qGaZqieFtTvjHc/X7m9WaM6PKKsFhYRQM2uUKgTpoHmAFOJxt/FAIFIvVCRi85TMiIkItazRkh7Z3SRDc+rU9E4dwINY6of+ClIGZibyCE8ZgF1vOdKRvZI9ZpzNa9Gz9CYCaQqVy+dc2icIIH7XDPr65MV5hRAA68syhyf6QLdhfLXDfr8qFmPHAyz2Zx6swTATCbjsdzcoTF9SZsAnaX+6NxJwCoiR8O
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1101MB2329.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(396003)(376002)(366004)(2616005)(2906002)(316002)(7416002)(4744005)(5660300002)(54906003)(83380400001)(4326008)(6506007)(36756003)(8936002)(478600001)(8676002)(26005)(71200400001)(186003)(6486002)(66946007)(6916009)(76116006)(91956017)(6512007)(64756008)(66556008)(66476007)(66446008)(86362001)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?OXNlU1ZjSGZiSFh4aGtiRlpHMzNvTUU4M3Z2TXkzZnljMEN4cmFReVMzUXlx?=
 =?utf-8?B?ZjNpNFplQlR2RkdZM2RXNWtoVS9GOVVWK2dGUVZnTW04aXZLMDF4dmpkUHhB?=
 =?utf-8?B?bFVFZXdzZXh2N1l4b1ZxcnhpNUZzR0FNTnBMeUJySnJFSk5SYXZkVUtaVzRo?=
 =?utf-8?B?eVpzSGVDT3ArVzE1MzhUTzNJSE4vUlRXeXZtZy9qeFFiWmNpWkgwOXg1TVJO?=
 =?utf-8?B?SW1wdGxzZHlyajZ5RGVVSU5Ha0I3OS9OZjRtNlkxZ25MamFkWFJWQ3dCR0JR?=
 =?utf-8?B?bW1wMFdlL3pOMHRMTGZvbXFCbE43REtQV1Y2VWVKMWNqWlpPQTZYandMU2hv?=
 =?utf-8?B?SW5PUVBOY1FOWS9wUEVibzd4TkgwOWJZTkJqTmxueklrQVZNSUlEcFk5Vkto?=
 =?utf-8?B?MmFkRlNqSTJ4NE1SM3RYQ0pCZU1WQ1Fub3JXNEJGVXdROUVXTFRJcGdMSTNP?=
 =?utf-8?B?TURPek1UeWRjTG1nRUw0VHYzVHY1aFZnQjl0NjhHdjdhZ1l1d1JoUXJHNDR0?=
 =?utf-8?B?eStmR2NYa2Y4c2Z0SDJSVzUxNFN6SGQrdmRtWHQ2MktSZ3RvWm9JaSs3QWRN?=
 =?utf-8?B?RktUR3NmR01mQklKNWV4REVraTVQSlB6RTRRZTV4TjR3Z0pnN00vK2FnbHhH?=
 =?utf-8?B?enhGd2U1RHJTRWxiOU8vRGtrWW5uWU5hQVl5NmhVMHBTNEdsdmc3bHlRUkJK?=
 =?utf-8?B?Q1dFb2lhTGJnSkZNMUc4WlBpa3pBa0dDT3dUOWF2MkpiNkRIbHlFakVMUlM4?=
 =?utf-8?B?VncwQlpxZVBNcG45MktNREE4RVJVSlJkeGNSa3BCMm4reGoyblhuOHJLLzBE?=
 =?utf-8?B?KzdyMmtSc3FuYnlSUjk1UGl6TjRqbmRMU0x3SkVZcS9wUDhIUm5VRCs5QzlQ?=
 =?utf-8?B?OFZiMFdPdGtjUno0eVNTMDFwenFZV01WRTU4RDZkQWRQNWQ1c00wYUlXRm1Y?=
 =?utf-8?B?d0NhWGdrUVNabWhvM0s3TDNJQ1huNTliVFJIQTJaSXFLSkM0NkRyZ2p2RVJY?=
 =?utf-8?B?M3RWTGMwZFBIc0IyUkxSeFNaSDkzMFU3M2xyK2NqTGpZWnZ5NWFnc0pTekl0?=
 =?utf-8?B?T2NkbjZBQXhiWFJLSXVyN3BkRkZtVnVIazhjTUtkdWU2MlZ1eGZRZkVLOWJ5?=
 =?utf-8?B?aTVnRlRmd2Z1MjBLMkVTajNYbXM3aHFVcFRMTUt5Wks4V0pyRSthUVVmSjRu?=
 =?utf-8?B?QXRjVTJ6cURsaXZLVWF6Y2N3VXBUcTQ2YjlwWnJKU0UrbFVvRWUvK09HT3d0?=
 =?utf-8?B?VldNTjIvZXFxUnhuY2dWaFdndkw3b2JReHMvTkdTV2tReHczSmNvUU40QmlZ?=
 =?utf-8?B?QVp3K2xtN2s2NTBKM3JKVHNlSmlJbG5wZ25aelBhMGRndFZuN1FHdkVYOVYy?=
 =?utf-8?B?dGRYNHZoL0x0anM5b25pd3ZZdCtFUDJNdlZIWURUek1aZ2RnN0ZUb2pPVGxM?=
 =?utf-8?B?ZGgxTWZRRHhFbUpBOVVmdmFNVVdYMm5INm9GdnVVT3Z0cHNGaS9sRVZjR0dR?=
 =?utf-8?B?WXBwRXhlM2pZL3piVys2cnpXS1JyK1d3TmovMTA0Vmx0TlREWjdDNjZUQVk5?=
 =?utf-8?B?Uk1YRkRKajZZOE1YKzkvYkRSa3B1ZE90NzQ5Vmdmc1NTcGhPQytDRmhhbkEx?=
 =?utf-8?B?ejlJUGxQcmM2eFJiaEdtMktaWnlGTlp5Y2ZWMVpKNWZkVi9CKys3SHN0UFQ0?=
 =?utf-8?B?NjhtOCtqenRvNDIrQm9BazdaODE2ZXNYa1NFUkswa01Wb2VVN1V3WENKUWVs?=
 =?utf-8?Q?qwLxnWHAdBd3Uqlw972GxRCws32iKdUF9XxjF09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D12EC3A259DE564ABB419A81B973D0B1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1101MB2329.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59255449-32b4-4452-cdd7-08d8d1956e9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2021 09:38:20.7668
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lhEWiN7KIUsrt9pZyLGJqFVnGawEoiszHdOd1HqGQsrqauBeVWc6pY8WyW/b+Fwy4pnrmSrFTcMWQJAmHmklnHanGEXd1gYyh0o9mZ/lUDQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4364
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIxLTAyLTEyIGF0IDEwOjUzIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRz
IHVubGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiBGcmksIDEy
IEZlYiAyMDIxIDE1OjA2OjQxICswMTAwIEJqYXJuaSBKb25hc3NvbiB3cm90ZToNCj4gPiBBdCBQ
b3dlci1PbiBSZXNldCwgdHJhbnNpZW50cyBtYXkgY2F1c2UgdGhlIExDUExMIHRvIGxvY2sgb250
byBhDQo+ID4gY2xvY2sgdGhhdCBpcyBtb21lbnRhcmlseSB1bnN0YWJsZS4gVGhpcyBpcyBub3Jt
YWxseSBzZWVuIGluIFFTR01JSQ0KPiA+IHNldHVwcyB3aGVyZSB0aGUgaGlnaGVyIHNwZWVkIDZH
IFNlckRlcyBpcyBiZWluZyB1c2VkLg0KPiA+IFRoaXMgcGF0Y2ggYWRkcyBhbiBpbml0aWFsIExD
UExMIFJlc2V0IHRvIHRoZSBQSFkgKGZpcnN0IGluc3RhbmNlKQ0KPiA+IHRvIGF2b2lkIHRoaXMg
aXNzdWUuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogU3RlZW4gSGVnZWx1bmQgPHN0ZWVuLmhl
Z2VsdW5kQG1pY3JvY2hpcC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogQmphcm5pIEpvbmFzc29u
IDxiamFybmkuam9uYXNzb25AbWljcm9jaGlwLmNvbT4NCj4gPiBGaXhlczogZTRmOWJhNjQyZjBi
ICgibmV0OiBwaHk6IG1zY2M6IGFkZCBzdXBwb3J0IGZvciBWU0M4NTE0DQo+ID4gUEhZLiIpDQo+
IA0KPiBQbGVhc2UgbWFrZSBzdXJlIGVhY2ggY29tbWl0IGJ1aWxkcyBjbGVhbmx5IHdpdGggVz0x
IEM9MS4NCj4gDQo+IFRoaXMgb25lIGFwcGVhcnMgdG8gbm90IGJ1aWxkIGF0IGFsbD8NCg0KU29y
cnkgYWJvdXQgdGhhdCwgSSB3aWxsIG1ha2Ugc3VyZS4NCg==
