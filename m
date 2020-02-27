Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C763171394
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 10:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbgB0JB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 04:01:56 -0500
Received: from mail-eopbgr150085.outbound.protection.outlook.com ([40.107.15.85]:28098
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728624AbgB0JBz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 04:01:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rcp0hZjZmfVmYkJtl9EkL9PCyraoayKTxvhVeX6NipsqKHIvm5cvsEIOH1Q9VjuikvE7xZi4G2JSO4MHjYG6HoyGhKjL+2dgc8a9muicX9/VcxUBwrR3w7WAq6SI9bXS9PBcp8mGLtsGYt/BYEdWLiW/zPIaOv99XU2ahZu3SxVL6fERbtn6yBe+zg4OwCC9ykW1TZ/u1dTS2UrgARrOeQl2zEC3bn0INLDvR3y1Eehy9iTq6IK5lc6QqHDh8nacORABQB+V8Uz8jRBSgIdCfagofdxSPDYgNE6FbvtyXGPqnzFYLt4vk5O7LKEr299jv4ZoBspphr5wahm1TVVSeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1OaLz3ieDm0BvzuyfM8KTLuA3T8Phenjw/l7xvhlNxs=;
 b=nG7eB0hUnHKgVsSm+bLUjZruwog2xFSM56KY2Wo9tZqq6GzUWTOGm7tlqIUqSjsK7pGi98B+goSvGbZhNcLqxici0uYA/KJ4SUNtDJ9JMFQw+bN13R9NjLxlS4Hv+CGmzOeFuiotCKqOYYGGPkfLVx+jAibqGZ0wjhPDjtIXVQd3r2vIZ1yLCdbIf4lct/4IGzPBittrwNsag9yxA3sIzNG32S88xKwYpyBcIDLdCnEYLH767Yo2SNDOsdu3ZPbS3sX4HL0YX/cpuhMyq8RPX6aiXlj8W5cNXUJqCvu2Ua9PO5WpAz/SGtzBHeLpo1UTAYA3Ns9ukRqggv1XAljnow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1OaLz3ieDm0BvzuyfM8KTLuA3T8Phenjw/l7xvhlNxs=;
 b=oCYtqQxYUfSSRPt163MDOqgKgF2sJFKNYZRLook5xetuPKgRZULcAtWzarDjqRnVwMpT1fnM49xR0PUtlFr2yrZtGE+Y3lzgDTOif0lFsYtp/icm0/KSmvZChB0LULMQyr+tmds2drrSNytQGa7rpJkmDsPEvmYIGxEvyN1iVyc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
Received: from HE1PR0501MB2570.eurprd05.prod.outlook.com (10.168.126.17) by
 HE1PR0501MB2825.eurprd05.prod.outlook.com (10.172.125.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.21; Thu, 27 Feb 2020 09:01:52 +0000
Received: from HE1PR0501MB2570.eurprd05.prod.outlook.com
 ([fe80::60c4:f0b4:dc7b:c7fc]) by HE1PR0501MB2570.eurprd05.prod.outlook.com
 ([fe80::60c4:f0b4:dc7b:c7fc%10]) with mapi id 15.20.2750.024; Thu, 27 Feb
 2020 09:01:52 +0000
Subject: Re: linux-next: Fixes tag needs some work in the net-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
References: <20200227154251.5d9567a5@canb.auug.org.au>
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
Message-ID: <5144804b-0a96-8cf3-4490-2d0f6c4134d1@mellanox.com>
Date:   Thu, 27 Feb 2020 11:01:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <20200227154251.5d9567a5@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0033.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::20) To HE1PR0501MB2570.eurprd05.prod.outlook.com
 (2603:10a6:3:6c::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.57.0.150] (159.224.90.213) by FR2P281CA0033.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15 via Frontend Transport; Thu, 27 Feb 2020 09:01:51 +0000
X-Originating-IP: [159.224.90.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a2c67d9a-3502-4c44-fc29-08d7bb63af8d
X-MS-TrafficTypeDiagnostic: HE1PR0501MB2825:|HE1PR0501MB2825:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0501MB282539C5F3B3D39D92183882D1EB0@HE1PR0501MB2825.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-Forefront-PRVS: 03264AEA72
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(396003)(376002)(366004)(39850400004)(189003)(199004)(8936002)(8676002)(81166006)(2906002)(81156014)(36756003)(5660300002)(54906003)(16576012)(478600001)(2616005)(316002)(110136005)(956004)(4744005)(31696002)(16526019)(55236004)(186003)(52116002)(53546011)(31686004)(6636002)(4326008)(86362001)(107886003)(6486002)(66476007)(66946007)(26005)(66556008)(6666004);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0501MB2825;H:HE1PR0501MB2570.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mZyHxcb3kBOabJNdZr23WIJRePQ1tP39dEQI9o8sWeeLaA8oEvXXaRFTrwdG3uOr5knXcRh+nIG7FgWlR2ecQtZfXCDQjH2uTYcpKuG5wn0PoNhWYlvPjdne/4Mdu+ZkujasPFSiyCFjtSHq6BfHCjLQfwbo3jxt40hL4p1go3TLUVu3GKijZMBcRhzzimJvvUreCeLjEI0wMQxDTwEKaC/nQv9l47IXZJFjhwsWWV4lB8dNKSLKix1NTjc4IRJscj7z4yrRPZEkQHW78DMgRqzr1WwL8pU7LwjN2sNWrxNzercvoAPhMxqSQlnWQLvDPOObvWaCmHZQeYqOlBsYd4WVn1EvnFlupf6gWdbzdavu5T1gzy3d8v/DUKAMGu18zS3Ewx9ipK7CPhs1o7yLKZFZe8G6gFAZnw1MSsh/7E1k1Tf/A2Gk4eFxjxaC29xS
X-MS-Exchange-AntiSpam-MessageData: gC9IqZjb1w3jZsfU2qTkczemqS2rG9mULUe9kWc+MM33DGx6Ewpt0PPAOU2eBlVJkLHTmB1oVi6OPHSKhwbCc2qhC23FB8WVV13WBcLqqxKPu0+csXyYjWhIaCWUoCMyODfwqO5iYJ/n3mvTeJOVQA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2c67d9a-3502-4c44-fc29-08d7bb63af8d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2020 09:01:51.9638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9X9eNCln7ivwRpH0FrtYg78QiBTQSLYLVkjjLTSSizmm3bhCcQCOXFAbvmZiOaDt5jOjhdhGapILqQemrJ5XIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0501MB2825
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-02-27 06:42, Stephen Rothwell wrote:
> Hi all,
> 
> In commit
> 
>    fe867cac9e19 ("net/mlx5e: Use preactivate hook to set the indirection table")
> 
> Fixes tag
> 
>    Fixes: 85082dba0a ("net/mlx5e: Correctly handle RSS indirection table when changing number of channels")
> 
> has these problem(s):
> 
>    - SHA1 should be at least 12 digits long
>      Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
>      or later) just making sure it is not set (or set to "auto").
> 

Oops, so sorry about that =/

I relied on our CI that has to check the Fixes tag, but apparently 
failed this time. We'll address the issue with CI.

The correct tag is:

Fixes: 85082dba0a50 ("net/mlx5e: Correctly handle RSS indirection table 
when changing number of channels")
