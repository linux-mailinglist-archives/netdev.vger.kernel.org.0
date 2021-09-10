Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A3540705E
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 19:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbhIJRQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 13:16:21 -0400
Received: from mail-dm6nam10on2058.outbound.protection.outlook.com ([40.107.93.58]:49760
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231235AbhIJRQT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 13:16:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N9sJfRZPLXkac/pfprCwm0Ax3rDaba35WlYodbrmjrSt99lJ84rvEqG4dDR1jnHZhiiUWZL0+f9DNCE0lNxUsKerUtXSVY3Kn1yZTB+6EESGnV97plE1j32UVR5WCSbSXsIMIenDxfnB8Ekkt62ktzu7juBQJwKoEO48/NbKX//oBBXxl2A/vP3GPDGtAkVL6pOQ3CU5ikcGc8jh9Ix9I5pEE9VtPkKs2gRnKJgFg9fFyIC9JLbfSJElR5giIMWuHaHGpTyMfOYE18+oGCfMRHJGk6eH5DwGREXcPi1uttDqHAd5KsdCn7uO9wbXxc7FafTXI0H1thtyvxJ0GC1U2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Knt5Qb2PcFyVq783VTreP1ESvRegyPPNIqJpzrm7cmA=;
 b=Q43xBq7KoI1koJnlOJgw1V7Q2PMBXUb4H56wx7NRv2bYZI6hSvFI7+P9FVJV3NBnFWVV96Ot7sCTmRNBckf/e8Xt6JdFqB+SLgHt6sLvusGU5rSG7b4Mjn6XXbZ4SnNZxZ3VazlYo/g+F6PDD+lyZNEKtDTkLZDQUCVFd1kAwLJX3p5kxFWqRG+7+6UzgC3NTeDlyGJH5zs5h49Wuq9A8y/ugrF2L3Rv1+7e41Awcjfmpllfb7bzr/E3J7cu1FO2aCJFN/GTNuUuDqDuwtPUOv0/wIXAsuUNcy0RypEUloBfshVx7Wl7vK2U0DSPZM54FYpM9VpxPXYixyu7/fDRDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Knt5Qb2PcFyVq783VTreP1ESvRegyPPNIqJpzrm7cmA=;
 b=jx5KBru83Ut7nizGxndoK1GsIAy2r/x+kQYnUs5vVa9T8RhJiCNfQJUUIy/omHFRjQ7Goi0t21O0HQiUbb9zxO5LXmnVKULWBnSivKizNIZJWUXK9LvXUPjy+8JuTEzlMJBX8vcXZ0gtczxny3m5XJ9FyjQXxKyKCdMh69boLUc=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3167.namprd11.prod.outlook.com (2603:10b6:805:c6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Fri, 10 Sep
 2021 17:15:06 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 17:15:06 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Kari Argillander <kari.argillander@gmail.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 00/31]  [PATCH 00/31] staging/wfx: usual maintenance
Date:   Fri, 10 Sep 2021 19:15:02 +0200
Message-ID: <13174530.2x9GDzOmAm@pc-42>
Organization: Silicon Labs
In-Reply-To: <20210910170741.qzl6qwbhxdz5o2hq@kari-VirtualBox>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com> <20210910170741.qzl6qwbhxdz5o2hq@kari-VirtualBox>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: SA0PR11CA0170.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::25) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.localnet (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SA0PR11CA0170.namprd11.prod.outlook.com (2603:10b6:806:1bb::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Fri, 10 Sep 2021 17:15:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03bc6583-f196-4809-6ae7-08d9747e8928
X-MS-TrafficTypeDiagnostic: SN6PR11MB3167:
X-Microsoft-Antispam-PRVS: <SN6PR11MB31677E3DC664EF7DB9814CD093D69@SN6PR11MB3167.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oMa+RtuN9m3xGWBA7bii32+5Ru8IGmZtkiQeBq8eGvHx+JtlLl9mA3tDi/lRJgNMDnut9n7ruVrjmVqwTnDaeS5wdVIjQ+CWSU9nKWqJjA8C3QA77r7oUbOzhdMZwxlGdJX6yJJLUMKAOLElGYgOqEVZXnQUpjXOTSU7Kkqi30XWSE5zzqsFgASaozcCDCE6Q5UdjjSinmyIMvNn3CP7XboCiKVu5sBYV3uennnGMjfZ1PDCQdQN5LvTsmhqzWvdXrsoZct3Y+OKg3hToZJhJxmhMdCqZvFgRPx7k7ZZF9MT1wZfKY5qQTDWsDRRMkFb3GmM01j1IIxcUomAdg/2E82o/3rqo8InLhOYZY3aN3oXBPpuZGrVyI/XyUK81yJf2Gcj3Dx7MIo6Imd7kLUf083lSylR5EZQNGqX/GqE5rGoL7dNZYaDIMSUVu8ueWfV+mCj2BsEPOyn7/FBhKI6jUZphW6fwW8I2AVS5O18BMcBCpPajLeGPcLR0eJn9uMQSFbd3mshM574r0bteqxtELH3kelUrtQ+Qharo+RlWcr2zrlawZRjPcSqgPxufrl5jUHWsd3bC2kdwy1GkfRbNLu8KWeLXQ/Gq+g52AkIfjZlc6xruhts3E8w16BGYs0tF/75NRYGVIyNpP8hbDVAFayEewCzPKYh9i8NgqvV8UWzdZxd653LC9wcQEqKmhAhaUA8E0EGHd2gtxmqTn/jEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(54906003)(4744005)(8936002)(316002)(6666004)(186003)(66946007)(86362001)(52116002)(6916009)(508600001)(66556008)(8676002)(66476007)(38100700002)(6486002)(33716001)(66574015)(6506007)(4326008)(5660300002)(36916002)(6512007)(2906002)(9686003)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?X2A72dOS1FxmuUx3w6DRLmeUokQwru7J7i9WnrAXXcOEOU4l3vKt6DtF5D?=
 =?iso-8859-1?Q?ij0kUwWu0yZBY6UTpbBfMIF6nmC1DbNwrcJkq22BAkmgaQD1aTpWvpTcN1?=
 =?iso-8859-1?Q?SGtKsPsWlu12qiyojfNy4vK5L7rqTj6PJLxMqP2aGWo3x9DQWOmzJOmGQs?=
 =?iso-8859-1?Q?2el1s8wkMr5tZeD0oUsFiPdhG87BhlUq2ae00kZmzgJMBW1FDDNtusk6Zt?=
 =?iso-8859-1?Q?h2vp6OBnwwXnaeuk/vcA1hziLR1e9QaWcu4udOufqgUFGFdd181JptG6Cl?=
 =?iso-8859-1?Q?2jNVtcJSZmfjgUjUjBdjGD7sKYYgCcKEwCTegsK4xqpyarOj8Wl8nd0XQ6?=
 =?iso-8859-1?Q?Ix8SZfvnQ97zXQSBFACXRb+7iBH7tiXZJSWohLC4xGkLpb8yaEfF71H4Ah?=
 =?iso-8859-1?Q?C6YMSd9++NFvZi4ts4XGITMlPGKgvVb3s0e347r4Ev0WFqlrW7ItVdBx+u?=
 =?iso-8859-1?Q?47ZqIfjBsevD0BVjH89gVQfk0iBQnI0ZVvXsnBKHnoXxWHDrsT0ZIWiVpJ?=
 =?iso-8859-1?Q?mrFJl304i51pPr1WKa0Jjc0T/oKxQLIy6UzMEXu90tyLEem3rw2erHKH9a?=
 =?iso-8859-1?Q?6PnBfDvPRci/molG0hc+S/2dbdTksoJ1Mf7tvid3OkJuQZYdjRvu3uWCZj?=
 =?iso-8859-1?Q?r/o7sET7ew/eCewxoWWrc92nIj/CJCiRV9Om8xry84rxqT1liBqf304Soz?=
 =?iso-8859-1?Q?qTdttXm3CflDkp9LgpxmoxhvQSEYFwY442g1hgnWz6CSZWKW1JkNi0lQsJ?=
 =?iso-8859-1?Q?r86YjyFLPURxQtxWSDSIWL0KV3aBvdfF4I+bQBOniSglNpQxCoKCksIRDz?=
 =?iso-8859-1?Q?SI7I3STjs7WyOGv+s5PXTOVxEtnKJeF83Rf2kcL3J2VWjoO8CKZ9awxgO+?=
 =?iso-8859-1?Q?GLTUkHSjNvWvVJpjNkYX1fJFUX11J8z15OMtyQ2h+9C/7Pl5uSZvNHe07i?=
 =?iso-8859-1?Q?aDaJq0hq99HjsKRHbl5hh89IQTq2sqplTSTRYx+XHfMkwQiLpGq4IB9G5/?=
 =?iso-8859-1?Q?EZwR8QQBM0KTq457TVuFclVxLAOaPM+3MOEl6Hju6TnJ0u/++nntWl5QaB?=
 =?iso-8859-1?Q?QVnrXba8iC9Rk9NvPcDm8cNQa6DlwWzCR4Q3NDH27g5k1HVsFjDU+SXnx/?=
 =?iso-8859-1?Q?o5DqehJu6KKfbGCi689Fikd4YwySR06E8hSO9EpkUVbQNLIUmiDdGsbtSG?=
 =?iso-8859-1?Q?WgQm0Y/KJ8NcKykidWCak5Cd1tc3i3LrloNQFya3P6urKmmM+dZCBYw9vx?=
 =?iso-8859-1?Q?U6L9gDj6Gul59PZkRgUI3fGpao9s5JOYNMHnsuTjdqnXVE0w6JnEBYjNAt?=
 =?iso-8859-1?Q?qAzKeJb2wGEbbUEoE+mfSmHksWBIx4ukQLyDpHH8uAcepZLyNvt5ZpeszH?=
 =?iso-8859-1?Q?0WCZENK04rWe8acjI8yJZESFb86bawPeseKimGFNx9fBd1M9ulRkkzWzI8?=
 =?iso-8859-1?Q?D5nukTPEdDfvrf4U?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03bc6583-f196-4809-6ae7-08d9747e8928
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 17:15:06.6483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VNVHoMmIELl2TsrCezgafxiW2msdlXzSJvNTNbVCTZUJS5vk4meNxe1uwQ6VC7NK+STIkaenYeZryRFLU7x/5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3167
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 10 September 2021 19:07:41 CEST Kari Argillander wrote:
>=20
> On Fri, Sep 10, 2021 at 06:04:33PM +0200, Jerome Pouiller wrote:
> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >
> > Hi,
> >
> > The following PR contains now usual maintenance for the wfx driver. I h=
ave
> > more-or-less sorted the patches by importance:
> >     - the first ones are fixes for a few corner-cases reported by users
> >     - the patches 9 and 10 add support for CSA and TDLS
> >     - then the end of the series is mostly cosmetics and nitpicking
>=20
> Nicely formated patch series. Should be pretty easy to review. I just
> check for fast eyes. But overall nice clean up series.

Thank you for the review. Monday, I will send a v2 with the small changes
you mentioned.


--=20
J=E9r=F4me Pouiller


