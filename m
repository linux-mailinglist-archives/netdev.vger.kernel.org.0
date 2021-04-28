Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4C036D88D
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 15:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239872AbhD1NsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 09:48:15 -0400
Received: from mail-eopbgr20111.outbound.protection.outlook.com ([40.107.2.111]:45134
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238675AbhD1NsO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 09:48:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eKcWPmkBwtcvARqeWj/ibcOHrQjbCUw7SDhPUdSYimpkz5+DzpZxTOXGGQ49CPEp0Q355tTiv/pGOyTqFiH3Rf42Vaw/eFQJaeu9c5rp4uDPw1sj0xVhawvckkJkVjd2Y6kCfTiUNWbHA4riJF9Cjq9Ea9aYkZf5pmT+KyuqBxT9tHtci5LGhWbC0lFNHF0dB6UvQPZFPT+cOkkio4A8Y1GgCZ1RNHVQbgy4Rk8yHVDhXDWxnILfdC7g6RTu23sKdrGSQEFsLezxFBVA2Teq6rY3EzJ/GJdSq9BxpPLirTSHazfJ1TDlIfWV+6TWZRQm5m1pGNViO0+FCb3tkIhktg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z+Rj17JHqXxK7RU0dgfLXoHFEzSHd40+Z0vg4Iojm4M=;
 b=FReqdc57oKvER1JLYQKFF3E8e79QN3ryMUQcMYDNrcEmk08smc0axYNo8P2d0XqDoOZ5gVZnIJ/cfhZof9gU3BvwS9K/1UCB+2Hr6DS73mWNmtt9Z8XE9VLtnl1nTo7APmEm5+riVzdScbrlgBlVTalfs2u9B32WJYanJgHG1gCD0dQPO3D7S6wF+P+fdj+8GkZjVUk/q4DYzoTmcfjtsnhq7DjsrkREqmYQ9PiumBQ8T5VOvKfS62C4/ZDZRCGNB0fjFutLYgHlWaQZEn+zq+mr41QZn20zqKngrIqG1mVJLWIs4gn7fNMWerxW1jn33HmS+xSTrClZEyyFhUcKSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z+Rj17JHqXxK7RU0dgfLXoHFEzSHd40+Z0vg4Iojm4M=;
 b=fhR4bW2QEYbeqXeJxsqMagf0HVN0aorNqCx7qw7rF8eIvGqv6r4SrlZmsCaUS5ZoAcgDPucrmVj8jZsVByT1FzwaETYONkFDEZsEJUOqqjt3DhW63CZza+brTDzjM6Lq01VZWfrCJoV2zocsvbOlXgTGdot9AmD639ON3+swq1A=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0027.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:c8::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4087.25; Wed, 28 Apr 2021 13:47:27 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::a03e:2330:7686:125c]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::a03e:2330:7686:125c%7]) with mapi id 15.20.4065.027; Wed, 28 Apr 2021
 13:47:27 +0000
Date:   Wed, 28 Apr 2021 16:47:24 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: Re: [PATCH net-next 1/3] net: marvell: prestera: bump supported
 firmware version to 3.0
Message-ID: <20210428134724.GA405@plvision.eu>
References: <20210423155933.29787-1-vadym.kochan@plvision.eu>
 <20210423155933.29787-2-vadym.kochan@plvision.eu>
 <YIL6feaar8Y/yOaZ@lunn.ch>
 <20210423170437.GC17656@plvision.eu>
 <YIMLcsstbpY215oJ@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIMLcsstbpY215oJ@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM6P191CA0098.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8a::39) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6P191CA0098.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8a::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend Transport; Wed, 28 Apr 2021 13:47:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f6ac9a4-d737-4821-5d13-08d90a4c28b2
X-MS-TrafficTypeDiagnostic: HE1P190MB0027:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB00271A99135CBDD8597075D295409@HE1P190MB0027.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6dRK1C7X6pTmL4XXTy97lcL+zxwihsRVrxgua+Q4edAOTGekx1P0EdObHK/AUUK/dsWSNwRokaAmnXrzxwmAIgCH6+hTkydQi0eQ3mT+uu7ptZZiE52X93GguraZ3Dn2scvKFZDpk7f1TzyVZECe8HOvfR6oVSkQ38GqduxjjsRMpEXyIyVMzJazDJyl/gYP5SDcL6ScPpdd9m9I5/sx/Ycv2Bgo7CZLrB6mIcXVqdPreZQCPBhM+G8JiN86OJzeL0t+QlL8zkP7WZq8EWVYxTb6HDoEFE8z2QzicMpZpbnjqEDePRXD+I093fbvbKbqfoIbqAk9ys+UmgJvXXuUadCrjzRGaVp4O92Df6A6S0L+/y5ky4v2HeS4dgTStPtpC6rzO2GVSEzLyojEN8gJeuq4adX1jBLk5H2tXTCtz8rtlDnrDsMdMJPl26LMEupJYLMxcXpRuKR7j5DbUudkTLCwhDqC6Fg9GcgHfiV1P/uEYR4B3yua3LLVynryYZvXwVNBc14JpdZafpELjF3GyZXJz+J/O5vWyI1mzecgHpmtqIWa3X9/pyjugHdkmWlkOteeXA/0/LL2vEaua2PfHxCR9iz+i3evDUjDauopzTA28fr7N76di0Jre6sdbyvTQR8Jc4dujnubgjPuSpl7NAMZxhChwADlMxM2+kNIOqg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(39830400003)(136003)(366004)(478600001)(8936002)(83380400001)(8676002)(8886007)(33656002)(66556008)(86362001)(66476007)(5660300002)(6916009)(55016002)(2906002)(36756003)(38100700002)(38350700002)(66946007)(44832011)(2616005)(956004)(16526019)(1076003)(316002)(4326008)(7696005)(186003)(26005)(54906003)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?gFujnt5hIfQhgKnwHdZYYV4vZXzWN9AMHB8fxcGUpESPHN2RsdzZZLCEpxgT?=
 =?us-ascii?Q?KBvmULdF1Ep2lvOpV7CAAP/X1lHknhWlnoojnVbvkJZPWD3FHqrHOk91xIzz?=
 =?us-ascii?Q?NTh4KJwudmZkTaIC7IrA61Miss82uKuAlrwsJlJXoOxdIRJ37bCgVnMm5n71?=
 =?us-ascii?Q?hpm+gx1ndUnRA30Uc2GHZPuOffRcwiMSANHwkPmsDEMaTCScUalt5nNZR15D?=
 =?us-ascii?Q?wayIrK82FMUyU5QERhJPd2W6CExselpgluR2LYXQWeFhNYVTmeuCM+Mp/d2+?=
 =?us-ascii?Q?7118PvnHdzVxP0/BqsR4oXoNUCMluYlAfjq9Fctp98XsA8xHlYPE5NaF3Z+/?=
 =?us-ascii?Q?n5atCI9SUjujO+90700MRwAmbNFK9qEjp+1dZYwph4y56Cu1xie8yW1lq6hC?=
 =?us-ascii?Q?4wdPB1vWjVuOKVWVGCRXbIvJmGuj483BYO8hDUeKwEPXEuHvqmSl1qWiS1XP?=
 =?us-ascii?Q?ZUI3dUZ1c2aZmlRx8QrRoDH+RSFpg/S9OPKWNIwKnHUKR/2SrW9SLm+wOvqW?=
 =?us-ascii?Q?f9etTqp0U026iURj1HQcCsR8nHu9uwJD1/SE2TpdMiael2AUxuLez4fte197?=
 =?us-ascii?Q?/+2T5+Ql/4vsr/2c7ZIEsCw8UBtqpiLSYgeh4ZcP+SsMpkakqoNmzyoNKqii?=
 =?us-ascii?Q?85DnFgGvzWrKZ7r54QEAori2sUaEP50kqWf36btM6ZFfm3mkJ3OJVXLyP2h9?=
 =?us-ascii?Q?DZ9rL5nz1dfXJXkLtlgjHYornMRbjHzXuNKVpBcw3qhkq1nrZWGNI6wWT+XR?=
 =?us-ascii?Q?V9cm+eGpCLa0Aw/05owyTVlKg4LFx1tG7XRW44urCFgRsPgmkrX25vt9VGov?=
 =?us-ascii?Q?umCRhqsjlwbKEmRrc0Id4zPNy7lX/gYOy41CTlXpTLS7tut7JeJ79hj1Ibkv?=
 =?us-ascii?Q?eppI3IHRNv3yqTmLlKcU0K9cGvbzlbSp9c4aa2DnMP2vWe3GNo+pdBlDINV7?=
 =?us-ascii?Q?nUCCWv4dL/sw10N0wEeRzd7ZPabMu31k37Sj6RgzmwfNIZrk03IzPwaYxt05?=
 =?us-ascii?Q?l45CMUL1lrRmGFnRIUDyZiXG1uktOq4TU5Mf004QtoXinll1YctS3kV88zi0?=
 =?us-ascii?Q?vbLqVfUL6CYYLFGqXBQvwSY3ArJcaWKCk7RwfShtee2sGK0Q1HWzNsut0DnH?=
 =?us-ascii?Q?1lfePLfllZDTNh7JKKnOp5I73ZVQqsS7gyAyLGsVEvCh25OmF8qTpMz37Xs7?=
 =?us-ascii?Q?sUvTfeqBSd+kKCCw9pr33H65KkZJyx8Od6RWaulHIy3xsiJE/FsPKlg6OPv5?=
 =?us-ascii?Q?8xN2BYJY53OJIJNI0W3qOX+EsSFSFs8vuMZUGs/MEryTVyVCMhjBiYmIYZUC?=
 =?us-ascii?Q?Q/21Ebut+x3DN9LtMNqm3J9L?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f6ac9a4-d737-4821-5d13-08d90a4c28b2
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 13:47:26.9214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S1Ra29yX1Ov/Z7jDMBc1D7VNtXrE0lsh6LNwNyeTD1RT4N02vW8t1AgPeM/J3UESnhEviWqU1Dp5QGjD8K4MVm/ksH9mLBqzSnC7RC50WoA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0027
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Fri, Apr 23, 2021 at 08:01:22PM +0200, Andrew Lunn wrote:
> On Fri, Apr 23, 2021 at 08:04:37PM +0300, Vadym Kochan wrote:
> > Hi Andrew,
> > 
> > On Fri, Apr 23, 2021 at 06:49:01PM +0200, Andrew Lunn wrote:
> > > On Fri, Apr 23, 2021 at 06:59:31PM +0300, Vadym Kochan wrote:
> > > > From: Vadym Kochan <vkochan@marvell.com>
> > > > 
> > > > New firmware version has some ABI and feature changes like:
> > > > 
> > > >     - LAG support
> > > >     - initial L3 support
> > > >     - changed events handling logic
> > > > 
> > > > Signed-off-by: Vadym Kochan <vkochan@marvell.com>
> > > > ---
> > > >  drivers/net/ethernet/marvell/prestera/prestera_pci.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
> > > > index 298110119272..80fb5daf1da8 100644
> > > > --- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
> > > > +++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
> > > > @@ -13,7 +13,7 @@
> > > >  
> > > >  #define PRESTERA_MSG_MAX_SIZE 1500
> > > >  
> > > > -#define PRESTERA_SUPP_FW_MAJ_VER	2
> > > > +#define PRESTERA_SUPP_FW_MAJ_VER	3
> > > >  #define PRESTERA_SUPP_FW_MIN_VER	0
> > > 
> > > I could be reading the code wrong, but it looks like anybody with
> > > firmware version 2 on their machine and this new driver version
> > > results in the switch not probing? And if the switch does not probe,
> > > do they have any networking to go get the new firmware version?
> > > 
> > 
> > Existing boards have management port which is separated from the PP.
> 
> I don't think that is enough. You have strongly tied the kernel
> version to the firmware version. Upgrade the kernel without first
> upgrading linux-firmware, and things break. In Linux distributions
> these are separate packages, each with their own life cycle. There is
> no guarantee they will be upgraded together.
> 
> > > I think you need to provide some degree of backwards compatibly to
> > > older firmware. Support version 2 and 3. When version 4 comes out,
> > > drop support for version 2 in the driver etc.
> 
> The wifi driver i have for my laptop does something like this. It
> first tries to load the latest version of the firmware the driver
> supports, and if that fails, it goes back to older versions until it
> finds a version it can load, or gives up, saying they are all too old.
> 
>       Andrew

Your comment is right in cases when there's no management port.
However, the all current designs use management port connected directly
to the CPU and not via the PP. This promises the Network connectivity
will remain functional all the time. As for your comment, we have a
plan of designing basic PP ports configuration that will enable
recovering the PP ports connectivity in case backward compatibility
issue will happen.

Regarding the distribution issue when the driver version might be released
earlier than the firmware, it looks like that the probability of such
case is very low because the distributor of the target Linux system will
keep track (actually this is how I see it) that driver and firmware
versions are aligned.

Thanks,
Vadym Kochan
