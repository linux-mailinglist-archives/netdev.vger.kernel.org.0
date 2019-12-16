Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 600FA120100
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 10:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfLPJ0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 04:26:32 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:52670 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726903AbfLPJ0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 04:26:32 -0500
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id DF950C00A7;
        Mon, 16 Dec 2019 09:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576488391; bh=VqE/VXg+vV+Li+3VRW2K8tKQYknthHpXqMs1+Qjnbns=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=O/AzOzKxdkNz6NWBhowZTraYvTQL83By659a42a+OHeX7qWA2odlhOJ0BNM/YvLOh
         pohhBjJJK8AK85svOVn+uTAT5EmDxw8YhARzfaBHFUl8eW1OSOOFDlRBGTIY3HNeIK
         xq9x6TkPxdiru0Gtdxy2ZqxeqXkgUwOXELEqIbmkC87VNcv8tkzXKsjHIwgt4Nrj5u
         L+mJlypAqn0bmGVVmKhwHKfKT4wi7MgO0M3d+k9KXSzDoeDKzzrIJoXeHm0PH21/Lj
         fYPzmvFLK1MUQ3vQN7vZvXt7vnrxNLkfNkHrTPzoKh2MRE0C/AmhPN2eURwoTDf+nW
         y6Vlg2/V50LNg==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 53EE3A007D;
        Mon, 16 Dec 2019 09:26:25 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 16 Dec 2019 01:26:25 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 16 Dec 2019 01:26:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jGaNTXRnw6wGN27Sk4rAphQwqH4ME4usVRm3CHMdYSwp5hBzg/Y6lBzRZy0mWk2stf/FY2AlEey87vNGjveJ877u6xI9LDy45m55jauaibRBAZ0mNFJkfO/CXrhvitkCCpq+rhspFHUhpAb2vld0NWOjO3u4pAhC7QrruXQ+vKr+jreX7E5MCheU5y0uzDgjwaT0i1qACfFRkZ3UW5fzQ5xQdaPvR1AWWTotd8PNh/2iJlFTVMHwGyv0aUcsnG+E1nQE+eyRLv5/7zq1O9aJEFzxLtNKTnt4xePzAZSNb3rOtC1BB3C1wDuzcWoze3d2vXspWFzSN8D8srXag/b4lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VqE/VXg+vV+Li+3VRW2K8tKQYknthHpXqMs1+Qjnbns=;
 b=NKjSzUB3hXu+yHdEczsnRmeHHZsaKR1+O2wgYXwcoBnOcSW7WCcpsJ9JwxYbiH7lzrVxhFtoDEi5z+WCA1AdL56NVtmtzjsiznKVX2eL+JZBxsFFWto0sg8Lv0lJh6KDpvcTiqwaC2SHk5lJkMn6LqdbTyWlt5n7oJuzUh7fQHKZSSmAQJ0AWs13C31Fu8X1ZBUfDCwXSCwIhLJnEToxXoVx2Scd/g6WRHlUb0SIeqDvfFCvYIECRl6eMX607vdUxu+F6bzh7Z5yAhl+rN0RQd6f7Jh1x0qQHCXI8WCwc6jbg44bXlEJMrtW3e7HoupQ9iDXOjYtAo5O6Ii3v5JR/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VqE/VXg+vV+Li+3VRW2K8tKQYknthHpXqMs1+Qjnbns=;
 b=Ww0rOw61UkDyYzfgQE4EYt6mFqK+OXREFJgyuchu31AHh8l7oyrw5NK1QKSRVWXDN+SVv/BhZOcPD6ljpWlFQE3X1TtoHx3Bhh40V8l7hKuI8tkHqFsSi3cAboVKX5SM5t83LBtfFzVAJ/WNzh5JtUeXSp6+o1P5otmCJF+PfiM=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB2994.namprd12.prod.outlook.com (20.178.210.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Mon, 16 Dec 2019 09:26:23 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::3d20:3a36:3b64:4510]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::3d20:3a36:3b64:4510%7]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 09:26:23 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net 0/8] net: stmmac: Fixes for -net
Thread-Topic: [PATCH net 0/8] net: stmmac: Fixes for -net
Thread-Index: AQHVr5DiuA/S/u4Lb0GUkL7jqplpwae4yfIAgAO7yTA=
Date:   Mon, 16 Dec 2019 09:26:22 +0000
Message-ID: <BN8PR12MB326639325F465266DEACAA64D3510@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1576005975.git.Jose.Abreu@synopsys.com>
 <20191213162216.2dc8a108@cakuba.netronome.com>
In-Reply-To: <20191213162216.2dc8a108@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ee42dd07-2751-4a2c-2d90-08d7820a0456
x-ms-traffictypediagnostic: BN8PR12MB2994:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB2994598EB0751D1EF528A922D3510@BN8PR12MB2994.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(366004)(39850400004)(396003)(136003)(189003)(199004)(186003)(316002)(66946007)(54906003)(6916009)(5660300002)(33656002)(66556008)(66446008)(66476007)(478600001)(76116006)(64756008)(7696005)(6506007)(26005)(2906002)(71200400001)(9686003)(4326008)(55016002)(8936002)(81166006)(52536014)(86362001)(81156014)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB2994;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rq/5T77uCWoaPGCq9QEHSHrvONj8AeSD2Lac9RuOP15uUbIYOulJpd3F2vjfJubSNVBAHct+CsctIDhYPPXVvDwLfKNLRsvEPCeWKg/40KqboEklBPJCLH6Knmb0NbzkvZw+YgEXniH0GE8p6xeNzrl9CBgzJwdz6QBt57zrHoizThXzN/7vjyDod43OexQDED1mjulMEM5tCQOwstWmV4M94C3ZOuqDRZfFNzcRaDeRBvQQjCDK1r4LTCz6fUpdBYQJh/jlgra7EyApZZND7Fp7GNHG04HKNX44NTRWeaPsdVQ8y9SqmY7FknkKb2aaxt7CmNs2jhG8JTnQo0nmm0LS6CZFLHTeIwg//3GThjhKJrXz6JnnmjkaTyeC96S8QrVESSnh96PrKuvqyWouczVLNd5UIFo3cfNi6NM/KIbqJ1gel76apqKZbf8R/VSP
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ee42dd07-2751-4a2c-2d90-08d7820a0456
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 09:26:22.8426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8k+GIvVuJ9NtsjZA/P5bnQjIjyZCTWa1KaYRvUOWnrqj6uJ2vvYN9a8vhFTM57HOPwOBzLGdZ6qfn+GbBFtj6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2994
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Dec/14/2019, 00:22:16 (UTC+00:00)

> On Tue, 10 Dec 2019 20:33:52 +0100, Jose Abreu wrote:
> > Fixes for stmmac.
> >=20
> > 1) Fixes the filtering selftests (again) for cases when the number of m=
ulticast
> > filters are not enough.
> >=20
> > 2) Fixes SPH feature for MTU > default.
> >=20
> > 3) Fixes the behavior of accepting invalid MTU values.
> >=20
> > 4) Fixes FCS stripping for multi-descriptor packets.
> >=20
> > 5) Fixes the change of RX buffer size in XGMAC.
> >=20
> > 6) Fixes RX buffer size alignment.
> >=20
> > 7) Fixes the 16KB buffer alignment.
> >=20
> > 8) Fixes the enabling of 16KB buffer size feature.
>=20
> Hi Jose!
>=20
> Patches directed at net should have a Fixes tag identifying the commit
> which introduced the problem. The commit messages should also describe
> user-visible outcomes of the bugs. Without those two its hard to judge
> which patches are important for stable backports.
>=20
> Could you please repost with appropriate Fixes tags?

I agree with you Jakub but although these are bugs they are either for=20
recently introduced features (such as SPH and selftests), or for=20
features that are not commonly used. I can dig into the GIT history and=20
provide fixes tag for them all or I can always provide a backport fix if=20
any user requires so. Can you please comment on which one you prefer ?

---
Thanks,
Jose Miguel Abreu
