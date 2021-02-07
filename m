Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A924E312257
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 09:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbhBGIAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 03:00:25 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:17509 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbhBGIAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 03:00:22 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601f9dec0005>; Sat, 06 Feb 2021 23:59:40 -0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 7 Feb
 2021 07:59:39 +0000
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 7 Feb
 2021 07:59:33 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Sun, 7 Feb 2021 07:59:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HapvZAGOz1fXG5TkByy8e6+JKqAslv3p39dp/9DDBII+iDJOFWkAJQmEAkEu/rGf1tuRN5B+lp0eT9xg/h27PIXg40I7rzyDd12475WqAUjdPnCQZ8TmwZPievxJA1dSxez3CanijC0Rxm33lu1D1cdlut1D4cjEhsQrxyZweTTBJ3IQsZU7fOyXUS8Iakkdzn4SHPgUJd1g1jTxjM0NPKEBO25HrSSqw4ZF8xWoSs6ISh6aBqrN9WoEkhuDKRfITD8r2w03CWc+K7JxTEcxPu5RVUA55t4A8f54eSMsFlZ9wSL0z/DcH+S5aMrpw2cGmC8Ujg4H9BFKsoYV8yH5iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W08Gh6L/xxnRnzOpQvewjcDMA3wVPBgyIt4obQ0BbXc=;
 b=g+m+POaj2R5/sCFJ5JdLxcvcyVZYDpQQuUEGGtojteOO5b+ESc4ai5M/5O1ygToNLN0W9eXd7+oCzt9q5BGwIDON9XA4VrbbOGktsD4BGSXwS+98aFwNs4WgQ+bFBHcVkdYQNhZXyGxd5qDqAlwLwVjNbliEGOjrNbVGHuNmRYCtutlGFG7z231uPkt9GYU5oe7rJgqTI0PYu44X2k83KJuuJyq3SPxAGOkb9vBRVpZKomnXQdPA0/BDb4aw33xU12qZKqm3ganvSSiXCjJgA++aVMekfPz6PxH5PKwuugYEDag4BKsVYX7MhUY/yvfcEOMrxxFtF2DXr1vPyf0JnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4904.namprd12.prod.outlook.com (2603:10b6:a03:1d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Sun, 7 Feb
 2021 07:59:30 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4%3]) with mapi id 15.20.3805.038; Sun, 7 Feb 2021
 07:59:30 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     kernel test robot <lkp@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>
Subject: RE: [PATCH net-next 1/7] netdevsim: Add support for add and delete of
 a PCI PF port
Thread-Topic: [PATCH net-next 1/7] netdevsim: Add support for add and delete
 of a PCI PF port
Thread-Index: AQHW/IdwR9EHRfAuakq1APU/lzIls6pLMU4AgAEjJeA=
Date:   Sun, 7 Feb 2021 07:59:30 +0000
Message-ID: <BY5PR12MB432220A4F010C281CD28FA65DCB09@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20210206125551.8616-2-parav@nvidia.com>
 <202102062248.3PibXnkM-lkp@intel.com>
In-Reply-To: <202102062248.3PibXnkM-lkp@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [122.167.131.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 12b7477a-61aa-42e5-a91a-08d8cb3e4cb0
x-ms-traffictypediagnostic: BY5PR12MB4904:
x-microsoft-antispam-prvs: <BY5PR12MB49048E553B4FE8E335596F77DCB09@BY5PR12MB4904.namprd12.prod.outlook.com>
x-header: ProcessedBy-CMR-outbound
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4+0eqbvM5tzX6in0u2f2wMCOvIzR2Kwzhl58/TE5ibTNP7ANTpCr8upMO0vufzSQA2A0TWnYo4nsOg0Im+umRduAqhe0O4NcAYmzHB+eKcMZ9fIt4nnPr4fU057NqWGBr3tI77mL8iw6zacvJTIToUkWnuoJTZKR800wO/2pH+hdkcONqq/wnoDj7Vb+Ogc2/QCbnbFzjHSCspOFxw/q2aV23vfhCTHaU3INYgx+ZmfZzdZzlZpzO1aeob8mPyNI1/vgSeI3ItljSFaEPF/+iP2iQ56W/kx5QlXGNp81abCl1xMAV1ywlz8bxAcu2WmAFax1hYm8FK9oEQyi4Ndnm+u4WMgrAb+nUzBOjL1xd9j7nqF4+MV+euaPXNKnMLTH1GYM5mYTL5wO68DRQXMtM7Z7VFwnkdDfXsRs8h6+dnvF1IlKBqjnPk0Xgl8+IApikAA24yKjXzKwYU95oSj3mlq63UB3DdqpuDKxrMgxXPDxkNLXqcpo6JQXBms3kp5XVwa+e5WbZfgW5ssBK62zSbbT09YTgKfTg4Ki2tP6dWxixO9j3fOXDnJtMXs+lKZWcaP8l5xba8EmcRfYno+tV5PSLgsgSM1/r4YOc6inGBc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(346002)(396003)(136003)(376002)(366004)(66476007)(316002)(4326008)(6506007)(52536014)(26005)(2906002)(86362001)(186003)(66446008)(110136005)(83380400001)(33656002)(66556008)(64756008)(76116006)(66946007)(9686003)(55016002)(7696005)(71200400001)(966005)(478600001)(5660300002)(8676002)(8936002)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?TvK7D7lrf1S6gSQ/025LOy/JMEGhnJsFW6YlkFRXiMLKrB0gCLxqA4oJVtYb?=
 =?us-ascii?Q?dhs9pKxB0gvGHD+34zPt+PxdQeEllqvVeK+Gimw1xURWz21GtHGgPEuEyRJr?=
 =?us-ascii?Q?mThyLpa2Ymr12AcEXnokP843WONWcRHajo6fuMKn7zaxTrqlUPSqNV6HPiEK?=
 =?us-ascii?Q?qbDpLVA3Hjz8OhSa6fDqI7g3J+WglvJlTohzWjMx5RGKeWrXBpIVoo3pCrfC?=
 =?us-ascii?Q?s5GTrFYqRX04Ud0UM50Zyiq9zllSlSLjLDAlmzxBvYI0c+yUWZ6p0jUnRu3U?=
 =?us-ascii?Q?hM913jr9+VR5+XQ059QaAa5vM+JmEJjdiyufKPhIp0utM/4GsAm3/qi5t5S0?=
 =?us-ascii?Q?sTZvKZCe4NJ+L5xJ2GyT4vgEo8ul/6TpDT6hEnAoxPmJHjvaHCFanV7WubED?=
 =?us-ascii?Q?OKGQepf9nWJjDUkwxZ8B7CwRyoDqnq1trFCfC4OQdD3aPqsL7kuvGHP/hFES?=
 =?us-ascii?Q?kH6YmJKQszpcgifOAAO4pAfpSB8vtna78/80neosB2Z28IWx1EIUM2SWdf6k?=
 =?us-ascii?Q?qQh6CptK2nXEtWlvpALKiLuz6KDVO+elVpLtLBKVWceRUwBbuwwBKaH9QcHU?=
 =?us-ascii?Q?Yzgzyzadd9Sne2mH6n7jHERRzIqnP9uCBQnDkp3H5Uf/P4racjxyG6s4vJ0m?=
 =?us-ascii?Q?7b3aovc9/rbFjpRbY3464lzR9FLzizhFIRAa1AGKpA+4JvHl1ophTFMIVXRB?=
 =?us-ascii?Q?i7sRnenrQGCM9QAfu11lvZwYDiYPtoj5Q76ALGa2odqAmUCEA99J7JvjJ0Xk?=
 =?us-ascii?Q?PfJxntFaw0OaRE2iIDlwnkKNvQ9jC43H1r08cKbjFhkHvq/sejgN0OpEXa+j?=
 =?us-ascii?Q?OuzVs7IDTrdd7ghaBZr6A2BaoqT7SpRbU4N7+nBJ42HXdkiAspJvV9Ro9c+W?=
 =?us-ascii?Q?65ZZIXzkmvxVgUulli1n2tBEnUZSwX+xlze/1Tj8/qir4etO/iUyYHdimR99?=
 =?us-ascii?Q?OQrCP4iRzelXi4YluYZpGEjAIkXIZEqTXAmvhZuV3kEBPR/JgIN11JE4neu5?=
 =?us-ascii?Q?B/Fvn1sKih8HxYb6mGcDlohmoD/JDIIt/dUQuAqTaIxOyYtQhVJoa4aA/pxH?=
 =?us-ascii?Q?zmckcw2ku0VRijzqUhN10Ns2qn4iR1+O3rG7rEvpjAmNhYUtNUVKHDXWAwJJ?=
 =?us-ascii?Q?LfCSCnViuH8jz8GNE9i2oN2Zv1m2HjHk/IGI2m5sewDMHAytdsKvD+ZTPqYQ?=
 =?us-ascii?Q?1aV+N3PML1E7axpAY/1iwPXwz1BqVAa51lKsIL/HxZXpu/r/XtzgyXduELGU?=
 =?us-ascii?Q?gVUWey2Ydb6bLDTPKwQSumqx94AtljD+W3YGCiiTHabgt5XKPv8pB02hw+bq?=
 =?us-ascii?Q?l/TwSugpj5/X5kiWX2Bg3YYA?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12b7477a-61aa-42e5-a91a-08d8cb3e4cb0
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2021 07:59:30.6936
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RwS9SwT2wPSv5uC+VZZj3pq61WSFs3bwTi76NJRaXwQAV++AGM+m8HIo/8X1ZxKiNFL/QBoBSscDddJUpm1lLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4904
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612684780; bh=W08Gh6L/xxnRnzOpQvewjcDMA3wVPBgyIt4obQ0BbXc=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-microsoft-antispam-prvs:x-header:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         x-ms-exchange-transport-forked:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=Z5eZE36d6uU7jVf5uGobvn9GNVguDT208oW5MbvolBayarjrew2kmJB4HaAIY/DVl
         MWeutAjg+ga3l6aH5aSJn1rD72+NtiZ58y+i7jRf9ELnJYC3IEypTN3X4mBjwNzHIZ
         0ju763U9l6oh8zcsewH6TL4G0g+cH9v1PApjzqken7ks87nDJxK/ImbJqclspBc774
         jYS0kEZAiVaBxsbhNxr44JGi9SyXdUsNaQUQWLu1c/o2mEFyGtCPHzUVPk3qs3nz+r
         EviiGlqaPdagmlFFrOOF5YYNWRz4q3kr8R/URc9cHEst/Ej2jsEop6uYjgAh83dl7+
         nrIBrlCk50hpw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: kernel test robot <lkp@intel.com>
> Sent: Saturday, February 6, 2021 8:05 PM
>=20
> Hi Parav,
>=20
> Thank you for the patch! Perhaps something to improve:
>=20
> [auto build test WARNING on net-next/master]
>=20
> url:    https://github.com/0day-ci/linux/commits/Parav-Pandit/netdevsim-
> port-add-delete-support/20210206-210153
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.gi=
t
> 6626a0266566c5aea16178c5e6cd7fc4db3f2f56
This commit tag doesn't contain the devlink patches required upto commit 14=
2d93d12dc1.
Can you please update the 0day-ci to move to at least commit 142d93d12dc1?

>    drivers/net/netdevsim/port_function.c:269:6: warning: variable 'err' s=
et
> but not used [-Wunused-but-set-variable]
>      269 |  int err =3D 0;
>          |      ^~~
Sending v2 to fix this warning.
