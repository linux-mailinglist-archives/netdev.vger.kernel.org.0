Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 949AD17D44A
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 15:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgCHO6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 10:58:05 -0400
Received: from mail-eopbgr10050.outbound.protection.outlook.com ([40.107.1.50]:35843
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726339AbgCHO6F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Mar 2020 10:58:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=et/4bxmEIJY4/Z2k+1129P98syBoEJb357PlsR6+OPZi09CnK+zckK2SUpVLSX6Dt8KfMDEMVTCoYKf1BdfRxxmuerUvgwDLH/khkoTHdG4OwTatp/+fYyGuZox+Pgon2LP2E4N1qGMN2QUBr7LDtNo03NcDRRg02u27ijr1De/oTMiq26rj0ALTpAXNmesvJ9naAVnFUuY/PTiohRN+Zs3ttUvWVYsQyXJnLXiyBiGTLUrQy3jT2nXUNzOdEd0ayct4FuDxH8qbkqWLXU5nZ3kptb6nvc+EiPtu2xHItEwZpC5QXrbWIh4GDccAvhbFmr0lyPit2Se1g59zfeWLjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TWdhGrJ+hiXqojbDtONz9o7sT0p6Xbd6S3rmjI/xwfM=;
 b=kmv9Kd5mdqNviGK+6IDZ/6WoJ9HBkYY2Grzw39Va413TfaVPwjwzkDR0e4wzHLMK8A4dbFjbe4U/DXzYNZqtpBVfaKNBesIOONWnBlYLil2gAuJfXnrErHe6/XrP1jGKD0vxCd95ijjrLtqVryLdOrWJ4C0ZeSTnB+D5K71qfXoWoZNdCZJyxYDp0uy/JDr4e3LC0z/Tj2naqr7HJV5IQ9QjGjL9498sRwUWdxQS//VjWQsiXQTjHYmTNy3AVTr9Fjb2qA05LB9UTXWZmll3YP33mGHh//p+QDb+UqQHSEk3YLKv61zgTD3865lHoFrLl8HWyFTBNb9z+TlzlDw+Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TWdhGrJ+hiXqojbDtONz9o7sT0p6Xbd6S3rmjI/xwfM=;
 b=YsHQpaU97z823u5HGW0eOtDada/e+6Q9jmhloNzLXu9NsyBgCHJFjSnn7MBHPSFnT7AWfoQRwqsjb45dn33IBr/0wqIea3+1f+vW5EMTjQE/sFychPV6A/+ZB1FlqvQ47BXIMSGR9u62xalziGPrF+w41Ncab7wr9TPlXhJbWpU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com (20.179.5.215) by
 AM6PR05MB4486.eurprd05.prod.outlook.com (52.135.167.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.16; Sun, 8 Mar 2020 14:58:02 +0000
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::c99f:9130:561f:dea0]) by AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::c99f:9130:561f:dea0%3]) with mapi id 15.20.2793.013; Sun, 8 Mar 2020
 14:58:02 +0000
Date:   Sun, 8 Mar 2020 16:57:59 +0200
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v4 net-next 8/8] ionic: drop ethtool driver version
Message-ID: <20200308145759.GB11496@unreal>
References: <20200307010408.65704-1-snelson@pensando.io>
 <20200307010408.65704-9-snelson@pensando.io>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200307010408.65704-9-snelson@pensando.io>
X-ClientProxiedBy: ZR0P278CA0052.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::21) To AM6PR05MB6408.eurprd05.prod.outlook.com
 (2603:10a6:20b:b8::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (193.47.165.251) by ZR0P278CA0052.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Sun, 8 Mar 2020 14:58:01 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ab6160d8-2c9d-4d4d-8bdd-08d7c3711971
X-MS-TrafficTypeDiagnostic: AM6PR05MB4486:
X-Microsoft-Antispam-PRVS: <AM6PR05MB4486C8816A63B240873DDCF6B0E10@AM6PR05MB4486.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 03361FCC43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(136003)(39860400002)(346002)(396003)(376002)(366004)(189003)(199004)(81156014)(81166006)(8936002)(186003)(2906002)(8676002)(33656002)(26005)(956004)(33716001)(4326008)(16526019)(6916009)(4744005)(1076003)(86362001)(52116002)(66946007)(9686003)(6496006)(6486002)(5660300002)(478600001)(316002)(66556008)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4486;H:AM6PR05MB6408.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6muh8okItI/jf0+q8cas7HwsFm+MHfGJwxsFEdWEqjY+N/H8xfRtT8U37FTqa/p/qf6aIzHvtejXbez2RXv+pfhaiCNJxujXBnqa5kA6Yhbe8+izONl9vbhcAQEys2dMOGPriOuJPgN+m/9H2dydlNS5f0USgUJd0IFOk+7e3KOoX1+10UweZbzIbIscMB5IrTHR2yczZON4A44HREwg5mQkxqhsvpwsx761ootNveVZIBjZ/rhOK1l1y3KxLSFRhwhswCznH1ToaevEDa58mahFiZ355jSfTYtHH9Re+NMuUWjB8Rkn+hqkY+eAn1FZ6PSIKbq4y5AZ8DZ0O6hCnWsqaOCHok2yIRFAekYLNTXtp1hTTnlY/yDOMvgngINGxASnU0zYzGYS2aG1trR0NCWHTewiHO6pB8cstr1qWh68jgFXSrf5uN2uEhB2kShB
X-MS-Exchange-AntiSpam-MessageData: Ab3tPHQ34p/LPjQi2+0Dne7wR+kE6bFOofYoRpk5a62L1RBWYskB5bqYPY3dNErzFLj10KLsKjckg2wnA/e0MgEXXpECpWrp6TME+ezpJ4kXhDekHJtiB+YDNZouzzGrOiL4/GHwpHgL7tljMn+68Q==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab6160d8-2c9d-4d4d-8bdd-08d7c3711971
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2020 14:58:02.3356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YNtuxj39wVHiSERU3O55i1FrMNXk9ZftHGnP6bDzdjyB1FDBNK7rdXRKTRtKsMvTjJgXShbM4R0wOM5y1e7i6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4486
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 06, 2020 at 05:04:08PM -0800, Shannon Nelson wrote:
> Use the default kernel version in ethtool drv_info output
> and drop the module version.
>
> Cc: Leon Romanovsky <leonro@mellanox.com>
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  drivers/net/ethernet/pensando/ionic/ionic.h         | 1 -
>  drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 1 -
>  drivers/net/ethernet/pensando/ionic/ionic_main.c    | 6 ++----
>  3 files changed, 2 insertions(+), 6 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
