Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB5918B303
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 13:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgCSMKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 08:10:42 -0400
Received: from mail-eopbgr20076.outbound.protection.outlook.com ([40.107.2.76]:11013
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726785AbgCSMKm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 08:10:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SDkXSvEokbDtemXKvsgHbq1+xMlX45kQ+Irei4Fb+dhqX2huVlcw2XaF4Z1h0LUy2KTetZc4p+xgKUsexl8oh3Yojxay/UqJCe8qQQZO6WqN8vUhJQ1RPPrkR7DzpXwHkyt7ZUzctJ1fai6VTTIuiG41QdkygegPRkuApA2HRGFWCdSB4Y8oHnJ9MPC43safn9tOH2OpRKKaHp+ny8o4RwuINDeVBRtq+nf9CN8pKlqwUjpKbruKf6MenAr/TkvJb6RO4XnSBkfUEJXWdsvOns1v7FRzGdsskG3qOUPMAp9/GvOsy0aQUAuyebuosGiHti83tHL/akZwHCXlGTnosw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7f3HiXVtPC/ErEaRBU870X0unj0Zx2x3VcdJ1etoRvU=;
 b=RWlyzhyKuIp1ZZ2V+Qu0STDIx80jUJyQYMhc23pjMn30KCucjVmH9/JIqiWF+32FBtKzW+BN402VbMm8S+oLJXc0vn4PGzNceD/0oy3dpp0QJh0QnpC7Kj0VsHU4GK5a4pMXgZkSQ+Z9oNQTCcJvbojTHp/t3DI1rb+r82UulrDdvtRDDt/PnQvCYazGl4lqH2qfFD+BKcaEXs40/3DLb0OBxg1YTI3i0MIN5UhzGOOuFJSDO3TmFt1Nfff7G2uQCQz7/cwpz7skAcL5aLhbSAO3C13nzeWBPGcPzHw8O7biBfhtNIZ/IoxfGydMPNQUSEb1h76YPJLX13sMe746cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7f3HiXVtPC/ErEaRBU870X0unj0Zx2x3VcdJ1etoRvU=;
 b=ObGs3GRMvz5AnK+e9SsaBBUrn4i63b6FD3kMQf75TFYBHFJjRcuJhYqUBpoxu0wBu3LnMpLMWlpqQkch8oLGUPEf2VS7U0XAd1kn9JZ5fj+GYpO9dFWII7Qc0SR0TcUVWxpNQyL2yIgsaQMtmnYDoQPV37Fqqq3gsXfuhW/Ed/4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com (20.179.5.215) by
 AM6PR05MB4872.eurprd05.prod.outlook.com (20.177.35.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.19; Thu, 19 Mar 2020 12:10:39 +0000
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::c99f:9130:561f:dea0]) by AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::c99f:9130:561f:dea0%3]) with mapi id 15.20.2814.021; Thu, 19 Mar 2020
 12:10:38 +0000
Date:   Thu, 19 Mar 2020 14:10:35 +0200
From:   Leon Romanovsky <leonro@mellanox.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Derek Chickles <dchickles@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH net-next] liquidio: remove set but not used variable 's'
Message-ID: <20200319121035.GO126814@unreal>
References: <20200306023254.61731-1-yuehaibing@huawei.com>
 <20200319120743.28056-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319120743.28056-1-yuehaibing@huawei.com>
X-ClientProxiedBy: AM0PR05CA0049.eurprd05.prod.outlook.com
 (2603:10a6:208:be::26) To AM6PR05MB6408.eurprd05.prod.outlook.com
 (2603:10a6:20b:b8::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2a00:a040:183:2d::393) by AM0PR05CA0049.eurprd05.prod.outlook.com (2603:10a6:208:be::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.15 via Frontend Transport; Thu, 19 Mar 2020 12:10:38 +0000
X-Originating-IP: [2a00:a040:183:2d::393]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c173a8ef-f6e7-4bbd-6c91-08d7cbfe8982
X-MS-TrafficTypeDiagnostic: AM6PR05MB4872:
X-Microsoft-Antispam-PRVS: <AM6PR05MB4872BC32D9682C7F94766A86B0F40@AM6PR05MB4872.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:46;
X-Forefront-PRVS: 0347410860
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(7916004)(346002)(396003)(376002)(136003)(39860400002)(366004)(199004)(6496006)(6666004)(52116002)(316002)(5660300002)(6916009)(86362001)(2906002)(81156014)(81166006)(8676002)(8936002)(33656002)(6486002)(1076003)(9686003)(186003)(16526019)(66476007)(4326008)(478600001)(54906003)(66556008)(33716001)(4744005)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4872;H:AM6PR05MB6408.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fqSL2R7T9U1f6oDTQ5yl28hJeyGm9ArXBqYKAHMnWZCl6oykmrAtKPQ4Xzs4/5f4sInd+r4LXG+GbHzxLbwZa+6gmGz4ishFiupRwquXoX52omWAaNMHrMTrpt7EFLiXdGFztYq4ZkOXBl1Z6FO6neevoS/5jPHk7HTzMKO4kD7F47PruD0EH3RkFr+dhdPPZL2lPYXfHoCEL6bTQA6x0lyHOJGM7FAEvqAIFc3OsQ9ZS5ZuP1nk2BTXaXMiE0wh+/2qlq+jfhgRCt2+3zfm+osB8dpdUd4hAj+rVBI3e8e8Pzw4bnkCrxZTOn0Dt1ZuuKw+nKsm7aftxNPUBygYsL4nP3q0EcjRXPT7jXHZ9p5KkOw9fMJLEUcZkfgAKKwaPwjKDFEZdo/tqXRc/uUbc7gPlQ7tKHvFp0wJANy+hxMEF7gprR5ZZuPYUn2zx7+q
X-MS-Exchange-AntiSpam-MessageData: rRLD2n+dC0lPatzwXdjVWkf1fSrf3rqG8nobLkiVWLj9+poi9vdn2yWaJIK+it54LNabuw+Wv07AcS4h3U7FKb5DlEnHuphvjPDyfatZztVjJrvfjivIpbaSoiUjoda5/g4eMIfCxJRaaAOsYbgPBt8VmIDcU2QPfIrttfOhL8M=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c173a8ef-f6e7-4bbd-6c91-08d7cbfe8982
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2020 12:10:38.7750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q1uDq1dwuXVwUWKVZO3u1ISPwf2WGsC66zXZGQ4banwGKIwZPVk2i9klvHdh2QiK6LDPOfjZ4PkB+aqrlpG5Qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4872
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 12:07:43PM +0000, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/net/ethernet/cavium/liquidio/lio_main.c: In function 'octeon_chip_specific_setup':
> drivers/net/ethernet/cavium/liquidio/lio_main.c:1378:8: warning:
>  variable 's' set but not used [-Wunused-but-set-variable]
>
> It's not used since commit b6334be64d6f ("net/liquidio: Delete driver version assignment")
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/ethernet/cavium/liquidio/lio_main.c | 5 -----
>  1 file changed, 5 deletions(-)
>

I'm sorry for missing this warning.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
