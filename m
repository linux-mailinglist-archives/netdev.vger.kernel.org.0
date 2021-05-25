Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB3D339070D
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 19:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233174AbhEYRDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 13:03:00 -0400
Received: from mail-dm6nam11on2129.outbound.protection.outlook.com ([40.107.223.129]:32736
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232860AbhEYRC6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 13:02:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GXzuYezTwPrOpvyhoTXNEnTk+/CnAh/YVliPgEa5q5J5WNTHnPZ620EnYQtDo0zMDCmeJidk3CXP7GVX9QQCLbB/Ts0vl13tRhkiEshFGJ8gCjlYrW2ofD/N42pzBGUwRbLLdEAHDOulGUkNFSVGt+jSSXxTkzB52U4zdzU+Lu7Wt2ER6RWMaxg6DeYOzQKPzYoxW1b5Z3dRxgVE0q7Iv6mT4peFQmC2OKJyEJU7laW2jXO9BgawZ7GypHsV9oh6i7Un/fEA9j8mUJh1wNeX0OZD+stsUruRA1KtO6YrH70CsEOPKPvtPtR00qpsPMzkbHohozXQKJYC3nC/CdYofQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SgYhVckkj4IAhU3KpaViBpVsXnHTRPJmvPXY4kI6bTo=;
 b=ShO8IuIs7mk+wuuFZis6CtXIogfDfRCQInap+AlQG5KuYVyfi2sa8rJ5v6OV7uT6m+SQzoET1FT3pu/vILTwoh3wurD36oQpH2r9xiVd9ZZVP+o2NSfxdSRmHDJBL/xDZKUE+hbbLpKQjVB8Z13SCj0H93ZkdBrX/XVvb/TOcSeZY8A0+Cv4m/ICzC7Sx6bV5FqdTgZukSUO7s5kRmZ89z6JFxbiNbVL1LzvcMl2yaSjo53hyH2rLmA2NLw++AQEr6xXnvX4lrdtYnAvltVPeSu/oK8+sB0hS343yvtAxxqyqNahU+mfEes8GpSUlB3saZesWGMmCM/JVERhY7JQYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SgYhVckkj4IAhU3KpaViBpVsXnHTRPJmvPXY4kI6bTo=;
 b=IXRMyY+ygBTn9y+wAQevgP8UVt1vI0R0P9K67eedDb+q4mF2KKJexutawhU4c9bu5Jk2faNqUbKErCloiVYk4dCUTBgiq2+LZ5tThvwXtl75lCZDYirxRIZZmhIsyR9WIzKLvZ9WZCP4ClYed2UIQUWdN/BWeyRYkwtdygL8aXE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4796.namprd13.prod.outlook.com (2603:10b6:510:99::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12; Tue, 25 May
 2021 17:01:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 17:01:25 +0000
Date:   Tue, 25 May 2021 19:01:20 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>
Subject: Re: [PATCH net-next] nfp: update maintainer and mailing list
 addresses
Message-ID: <20210525170117.GA6889@corigine.com>
References: <20210525154704.2363-1-simon.horman@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210525154704.2363-1-simon.horman@corigine.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Originating-IP: [2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a]
X-ClientProxiedBy: AM4PR0302CA0001.eurprd03.prod.outlook.com
 (2603:10a6:205:2::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from corigine.com (2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a) by AM4PR0302CA0001.eurprd03.prod.outlook.com (2603:10a6:205:2::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Tue, 25 May 2021 17:01:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2699fed5-9baa-4168-aa39-08d91f9ebb33
X-MS-TrafficTypeDiagnostic: PH0PR13MB4796:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4796615D17FF1EEA92C85A0FE8259@PH0PR13MB4796.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1107;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RZo33vO9C6h29soUJyxXdpoTEKe3msERXsav4V/7BhTVelNGUXgX6HQw3pxlRp3PA8h/e4rW55Zb22OR8tzpi6QOV1YlkdUyGiw6uaZqkdMVoV/HxtkSG9Zo+Kkou7RrNizf3RmWw7qfuOEWcorBQ5CZ4XlIsW4fXo+Ly6BWLpdg1DA31LO7ypbXtFUVmnzgS3s4hd8GFfWPOlP6HumqP4Ot+aHE+K33xVH5Cx8dIz697XMQyVfMhOM0vIyH4eKrVSYw2zT9HHp5oxhNyNtc6orIh2LPEfaesPCYN1YCE9SxVKQ4SQuUZ4+Ml+CAHWemoqC2mJQdvNRs/UrKxvh5WS17rPjY/MAjpq3swm35U7NSGc5T+xS9CT3ZFwxOSDeX+i/dqTQTVtJSrVeVrlUCnTY1YTsUwWpA6t3evm0DpSNPJWRG8zj8SpBfkMW/oxsbJWNYa51pvYz0/EkyPxuCNAjqwb8P7CO+IRbpe1tO/MydJ3CRJ97sCxs7vcA+9rU2pOBTVgB6R9E35JLwvDq0GW+rHalBlMe+MGzioHyJ2jWyqzwgPH9UhkC1XhhXw0T91mGpttcVPt7Yek6QGYz0jwAyRD6hiUlzE6wVboAF4Q9FW/cDOsCb90t7jpm9Uxj+JaUbi0W4zbAmLDzAuKW3a/xr64GlkIcatk+jD5hyp+8TNhklD0HbpI/ydMqINAaE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(39830400003)(376002)(346002)(83380400001)(66946007)(66556008)(66476007)(33656002)(478600001)(8936002)(2906002)(5660300002)(8676002)(38100700002)(7696005)(52116002)(86362001)(8886007)(1076003)(6666004)(186003)(16526019)(107886003)(4326008)(36756003)(110136005)(316002)(2616005)(44832011)(55016002)(130980200001)(223123001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?bUsTUO8WD2mo+/hr9zcCeuZbwC0Mxx5ejJ8OhKVmyd8IxMwmwJm+BxxJLeAY?=
 =?us-ascii?Q?NrDztZG/a/m/knq8tB6TU9E7Sad380YBQFewq2QGY+S4NtBLUhh1+TAHy5s1?=
 =?us-ascii?Q?Zd36FDuvTWNXmSwaxqTx8lLvjI4ndnazZqz0AxpfO8GzJi1/XBBPOIo/m0Lo?=
 =?us-ascii?Q?PK+9rC9/j7S99T619jeriGPVMe5c5aWTBLm9+Y4vX9WvBysgYwYmJAUXoiCl?=
 =?us-ascii?Q?EfW7DMTF8dDbV2f/PH+WucjAPnTHTS2PqaRNz3OisjYnZ3bB/Cuo2FLgENDU?=
 =?us-ascii?Q?AifLLZ7bhipmVCCCYZYFX3ydS5K6Kdoy0jqMkASv4N1S6yh9aXrxTUV90d/A?=
 =?us-ascii?Q?mPJ3iFpU0/OcSrhw7NqZE1eJNQuqRT44bL4Rj+FY+1BqfUAuXUZYyLRDA9Ba?=
 =?us-ascii?Q?Lx7kS9wk5sQmQMwsVyIXQy7FD4xIyYGLqv6pMs2Xa/UT+2IemMf+I7gisoq/?=
 =?us-ascii?Q?Ms0SFxFxXg6NY50iLfZdEbT+dhmrjwWlupXLugsiiRHEO5oVqPq5y0JyoI6i?=
 =?us-ascii?Q?fPtIjVetNN0jUY9Teig+bXGVwbPMNJ3Uq5UFYhy8Eym28hDn0z/U5Cp3DrZx?=
 =?us-ascii?Q?W/PEYLqrR948J5KH77PkCE4ju8O2IBRA2bGXTQhawMGMnNfdFhGsbb4HXwAp?=
 =?us-ascii?Q?Z0dJlYR4kzWNYN6jbeUmjYN6hXZO6uMZaAHqq3s+lXeaeJFdVSQmKzgISNPJ?=
 =?us-ascii?Q?lI7oNHF3SH6PP5LM5WNyEry5ckTxn/a5EyzzU5TXI2RbYXrPh5qtJkUU1I1X?=
 =?us-ascii?Q?/Cak5U3TsMPy3hAkz1hf31ldl03ke1v7GwGkH9csT6rn+u6u26dHwThtDhUH?=
 =?us-ascii?Q?Xx3cWrQJkTI8T3Woxpu/GHtUlkNJCpJ+HCXssr2YggZjkVJnRsMa4Y5Yx8Wk?=
 =?us-ascii?Q?MbnBnSBiAqqDIWrN9m5Ksh420ejKLGSed1q16mfxFeotwgNKv0iFePm/7yOx?=
 =?us-ascii?Q?VRTMTp14smI9p58pH0jYQlixQ9i6//IzI1pHVsMdg+lrjlKC2Zjh3LnOTHzV?=
 =?us-ascii?Q?ChfdmYr6xyUG0GYw8itt9xATBYMjB9kdksFihtnkEVQHv3xJevakavva7/lR?=
 =?us-ascii?Q?uEKLQ0dTL/pRAgzXovemSVpCsfss6Rlsoto9uduYB5B2ottokIv+bSzkyomK?=
 =?us-ascii?Q?ticiapQTS4q4yR4f46l2vl2wjhMC320te+3ap7C0IvFo4Hm+YdodhabbIDII?=
 =?us-ascii?Q?OxbQQ1nEUFuO/w/1bT4hYWbqHz6X6ALcw+bmLbl9xgXmW74OZWtRLk5smVdi?=
 =?us-ascii?Q?/bPiBuQC7RDvc2uRa6IkzVjwOLm7vE0qWPEKozyBqE7Cr5/97WHAfxqaxwUF?=
 =?us-ascii?Q?jXbEO/S8tQ0okrDquGelG1qYTWz/XAYm9NW0ALyie5xRQLCn3AoBeMgwOR5s?=
 =?us-ascii?Q?PKJXWL+3rqEpUUgqxjd5TWM2G18e?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2699fed5-9baa-4168-aa39-08d91f9ebb33
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 17:01:25.7516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m8rkxYDSADU3Qcm62W7qSed/ip2xkmunXQz+nC3BzdbyAU5vOOxb2uRVZyJUlOsRkqWTwGl1qAFQNzEUjoGa5lm22A3FH32S1wlM3lM5g2w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4796
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 05:47:04PM +0200, Simon Horman wrote:
> Some of Netronome's activities and people have moved over to Corigine,
> including NFP driver maintenance and myself.
> 
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Louis Peens <louis.peens@corigine.com>

Sorry,

despite my best efforts there seems to be some problem
with oss-drivers@corigine.com (probably an error on my side).
I'll get that looked into.

> ---
>  MAINTAINERS | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b9f329249a5a..fd31ecf7da13 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12686,9 +12686,9 @@ F:	drivers/rtc/rtc-ntxec.c
>  F:	include/linux/mfd/ntxec.h
>  
>  NETRONOME ETHERNET DRIVERS
> -M:	Simon Horman <simon.horman@netronome.com>
> +M:	Simon Horman <simon.horman@corigine.com>
>  R:	Jakub Kicinski <kuba@kernel.org>
> -L:	oss-drivers@netronome.com
> +L:	oss-drivers@corigine.com
>  S:	Maintained
>  F:	drivers/net/ethernet/netronome/
>  
> -- 
> 2.20.1
> 
