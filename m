Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A23A29FF90
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 09:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbgJ3IWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 04:22:05 -0400
Received: from mail-vi1eur05on2041.outbound.protection.outlook.com ([40.107.21.41]:8160
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725790AbgJ3IWF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 04:22:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FkuLeTloU22hBMWvVVNGj2B7OjjnOk3fmNzllyRxbQHkLngQWqalSqCs4dnF+l3gPnTBYLbrhn7N7P5PaktiH6xmHOnjd7rFHW6YN5mHFthhtkYltyjBAZV0NleC2cGaKrSUzWSYqs0lStZTdIh0m91OphWZG/UhC2KZG6r3gGQjwO4Vt6+gMyEig5q0PWXdC95eRuSY0gB/XI1VDv5uOB5s5qgwav1qtP/hT/4qTDy060nz8Yp+xrqLRzmfMyfwHWi5tm2G2HoChzJMEpEOnfeMl4OUHMhdaXygi6aELiQNxt1XVybwhoeA8W8F+fDgPqzOoa5Czwxqt5yAUr9nJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+rrqLSHbLqnJcVtlMGjd8hpXQ8/gvuslBhvZauU0V2E=;
 b=iFZE9SfFYWvZ/z9PkS9+SOMjNyOC4KcNEN6vjI5izYadpWBmvteY2oZfAkyyS1jpCQlmPsVXlGH9Sw70xqgdKo+P9HcEWO7eZ2fBrtWsBJ9TUKivUpbK15S02w+7UXtZJfAZJVkSuLfHDlC1mlKDJoQd8u+pvMn/VLMcQK8m45t0TcemAo56snsDzb/VBiVjVbbNz3sGDkdD7FlsqdI+N/SV5cAeN6g6juPmaEfvf/1YP1xmbclB0TuD1PLCoQsugIGOb4AsySyXJtNSl13rhnKiyBWgpQlEi+H1njSZk2hGOHuDBG5oAh9h7cl83c9W8eIBVCwx/IVeadAVgDx3Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=5x9networks.com; dmarc=pass action=none
 header.from=5x9networks.com; dkim=pass header.d=5x9networks.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=smartn.onmicrosoft.com; s=selector2-smartn-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+rrqLSHbLqnJcVtlMGjd8hpXQ8/gvuslBhvZauU0V2E=;
 b=Uka2Y5zkUEeJqFIesOE2G1zNVt8Yttij6ZdUjq7FyX8deEzgPbKvsCSwvj28CUFcSWJY4TeOWHVhEAcaoVdHH2x6XyMvnpdmYGk82cydxvJ8Zd41E8d6rZVLfotZ05io1Ps5rEbkRCCLPHrWRDzmk07iQnUoYg4BmOycdqECEiA=
Received: from VI1PR0201MB2448.eurprd02.prod.outlook.com
 (2603:10a6:800:52::19) by VI1PR02MB4894.eurprd02.prod.outlook.com
 (2603:10a6:803:98::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Fri, 30 Oct
 2020 08:22:01 +0000
Received: from VI1PR0201MB2448.eurprd02.prod.outlook.com
 ([fe80::7d0b:44be:cb9a:1a49]) by VI1PR0201MB2448.eurprd02.prod.outlook.com
 ([fe80::7d0b:44be:cb9a:1a49%8]) with mapi id 15.20.3499.027; Fri, 30 Oct 2020
 08:22:01 +0000
From:   Branimir Rajtar <branimir.rajtar@5x9networks.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] typos in rtnetlink
Thread-Topic: [PATCH] typos in rtnetlink
Thread-Index: AQHWrQzX5yVDsDd+FE6hbjcZzBx41Kmv0ReAgAAASQA=
Date:   Fri, 30 Oct 2020 08:22:01 +0000
Message-ID: <6b9672e299364cc9b42829fc24774fb230346e46.camel@5x9networks.com>
References: <83c34b90a2f7c87e84b73911a7837de2e087ad8f.camel@5x9networks.com>
         <06351e24b36f55ee16fda8e34130a7a454c1cdea.camel@5x9networks.com>
In-Reply-To: <06351e24b36f55ee16fda8e34130a7a454c1cdea.camel@5x9networks.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=5x9networks.com;
x-originating-ip: [78.1.180.48]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2407a826-653b-43de-ad59-08d87cace059
x-ms-traffictypediagnostic: VI1PR02MB4894:
x-microsoft-antispam-prvs: <VI1PR02MB48945E0A8562E463533F4B99FC150@VI1PR02MB4894.eurprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PcQSjUfOOChjkO8HOVjgLxOgwfHDFg1+czuOGocFhADZjI4PNmc5hPN3oMqqXHwmkvIa6uEwS8obJKHfXiXbAlcsDVAadhwREu6CUNZkO1PQl3sbvDIeLJlG5+BZW/DK92F64Ks9pjH8tVjOPpJYEKPJuAAabBg/GiAq8I1gvOdRGxna6/YrSP7NzEnHj23dQ+jCIKEST0kCiDYsS6YgM0axkThrivAZsqvW3pA17Q63gys78F/cp6Z2JVRukNktjsMmGmDfFCH8Cwvt8PNmwr2kDzhld2PfpbZYILIlzcmR9XQ/UJKPrGavK+O4Te9wywMRjeH+ieOMH1z6PZfC+w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0201MB2448.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(366004)(39830400003)(346002)(26005)(66446008)(6506007)(44832011)(6486002)(4744005)(186003)(64756008)(478600001)(86362001)(36756003)(66556008)(66476007)(71200400001)(66946007)(5660300002)(83380400001)(2616005)(316002)(8676002)(8936002)(2906002)(6916009)(76116006)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ME4+qdlr6SeNvF2/hXhc0hsJu48OVCTuqwfEohyjAVSSugXXhrZiJmMSu3Xi2ZxB8ad9SyvvRTdeptT7XAjbXX2pSVqb18VfAJlmJnAOtQuWehD1DsK4Cm3qp5AEKTUMIToFvk2tXqig7ca/jLEIGYp1bB+2KzAeGvefeab+DnvfJYOsZOcOYrhACJrKegFvaW2LVDPouuB6ngm6v9EkB4jzMxsBbrPyNJ4fC6e1i08feXylkxWsP1DCL3MXa4exxJq6CFkWLL2Fw/BbF0TwNiDm+8Vym7Ywy7tFCdFulepdYHaWMbuZ2ZQeSY5FziBGhzUPF7tTc71qgXg6D26K6D36yAT+yMS7X7o2qtr5VCvwAMv0vJtq+pV/VUgjIudU2wEU3eQA3y+48EGKcQVviYoNXpJszsM49XvwCovgFSbrqC5KAPdjK9Gtj8FlfRYDUafrd7UKCFrBPnanz4xKEtjsxtU0DU2ZIHUS1IEsxPsFVget92dM5c5R4N86C5S0zbWrsWE6UfCeR1J4ECUg5i7Osjlk0X76CfFoeCRl9p4mj6xcUQWXClMEWCspgj5Ii7TV8pKYY6yuxbrdtXpDKQW7Lf9Sl2NHrxETTIQ2kqmQ7JnBS2ddfsx9M8zq2yx4c83hZucNJ1eTBjHcTkWwrg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <852E7CFFCDDDA04FB4D24CFA6D422897@eurprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: 5x9networks.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0201MB2448.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2407a826-653b-43de-ad59-08d87cace059
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2020 08:22:01.2138
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d7b4403-09d4-4db1-b2b2-3c5c42a4d68f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vPFrTGP+1kf7NS97VmMRl81oc4LSme0fZl8Fjs6Y71iN8xBm/lIuMp8NwLlj2BA1j6yGm8jlYxlCKNbpAemIh/1Fqqg0rtmUCfsYRePzJXQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR02MB4894
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCkknbSByZXBlYXRpbmcgbXkgZW1haWwgc2luY2UgSSBoYWQgSFRNTCBpbiB0ZXh0IGFu
ZCB3YXMgdHJlYXRlZCBhcw0Kc3BhbS4NCg0KUmVnYXJkcywNCkJyYW5pbWlyDQoNCi0tLS0tT3Jp
Z2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBicmFuaW1pci5yYWp0YXJANXg5bmV0d29ya3MuY29t
DQpUbzogZGF2ZW1AZGF2ZW1sb2Z0Lm5ldCwga3ViYUBrZXJuZWwub3JnDQpDYzogdHJpdmlhbEBr
ZXJuZWwub3JnLCBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQpTdWJqZWN0OiBbUEFUQ0hdIHR5cG9z
IGluIHJ0bmV0bGluaw0KRGF0ZTogV2VkLCAyOCBPY3QgMjAyMCAxMDoyOTozMCArMDEwMA0KDQpI
aSBhbGwsDQoNCkkgbm90aWNlZCB0d28gdHlwb3MgaW4gdGhlIGNvbW1lbnRzIG9mIHRoZQ0KaW5j
bHVkZS91YXJ0L2xpbnV4L3J0bmV0bGluay5oIGZpbGUgd2hpY2ggaGF2ZSBiZWVuIGJ1Z2dpbmcg
bWUgYW5kIGhlcmUNCmlzIHRoZSBwYXRjaCBmb3IgaXQuDQoNCkkgYXBvbG9naXplIGlmIEkgYW0g
d2FzdGluZyB5b3VyIHRpbWUsIEkgZG9uJ3Qga25vdyBpZiB5b3UgdXN1YWxseQ0KYWNjZXB0IHN1
Y2ggc21hbGwgcGF0Y2hlcywgYnV0IEkgaGF2ZSBiZWVuIHdvcmtpbmcgd2l0aCB0aGlzIHNwZWNp
ZmljDQpwYXJ0IG9mIGNvZGUgZm9yIHNvbWUgdGltZSBhbmQgaXQgYWx3YXlzIGFubm95cyBtZSB3
aGVuIEkgbG9vayBhdCB0aGUNCnR5cG9zIHNvIEkgdGhvdWdodCBJIHNob3VsZCByZXBvcnQgaXQu
DQoNClJlZ2FyZHMsDQpCcmFuaW1pciBSYWp0YXINCg0KU2lnbmVkLW9mZi1ieTogQnJhbmltaXIg
UmFqdGFyIDxicmFuaW1pci5yYWp0YXJANXg5bmV0d29ya3MuY29tPg0K
