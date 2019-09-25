Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65B19BDD65
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 13:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404994AbfIYLrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 07:47:04 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:50110 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726582AbfIYLrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 07:47:04 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B2DE5C0486;
        Wed, 25 Sep 2019 11:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1569412023; bh=IdoPo/e6cxgRg5PL/tOreDuLgW632BMBD0uydkI7g0I=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=JL8Sl44p9aSqrhXIhJKlw64eRvYstw9VKERvn6sPdQGwyBwL6gYYEkSlq1In9BxHh
         Oip5AQrFEWis5DDBpfGOO/cyzEKFDDzWqjoO67Cpj0A8P8MskpYEJ33YpnRW8AJDfp
         8b1buXscR+BVwCZK5gnu9DNlcQyo6AQG2/HcDiaXeBwktam/cFcxKB8ZF0n5mqyIAD
         Ew3IVPGXTVk7FrhpY6Zf37bCcpefbJpnaK4csz0npY/oZFUPhGGdmv7A/k7LNHSEyv
         n/QyaiTuLGmkMm1l/p6aYRT9CliIxXOLLOlLRMRXipMMiv/vucuN/sAox8oJ5EXSLW
         twdaLp5mTKFbQ==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 605C7A005A;
        Wed, 25 Sep 2019 11:46:52 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 25 Sep 2019 04:46:37 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 25 Sep 2019 04:46:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RQBW51owWsyuIg+FhisJ//Z8EdUJ86k4Gc8KuvCYWIg51DFU3iiiVG8mTPg/H0kNAbLQ6cpuou9HYey+0YTifIYMbjCkrDEuRHm96Nm7pLiVqxs9GW78wsff62txq3V24lbEw3ARe6Yy6lKuyM5x0IVJRaMC5ZJhtQrFYltIzAlZxPw3QLXtlNtnNXBCF5Lplayahc/XAI0zG1aWbtwQl8r4zvNxdaw9rbzdDnNJRoDf1LbCSqjD3dkfLl/Y+zB7e/xE+7SeYijpIwB7xwmXSMgfsPq/8F1a2/vBfxC1psFxHEHNHBCzlSV4moaAmh2zkgAPOHcflsz1Tc4o2eknag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xBBXL0j4NK9V19wcwmMPJSJnd1msC9oEPe19qsqPiuM=;
 b=CoBu+paPBt4U7r4FpbxMpjS2Kr0LNbJgG0oYkd8TVssd6RrTMLiOYGXFYsCDu2DdQiXV0Q807QUjPREQKxIzsKBZt/bqkeTTpaZi83GmPFD+3/bNITQm4qKx/vQd2/ba6ovoQgtpouIW7CH1W6LfS45CADOsXwe6S1ke87LfP2UbnrXBgc4skT5kgUyjh4g4SRKXnCyZx0fq13yYq8kXwaHZTLHh0yy2h0NGqpX8iPVx0TF7b1fVJXeHH+W4MrTCdZMhRrY9wJy96Lhb4SXbDtJviY5EaUyLeb5uCST2O7ne3F0TUjTI7uvQNpZy/KMJGg80H4RBW82piDKE0ZEB0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xBBXL0j4NK9V19wcwmMPJSJnd1msC9oEPe19qsqPiuM=;
 b=idvFvruhgk4CBVfTm7NZVJBGKbgNUuGi+2WdjBYyTzZ3yHIVQ2qUF4MHBAe6QljJPXK20x3i1hNWXhNTe80yyskTL9Un1ZFeTqFje28WFVnV6bwsxyHRxI0WDfYai5skE6zq6LBbQGHHzQZOvoDzSDYLDkbIvM+U/aQX8RaYyIY=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB2882.namprd12.prod.outlook.com (20.178.223.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.19; Wed, 25 Sep 2019 11:46:35 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8%7]) with mapi id 15.20.2284.023; Wed, 25 Sep 2019
 11:46:35 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     David Miller <davem@davemloft.net>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>
CC:     "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "bbiswas@nvidia.com" <bbiswas@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: RE: [PATCH v3 0/2] net: stmmac: Enhanced addressing mode for DWMAC
 4.10
Thread-Topic: [PATCH v3 0/2] net: stmmac: Enhanced addressing mode for DWMAC
 4.10
Thread-Index: AQHVb9UIZvUBuIRUTEGi7mSYMt4cT6c7QXkAgAD6QdCAAA7TgIAAAZPAgAAAnpA=
Date:   Wed, 25 Sep 2019 11:46:34 +0000
Message-ID: <BN8PR12MB32667F9FDDB2161E9B63C1AFD3870@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20190920170036.22610-1-thierry.reding@gmail.com>
        <20190924.214508.1949579574079200671.davem@davemloft.net>
        <BN8PR12MB3266F851B071629898BB775AD3870@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190925.133353.1445361137776125638.davem@davemloft.net>
 <BN8PR12MB3266A2F1F5F3F18F3A80BFC1D3870@BN8PR12MB3266.namprd12.prod.outlook.com>
In-Reply-To: <BN8PR12MB3266A2F1F5F3F18F3A80BFC1D3870@BN8PR12MB3266.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e3f7c9b1-a59c-41e3-873b-08d741ae047d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BN8PR12MB2882;
x-ms-traffictypediagnostic: BN8PR12MB2882:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB28820C23BF14FE74120443F3D3870@BN8PR12MB2882.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01713B2841
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(346002)(136003)(366004)(39860400002)(189003)(199004)(52314003)(229853002)(26005)(5660300002)(305945005)(14454004)(256004)(102836004)(14444005)(186003)(74316002)(6246003)(52536014)(3846002)(66066001)(6506007)(2906002)(478600001)(6436002)(81166006)(316002)(8936002)(76176011)(110136005)(4326008)(54906003)(8676002)(6636002)(6116002)(66556008)(11346002)(64756008)(71200400001)(71190400001)(66446008)(446003)(7696005)(66946007)(66476007)(55016002)(86362001)(9686003)(2501003)(25786009)(2940100002)(99286004)(81156014)(33656002)(486006)(76116006)(476003)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB2882;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dysSh5F7I+1CCSsGXj/+cvn8C/VP2q0PIlhdRzb+9iPZ9b4VSDaJbKk8dHZy2acFvepgM2ukhFVj2wh5ViGyXifYslvHBNz1RZTwts9CUSVMpCTD7zTFUEtSWPtPU2BGM77aa3qSfNz/92GGjvc0oJkMLI9ASfXYfZzsZehALcdS36UIUuE0tTR9UrKK1Q2hsHw+BjZMeh6UFSIIwvmUmn71DPoGdzSqph17zfC9hOfAn6Q77WUWr6JaJYH5cCyKnEHJLUji+erG953P8zlzUQBey9JAzehdUN5t461UmGnMUsJOdTjD0TJx85dLZV2qa7fqDGP9m0bLk5+cq0JNCA4VzrWbxJc2M2hfPGBy0r5RuMKN8LI/EWDz7gknvg6tJXeCZo0ExPQRlXT4WCXX8twvemSRiRcxC5W1tXVONsg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e3f7c9b1-a59c-41e3-873b-08d741ae047d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2019 11:46:34.9006
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kaYaajV41mDXD48nMRiYgxLX0m0jbXx3uuyp8COd7u0CccUBWRzvC/fvJLAwbjuZ1QAO4xsV+uVEXcybJsFmdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2882
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <joabreu@synopsys.com>
Date: Sep/25/2019, 12:41:04 (UTC+00:00)

> From: David Miller <davem@davemloft.net>
> Date: Sep/25/2019, 12:33:53 (UTC+00:00)
>=20
> > From: Jose Abreu <Jose.Abreu@synopsys.com>
> > Date: Wed, 25 Sep 2019 10:44:53 +0000
> >=20
> > > From: David Miller <davem@davemloft.net>
> > > Date: Sep/24/2019, 20:45:08 (UTC+00:00)
> > >=20
> > >> From: Thierry Reding <thierry.reding@gmail.com>
> > >> Date: Fri, 20 Sep 2019 19:00:34 +0200
> > >>=20
> > >> Also, you're now writing to the high 32-bits unconditionally, even w=
hen
> > >> it will always be zero because of 32-bit addressing.  That looks lik=
e
> > >> a step backwards to me.
> > >=20
> > > Don't agree. As per previous discussions and as per my IP knowledge, =
if=20
> > > EAME is not enabled / not supported the register can still be written=
.=20
> > > This is not fast path and will not impact any remaining operation. Ca=
n=20
> > > you please explain what exactly is the concern about this ?
> > >=20
> > > Anyway, this is an important feature for performance so I hope Thierr=
y=20
> > > re-submits this once -next opens and addressing the review comments.
> >=20
> > Perhaps I misunderstand the context, isn't this code writing the
> > descriptors for every packet?
>=20
> No, its just setting up the base address for the descriptors which is=20
> done in open(). The one that's in the fast path is the tail address,=20
> which is always the lower 32 bits.

Oops, sorry. Indeed it's done in refill operation in function=20
dwmac4_set_addr() for rx/tx which is fast path so you do have a point=20
that I was not seeing. Thanks for bringing this up!

Now, the point would be:
	a) Is it faster to have an condition check in dwmac4_set_addr(), or
	b) Always write to descs the upper 32 bits. Which always exists in the=20
IP and is a standard write to memory.

---
Thanks,
Jose Miguel Abreu
