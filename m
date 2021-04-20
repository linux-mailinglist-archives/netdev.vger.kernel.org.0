Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB48365950
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 14:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbhDTMyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 08:54:55 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:57420 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbhDTMyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 08:54:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1618923261; x=1650459261;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dEFAUqHW0fGr1pwWWfapMq1ldcU9P3bsTQL10wVvELI=;
  b=IbTjSd21OKsvYi41GyQ8EzMza605z0DHJD7sK85hd3wJS6hBXMT7DVoP
   /+CKV3tcZS+b04NdpQp9SKYzq0lqmcz2b+NOuDxMUI8E6pJXSNrXscJIB
   o5opJjG0KXQlBEGhwDB/Tr8RdkRy2uv+ilOSesyjnAToLSkxI6cq2XDL9
   QnxkcKT5MNUpiy2t63vPE7DsY/71O/St/crtFq6MVDZ79vdHHudV/C7W4
   0DW7GRCJ8g+iLx3YNLsqEAlV7ZxYBGlicKwwhHYnmQ7vjcgVx+pzziKSP
   j5qgmbUsFZ9v+G5xgtEgnC4ObMs11h4i8eYi4+LtzMVPPTvsIZtXg/SDr
   g==;
IronPort-SDR: ilACwkGmJSayi8C9Qrq7y3e5CBp4jvC3xwY1cTO8w8dfHuIw+6UzBGRxoDzOvZEL/5ldBxWo9N
 9bfsL07t0kCnP6cxUwKio0NEzFMcmkWaqcgwQ8TDRmQiMbkGPufOnOO/tcqTQC6W+RAt4kgFd/
 +9Zdph/nW0xgiwFpRiWS/02oeb/cRQL9v7SM52zHxgTK66VsCxW9IdroaXnNUoj6JPk9zSWvEv
 YlahtCquGnI2IvSVfI48fNDjO/Uz5Lyq7JHEMC+lklHy0QC4Vj5o7Jjycqn6LI5C6X+YKicNvY
 LDY=
X-IronPort-AV: E=Sophos;i="5.82,236,1613458800"; 
   d="scan'208";a="51815096"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Apr 2021 05:54:20 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Apr 2021 05:54:19 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2 via Frontend
 Transport; Tue, 20 Apr 2021 05:54:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GzsSNmsNcBMoLvp9Udu0TIZ+BMTNtlwP7fTU/3xnulXpMOIX0pGgSWvjTYEX5dqDztGsalXJDngppAhWY+XdcgYiHzNLVHMkN/MXPV2lImiY6giF3HnxTPFjcv8Rk59z6PsnUE2TBB+75I/XK+BPPd1Bg0WyqE9tGjh4g6iHOgE5HnA9A+RzGUGHyovaVJNkrwgAA0JE2brOwXXMBlfakm0OkCokxToNFz0iizr99bqTUfQOtM4KHAPQGlFH16e8hHuy1naRsBWWu5TMcX3/kshWP0ej6K9c4yY42Y4lwkAm7JDEfpXyzI2OrQKdRrqjpyXk5ua9O57xOaTxD8ICFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dEFAUqHW0fGr1pwWWfapMq1ldcU9P3bsTQL10wVvELI=;
 b=Q4tLaWt3K5ldC1R5Hp89VOqsSnx5lFVsXKIqKQPHhMc7CoJqzeXRb6WkKYbWEC8XwrihS20Xy2yoXFj9uaH5mwtHfLt2XdQHL6xKf0h33+TtuH9aLGG4kVSMpezHD9JkWYHpQiTYgc+tQmBa8cL4qJJZyqas6tBoGwh0dwy+87C/Ldqmees1qVFJJtYo8kOSW6btWs+wuj92sRHE9bRhaO3ENwHbnGiuG2nDgudFLc5EkVOhzDF4aaRcouvkaHr8BmR2I3Qu/tqfQ+WcBlbv/G6Gl0mqlSf9PbOkZP9inCJTYtXCsQO06l5P6evAK1ZH5cFLAr2DfmW+DTHZTDG3Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dEFAUqHW0fGr1pwWWfapMq1ldcU9P3bsTQL10wVvELI=;
 b=NPZ4Qi5m7XACUw0DIXnq39HOt7pvwjnUeiElzrZ1UtceXPokvYox7nYiB4E4Q/YSLntdQ/O3NRLQyL2pn5dXyxVmjhgW+oqVyBRWXBOIKFUZD6EH5xztavhTa/4FQorJjNNk2s2CLMB85ZgeYePDxRr1FE+ciVoh9ZsWs75BGdc=
Received: from DM6PR11MB3417.namprd11.prod.outlook.com (2603:10b6:5:68::33) by
 DM5PR11MB2010.namprd11.prod.outlook.com (2603:10b6:3:12::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4042.21; Tue, 20 Apr 2021 12:54:15 +0000
Received: from DM6PR11MB3417.namprd11.prod.outlook.com
 ([fe80::c994:babd:c007:eeb3]) by DM6PR11MB3417.namprd11.prod.outlook.com
 ([fe80::c994:babd:c007:eeb3%4]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 12:54:15 +0000
From:   <Steen.Hegelund@microchip.com>
To:     <kuba@kernel.org>
CC:     <andrew@lunn.ch>, <masahiroy@kernel.org>,
        <Bjarni.Jonasson@microchip.com>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <alexandre.belloni@bootlin.com>, <linux@armlinux.org.uk>,
        <Lars.Povlsen@microchip.com>, <arnd@arndb.de>,
        <p.zabel@pengutronix.de>, <simon.horman@netronome.com>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <mark.einon@gmail.com>, <madalin.bucur@oss.nxp.com>
Subject: Re: [PATCH net-next 09/10] net: sparx5: add ethtool configuration and
 statistics support
Thread-Topic: [PATCH net-next 09/10] net: sparx5: add ethtool configuration
 and statistics support
Thread-Index: AQHXMsL4AokB+DIEjkahXmIWHp8LKaq3qLqAgAVuDoA=
Date:   Tue, 20 Apr 2021 12:54:15 +0000
Message-ID: <d5369c9e40e5eabcb8c2f8a133b50746c31f73bc.camel@microchip.com>
References: <20210416131657.3151464-1-steen.hegelund@microchip.com>
         <20210416131657.3151464-10-steen.hegelund@microchip.com>
         <20210416142613.7307cbc0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210416142613.7307cbc0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.4-0ubuntu1 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [2.104.141.80]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8471bbb6-3f5f-4c42-bbeb-08d903fb675f
x-ms-traffictypediagnostic: DM5PR11MB2010:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB20107A4B90734E0CF632EEDE86489@DM5PR11MB2010.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XKvqWv9zLFGyW2n4oorKWH9gkm3lnmUiopP+y6v/uKa/H8aV2dlsIc8H2gnS3uKZYeLnf7RJE6zoICEhSw2P6jywPqYexzz70NgF0Z7+fJs3yY4PVrIlXJr93IKiITJXgr4Qt/NytjBvWjhogj72SVkc7U+vK95CQqfFrplof+nvOf5bk0s5JZBnaSD2Ju/4GVbtwn6+Sl8Rzj8+6rqo69KBJHTK4A8vNi1ofCcY+pClYB7Ck5QM1+lqJwsZv67NzQqbPFflof1vVDW+X/NteVlMFwg3mfv+20yBVnFW7NsfFoWsi5zoJFAmCKguRllCeh9KfkV9vE2k1gT/j216Df2CKRXUe6QjUKqdhkvNIIMI05vpwWEyMqdUy22pVRL9515ew6+TYVFMnpVSQu9UCcnqRNvAvO3XXSXqCWOdlEYTqqFQjHnlTP7h8J6cjUNu/F727h9U1qnCD2Bj7gzbrhww2dkTL+GHUIta4myzo8qAhAfl/H2RmUqindEY9VpWCN6W4EPn4ZHoOl8zuRdUy+OAoRqs5m4t8PidIP92k9Rofg35Hm8855HIp27uEkDd/omHkHWFAoNzMogeYgPDOrxuRHXkGVo5Oy3TkNHtvH+NqcLw4DPQ+WXOG5kE5Y3qWWEKds1i12pWPo/q5u5DZTB9uVQWMMMpO3HEskzBaZRASXc/jH+6c0yGl9DwVUYs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3417.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39850400004)(136003)(376002)(366004)(396003)(6506007)(2616005)(122000001)(478600001)(36756003)(316002)(8936002)(6486002)(8676002)(186003)(5660300002)(4326008)(7416002)(86362001)(26005)(38100700002)(66556008)(66476007)(66946007)(91956017)(76116006)(54906003)(83380400001)(66446008)(6512007)(6916009)(2906002)(71200400001)(966005)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?U0RzUzJBSTFvMFBlVytmREpkTHJmV1VoT3NQa0I3c3Nxa24xMjRmT3FsN1FW?=
 =?utf-8?B?RjY1Tjd1VTZoTmIwR0NWY3I4cUppdS95Q3N0UHJnbWpmRlRGUCtnalVNTGI5?=
 =?utf-8?B?SldaM0RZY0EwVXdQSk1sQVVLaWlHMkFaU0xLYlo1N1lmV1VpNGxqOVVySlFH?=
 =?utf-8?B?YTFEWC9ONWpqV2pqN1ExMUxuVkdSdFg5dko1dlRlTnVqQ1JkU25MWjR1MXRB?=
 =?utf-8?B?SnJNVkQ1M2VSOGZXcVJVSXZxMTJ5Q3ZjM3Nhb2pKMjdWVTlzZ05tV3lOck05?=
 =?utf-8?B?U0xhbTErSHJQVHQzdnMyczQ1eWlNVmxjQmgvN1BxT3lHdGtmV3E4SkhiM3VN?=
 =?utf-8?B?VHl6Mm5jb0RoUTdlOHI3ZnFFNDNFZWZRMUhJNUw0WmZkUTJpYW93Wk9wUjFp?=
 =?utf-8?B?MVBQU2p5dkRWVG45UC80TkpaVUx1bzR0bjZTSGp4Rk1SNU42dU90TTFtZUM1?=
 =?utf-8?B?cXVDdVpnaGxmTURDY2dCbWVwSGprQUhEV210UnNNcVM4V3JzcHRnaGUwZG9O?=
 =?utf-8?B?SlcvUTdaaTlsRXdhRDAxZHh1VlBuMUo5eTcwSE1JU0ZjYlV2RmtCOEdHVkRm?=
 =?utf-8?B?N3J6OW1mTXlPLzAwTzl4dHJ3NGxqaGdVbXpCVXRsellzODdFSjE1YjFrZlZp?=
 =?utf-8?B?L2plSXRaQU1iN21OUDdQTW03TnVMdERPV3JlV1hNVGg5elQrcWVwek1mc2VY?=
 =?utf-8?B?SjRMaEo0WEU4ZE5hKzRFT3R6SlJkZXJ6TU9BYWZIOXB5UlRieDNUSkxMdzlD?=
 =?utf-8?B?YXJ6c3FFbjhJS2lJRDZqVmp2eStXMWREcEZxU3FXa2VmbDl5R3FGcUJheVVI?=
 =?utf-8?B?RmZWTUJVYlcydVp0ZjFZaXFrNjlCbVlGSnV0Y1o3R2dvWVYxMU1ObUFLaW1C?=
 =?utf-8?B?R0UrV2ppMjBuNUw0TGVzMjZLQktTR1JxYmQ3UmRpa25icnltSFRrTE9Xdk1S?=
 =?utf-8?B?RGo3UHVqdFNJZUFwSlF0WEdKTDdTZEd4em9oM3ZHRU1VQ2ZSelUyeTNIV0FI?=
 =?utf-8?B?YjFqSjg1bUZLN3VCb3cxNVVMRElPYnpMMW5VNGhnSkNVMmU5T0NTWlZUVXhW?=
 =?utf-8?B?VUdSSjZEeG5lZmhxa2ViVHQ1aU1XUEFQRWdJUUxuUG4vQWRZaGxITFB6bkNr?=
 =?utf-8?B?M0wvUWwralRKRVVTNmpaZ1N3VE9XL3JhdnRiZExoVURMYzN3QVpzb0JhSDRz?=
 =?utf-8?B?amd3R0IzbzVRTGN5Zzd5QlZTa2k5QVpFY0ZxcEY0ZkdZbFpIcXk2R0VFbE5F?=
 =?utf-8?B?MzZoMmRwR0l6VTZVN2xFTW5jbkRrQ3VXdFBaRmREdVI5cGZhWVNSUTg1TkhR?=
 =?utf-8?B?UXRWZGdkdGdoeUxoVUVSTnpaVWVXa3JRK1BXcmc0QnNKamY2MUw1RWRFbERt?=
 =?utf-8?B?MXlPVUl0RUF3bWk2OGhHcjVEaDNmT1RuSDZJTWcvSDhvWkNGbGhuczJFazZl?=
 =?utf-8?B?WFc4clkzQkFNODBOaTNnVEVqV2lJUkVlNVo1bEFoSTZCOThzNndPdWE4Vk9N?=
 =?utf-8?B?WEpNRHlmWTlwcERuY1B1SlpOYzZVT3F2alNPTzdaYVIxZ1BRL3VWMDduM21Q?=
 =?utf-8?B?NkpsKytXK2dTZ21MY2FMLzlSY25uc0xQWlJER3BOeGhYdklCTHdTWHI0aEMx?=
 =?utf-8?B?N1lJUU5pd0FXWnc4QUZDMkR4d2NDNVgwcVltVHFCUHloNC96eURrRW12SEMz?=
 =?utf-8?B?emdkY2RRanV1ME5vc3FmUnhZRkNkRjRhdGxDUnpPekZhWDdpUTI5Z3A3d1V0?=
 =?utf-8?Q?9DPHtoK0rp46uf7D8dCpwUMTq/IfI9xCdmcvGhn?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0789C44C3983AC4B846DCCB4444DECFD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3417.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8471bbb6-3f5f-4c42-bbeb-08d903fb675f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2021 12:54:15.5237
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9vc+sAxuOxrzXz30jWkVIZOWLhYon61NFCWynF+pfNbUJscd5UAQM+k/pHX5gcvnYoYARcdzcGvvQRViXq1aJBOa2RRQIkFk0LJW+zvNbKs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB2010
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFjdWIsDQoNCk9uIEZyaSwgMjAyMS0wNC0xNiBhdCAxNDoyNiAtMDcwMCwgSmFrdWIgS2lj
aW5za2kgd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4g
T24gRnJpLCAxNiBBcHIgMjAyMSAxNToxNjo1NiArMDIwMCBTdGVlbiBIZWdlbHVuZCB3cm90ZToN
Cj4gPiArICAgICAicnhfaW5fYnl0ZXMiLA0KPiA+ICsgICAgICJyeF9zeW1ib2xfZXJyIiwNCj4g
PiArICAgICAicnhfcGF1c2UiLA0KPiA+ICsgICAgICJyeF91bnN1cF9vcGNvZGUiLA0KPiA+ICsg
ICAgICJyeF9va19ieXRlcyIsDQo+ID4gKyAgICAgInJ4X2JhZF9ieXRlcyIsDQo+ID4gKyAgICAg
InJ4X3VuaWNhc3QiLA0KPiA+ICsgICAgICJyeF9tdWx0aWNhc3QiLA0KPiA+ICsgICAgICJyeF9i
cm9hZGNhc3QiLA0KPiA+ICsgICAgICJyeF9jcmNfZXJyIiwNCj4gPiArICAgICAicnhfdW5kZXJz
aXplIiwNCj4gPiArICAgICAicnhfZnJhZ21lbnRzIiwNCj4gPiArICAgICAicnhfaW5yYW5nZWxl
bl9lcnIiLA0KPiA+ICsgICAgICJyeF9vdXRvZnJhbmdlbGVuX2VyciIsDQo+ID4gKyAgICAgInJ4
X292ZXJzaXplIiwNCj4gPiArICAgICAicnhfamFiYmVycyIsDQo+ID4gKyAgICAgInJ4X3NpemU2
NCIsDQo+ID4gKyAgICAgInJ4X3NpemU2NV8xMjciLA0KPiA+ICsgICAgICJyeF9zaXplMTI4XzI1
NSIsDQo+ID4gKyAgICAgInJ4X3NpemUyNTZfNTExIiwNCj4gPiArICAgICAicnhfc2l6ZTUxMl8x
MDIzIiwNCj4gPiArICAgICAicnhfc2l6ZTEwMjRfMTUxOCIsDQo+ID4gKyAgICAgInJ4X3NpemUx
NTE5X21heCIsDQo+ID4gKyAgICAgInBtYWNfcnhfc3ltYm9sX2VyciIsDQo+ID4gKyAgICAgInBt
YWNfcnhfcGF1c2UiLA0KPiA+ICsgICAgICJwbWFjX3J4X3Vuc3VwX29wY29kZSIsDQo+ID4gKyAg
ICAgInBtYWNfcnhfb2tfYnl0ZXMiLA0KPiA+ICsgICAgICJwbWFjX3J4X2JhZF9ieXRlcyIsDQo+
ID4gKyAgICAgInBtYWNfcnhfdW5pY2FzdCIsDQo+ID4gKyAgICAgInBtYWNfcnhfbXVsdGljYXN0
IiwNCj4gPiArICAgICAicG1hY19yeF9icm9hZGNhc3QiLA0KPiA+ICsgICAgICJwbWFjX3J4X2Ny
Y19lcnIiLA0KPiA+ICsgICAgICJwbWFjX3J4X3VuZGVyc2l6ZSIsDQo+ID4gKyAgICAgInBtYWNf
cnhfZnJhZ21lbnRzIiwNCj4gPiArICAgICAicG1hY19yeF9pbnJhbmdlbGVuX2VyciIsDQo+ID4g
KyAgICAgInBtYWNfcnhfb3V0b2ZyYW5nZWxlbl9lcnIiLA0KPiA+ICsgICAgICJwbWFjX3J4X292
ZXJzaXplIiwNCj4gPiArICAgICAicG1hY19yeF9qYWJiZXJzIiwNCj4gPiArICAgICAicG1hY19y
eF9zaXplNjQiLA0KPiA+ICsgICAgICJwbWFjX3J4X3NpemU2NV8xMjciLA0KPiA+ICsgICAgICJw
bWFjX3J4X3NpemUxMjhfMjU1IiwNCj4gPiArICAgICAicG1hY19yeF9zaXplMjU2XzUxMSIsDQo+
ID4gKyAgICAgInBtYWNfcnhfc2l6ZTUxMl8xMDIzIiwNCj4gPiArICAgICAicG1hY19yeF9zaXpl
MTAyNF8xNTE4IiwNCj4gPiArICAgICAicG1hY19yeF9zaXplMTUxOV9tYXgiLA0KPiA+ICsgICAg
ICJyeF9sb2NhbF9kcm9wIiwNCj4gPiArICAgICAicnhfcG9ydF9wb2xpY2VyX2Ryb3AiLA0KPiA+
ICsgICAgICJ0eF9vdXRfYnl0ZXMiLA0KPiA+ICsgICAgICJ0eF9wYXVzZSIsDQo+ID4gKyAgICAg
InR4X29rX2J5dGVzIiwNCj4gPiArICAgICAidHhfdW5pY2FzdCIsDQo+ID4gKyAgICAgInR4X211
bHRpY2FzdCIsDQo+ID4gKyAgICAgInR4X2Jyb2FkY2FzdCIsDQo+ID4gKyAgICAgInR4X3NpemU2
NCIsDQo+ID4gKyAgICAgInR4X3NpemU2NV8xMjciLA0KPiA+ICsgICAgICJ0eF9zaXplMTI4XzI1
NSIsDQo+ID4gKyAgICAgInR4X3NpemUyNTZfNTExIiwNCj4gPiArICAgICAidHhfc2l6ZTUxMl8x
MDIzIiwNCj4gPiArICAgICAidHhfc2l6ZTEwMjRfMTUxOCIsDQo+ID4gKyAgICAgInR4X3NpemUx
NTE5X21heCIsDQo+ID4gKyAgICAgInR4X211bHRpX2NvbGwiLA0KPiA+ICsgICAgICJ0eF9sYXRl
X2NvbGwiLA0KPiA+ICsgICAgICJ0eF94Y29sbCIsDQo+ID4gKyAgICAgInR4X2RlZmVyIiwNCj4g
PiArICAgICAidHhfeGRlZmVyIiwNCj4gPiArICAgICAidHhfYmFja29mZjEiLA0KPiA+ICsgICAg
ICJwbWFjX3R4X3BhdXNlIiwNCj4gPiArICAgICAicG1hY190eF9va19ieXRlcyIsDQo+ID4gKyAg
ICAgInBtYWNfdHhfdW5pY2FzdCIsDQo+ID4gKyAgICAgInBtYWNfdHhfbXVsdGljYXN0IiwNCj4g
PiArICAgICAicG1hY190eF9icm9hZGNhc3QiLA0KPiA+ICsgICAgICJwbWFjX3R4X3NpemU2NCIs
DQo+ID4gKyAgICAgInBtYWNfdHhfc2l6ZTY1XzEyNyIsDQo+ID4gKyAgICAgInBtYWNfdHhfc2l6
ZTEyOF8yNTUiLA0KPiA+ICsgICAgICJwbWFjX3R4X3NpemUyNTZfNTExIiwNCj4gPiArICAgICAi
cG1hY190eF9zaXplNTEyXzEwMjMiLA0KPiA+ICsgICAgICJwbWFjX3R4X3NpemUxMDI0XzE1MTgi
LA0KPiA+ICsgICAgICJwbWFjX3R4X3NpemUxNTE5X21heCIsDQo+IA0KPiBQbGVhc2Ugc2VlDQo+
IA0KPiBodHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3Byb2plY3QvbmV0ZGV2YnBmL2xpc3Qv
P3Nlcmllcz00Njg3OTUNCj4gDQo+IChob3BlZnVsbHkgdG8gYmUgbWVyZ2VkIGJ5IHRoZSBlbmQg
b2YgdGhlIHdlZWspIGFuZCBlYXJsaWVyIHBhdGNoZXMgZm9yDQo+IHBhdXNlIGFuZCBGRUMgc3Rh
dHMuIEFueXRoaW5nIHRoYXQgaGFzIGEgc3RhbmRhcmRpemVkIGludGVyZmFjZSBpcyBvZmYNCj4g
bGltaXRzIGZvciB0aGUgcmFuZG9tIGV0aHRvb2wgLVMgZ3JhYiBiYWcuDQoNCk9LLiAgSSB3YXMg
bm90IGF3YXJlIG9mIHRoYXQuDQoNClRoYW5rcyBmb3IgeW91ciBjb21tZW50cy4NCg0KQmVzdCBS
ZWdhcmRzDQpTdGVlbg0KDQo=
