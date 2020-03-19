Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9222918AD14
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 08:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbgCSHBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 03:01:32 -0400
Received: from mail-eopbgr40080.outbound.protection.outlook.com ([40.107.4.80]:58375
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725787AbgCSHBb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 03:01:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k3onsb5ZtcRkkIewYtty9YNI2YG/Q2TwuY5ZWoKEJMzZcJA7XlJJNRdK+E6a0kgWu2nkn9RUFxve8HJlAEGPje4FVGAJi1k6PcryIJ9NL4EzRQrwFNNfwnMUg7Ke3Mrd65uQQ84aU96ivHGYCKYUCVvEG6VvJB0LF3xBMJvrRCxWiCYxeu0Fk6G063cY8uzMaKO51QRRKanubvjq6PyezTIDHkDGJuVf0jlE5K6El2PJYyO98icDH3J84fOl6+7dsXOoPccfmRAhOxvqCaCF2C4hfqWtd0e1fd4oXht/6BVt8xZYtasSE0UzqFhfHfVndjo4/eKvHamQKYW1FWt05w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3vGa26LuFfY+iHgMfUtU1vFcXCpGi56ULIn1q2psfjM=;
 b=dd3EoDX8LmmMmjaUIkRZk3/4BdOryTChlnOcZQYxnL7oznW0fP8eppftl6ChfZYTsnAZbATo5BDtntlXCywIQAfiV83ywvpJzkUHUeaqAUK4Je0ow67sB4/iwxQHi61JiqID/YCjIy6YamkO9E2lOy6QduQxCcnFUKg12x6JZCebNJ3R5NubfwK7OL2hc3m9fYMEHaH24r3ptMpdQZ5gZnntbbNaxF37EdvDLfKVbPDneHAUO/wdxrpRiyCzXD4+KG6cucmlJxKmmfCL1fCSxsn4YfUNvqg7QFq6cAYR7egbxkrgW6QsF2n0oVgEMdy1ergnqu1fnMFCQrp86kG5xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3vGa26LuFfY+iHgMfUtU1vFcXCpGi56ULIn1q2psfjM=;
 b=tTwgtpyccWfPiSAOQIoUDmSbySZjknN7eLRYhi7X/I13q4DCyK0F4WJ525QE7NHPfj93LEisAlo2lNS7tLBNrcKNJvJT8ass7xVRNLRv75mj5HXk0YA3XhmPHBS7BfhBCVLL9wgCUiMn7Xp+yyxkvWWcUaDjx3x2Lg/l2qLnWNY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com (20.179.5.215) by
 AM6PR05MB6405.eurprd05.prod.outlook.com (20.179.7.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.22; Thu, 19 Mar 2020 07:01:28 +0000
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::c99f:9130:561f:dea0]) by AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::c99f:9130:561f:dea0%3]) with mapi id 15.20.2814.021; Thu, 19 Mar 2020
 07:01:28 +0000
Date:   Thu, 19 Mar 2020 09:01:25 +0200
From:   Leon Romanovsky <leonro@mellanox.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     claudiu.manoil@nxp.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] enetc: Remove unused variable 'enetc_drv_name'
Message-ID: <20200319070125.GM126814@unreal>
References: <20200319064637.45048-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319064637.45048-1-yuehaibing@huawei.com>
X-ClientProxiedBy: PR0P264CA0225.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1e::21) To AM6PR05MB6408.eurprd05.prod.outlook.com
 (2603:10a6:20b:b8::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2a00:a040:183:2d::393) by PR0P264CA0225.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1e::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.15 via Frontend Transport; Thu, 19 Mar 2020 07:01:27 +0000
X-Originating-IP: [2a00:a040:183:2d::393]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d5263be1-b355-45f1-228e-08d7cbd35884
X-MS-TrafficTypeDiagnostic: AM6PR05MB6405:
X-Microsoft-Antispam-PRVS: <AM6PR05MB64053FEB44D6F0A21FCB0F3DB0F40@AM6PR05MB6405.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:161;
X-Forefront-PRVS: 0347410860
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(39860400002)(346002)(396003)(136003)(376002)(366004)(199004)(8936002)(9686003)(66946007)(66556008)(66476007)(81166006)(81156014)(2906002)(33656002)(8676002)(316002)(1076003)(6486002)(33716001)(478600001)(16526019)(186003)(4744005)(6496006)(6916009)(5660300002)(4326008)(52116002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6405;H:AM6PR05MB6408.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HbDCpxmwt5c60oBl1uU6yb0ePGLUml7joFtPXnamVOvaDIZFCv7TdNCyEvIIcd8qi5WgjrtUXTuqwsFuLF0sKTuHGKwF+gDmeNmCDl7TGftYNJOHD2QG/MifSyVXRl2L7CEU5c0zsXIBfTuHiEP0sHp7IZd+wPgq8YPZesUHW4dLLi8XVcLkT5K+rL1EBsqUilLq6jOxsZqquQYw0H3wx4cA6etr1OkqS+hzJxWentD8hv1pfTSXKqlcUgIUsjPOhbDjr14medWfblKjZl369mneayXd1GrAI+RljTNITwu+NZYmfbRu3hiRm6NyILa4lwNvcxEnV2DIZjbFs5JGH40UuL4ygqvqknGDFLaPu/EXyW/DNq1M8k9fn4VK3TqqmJzbkaq7miL4BK8frVAw1egBXJ3GfiuMOUJqAlr1MUYOupX6E1UXoA/Gu8OEFSm9
X-MS-Exchange-AntiSpam-MessageData: XkVC7g6MVxrFmrHCvHceXYbo1uG6uBbqC8g1srAWWL6EQ9QDbqrCkMLIOuMMrwYy4R77A28juPspoJVtI0qT8c+7IjYR7Sdmtt4UZfNOhTKGKwWVzabn4NBJbrU6Tkq1EBCjhVN/q9LRlLxsgMbZiT3tjirqsagGEdS2l9MZtTA=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5263be1-b355-45f1-228e-08d7cbd35884
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2020 07:01:28.1825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J5h9Rp0gpdFJMVHcL41kQsxUQPI9U2vB3kfBwvb5zQvcwRc+1EpGq8ek5idmsAeCMREO7tkD1dS0Q3GP85qD1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6405
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 02:46:37PM +0800, YueHaibing wrote:
> commit ed0a72e0de16 ("net/freescale: Clean drivers from static versions")
> leave behind this, remove it .
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/ethernet/freescale/enetc/enetc_pf.c | 1 -
>  drivers/net/ethernet/freescale/enetc/enetc_vf.c | 1 -
>  2 files changed, 2 deletions(-)
>

Fixes: ed0a72e0de16 ("net/freescale: Clean drivers from static versions")

Thanks a lot.
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
