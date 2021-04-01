Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D85223513CA
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 12:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233922AbhDAKld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 06:41:33 -0400
Received: from mail-eopbgr1320137.outbound.protection.outlook.com ([40.107.132.137]:6213
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233702AbhDAKlY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 06:41:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QMWW6NsSjBQiW7MUd1Km0twTZbKu42TMuiz4xnUfN1iytHMHl/4EiTBmnnFl2iEKQDjHviI1BWaBi5dbjoV/bqENeHB1sCte38HzzuT+V2sjpFLQGCxZBgdU5sEW1U4YrTEdMf81t5OvzpPBf942G5n3ae8nq72XBIThGQM12rFi2TFoX6vyYP5j0WYrKp+2aX6YAiNhrxRtvK9dzU1w6P1iy6W2xrAdS+29sjOc+3SA4M8kTVzNrT+K8cyaCNL3R653Te1b3ZwHZFbSdpr1tFdMoWJ/TWjcXDIQysvzfIxhUv5UTish/eTqFv9GpYdXt19ipBjshQerZiBjFEp/Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rLI9lHIuo2KbUxQ3RDMgOxVCKn++jNstKSwr3IuGRoQ=;
 b=daO+ZHx1I3xz/PcYC1ILBcqg530WbKboYpgaRrCUXP3wikDFkObhQkKz5fwC2RwuJtaQbJGf1kR0vH/3AcPDshFhURWpj/8XtneVmgmyqYzv+wQtrIZlBD6AIcarlDfZCzSuQ/cgfyKY8JibRdESs1xtzDAS/uZM4SNqTSa8NHmUbBMJ1f+3zAZqyBNi0u2P6VBuP0MOQEEawUwqcpfNo3dM4q15qqXAsvk/feTUC4DeYvQfim6/t7O3YVbbD9APWn2bY3cpGYU8J4+v4OWkoLICNi2kW+aIxNKOxykIcxFGYeAKzqjQUHrydSRyVZkkOURchx5oyHSIjSYj6MVHOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=zenithal.me; dmarc=pass action=none header.from=zenithal.me;
 dkim=pass header.d=zenithal.me; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zenithal.me;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rLI9lHIuo2KbUxQ3RDMgOxVCKn++jNstKSwr3IuGRoQ=;
 b=cOyvoEJ5bG1fBOwtaccKsusvavzdLwKzi34QY9SooukIcXuotjHoahC2Pzvnn8knVY5CtXHuIOQ6XhF3y33Y3/76LEUCaAjqCjnkV2J479wHVgoA782Rx9DAbpskqloahw32c9MT0x/rLOxodrrEiXQc1c06x6qFfknV5QvY+B0=
Authentication-Results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=zenithal.me;
Received: from HK0PR03MB3795.apcprd03.prod.outlook.com (2603:1096:203:3c::10)
 by HK0PR03MB3905.apcprd03.prod.outlook.com (2603:1096:203:3b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.19; Thu, 1 Apr
 2021 10:41:20 +0000
Received: from HK0PR03MB3795.apcprd03.prod.outlook.com
 ([fe80::8492:e28e:e777:6d05]) by HK0PR03MB3795.apcprd03.prod.outlook.com
 ([fe80::8492:e28e:e777:6d05%6]) with mapi id 15.20.3977.025; Thu, 1 Apr 2021
 10:41:20 +0000
Date:   Thu, 1 Apr 2021 18:41:18 +0800
From:   Hongren Zheng <i@zenithal.me>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] iptoken: Add doc on the conditions of iptoken
Message-ID: <YGWjTg2yzYT3V7YN@Sun>
References: <YF80x4bBaXpS4s/W@Sun>
 <20210331152602.50cc4a79@hermes.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210331152602.50cc4a79@hermes.local>
X-Operating-System: Linux Sun 5.10.26-1-lts 
X-Mailer: Mutt 2.0.6 (98f8cb83) (2021-03-06)
X-Originating-IP: [2402:f000:6:6009::11]
X-ClientProxiedBy: HK2PR02CA0141.apcprd02.prod.outlook.com
 (2603:1096:202:16::25) To HK0PR03MB3795.apcprd03.prod.outlook.com
 (2603:1096:203:3c::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2402:f000:6:6009::11) by HK2PR02CA0141.apcprd02.prod.outlook.com (2603:1096:202:16::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Thu, 1 Apr 2021 10:41:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7e7cb78-2184-4832-f52d-08d8f4faaf68
X-MS-TrafficTypeDiagnostic: HK0PR03MB3905:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HK0PR03MB3905F872919420C0EE81C449BC7B9@HK0PR03MB3905.apcprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BCpxVEclStpDRlM1OxV5Snf6qzMoY4vJQv2aIr7Tao1Dyx8Bx8fwqUIeYFAdhqHKA8ZKIIAMhJSYztkQl9y1b20mpoM05d0zo8tF7k+arDLJFP7vvHBMwrIFAR2kb2igCCGID4OaEfgLw35UhQPUDJrDUc+ANu0ve+UiLZS3M/2lfEaI2GHVlIHYEd9Sli6/yc/IfuUDTwwjb/fs8npnpZIGTAylKsJeIXfEpEXj1jAZ2Dbcx0D4cyfNXyP7fmU0rXqcDhhl5rxjFcWgeMQCHdn0s3y0w8WTrtNTUqqyDEl1UHTQjsv8xt7s1yTOjx2Blt/OpuneoYLdfkhjG+Sz9849c/UiGvoe9xC1pDbm9CNPX2pS3Mi5x3r49assKgmkOsFaMd0A7kWOZmwdb/UYzWN2oaCU38Aa5twtbrr5dUVAb2eTUZVayqu1AlV2BzN1b+PgluA31ORb8yjTYPOqx7txDc0W32u/Ws7c3J/g+9qHzIcTE7r1Upv5on8WLqNISvSajEFq4UTZMOYLPCSosFgerpBfqWdPA1vLR6LMxzf6v4MyCYPGPZVv4xMDpzQUDnovB+6ufftow+lCZSTcNSBWWUJzr+uE+FspxmQHUwW2ApgcvmVWVPxyUZYrCp+kgK4g8YWTOKgpeBcOKUrYtg02Ku2ck7frZ0PF+eN3Hkk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR03MB3795.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(376002)(396003)(346002)(136003)(39830400003)(66476007)(4326008)(66556008)(8936002)(4744005)(66946007)(6486002)(38100700001)(8676002)(83380400001)(186003)(2906002)(33716001)(52116002)(9686003)(16526019)(6496006)(786003)(86362001)(5660300002)(6916009)(316002)(478600001)(49092004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?yletsm4AubtynLtR7jWIorMioNUW+RXLgPMKXsnWkc8ssfWCmn7zPirjBlZC?=
 =?us-ascii?Q?ptNq8TdzLz5A8axd3zA9F2jItonx7siGeCsz4inlWG1bHj22WppxwAshRZBk?=
 =?us-ascii?Q?9Sq5WN4EIm28ESy2Z9lUKE59XupNYZV6Uoyr0pVpueJzqaHErZ3wB0yl5Xar?=
 =?us-ascii?Q?MBES2k4Qs1/rLlfJ//lV4MLKfZ9UWAbcmsEm9N8yxE3HzEh6RImQEO9zPLrZ?=
 =?us-ascii?Q?A2PwBhiCGS7P255/nIDOkvLkrpRV5e+AQvMhyvZRzd7yYsgexR1hjZw06drr?=
 =?us-ascii?Q?gQOAw41AyR9JwfDRTUKY0EICPMkSXg2ijSIyenSkG+mrEYPxHujYTye8HorS?=
 =?us-ascii?Q?pajOcxn0ofOOWkyCpMhrUg2FsBsVXZdb9q0tsYi7Gq0U61FCVuEvjx6NRwBZ?=
 =?us-ascii?Q?TQz/sdkm3wq2qW1jxjhdxga7CNaaR7xcgAFAnIENFnxKToQNiyO6GO7yRpYK?=
 =?us-ascii?Q?iyyrIFfjGyT+lYHYWXZ2A4v5gwmgrNUATPTnD/AYZHb70YGv12r/1rQdaSS+?=
 =?us-ascii?Q?UdOetJp9s/l8a/c3kx0yY1XhbHLbUHNeO0jmKT78HF4IaS8iLC87u3R6EwJU?=
 =?us-ascii?Q?gjbOeoqQ6NunVzv3irfFowadNyKKI5XtXkMZqq+54ewlNuFZR3BVHzNDjwMJ?=
 =?us-ascii?Q?gZz444LdvHrE8qoI6ZcvU6zVyWevfpBhrjRT8CBldVFzKQpM3qyZLhenJZHP?=
 =?us-ascii?Q?vnCqjdoA1q9Iln3CWsljNFK42Mo2SC41s7YNu1rY+MF8pAA4fRBwGwI3KJuK?=
 =?us-ascii?Q?OLBHdkC3hW+Eh5Odx9IjGWgvcFlftrMMD2waeF99mZLcPTpCqYD2Xd7xs/VD?=
 =?us-ascii?Q?9/u/co+c/A9tvrPfRVqntZuzRwvud4wISd+cVv8ljT5WADC/jOe+BxkJt3tL?=
 =?us-ascii?Q?K2CyiJUJB3S4QjbD+KoCiMJaDo1lnUtVtQLrha59sbYIYRGBrQDQacE1+rS6?=
 =?us-ascii?Q?Tdq81zLIvW8MW72fBo8MeIpdniUfG1iv9VI/ihVh6oglBKuRSDUeSPSDt/cK?=
 =?us-ascii?Q?JTr8cmN6o+HQoIwxA1ZdNUuGaOS6cCl7StPWgd7XrZ/bBg8c2vUMPYodObXq?=
 =?us-ascii?Q?8UVl/l7wKONx7215VUj9c8Rfx2bJagIhQvAaBjoA5F3Bitr8tTnV6ZpXRhha?=
 =?us-ascii?Q?2cPe2mYkgwI1RfhrJ2mTHfln2r1dJDzYZApR1fsD5Xv9ueRMX3Di8WWilMKr?=
 =?us-ascii?Q?eAXK5lvnb48UszwIof4ZOOrjh3IEhKJAx/z7KzMxJ4e5zAgZM2tMtJZwBaTr?=
 =?us-ascii?Q?R11w4EOA6DLe3Fuj2FYNQ5YEnXT7i/GEB6RZQYGIDuu9NvtrKlj2H5wRS3kN?=
 =?us-ascii?Q?2T6UA3oxBMLeIvqhLMxnKXhmqGvGjWFtlmqw/1xl18YLTA=3D=3D?=
X-OriginatorOrg: zenithal.me
X-MS-Exchange-CrossTenant-Network-Message-Id: e7e7cb78-2184-4832-f52d-08d8f4faaf68
X-MS-Exchange-CrossTenant-AuthSource: HK0PR03MB3795.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 10:41:20.1693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 436d481c-43b1-4418-8d7f-84c1e4887cf0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BfMi1TSOzjl1YsW9LuVYYmQpj19ha4pJ5GQXHAqVEZ81CTOZiOemyuftxrHIrYul
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR03MB3905
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 03:26:02PM -0700, Stephen Hemminger wrote:
> It would be better if kernel provided the error messages through external ack
> of the netlink message,

Agreed.

> rather than providing potentially out of date
> recommendations on the man page.

I still think conditions for ip-token to be accepted and take
effect should be documented on the man page.

Errors in kernel extack only give hints to users in case they 
forget to configure some flags. For new users, a complete 
condition reference should be documented for them to
evaluate the use case of ip-token.
Also the autoconf flag would not prompt errors when the user
forgets to turn it on, this is unexpected when the user does
intend to use ip-token.

Even /proc/sys interface may be out of date, these conditions
may remain unchanged or only be altered slightly, hence
documenting them does not hurt.
