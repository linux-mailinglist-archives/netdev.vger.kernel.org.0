Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B4426C1EA
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 12:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgIPKsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 06:48:22 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:46050 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbgIPKeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 06:34:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1600252476; x=1631788476;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZqDxoyi2CE5TDuUki9vFnONxwFNUPXF9QfdulSaviFk=;
  b=s0JIkBJGPjc2Wn/tlPMfAacQrJA48ObpLumF0+RX1rfbXuI7UHgEKKfw
   Cblvhy2wA6QnVfKVkZacz4YXiSiBloftcPu6wuPOcIPH+YprSYcng5q9c
   omYQmfbnkPiyK+t/kgOyMQVFpAYPZoZQaVZX7DNxx7DclbPOViBKqVNFo
   Wo/hD6oWouyn/REfo0RbYly+4YkJPwKcafbbXX50A+yi0abdZyNF6r0Fs
   cfDLr7TOQ2Sc+jsS6zEzfPXTiwrTax7eVaRsYGCbyCbrWZdBa2INn8REs
   YKY1WaiPmdsZ2EXzg6o81gTE33RbCNumiv6abv10qHpFVUYUeKhb560WP
   Q==;
IronPort-SDR: lInEfgqVFhVhCrsozkw7GnsZayjG4zpQWA7SLyAAtaaujk+03OK9MTrW/kV0fymv2waLfTMpX6
 c4yyaHDIFLEWGuo3DkdSnbHE3x7dgBYSDXIb9VzN8Z3zWeV/tDKZoNM0r64fimDB2YcrRiJiOZ
 zAQiaYaU7ERRUlW0qjaHc3kDwY5lla3FfXQ+rdDwDXzb9lbp1kNuQqy6v2auewaLw/42yueTvO
 BG7xLSQrI77A7uI7aQ8bLpSO3i34ddset5tkzso2TDy5jx8JfK27OA09Q/AdE5M/xQaKLy92Cx
 Q1Y=
X-IronPort-AV: E=Sophos;i="5.76,432,1592895600"; 
   d="scan'208";a="26592826"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Sep 2020 03:33:28 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 16 Sep 2020 03:33:25 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Wed, 16 Sep 2020 03:33:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YK83lAI2M60mEGve9mIZeklNvTeISmhAqB8+Urk4DIH8NnJNCIOuCx06GbO1z277YbHE/Gy3ZOBWoNpyGH9ls4QNc1XXpMHgoI5Cl2FyceFhtBJ4M9zHAH6S2cfrpzsNVTn/DihTvTnQ4U6dP4iZbAU2kTHxY9XoO/sRzWnRuaZw39KrVO3yg40IfuBP3b9Ecw+EXUCvoxvcgtyEA9w/yQjR+dXTvXnyymB7vccMcN6Wy6EK4QyNRkYgSqPJuVNdpekG7lBky2FyzKy9Jh0ziPRGuJda/HomeejiyQ2byQxHPANG/k9uXvf4uD7XVR5IJ+NuP4TuxefHxcdyu4uK9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZqDxoyi2CE5TDuUki9vFnONxwFNUPXF9QfdulSaviFk=;
 b=lLTUPF/+XcK0pJsyYc/Y7h6sqonhBVl72oo254Glc4xvzzAOG70nig8esWwNlb4rVXD9kn90C8V+womD3GOW7LLjine5bcfvY7ClVbURs6VVIkWkqlR1sQpwQlQBUqU88sB3fSrs0zTuzGvbRy4zcoxridG/8HAM+H00J6oN3WgfkGVC98OON1swzNkSGCcAS3EZMDqmRcFjpU4+dMTT4E/U/2JHdvQQtA9X6/d92UKJjGFJ2bIuGMaiI9s8wG+dWHIxEN8lVE/yrVW/HFgUP/pvvmy9HNGluRQNxr+RE+da6OuPcAzT7snJV3X24RgcL2FSQnp9f6FtM/n5t1PA+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZqDxoyi2CE5TDuUki9vFnONxwFNUPXF9QfdulSaviFk=;
 b=hr6wBUlkDqWY9ktg6wp54Dq89dSTw/RtPfTY0p2tq2IBdMkYxyEvrUtIgwBjgCb6V/NJT6cSat7Mk92x8jW86qZUl0Pq//YeQ0w+JBDO0jqe0mNW8MzYphJeZCrCTMDfZhGs5+igCtJmGiyQSP3mLvCM+ze3Y2CieyXcM2MK7O4=
Received: from CY4PR1101MB2341.namprd11.prod.outlook.com (10.173.188.150) by
 CY4PR11MB0070.namprd11.prod.outlook.com (10.171.254.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.19; Wed, 16 Sep 2020 10:33:19 +0000
Received: from CY4PR1101MB2341.namprd11.prod.outlook.com
 ([fe80::908:a628:69ca:d62e]) by CY4PR1101MB2341.namprd11.prod.outlook.com
 ([fe80::908:a628:69ca:d62e%7]) with mapi id 15.20.3391.014; Wed, 16 Sep 2020
 10:33:19 +0000
From:   <Codrin.Ciubotariu@microchip.com>
To:     <matthias.schiffer@ew.tq-group.com>, <Woojung.Huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: dsa: microchip: ksz8795: really set the correct
 number of ports
Thread-Topic: [PATCH net] net: dsa: microchip: ksz8795: really set the correct
 number of ports
Thread-Index: AQHWjBFmjW4HSyny6kSUPuJoqVs5JalrEXIA
Date:   Wed, 16 Sep 2020 10:33:19 +0000
Message-ID: <832ce428-961b-62d6-1930-dc106b3202aa@microchip.com>
References: <20200916100839.843-1-matthias.schiffer@ew.tq-group.com>
In-Reply-To: <20200916100839.843-1-matthias.schiffer@ew.tq-group.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: ew.tq-group.com; dkim=none (message not signed)
 header.d=none;ew.tq-group.com; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [2a02:2f0a:c803:a00:5546:80a7:ca6:707e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4d946a64-49fc-487c-b425-08d85a2bedcb
x-ms-traffictypediagnostic: CY4PR11MB0070:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR11MB00705B8BBA855AAC368FB6CEE7210@CY4PR11MB0070.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5+XH7/6Lbj4JhmlMSgmbQACduJTpud2hGl1jHe0kkGgFlZoyCpQiXIPmjIaa5P/68OvaVxpQMdRYU5M9AJRaFWmgkq2fcHHp7eBJOq4qvuvLmcoyWs/ROMgL8vQA//RMNLHzqMhulLbMmdn4C2okREV3UQhBKzEusdx2kDKf3BKdRaNbRJJIno+HPPeNWaMV6q9NZA/xuTRhhUSnrghiyXRnkoCPRAOt4z3Xv+ecFmKNzN1YZIIOm46nmzUFrOGKjIB8C0w4D+O6pzUkoXnCV9HTqhXPuLnJnDM6xmcj3MzMtIM+vSGmFgNRXBaS0IKNanC8M5Evwl3122Ktnxptrj1z4Qx8Yf+epLX3MTDiSZ0yQDd7Zy2ydqh1aXauwoW8LYT238wJUEyhJLaLuzo/DceZpVmsiI/xydzt/69CY303ixsocE0yGFeYglNP+bum
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1101MB2341.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39850400004)(366004)(396003)(376002)(136003)(66946007)(66476007)(66556008)(53546011)(71200400001)(83380400001)(5660300002)(478600001)(6506007)(76116006)(186003)(6486002)(31686004)(4744005)(6512007)(316002)(110136005)(2906002)(2616005)(8936002)(4326008)(66446008)(54906003)(64756008)(36756003)(8676002)(31696002)(91956017)(86362001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: y9I8I9UOlEVvHw6anCd419Gs9FxLdEPgnLImgQIq882aNxnkxCxBS5H64Gljg8ITP0syVOZlIdRU/VdOE5o3Z3DUb5PmCJrwIpzTRuZ2v1XHlZgCCEEyokEM+jOE8XKvBi0LNzLHqAV3sH9mTG/mx6vWPYfGDo1WQluHzh6NYZnUjvB/ug5Kj5XRUxZ0MRSqst0rEGBArbChJAIW1RI5KsSXCSGwYhJloRb7ZZYwB6M2LYrOeHx/I3gWU3qhG3ulEuMOPJTdtsDUbmwZZOusQhCnKVFyMa1VuRLISWLYFxReBWU8qWqm45ZAdy8qNHwIPLkf+ZliUfdf47V26VaM+OnhGXLANTYfhwXlBBpRW+zOk8qaz3vKVRD/S/r1PtajmAV8qSfSZ9jvZC7R5uQpYsEhcBkqNUQwnhfPfkwsMYu0NFQfTIR/0pycwuMmd76+onkCwHotY2MH5EcvINzS1OaRX2hl3z4o2j601Vu0uH1isEbYsjlHN4uBH3rRZw06xmbjJvNYKa4OJ6NBOWuJvpiVz6W3mYXR9mxY4o8dLY/VEoUkXozZBmNmobAAJ9PQn6ij66L4dGIPGLnJNjbbisI77/bV+kwkIg27WJyA1cexL0Kj08tqu9/ITkSwh2Q8vmDkOozk26Ch0iyycZJ78xMQWgXxe+4rZieq01XddC4fOg9yHA3pAEhwej9+zhGV+OAcFjOHxVkiVoAttyMX/Q==
Content-Type: text/plain; charset="utf-8"
Content-ID: <183B390177E4E64F9790E0FDFEBC0EF9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1101MB2341.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d946a64-49fc-487c-b425-08d85a2bedcb
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2020 10:33:19.1539
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /UPkTw41G+74RMcQjrAsR8Maa9IfQXNeu+zXLP/bHE6i+XjdJ4ZRZlNFlEO4IlgaAxnMydoUZJdkDDkKZqfta5RfklW5uiJRJHhiDFa3mMY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB0070
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTYuMDkuMjAyMCAxMzowOCwgTWF0dGhpYXMgU2NoaWZmZXIgd3JvdGU6DQo+IEVYVEVSTkFM
IEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91
IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gVGhlIEtTWjk0NzcgYW5kIEtTWjg3OTUg
dXNlIHRoZSBwb3J0X2NudCBmaWVsZCBkaWZmZXJlbnRseTogRm9yIHRoZQ0KPiBLU1o5NDc3LCBp
dCBpbmNsdWRlcyB0aGUgQ1BVIHBvcnQocyksIHdoaWxlIGZvciB0aGUgS1NaODc5NSwgaXQgZG9l
c24ndC4NCj4gDQo+IEl0IHdvdWxkIGJlIGEgZ29vZCBjbGVhbnVwIHRvIG1ha2UgdGhlIGhhbmRs
aW5nIG9mIGJvdGggZHJpdmVycyBtYXRjaCwNCj4gYnV0IGFzIGEgZmlyc3Qgc3RlcCwgZml4IHRo
ZSByZWNlbnRseSBicm9rZW4gYXNzaWdubWVudCBvZiBudW1fcG9ydHMgaW4NCj4gdGhlIEtTWjg3
OTUgZHJpdmVyICh3aGljaCBjb21wbGV0ZWx5IGJyb2tlIHByb2JpbmcsIGFzIHRoZSBDUFUgcG9y
dA0KPiBpbmRleCB3YXMgYWx3YXlzIGZhaWxpbmcgdGhlIG51bV9wb3J0cyBjaGVjaykuDQo+IA0K
PiBGaXhlczogYWYxOTlhMWE5Y2IwICgibmV0OiBkc2E6IG1pY3JvY2hpcDogc2V0IHRoZSBjb3Jy
ZWN0IG51bWJlciBvZg0KPiBwb3J0cyIpDQo+IFNpZ25lZC1vZmYtYnk6IE1hdHRoaWFzIFNjaGlm
ZmVyIDxtYXR0aGlhcy5zY2hpZmZlckBldy50cS1ncm91cC5jb20+DQo+IC0tLQ0KDQpTb3JyeSBh
Ym91dCB0aGlzLiBJIGFzc3VtZWQgY29uc2lzdGVuY3kgYmV0d2VlbiB0aGUgdHdvIGRyaXZlcnMu
DQoNClJldmlld2VkLWJ5OiBDb2RyaW4gQ2l1Ym90YXJpdSA8Y29kcmluLmNpdWJvdGFyaXVAbWlj
cm9jaGlwLmNvbT4NCg==
