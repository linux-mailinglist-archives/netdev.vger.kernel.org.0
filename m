Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537401A6634
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 14:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbgDMLBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 07:01:48 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:38406 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728295AbgDMLBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 07:01:47 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 925A54006E;
        Mon, 13 Apr 2020 11:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1586775707; bh=2C672jaHo+XiKSC57ytH/85lAlBgAC3qNe0ZgCtKv0U=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=lKbPw422N3yr9+mo2lWnF4wEeQXezw+mSNXt2N1z+ExPNzOS73WVi4pTUzLGfdITH
         qpp52XoMJEvuCoJGBaiJ3MFNlYVL06i0PDxE3G/Bu/R9mB9+6nJzzqlMhn/FNApgq6
         QdOOzeUDcGEMgMs5Dwm36L0mD2fY8jocyHqTgEagOrZ3XTksuTJLimCL42NoL5wSI3
         yTJ4NQ0tH98tDR8QhRNj/pMSJDq7alW4hg3cbi/rZjv32N87SUiPrRQt6QUTGt7SAL
         hPOD2ZUKs91bwHXBNVGF2BZNl1r9cOoa5tFFVvtSAPvIPmxfwbGrTBBc7GpcaOvGl4
         Ts7Ydld9UBlcQ==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 06B03A0091;
        Mon, 13 Apr 2020 11:01:45 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 13 Apr 2020 04:01:44 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 13 Apr 2020 04:01:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kSvx5e/6qYuTFCf5zkcEooHZpraH004JG4dCmGwoASmBhBNMijDqxX1CHeglLQGzTAAYceSJJtzoV/C1KJ8kED6RtpKma5JMXlv2P/sEj39qTDgKDyly1L9ENG5ADHyh4fxJL8WQgc23KRtAHdo2yhLFqRjwqYIFA/sawXPJZ1cHQyD11M4BnK7pKm0szHtR+wwJjkWlQ5e2sknXoQdXJ/HQ7BJbDklJss3S78kmYHZOYYaDJhm4YY7AUJJUd2ks/rn4f5yWUQc6+k8pa137SLxc1V0P6/VQzrSRc1jnIx8haCcPvRbK+6qd6km7HG56Z8RZqqh8Rgt403/1PrkOog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2C672jaHo+XiKSC57ytH/85lAlBgAC3qNe0ZgCtKv0U=;
 b=SlDdu28oArw/x+RuABrAuSnPNdqozPS1yluklbDH6pfBsTiULxzSTbW+ou+/c3jQugy0YvT+oc2HIfMy0rvdQ0xJtjFx42cFgijLmalVJnNXm4MC1SooJ9Nzk1/ewO9rVaPxtNh7vtTC14d8Xxnh3YbTOLc8GLrNAn8HP+puSlql025tPAJ7j8BbqthCiGF6/QHj6ci8jgG29uMHrBWYAUGGcC8OXNp1eaMsTM1I8Zr7wxDGz0Df26aRQE7nL2c7+96Mwu1dpAy25nxKXOhdy5S9yFAOQWy0+WU8B1+Vh4g17duPRxs3ezONJUjnRtHBbJNhcopHjbJCI1Ysonk0IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2C672jaHo+XiKSC57ytH/85lAlBgAC3qNe0ZgCtKv0U=;
 b=M1gLvtNECbIh7NMMmQcoUWQDHQIsOYLLcY0v3ICi9N1JPCRv5iW8Uu3DscR1NzxjMQSo4KGsLldY26hQNvegWUJf4dnsNd3j4T01CY/DL6Cq9sJlx0Iejme+53JUZprUIzuQ+eN9XMHNE61PLC9jz+/c1v4+DpvA0fh3/eoaVu4=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (2603:10b6:408:6e::17)
 by BN8PR12MB3251.namprd12.prod.outlook.com (2603:10b6:408:9b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.17; Mon, 13 Apr
 2020 11:01:43 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::651e:afe5:d0fb:def4]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::651e:afe5:d0fb:def4%3]) with mapi id 15.20.2900.028; Mon, 13 Apr 2020
 11:01:43 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net v1] net/sched: Don't print dump stack in event of
 transmission timeout
Thread-Topic: [PATCH net v1] net/sched: Don't print dump stack in event of
 transmission timeout
Thread-Index: AQHWEJDvA8zEZsFxqkWKpdmc7/rynqh2wgkggAAXQYCAAALIkIAABoIAgAAA73A=
Date:   Mon, 13 Apr 2020 11:01:42 +0000
Message-ID: <BN8PR12MB3266B788233057BB024B92B3D3DD0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20200412060854.334895-1-leon@kernel.org>
 <BN8PR12MB326678FFB34C9141AD73853BD3DD0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200413102053.GI334007@unreal>
 <BN8PR12MB32661B539382B14B4DCE3F95D3DD0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200413105408.GJ334007@unreal>
In-Reply-To: <20200413105408.GJ334007@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0acb3641-be54-4130-3b85-08d7df9a0cde
x-ms-traffictypediagnostic: BN8PR12MB3251:
x-microsoft-antispam-prvs: <BN8PR12MB32511762385EB64C07651778D3DD0@BN8PR12MB3251.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-forefront-prvs: 037291602B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3266.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(136003)(346002)(366004)(376002)(39860400002)(396003)(7696005)(316002)(54906003)(33656002)(66946007)(8676002)(81156014)(8936002)(6506007)(6916009)(76116006)(86362001)(66476007)(64756008)(66446008)(66556008)(186003)(71200400001)(4326008)(26005)(52536014)(5660300002)(9686003)(2906002)(4744005)(55016002)(478600001);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6f7Bf34lkFv57OIgmX/O7frwkXjzSlL3SYuLLXencn3ntYJjhhupu0gxFa+v0xzQGIn2NThVp9JRmSh88dV2nlcyMu3WBHsYHrYQKsMaFTAJ/AXlBZPx1MwcWGtAQXCP80WNWWiJjTmagjiZCHhAZ2HiU673KlJHuLApdaF68HhIpk86UIcMGhvrhyqklfnXF8+kDyl5V4TMLvmQUJErUfoF2Fp3CUlFgAKPtrbHiF4rpMaijCblSmPmM+zuF6ZDnFARjfd/ZrHEhx5NHngxt+nxZGii2yAz8rvzxkkI4/qB817Nau9zy9Zb0FWXhD9g+kRPomcHdiMUTMDbvUM6n9FtOEV9w0YupEcxFkkjTHgGJ9KkRk/uassfhVgMDs+Wyd8J8g8lhRDfHylTClUpQh4P676iKF8duRzibdUwiMPAd6FUu4nFe/iKDOoP1Qjn
x-ms-exchange-antispam-messagedata: AdscBBWg+F+kGluNpnZaspYmtb03zjXurhIzgwx7GCslWJUS9dYN6gKcCxTsFhHtLmhdC7YHyhfzgf6ZudyAzdciUO5rnPMADXLnawYKL4dcokRSBxRgcJ68Ir2B/ErFJ8jPfMu6WW9WQjdh7D4QiQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0acb3641-be54-4130-3b85-08d7df9a0cde
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2020 11:01:42.8663
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: idUPRnRKqNFMOvCLABlIAVloMiccAZHGRONN6xXkwyxZfn+PgAtz4MHpVKt1r79cLUXWk+KxXfl0jjHHYfMVbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3251
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leon@kernel.org>
Date: Apr/13/2020, 11:54:08 (UTC+00:00)

> Sorry, if I misunderstood you, but you are proposing to count traffic, ri=
ght?
>=20
> If yes, RDMA traffic bypasses the SW stack and not visible to the kernel,=
 hence
> the BQL will count only ETH portion of that mixed traffic, while RDMA tra=
ffic
> is the one who "blocked" transmission channel (QP in RDMA terminology).

Sorry but you don't mention in your commit message that this is RDMA=20
specific so that's why I brought up the topic of BQL. Apologies for the=20
misunderstood.

---
Thanks,
Jose Miguel Abreu
