Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E1C1B7625
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 15:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgDXNDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 09:03:44 -0400
Received: from mail-vi1eur05on2045.outbound.protection.outlook.com ([40.107.21.45]:2064
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726489AbgDXNDo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 09:03:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lePltzTEcszMW2Haj28sw45bNPyo7YqW2iibZ2sCXrM9UbPVaY9l3k1XtJBBblEhg9YHnrkqAKi/rlUm5VOvo1Sa3sBjkv69RobIuESvpz+/bre1YLoKLdayR8Oe24YlpeG0QS0UekpROmoTrrWxW0I490rU2Bpk8gVnyHuG0iDXOrltOIbD8Ze9OknoZn7WGOroid4zqx++vsb+Qnq3ue89aa7t61aAbwcdO9PZ14M3RlQAdpL/EqySGFT7Qk7jkbezMmWgC/nbOrvqlUv5EFBqX4fASldLcSZFayO3oae/HDUqegmyserheWrGHiATbZXlNAfx5y0OzGS/Fc9v2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aqfa7TBSDHH86Iz3VXs2YqnHcfh4ngsLMKwKziQPv3A=;
 b=jibSvQqNzLMrPimfBmdnkYpxWdxBwUXj04GrN0UtFefzKX14uw2w27ReYD0OBtUMHuDa+mCARTRmtWXCRp9BEeN7nrME5BNR6atglne2vir7gkuvQeuQqfbIIl41ekGvPijnI0jH8kzwr/O9fojiBHx6HhLOuOkkpkyVut/Dxla/8bRcgRr2TjoZPiegtIlzWPyZMelUOQHTCTzWjhve8h0/VFhpbLU1GtbLxhy6vUNj5u3qSsfyhcj3R3pV7Mjpi94ox/FT8lOk/Bb+iEC08W7vfv5O3UVonw38V9KN0xDlS6e3eLt4yQqYQm7F1Aa4jqGiF2Z4WMNDGzrnmy6dVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aqfa7TBSDHH86Iz3VXs2YqnHcfh4ngsLMKwKziQPv3A=;
 b=iFJw2UPAE59BUPLA2ojmyjPsg5uZn4MK6zpS2Wh8ZOOFl0J4d+I+hdpjVudRyUeB6hBE49Ag78i9hTeNJPAimh+9zhNj4rUFkXiPirzFJkb5vZCsQGLeWUxbufjNt772uoGSHzBFe9rFxPlO1zBtqB3ne/cNtyyCZWfqr+GZkHI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=idosch@mellanox.com; 
Received: from AM0PR05MB6754.eurprd05.prod.outlook.com (2603:10a6:20b:15a::7)
 by AM0PR05MB6737.eurprd05.prod.outlook.com (2603:10a6:20b:159::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Fri, 24 Apr
 2020 13:03:39 +0000
Received: from AM0PR05MB6754.eurprd05.prod.outlook.com
 ([fe80::6923:aafd:c994:bfa5]) by AM0PR05MB6754.eurprd05.prod.outlook.com
 ([fe80::6923:aafd:c994:bfa5%7]) with mapi id 15.20.2937.012; Fri, 24 Apr 2020
 13:03:39 +0000
Date:   Fri, 24 Apr 2020 16:03:35 +0300
From:   Ido Schimmel <idosch@mellanox.com>
To:     Zheng Bin <zhengbin13@huawei.com>
Cc:     mlxsw@mellanox.com, davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH -next] net/mlxfw: Remove unneeded semicolon
Message-ID: <20200424130335.GA3652922@splinter>
References: <20200424090015.90790-1-zhengbin13@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424090015.90790-1-zhengbin13@huawei.com>
X-ClientProxiedBy: AM4PR0202CA0016.eurprd02.prod.outlook.com
 (2603:10a6:200:89::26) To AM0PR05MB6754.eurprd05.prod.outlook.com
 (2603:10a6:20b:15a::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (79.180.54.116) by AM4PR0202CA0016.eurprd02.prod.outlook.com (2603:10a6:200:89::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 13:03:39 +0000
X-Originating-IP: [79.180.54.116]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b9e22c2c-ca2c-40dd-6b28-08d7e84fe84c
X-MS-TrafficTypeDiagnostic: AM0PR05MB6737:|AM0PR05MB6737:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB67376003E50F68AC40EA8E5ABFD00@AM0PR05MB6737.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:820;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB6754.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(7916004)(346002)(396003)(366004)(39860400002)(136003)(376002)(186003)(316002)(8676002)(6916009)(16526019)(8936002)(4744005)(81156014)(2906002)(956004)(86362001)(33716001)(5660300002)(33656002)(478600001)(6486002)(9686003)(6666004)(66556008)(4326008)(1076003)(26005)(6496006)(66476007)(52116002)(66946007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CpkUHZ+vva9vbNkOxlHzaxhUIh+QT3+B+8DY50e+90Hs41o1eW6s7zqfN1+S3HPD4KEZM9nJjwhOXzNGvCVgVuJEU1k8X5mghDZFOBHVY7lmJMFaexIOaNpf4j3f32lpkb9HvfuqcrQAlMbnXNGhYL3GOzu7XlaPvEwlFWuYcceDcHqRuPNJy2YdXGzmUpL6Lvq0nd8LHUskPip6hnInJ3CIbeqm1Vv75xQvAxbkB8d37FKGyh9tfWqaIdTEltXYIBXM5TCcE9o6SuUknggLJxABJJQKvmx2YEjiTh9I4f7Q/yIId8i/WifR+3xrznXXBWhtgXQ26yzd2n1uCqouptdWix8CpsbJ/g87zJq10iyFOVSsOjranruHsGrY0lK2fe0omEDxsb9K+c7OmL8Dsxq/gcBB+6LcZu7ZSB9YCeUkEL9fljr5USc4qthqnyCn
X-MS-Exchange-AntiSpam-MessageData: S3AuHnAM3TttZlwRoNxELCMDPPRSSkJg16y3JaPUKMaLxqD4b8w1EZH1pP+SJovZf2VvYc9iNxJU+z5zKTofr/mMLqfcnIMdTbTfTH3bvEQq9oIMBFpNjJmujIZBjJfibUeDTcbX6syRMi+2kXOqWQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9e22c2c-ca2c-40dd-6b28-08d7e84fe84c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 13:03:39.5369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5IFiaGRe3J3JgJBYm9YnMZr5kNX+kpEzI7iSqUPbMwjtml6IYa5THdFz0IJYmEncPm2uZ5/8+Lav+vOsLQ7QLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6737
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 05:00:15PM +0800, Zheng Bin wrote:
> Fixes coccicheck warning:
> 
> drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c:79:2-3: Unneeded semicolon
> drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c:162:2-3: Unneeded semicolon
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>

Reviewed-by: Ido Schimmel <idosch@mellanox.com>

Thanks
