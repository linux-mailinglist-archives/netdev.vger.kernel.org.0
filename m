Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB04193130
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 20:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbgCYTdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 15:33:42 -0400
Received: from mail-eopbgr130057.outbound.protection.outlook.com ([40.107.13.57]:15691
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727281AbgCYTdl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 15:33:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mxe1ENjE3g9rB/ViA+O+ORh9NzD1oX1fYQZbvN6neFTxp/OkGi3xxbv+eMNxJdFaMhhvLrQONWf1j6nWPAJ7zG4RLsnfyZCCJ0BLYOJO2aqcwjcFdJBx153TKR2HUyJyiuLQwjqsN/xxzu9R4rk3q+qzjcS8T9Wo+km8JjsxgbUCGN3BXBpKXFQC5L8w+4BN7oPYITtvJkCMeU2GyCsWl8zrUjzilK7H6vbjeSPF02zn7ez9fKIm2w/w/x3OTJu6tOEv+CSqiYBL8ESI6UtHSV8p10YAan0ebq7JoXkIZrQHbimQIZCnlxz8Zyhs5Rv5Hvu42luswT/zGnfuFmvgPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lDBogbVoKMie9tnySLKVK5jJArdvLeL8wyFfsy0pT+w=;
 b=OnBpDPiPZzA+X9NP8DTMMk3F8tmBEMWdk4bv8odtbFUmBYtIdApppo1WWOavWtaN4qJwCH37nkDoFj85LlfYqiuXi9dMWA0BiAnEy8hICWKfNYav02XZmGx8p/ubzAY3YsH+GLWWFt7QAYNcGPGpRrvn0c3XpQkb9ylHmjsk2GeJgHzq05+vXRUs0Pe9GELO5oICzx2I0KOzUNijfv2iXY82adZ3F3klCcJAQ4en/Br1KinzOTFLC2z25jmV9YjFUsQbnhblSvi9Pw5T3ZqF7WhEBoU9J1YV7Mvz3AIWBviuV7TrPU/po2CNOACrJbEYyPzuNuHyR7ScsoDOwr8eXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lDBogbVoKMie9tnySLKVK5jJArdvLeL8wyFfsy0pT+w=;
 b=KLpOdTTjChGn+KkxEN/alVz/2NYBViIesCfJ6NiepzXD/3cv7LP4XomkTA442qi8mMvPM7SfVoy+Dcx0faHl3/Z1xLXbahF1tKJRIvFIBCkJxJPtjejv+x6tzz5CmFOzUNNHQiH8N7fQViT10zHMoNRA/XEwWYJMSealhIUJ8RY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=moshe@mellanox.com; 
Received: from AM0PR05MB4290.eurprd05.prod.outlook.com (52.134.124.144) by
 AM0PR05MB4148.eurprd05.prod.outlook.com (52.134.95.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.19; Wed, 25 Mar 2020 19:33:38 +0000
Received: from AM0PR05MB4290.eurprd05.prod.outlook.com
 ([fe80::b5c9:35a1:4e5d:af3b]) by AM0PR05MB4290.eurprd05.prod.outlook.com
 ([fe80::b5c9:35a1:4e5d:af3b%3]) with mapi id 15.20.2835.023; Wed, 25 Mar 2020
 19:33:38 +0000
Subject: Re: No networking due to "net/mlx5e: Add support for devlink-port in
 non-representors mode"
To:     Qian Cai <cai@lca.pw>, Vladyslav Tarasiuk <vladyslavt@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <0DF043A6-F507-4CB4-9764-9BD472ABCF01@lca.pw>
From:   Moshe Shemesh <moshe@mellanox.com>
Message-ID: <52874e86-a8ae-dcf0-a798-a10e8c97d09e@mellanox.com>
Date:   Wed, 25 Mar 2020 21:33:34 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
In-Reply-To: <0DF043A6-F507-4CB4-9764-9BD472ABCF01@lca.pw>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: ZR0P278CA0053.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::22) To AM0PR05MB4290.eurprd05.prod.outlook.com
 (2603:10a6:208:63::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.0.0.5] (5.22.133.156) by ZR0P278CA0053.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19 via Frontend Transport; Wed, 25 Mar 2020 19:33:37 +0000
X-Originating-IP: [5.22.133.156]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b5e3d20e-db1f-435c-6fe6-08d7d0f36a8f
X-MS-TrafficTypeDiagnostic: AM0PR05MB4148:|AM0PR05MB4148:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB41488E567A0AC4444B51D595D9CE0@AM0PR05MB4148.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:605;
X-Forefront-PRVS: 0353563E2B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(396003)(39860400002)(346002)(136003)(316002)(2906002)(478600001)(6666004)(36756003)(5660300002)(16576012)(81166006)(81156014)(8936002)(8676002)(86362001)(31696002)(31686004)(2616005)(26005)(66476007)(4326008)(110136005)(6636002)(16526019)(186003)(54906003)(6486002)(66946007)(52116002)(66556008)(53546011)(956004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4148;H:AM0PR05MB4290.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QVsI6P4UfX83SpbkvnK9T3NLjjhez5UEzinrdCHLZ0V4i5kZMhwYQA7+sU0C09pz6QTsNKvjllAvqedDyHXBcZQHD3yyUE7eXpmJtlVHm+LTwG3fh4s1ehfZlEkgRgF3jVDh9sh0jR1bDfEwAj2Gx/JYU1xNo41W6zI+1SHUfeebLmKdz7jg2clFhIgyqNctOfhfJFF5NdbtPRKrTRrfyJluyXmwfDtjYBG+4m+9HQuPdDJuEJIq5AYJUjdUydQ23pbII/eolAzMikMOhBEOZJNqHB2VB4YeCaONGTyZdZG7lK9O3tfb37TSd2qobeIcPzplQA7Kt31elFfRZHai1/EJ+P3in0ug9i1KtCJHl46f7OsMnDpFKlud/fVcppb/ilf4C/MRZiNJIMXUPBh4FFtXn6HHkEMUfwaII6ugfrfhMuSotNDHjHt23tXHxYx9
X-MS-Exchange-AntiSpam-MessageData: G0wLJqFcDrWrdpNkYmRz93ELfLJptzkNvRaCWTuOCgtCcF58uT86H4jFl+3W/csZ0ZjaDn83AOmRzhgwldfIUmv/MT8y7N1YBAimskTT0WqIKjYLCdfpozjI/M0N40AN0OASxdoG/eNuCg5DZceTfQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5e3d20e-db1f-435c-6fe6-08d7d0f36a8f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2020 19:33:38.1109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LLVV+C3bowhLTS76JAbmUuEsHgRb89yjNIMzIrBbM55sNGVu2eIaMaMLby6yAnsKqkj0rOkl0EUB0Z4s/wadrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4148
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/25/2020 6:01 AM, Qian Cai wrote:
> Reverted the linux-next commit c6acd629ee (“net/mlx5e: Add support for devlink-port in non-representors mode”)
> and its dependencies,
>
> 162add8cbae4 (“net/mlx5e: Use devlink virtual flavour for VF devlink port”)
> 31e87b39ba9d (“net/mlx5e: Fix devlink port register sequence”)
>
> on the top of next-20200324 allowed NICs to obtain an IPv4 address from DHCP again.


These patches should not interfere DHCP.

You might have dependencies on interface name which was changed by this 
patch, please check.

> 0b:00.0 Ethernet controller: Mellanox Technologies MT27710 Family [ConnectX-4 Lx]
> 0b:00.1 Ethernet controller: Mellanox Technologies MT27710 Family [ConnectX-4 Lx]
>
> [  223.280777][   T13] mlx5_core 0000:0b:00.0: firmware version: 14.21.1000
> [  223.287753][   T13] mlx5_core 0000:0b:00.0: 63.008 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x8 link)
> [  226.292153][    C0] mlx5_core 0000:0b:00.0: Port module event: module 0, Cable plugged
> [  226.874100][ T2023] mlx5_core 0000:0b:00.1: Adding to iommu group 2
> [  227.343553][   T13] mlx5_core 0000:0b:00.1: firmware version: 14.21.1000
> [  227.350467][   T13] mlx5_core 0000:0b:00.1: 63.008 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x8 link)
> [  230.026346][    C0] mlx5_core 0000:0b:00.1: Port module event: module 1, Cable unplugged
> [  230.522660][ T2023] mlx5_core 0000:0b:00.0: MLX5E: StrdRq(0) RqSz(1024) StrdSz(256) RxCqeCmprss(0)
> [  231.448493][ T2023] mlx5_core 0000:0b:00.1: MLX5E: StrdRq(0) RqSz(1024) StrdSz(256) RxCqeCmprss(0)
> [  232.436993][ T2007] mlx5_core 0000:0b:00.1 enp11s0f1np1: renamed from eth1
> [  232.690895][ T2013] mlx5_core 0000:0b:00.0 enp11s0f0np0: renamed from eth0
