Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 035E3BAEEA
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 10:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405073AbfIWIJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 04:09:32 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:46776 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388770AbfIWIJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 04:09:32 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id C1B22C015A;
        Mon, 23 Sep 2019 08:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1569226172; bh=gMQoXZAjeMul1SWCVJjbqxdJZii3yeUGcjfBbcduJJ4=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=gcZV2UOPmG7KkMW7ucEPMUgRjeP5cgsCeVopWWiLJdDAxH4+ziLKOcdndbsGP7Mvy
         iKTHMv/5ZNqgLx91OPtlMaoFpk/WXrMu77STjDstk5cMpODfb4FuVimTkx1aVQH1cA
         pUQirFv64B6VtLIAK0zZ+/7Tvx5i47YDzeAWjVrx4O7+cEiUJbME1t2MhKW+a18H3S
         8ERJXaevGQPrh0xeZqH1DcSNYv4vu/UR0bshvJAnkRLx0Pqg7xzieSOuLF0LTsvcSY
         VQw5v9BtXuRpJU+Gpo+q2K1CHoRXvkRfIGxt9ZMLZyUttHilJnVERZYH4pG7iYklRO
         9K6kG2fkSII4g==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 9620AA006B;
        Mon, 23 Sep 2019 08:09:29 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 23 Sep 2019 01:09:29 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 23 Sep 2019 01:09:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B+nGZFU0Z0Sz4dIUmw30g0lnwWd+p/q37cAgRpBWGh9q3LIP8lgkKi8LKG8aCqO7rD9Uw2ebFlg8V8klMLF0aHbSTiWf8R9ut1sNqbw3Pvlw5w2AyA+7ok7/TjzO9HLWj4SKhoksUV0gNzqFsnf96Vu8IHhT2VwbwcjP4N1QvZeigxC2Ey9uf/sMufwv11dNCnaWz9ME8U6gfXcZyw6DRX0C9/ig14RY2T2SNcqxyuKkbxA9ihIcFrgis27A3jviAM3PQkSLHdECRM5jiQ3xfV3/vLBUrAUputuTqq7gUXfMV8QAwB+McoP2IuFKzrel+59Ras2PhZACY45fFCDTuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gMQoXZAjeMul1SWCVJjbqxdJZii3yeUGcjfBbcduJJ4=;
 b=boqK2vLjpTKPipW+cDcZlqBTq/XzoSvIlP3gOceszbA20G/x+Q7j0WCCUMYDhgMyFx1+wuXcvbwR1UKondePMptUDaXmYbnYIu0m1O0Fc6pIt1FzXQV7V4usvgv3iTNKcJRKURvi71OY5Y0yRAnCXFoRtIiWPUHL13XV37GegTe1wpC9zRRu9mAOYr6z1ZFUfRTsqgOWN5D4boGncUeUgXFNUZ1f0FImtE0d6Vv+Gb/EM6BCIROfXMK7kwjeENK7Qn6+mzEGflMduc+o2XFzGBXu8Zwu9KjMPQk/6Ox0aud7t/218rfxy5jHt0CtF70WYuXXlolMrpY2CZXr1YCM9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gMQoXZAjeMul1SWCVJjbqxdJZii3yeUGcjfBbcduJJ4=;
 b=EI/hTkvj2EB9OHZybT6+N7bpr17GQRVxi4EXhmw3IMXTTb1haumo28uHE98mjW2okwy3/vrASTs3aQ3YT3obFLrtRRcXd0TD1u3TQ+cndhZ88nCl89nLpZucyDuCmywcSkUMZwCE7AsKoTPQI9DNja1386wBY2bEM8fqQjFuE5k=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB2963.namprd12.prod.outlook.com (20.178.208.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.26; Mon, 23 Sep 2019 08:09:27 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8%7]) with mapi id 15.20.2284.023; Mon, 23 Sep 2019
 08:09:27 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Bitan Biswas <bbiswas@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: RE: [PATCH] net: stmmac: Fix page pool size
Thread-Topic: [PATCH] net: stmmac: Fix page pool size
Thread-Index: AQHVb9UhqaJ1MxlM1UWEgbnFElZS1ac4S00AgAChIQA=
Date:   Mon, 23 Sep 2019 08:09:27 +0000
Message-ID: <BN8PR12MB32664D3109952EF5303464EFD3850@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20190920170127.22850-1-thierry.reding@gmail.com>
 <20190922153132.0c328fe7@cakuba.netronome.com>
In-Reply-To: <20190922153132.0c328fe7@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8edac5e4-7de4-45e9-e462-08d73ffd5a76
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB2963;
x-ms-traffictypediagnostic: BN8PR12MB2963:
x-microsoft-antispam-prvs: <BN8PR12MB2963536387BF393E8D86982DD3850@BN8PR12MB2963.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0169092318
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(346002)(366004)(396003)(136003)(199004)(189003)(476003)(446003)(486006)(11346002)(54906003)(33656002)(316002)(9686003)(81156014)(86362001)(81166006)(229853002)(4326008)(55016002)(4744005)(76116006)(305945005)(7416002)(8936002)(74316002)(66446008)(64756008)(66946007)(66556008)(110136005)(66476007)(25786009)(6436002)(66066001)(8676002)(5660300002)(256004)(14444005)(186003)(6506007)(6116002)(26005)(102836004)(3846002)(2906002)(6246003)(14454004)(7736002)(52536014)(478600001)(71200400001)(71190400001)(99286004)(76176011)(7696005);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB2963;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8ZoPTu8k2RHvBtIwT/aCjdy4PkmPjD1x2rCeU77LeNguR73E/gVfkotISJL8BwVh3kYBo0jh5+UcQlUl9Yi02CNefVQ0no1CIfZsN4iVs5L9AFzMAgsdoHjQUxxiLqkGcdJF+wIlTJf2VQmkFdhp+7niw8cEo3EBajSbnYr30seFp6yjEmhsZNdFR7dZeENiFDQ4GCv1zArKZUqyZKrZz6S/KKASOrPmd5kvL1KxKgFzROZq7ozOlNwDp+EYRCXyM2Vyn5xX3wxmr9yzS8vYBEpWp6ch7BGA7U5DYwn6Arntqn5ykHJqEY0FQpeSjOGARzA+6sH1z4/zWbWrw6lbhdcYr8AunkzMNdzWrQgoCgsyP2tEAQULz/nFNgHaTPTzAq8kOndiPwwmwq3wSD/lbfVGfBSS12kk4CSqai2NsZk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8edac5e4-7de4-45e9-e462-08d73ffd5a76
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2019 08:09:27.1152
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kqA60izWfQNeT0AxcLlVPOOE+x62+Px1nTpB3Oc0eOGfJsT9EyE8I+VxFR8gULv7AQdKPy6CCx5Zf1P65xRRLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2963
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Sep/22/2019, 23:31:32 (UTC+00:00)

> On Fri, 20 Sep 2019 19:01:27 +0200, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > The size of individual pages in the page pool in given by an order. The
> > order is the binary logarithm of the number of pages that make up one o=
f
> > the pages in the pool. However, the driver currently passes the number
> > of pages rather than the order, so it ends up wasting quite a bit of
> > memory.
> >=20
> > Fix this by taking the binary logarithm and passing that in the order
> > field.
> >=20
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
>=20
> Since this is a fix could we get a Fixes tag pointing to the commit
> which introduced the regression?

This would be:

2af6106ae949 ("net: stmmac: Introducing support for Page Pool")

Can you please resubmit Thierry ?

---
Thanks,
Jose Miguel Abreu
