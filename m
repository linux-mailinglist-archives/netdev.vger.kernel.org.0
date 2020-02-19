Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19D8F164ACA
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 17:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgBSQnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 11:43:18 -0500
Received: from mail-am6eur05on2086.outbound.protection.outlook.com ([40.107.22.86]:6057
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726638AbgBSQnS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 11:43:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MJm6AmTCqAtLWI5g3JrmhUFM7PmNw1bl8vgYgqY786GE+0tJ4uDhVQsXToIXAxsLt6BFQ+1v/Pl76LwqaE2K8frrDm9PUcuxnB5DfIOGYEU0gJa0didBDqGFf01pP7uvf+aI5wByIDQh3/Xv+qNU4WLMF2dvG/h/s9RtpebIaNhyc+lUiEvPjmYYxM7Tiz3ya0dgXqhRy/MMEAfwxUjuNtg9m+xF18FfmB1zIZpE+GlP88itPGvY4e6bSHNW6cYEeKGIfZYqQyjjBnTk/jUbW5MoX9mhI5l0R+veGdPeNp/Z3j7AcwhwRGRGPvq2a5iDT6Fhtx/tmyIPvhXq7fDg+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nGRmZD8SXDm2egzloCx7Q49iMXSRJewyjf0VSQuNGrQ=;
 b=dOQO6A4QefOLCNTEJVQlGpBWnmeuyTJ9eFOh5KBYa7unEk7TvEBeA0p04w2VPGj9QhvMsHKS9sROjv1t9CldLtOaYFmdBzfI90Y8scPot+jF4Q2ahSn3i8EATQ6NNUwqsblYNawhe4wjOPUu6YzW4dS6bYaKYOZKquA4Bg0qCrXQ736MdxohE5EoxfQKTwcQ9bff4et6nv+8Lo+zEPYjnsQWvobBd1kPrwvcRPypZfZ5wev7kNl8TVkz8cefJEnVUorQlab3QsuAt2RwnkHfA52SHRINbrvRzBcN56m3troxxLrdXlyBbvM5eJbJmiHqZ7SOup2r5G7UNQ3uC2b2ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nGRmZD8SXDm2egzloCx7Q49iMXSRJewyjf0VSQuNGrQ=;
 b=FgJXDx0kjrUj88GVgB7OFzYbays80kYktUxrvdcwAm9bzNREUyc64FVlUTk1aGqiAvc83Gkzs99qme8bdk3Rpxv2xs09OUdg4zGGK3geVe4051VXkQVeEGt78X16pOXzvQ8mlOd/uy9LeTkiCmNohZqKLlF2cNtbOBdYWksLqf8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=idosch@mellanox.com; 
Received: from AM0PR05MB6754.eurprd05.prod.outlook.com (10.186.174.71) by
 AM0PR05MB4338.eurprd05.prod.outlook.com (52.134.91.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Wed, 19 Feb 2020 16:43:14 +0000
Received: from AM0PR05MB6754.eurprd05.prod.outlook.com
 ([fe80::756b:53ca:e33d:7876]) by AM0PR05MB6754.eurprd05.prod.outlook.com
 ([fe80::756b:53ca:e33d:7876%7]) with mapi id 15.20.2750.016; Wed, 19 Feb 2020
 16:43:14 +0000
Date:   Wed, 19 Feb 2020 18:43:11 +0200
From:   Ido Schimmel <idosch@mellanox.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] mlxsw: Replace zero-length array with
 flexible-array member
Message-ID: <20200219164311.GA348671@splinter>
References: <20200218205705.GA29805@embeddedor>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218205705.GA29805@embeddedor>
X-ClientProxiedBy: ZR0P278CA0024.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::11) To AM0PR05MB6754.eurprd05.prod.outlook.com
 (2603:10a6:20b:15a::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (193.47.165.251) by ZR0P278CA0024.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.17 via Frontend Transport; Wed, 19 Feb 2020 16:43:13 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 65e7fe17-f860-4785-016f-08d7b55ad01b
X-MS-TrafficTypeDiagnostic: AM0PR05MB4338:|AM0PR05MB4338:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB43380990BDB5B3DEAC08B2E6BF100@AM0PR05MB4338.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 0318501FAE
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(7916004)(396003)(136003)(376002)(366004)(346002)(39860400002)(199004)(189003)(6486002)(81166006)(8676002)(52116002)(66476007)(54906003)(6496006)(16526019)(956004)(81156014)(66946007)(186003)(66556008)(966005)(8936002)(2906002)(26005)(9686003)(478600001)(33656002)(316002)(1076003)(86362001)(4326008)(5660300002)(33716001)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4338;H:AM0PR05MB6754.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HMg48+jLq6Vnb4m3Hx18o2RTUjj0z2A5fnZ76CCTI/My0t5fnpfyUbrwtzPhWDAXwzWsiQC1V9BJlJlGyJ0Cf2XF9e5O3aZfwejL+/9FxO89w5u004Ye1/B6kSNN1PuBolJbEmGn42IfiG5DIju5lFCi4foLaxsmUtJUkf3kymccnv6g26QDjcK/lV0Vfgr66Z4XUBji8Z0m6jMmD8cclL8rUHb+39/x5x2D0FkCvyyhdjvlGWxYHCVQnJ1QTx2YdFlHNJZ6iUTKZOuUGNTi9fF5agzc3lYnqw7aspyEAgCbpvxsSPPNusTYaF0FPEgI42fqJpM9/b6zf+jXlfRC1Tl1sPO0/BbJO5zTwsjvNrky0ovX68ruW5xm2+86LYw59r0o5vilGg/hi2yXWf08u6cnh8zMzI9SqYnnGpNWSt8PxU7noHllnKsntV5e1t+YtsFD972M7zOcKsvjEOBswrDzcppT9XfzOZJ7eBjuyBjvWV2/OdlLfP66aOaVQIMt1qKyYWbq2mEOS/AgFwCrjA==
X-MS-Exchange-AntiSpam-MessageData: zUocK6XZwkfSyecuqgdCVsJavDM65/k1OwKejoiV3mdYhnjMHNu+0Cf6mKMsOf/+2iP4TKfipLGmXfB1mc7tvrEaHlZ7g7WVx5TOdV74AG/C7osLIE3PM7T/SYgM7KHkuW4iPO2eDQ/iTeN5O2wo+A==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65e7fe17-f860-4785-016f-08d7b55ad01b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2020 16:43:14.1051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lEjVgDu8MlgyDqEL26iT36rlr/o+r971c6SlwDHSssMRBc7oPMZcR3mHx9OAXr07oOK580foozmsCAGMVpYzHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4338
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 02:57:05PM -0600, Gustavo A. R. Silva wrote:
> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:
> 
> struct foo {
>         int stuff;
>         struct boo array[];
> };
> 
> By making use of the mechanism above, we will get a compiler warning
> in case the flexible array does not occur last in the structure, which
> will help us prevent some kind of undefined behavior bugs from being
> inadvertently introduced[3] to the codebase from now on.
> 
> Also, notice that, dynamic memory allocations won't be affected by
> this change:
> 
> "Flexible array members have incomplete type, and so the sizeof operator
> may not be applied. As a quirk of the original implementation of
> zero-length arrays, sizeof evaluates to zero."[1]
> 
> This issue was found with the help of Coccinelle.
> 
> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> [2] https://github.com/KSPP/linux/issues/21
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Thanks, Gustavo. Looks good to me. Ran a few tests with a debug config
and nothing exploded.

I was just about to submit some patches myself, but they will conflict
with this patch, so I will wait :)

Reviewed-by: Ido Schimmel <idosch@mellanox.com>
Tested-by: Ido Schimmel <idosch@mellanox.com>
