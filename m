Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6A11343C4
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 14:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgAHNZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 08:25:33 -0500
Received: from sv2-smtprelay2.synopsys.com ([149.117.73.133]:35192 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726087AbgAHNZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 08:25:33 -0500
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 881A8404CE;
        Wed,  8 Jan 2020 13:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578489932; bh=uii8S55lkyXF530tXve56vi1H/yL7N+3SwH2y7gLmn8=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=ZWi06K3DqNIYSvfPZ9NWNB+UykrHiwB9I61yostoUglY7F/QR7LUYrB/sctnoLgx+
         a/xeBjUKC86tPFabxdQJNvoDp09GO+9hd+rZqCYiC2aUloxQId0amQzKmGhC/K840A
         C/oNIjlzjfR8KqK6MPsSs6ZjLsOP3NHelAvSI85qmsxeQyM7OXADWu3IEsrJFjnmSs
         o6Xa8FMSyQtDtGfVNLViXmp50AvueBj8jqr/DV0MWYG5kxSAe6LFJmlvx4+QuTk3ei
         fPvPtftnuCU61nCAo1j0k5ycchkGo/sqG9IjLiyCpkkYuQVSfFjtQD/KNWyISVD9G7
         2FcHxghTatZ0w==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 18F99A0069;
        Wed,  8 Jan 2020 13:25:24 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 8 Jan 2020 05:25:23 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 8 Jan 2020 05:25:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ikLIopKqcRJ8g7Ks2/IkgUlv+mUyNpZqj5V0mwtq+kJjpc1eq9oK3ro0WgAVzCpIz3hS9wClr4JVCrMUvZ43z4KsG996rRp2CrAeKnKyJgWAR1FIEQkoE8td+AURmgTmBylfYBdZHoVHYG6cI9BlEEXesWn/zJh+14hqR/hEE8IX+bKXJfAoZ3bVOPIjRz55gXNm5eeW9rRMtUlSoVLriL6TKLxAR4WGqemMoymNaa7TXo9cMiK+Gl1azSs1lkFntzcW8Q40uL25f5gYbcr9gqf5JwFEi3mm/mDXobmrZD+iALK1S+Nj2js4bogwB1XbudjyZI1PUO0/240IsqGCKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hleNpS0fHQ1LqzJ/Ih7ary9XjeItZY6tcm8lcdghJxE=;
 b=JJvOpX4HWMpv0XXZawck+8yfpAFG2ESewMQJPno4inMWAbaZTa0ds8Awtc4l3O7um9ci9tuCHJy8CpvJGRPLADRS50HJUAl/KOqsfnohgKea4tFOgw4F7oWxfULCeCAWafkacLxWJSconyQJCcG/IXHi5Cn5eZqgJmTykj3vnO32DM/DQOeVgwkPrihawgOw8PIvWEx/R+w94k9MorILNjhj89YKBxq9rYYeBY21K5T15qCPwbspR9DY61PHUu1C1I2gzvLCLsXb6/VUTkvln6Gl5Z72dYQpW2rR4pUUir7b8f8Rz1YgZt4zdm+lbmAyuVcpVFGf2i5A7bN3vVQyIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hleNpS0fHQ1LqzJ/Ih7ary9XjeItZY6tcm8lcdghJxE=;
 b=Ti/rx/0G5wMvr29PKzWmSjrtrvXOqVtRns5/sooiC78u6ksFGQ7wn4Gc4hN3INcDLYLIb/t6ctYSzM4Vk1pek212SazwTEzfAsUOwI5mgBDG9uVDU0Tuh419cPHhjqRM4WxtJf9EdCcCF1uQCRO7bSMO2xWwrIt1SjMzr5L13Po=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3075.namprd12.prod.outlook.com (20.178.209.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Wed, 8 Jan 2020 13:25:21 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2%6]) with mapi id 15.20.2602.017; Wed, 8 Jan 2020
 13:25:21 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Dejin Zheng <zhengdejin5@gmail.com>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        "treding@nvidia.com" <treding@nvidia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "weifeng.voon@intel.com" <weifeng.voon@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 0/2] net: stmmac: remove useless code of phy_mask
Thread-Topic: [PATCH v2 0/2] net: stmmac: remove useless code of phy_mask
Thread-Index: AQHVxfUGgqwdWhtbcEaMF7LHLdtnx6fgZjWAgAA67QCAACDesA==
Date:   Wed, 8 Jan 2020 13:25:21 +0000
Message-ID: <BN8PR12MB3266601BC7BA0F414BD60E19D33E0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20200108072550.28613-1-zhengdejin5@gmail.com>
 <BN8PR12MB326627D0E1F17AE7515B78E4D33E0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200108112652.GA5316@nuc8i5>
In-Reply-To: <20200108112652.GA5316@nuc8i5>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 647f51b0-59ea-4571-b86b-08d7943e366b
x-ms-traffictypediagnostic: BN8PR12MB3075:
x-microsoft-antispam-prvs: <BN8PR12MB30757FBCDA46D53EA5FB8A81D33E0@BN8PR12MB3075.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1013;
x-forefront-prvs: 02760F0D1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(396003)(136003)(366004)(376002)(189003)(199004)(2906002)(81166006)(316002)(81156014)(7416002)(52536014)(86362001)(5660300002)(4744005)(55016002)(8936002)(9686003)(8676002)(54906003)(66556008)(66476007)(64756008)(66446008)(76116006)(66946007)(4326008)(186003)(26005)(478600001)(6506007)(6916009)(33656002)(7696005)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3075;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GfwNb5DxBXQiEMbkSHfptl+bmDx4mmEPmft75Z0/Lk9uvs2VYIV6mURElhCMMGfHVHqeTP0gAyArinqmnb+WOwMUaxSIZ0dJ9V0yhL8jKwaTQJb3SQPKO/0KTE8AAXIN6PlE8E6rfUjOdYL1/fQqTH6V7tX265A2AtuudTQ594bcCLbkinv2p5+eKjA6KbJmEB7Qp7+q6th2fxtkkpYW7rlsviKDPRGZTnjw49rTuf0s3eRJHS1tw8efuyiB7Oo/ONjMHuCojFc87S8Rxp402+b0FTfeJKermJqRI2sBs+AwEzVuPbDoQqNEnn6LBMUNbQKUUEM4Yo8GtXya/fio3ij+FQoyBRit4qdH72LDMD+qxqmVKYvcJUGoDqvqz2cWTxsNeMREYSLk5ycfkuC8SzXMExUDXlS0TCkWsSYyJwkcpvUXYG11jUkfxX+tajil
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 647f51b0-59ea-4571-b86b-08d7943e366b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2020 13:25:21.6827
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YzcUUzTc9nsSJRMyiKdOzzSl6NAYODc6NUkheSXreqRpv76DcbmPH2kBT1O/k2Jd1u11XIQ6CiUSCUmbkeLgAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3075
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dejin Zheng <zhengdejin5@gmail.com>
Date: Jan/08/2020, 11:26:52 (UTC+00:00)

> On Wed, Jan 08, 2020 at 07:57:14AM +0000, Jose Abreu wrote:
> > From: Dejin Zheng <zhengdejin5@gmail.com>
> > Date: Jan/08/2020, 07:25:48 (UTC+00:00)
> >=20
> > > Changes since v1:
> > > 	1, add a new commit for remove the useless member phy_mask.
> >=20
> > No, this is not useless. It's an API for developers that need only=20
> > certain PHYs to be detected. Please do not remove this.
> >
> Hi Jose:
>=20
> Okay, If you think it is a feature that needs to be retained, I will
> abandon it. since I am a newbie, after that, Do I need to update the
> other commit in this patchset for patch v3? Thanks!

Your first commit (1/2) looks okay so you can submit that stand-alone in=20
my opinion.

---
Thanks,
Jose Miguel Abreu
