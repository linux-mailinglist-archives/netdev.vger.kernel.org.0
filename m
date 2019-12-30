Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62B5C12D00E
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 13:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbfL3Mic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 07:38:32 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:35266 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727397AbfL3Mic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 07:38:32 -0500
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 58E10C09CE;
        Mon, 30 Dec 2019 12:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1577709511; bh=1RcJb0Yj5TBDbLoTu0r5J7XvEmRJy53gZwDq2n1H6PM=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=B7qzLTlQFGrihY86wB1uhcWMXdqHIXWPdKDc0OsZI1e1HBnqIkWEfmTkVAgm8nPru
         u3xBbYXWYuwaJetAKvFKloHUz8CQIFqFSe+NabukOV7IN4cj0oVgLNV81UkoFlRU6n
         kiimYJN+lCgDNfzDYLw5FF9J89vNg8k0eEYArSsst3xal6MoKo23RQaPHTksVl2Ne6
         9bfQWpYoBPKGPeKAmQ5KsIDl68xz9sjxBsrtgtRkVr5I+3bPEoQuychGmpBtmvG6Uy
         xLnagF78P02EaZTocZb8T8idPdowJ9HqqeMXnaoHFQy6PRJXHa7OqtuH2ps185f0J+
         gQp+MVdNTXBvA==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 5DBBBA0067;
        Mon, 30 Dec 2019 12:38:24 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 30 Dec 2019 04:38:24 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 30 Dec 2019 04:38:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aRAfpWm5PwIBfcEEawLPJwuynwWpGImd0RSBiDBoc5UwMeBe3FDx6prHtM9rvtytA0Zs2jyEKpgXAKv3FcQQq6x0A/4LV+reqmMEi7rPfYojT0lYSvNW14oAFxyxTeOON0gWhbb/hS2v36krtg//fat3IdpV/h6Vqw4p5oXKJoxgGLK8FXdbFwEWowORk+vbOWj/f/Gg8hs+2paV4yJSw/092XwzYLb56Pscw6n+NGKHe8zke1p/xXEXAgS/nQHOW74n2NSDHZgFgty/ESnm+oOgl1DsXdStRatLAvzGzHuXgkWt5Gwtliqmn0flWSOqbLrbPOPQ+NpmBcTdSJLw8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1RcJb0Yj5TBDbLoTu0r5J7XvEmRJy53gZwDq2n1H6PM=;
 b=ZQUH4ViebSC9UWkHm3hx903oIaH144PkHOi9QGxcwDI26Rjtx7yVWIJ+Z+HS8TmPvT3LBYrb/FuMSql9gsxPYKvstqgSB3km/410/AsBdhfAUaCoKkqHuX4k2P0Jer0MfAiE1mbMFB6p08h+w23E3zJv7pLtets98IoUUGp8uhk7LHdUXw51X4Ey60dNK0lAv6PjK54aJL9xT4KvzpfKCMst/A70j7CV5gmirBxV7f+Rr79Ohr7T3+1iNBmWc7ImPhecXNg7PkjCtbJpjNfDZSFEUS9lJGHP2iNUUsk3gr29qsqQTPbZMLZeei2tzPnu5iMBRk6N89lXTsAdQkiUYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1RcJb0Yj5TBDbLoTu0r5J7XvEmRJy53gZwDq2n1H6PM=;
 b=ex+D+LydGE83zhS5YVzcjQAs/TUNWluqICMttB2IivcmZyQVV2KGLC/Rw1vu0szRFodAOKr5Hi8ZoysWsy0G87OnXzDe2yxhFX8/UKUxsStvW0I0aYiAO7N4L3A+n4P/qewuH1dWeoXa9FE5u3ZJpjBWnjbOPqXrEjDnu0x05Vc=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3444.namprd12.prod.outlook.com (20.178.211.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.11; Mon, 30 Dec 2019 12:38:23 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::3d20:3a36:3b64:4510]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::3d20:3a36:3b64:4510%7]) with mapi id 15.20.2581.007; Mon, 30 Dec 2019
 12:38:23 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Ttttabcd <ttttabcd@protonmail.com>,
        kbuild test robot <lkp@intel.com>
CC:     "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        Netdev <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Subject: RE: [PATCH] tcp: Fix tcp_max_syn_backlog limit on connection requests
Thread-Topic: [PATCH] tcp: Fix tcp_max_syn_backlog limit on connection
 requests
Thread-Index: AQHVvuQ1yVWGDwRERUGtlER3Sah9F6fSgZKAgAATC4CAAAll0A==
Date:   Mon, 30 Dec 2019 12:38:22 +0000
Message-ID: <BN8PR12MB3266AA78217C654E2F83A026D3270@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <BJWfRScnTTecyIVZcjhEgs-tp51FEx8gFA3pa0LE6I4q7p6v9Y0AmcSYcTqeV2FURjefo7XOwj4RTM5nIM7pyv--6woYCI_DAskQGbr9ltE=@protonmail.com>
 <201912301855.45LZiSwb%lkp@intel.com>
 <kJ06dlAPYOu17nqqVXSBq-lEd2lJWHS0YkKV5jEfzLY2wiNjazeZL_yJNXKUxIqeCSosIK0wlCQkxqxrcUhYcwP0xTAkQW9Ir63p4ejfefM=@protonmail.com>
In-Reply-To: <kJ06dlAPYOu17nqqVXSBq-lEd2lJWHS0YkKV5jEfzLY2wiNjazeZL_yJNXKUxIqeCSosIK0wlCQkxqxrcUhYcwP0xTAkQW9Ir63p4ejfefM=@protonmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3d838f3d-a6eb-4543-dbc5-08d78d252894
x-ms-traffictypediagnostic: BN8PR12MB3444:
x-microsoft-antispam-prvs: <BN8PR12MB3444D9E66D81006211F733F8D3270@BN8PR12MB3444.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0267E514F9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(376002)(346002)(136003)(39860400002)(189003)(199004)(81166006)(81156014)(7696005)(76116006)(5660300002)(8936002)(558084003)(478600001)(71200400001)(33656002)(2906002)(8676002)(6506007)(26005)(66556008)(64756008)(86362001)(66946007)(9686003)(66476007)(110136005)(52536014)(186003)(66446008)(54906003)(55016002)(4326008)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3444;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zUu80PcQPWjl87hql/WDtt7DwqMA25rrYQVsUyGaFaA6izRJLtX68ZJ+TM9XTQsS7pRx5PxYwhNSs6T7nlzlXqqe05aqhCGQo7rk4VKJEgbWWZTORhMyxi9OXoz7wOwxb8il3qOuJidWrKcgRV+Nszt6v8n2v9HcjhOiIpfQN5vxKmHUGCJ5rEAH2zNe+IkDV91MQEQog8V8LLuMttn7kcW7eHq68295ONbWXQd/Sz7mKu+TFr1dzY7aJWptduLME8KSKCPlKDdDcNbBxWMgYqtQbcrmfYe9uJk2KGikqAnmxVvXb/UYWfqyD+/jMWGfvLuQSCM4pfNP/CpDHuA4JvLSNh2nxT9CJ9RTxPC2nS/wcXh3QonevM/U7BAVdteseUNFogdhca2aT0x2waiTLqX9eL3oftUQmIF3xUAaQwPI+hJh+TXm8TzduxjVgaDm
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d838f3d-a6eb-4543-dbc5-08d78d252894
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Dec 2019 12:38:22.9045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LEx4f5S5qO9YxI0StVdKK3x3YisoQMPdCWJRLLAa8yRXiWEI00O4R1zAs0zawhRKTOHErKaPjihcJIjT/JvbgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3444
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogVHR0dGFiY2QgPHR0dHRhYmNkQHByb3Rvbm1haWwuY29tPg0KRGF0ZTogRGVjLzMwLzIw
MTksIDEyOjAzOjUxIChVVEMrMDA6MDApDQoNCj4gVWggLi4uIEkgY2FuIG5vdCBzb2x2ZSB0aGlz
IHdhcm5pbmcsIGl0J3Mgbm9uZSBvZiBteSBidXNpbmVzcywgYnV0IHRoZSBrZXJuZWwgaXMgYWxz
byB1c2VkIGVsc2V3aGVyZSBtaW4gKCksIGFuZCB0aGVyZSBpcyBubyBwcm9ibGVtLg0KDQpZb3Ug
KmNhbiogYW5kICptdXN0KiBzb2x2ZSB0aGUgd2FybmluZy4gWW91IGNhbiB1c2UgbWluX3QgZm9y
IHRoaXMuDQoNCi0tLQ0KVGhhbmtzLA0KSm9zZSBNaWd1ZWwgQWJyZXUNCg==
