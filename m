Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C83DF1E95F9
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 09:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbgEaHDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 03:03:51 -0400
Received: from mail-eopbgr140052.outbound.protection.outlook.com ([40.107.14.52]:63906
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729627AbgEaHDu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 May 2020 03:03:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hIZAVee/oM7WlTl8Tmfn6j0k6zTNngnycKKXrdAR4h/ojHqhfbv+jgdnkBLiKM9HObTyrQFKX4AfqAuDQzA1b+5ALnyJqLr49L4iibUeFeMoWL+S/Tki4wSCAi4HxAXuuMDLNS4AjXI5YhC6Gm3oSogk+JZdcoN3VJsd2j8+5xOdo5NDdKgRq/549A3s/KpCCg0upM+VODsEORSZtHV70K6az49vU1xVwCIXObis4FAoItYRIpvNQN8SMWUMX2PTSXu9yQCy6a8eGf/P8NpQwV3EBKTq6pcYNWfi3JQTl2L3PbHY/NZq/3hNPwABe2egOFUJA51G76HFsYemIIeZqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45bvsKm38u5SvudVztIjyZ6adZkBVlcg2jivzDvuiDw=;
 b=TN8VbyGM9Mg02Q3Y9kxj84t40V2jKCZGzcxaF93AHqlGinPHz+MkMEb7wzqkkvwh8Zqw9p3F+TfkqO9GPYSZp2uv9Hh8/Sd2e0Lp00hUHSuRlv0h6vOKk51NzyEaffhaY+k0ur2arpgm6/pdtJEciBQ0LZd2emh9ku93qKLR2Pcy9qvIUMctYuxlC85TQijZbTdp0c4AztkjJj7UKY7jogVC8/1wsMbiLdPnC5L/DU8lTg2ntqwMKTsAN6Nh89CbDAHZ9+IttqBe6Qf8oeVmZc5nm5vdkjkiFmc9VupoQz+A62zWu388+FzbaRirwY+nxX0PE33ZVlTOEXnrwDN/3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45bvsKm38u5SvudVztIjyZ6adZkBVlcg2jivzDvuiDw=;
 b=jaXvS9Br4nYQ0eYMoYQ/4+sNCZg8VglK+ipOza/l66vVEHMU2ZeHPjb0neP+j1GAouygWRlaRJCaiNKrz4Brr2loErIbJ9/Miq24zZtEAGWYsKbIwvcUFes9gRvHVMx/YIkCTRRiEAkPFk5QrE5/rJI0E6Y950otuKtQRbUEvcU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR0502MB3924.eurprd05.prod.outlook.com
 (2603:10a6:208:20::30) by AM0PR0502MB3748.eurprd05.prod.outlook.com
 (2603:10a6:208:19::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21; Sun, 31 May
 2020 07:03:47 +0000
Received: from AM0PR0502MB3924.eurprd05.prod.outlook.com
 ([fe80::cd67:f25f:c3aa:f459]) by AM0PR0502MB3924.eurprd05.prod.outlook.com
 ([fe80::cd67:f25f:c3aa:f459%2]) with mapi id 15.20.3045.018; Sun, 31 May 2020
 07:03:47 +0000
Subject: Re: The size of ct offoad mlx5_flow_table in mlx5e driver
To:     wenxu <wenxu@ucloud.cn>, Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1585464960-6204-1-git-send-email-wenxu@ucloud.cn>
 <fd36f18360b2800b37fe6b7466b7361afd43718b.camel@mellanox.com>
 <d3e0a559-3a7b-0fd4-5d1f-ccb0aea1dffd@ucloud.cn>
 <9f388f0a-d6fe-7abf-2413-255f9ae32d68@ucloud.cn>
From:   Oz Shlomo <ozsh@mellanox.com>
Message-ID: <9e8776e9-978f-a17f-5756-a9a08c88ea51@mellanox.com>
Date:   Sun, 31 May 2020 10:03:44 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <9f388f0a-d6fe-7abf-2413-255f9ae32d68@ucloud.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR03CA0022.eurprd03.prod.outlook.com
 (2603:10a6:208:14::35) To AM0PR0502MB3924.eurprd05.prod.outlook.com
 (2603:10a6:208:20::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.14.169] (79.180.224.244) by AM0PR03CA0022.eurprd03.prod.outlook.com (2603:10a6:208:14::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19 via Frontend Transport; Sun, 31 May 2020 07:03:46 +0000
X-Originating-IP: [79.180.224.244]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f38769d5-ac52-4e02-9c7b-08d80530c392
X-MS-TrafficTypeDiagnostic: AM0PR0502MB3748:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0502MB37489E844346FA305598BE30AB8D0@AM0PR0502MB3748.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0420213CCD
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rah4z6f5e/8SzRxvYnliysIybnUyym5A2pNKTXypzZiqKR8cmt9wjNhbdnU0aXIDc4nFerIE4HxNgG53/YETyBoN8zl0UiEe/ierZQyOdwo7nxmPekRCZMpxyzsZuOlSnwSZVU0ZBwpU9IZzb+a+2O+bOPRZaM/G2rbn9lFLXUJprXC1HsQA6kkpQfxv4GBa6EbFYdKjZ47FVZkpMJU9G6VtKiKxpbZ9jxOfPx992/5m+hH0FsOXLmW6cVrhFNp8vpLQ7rxj/O9d2qqVY36snAfUUiXMD5EBoGf0RGghXsHWTisKQLmwFdf7iXT5rW50Cd5/2nj2B16Xzo2PfxMgoD0WNLXEbNzFdBXvJU8wW5XpfL9bhAjKwhbK41WcQAY4SN7h2yUaxIb8zRa/Mfd70R3iGh57tKIpTt7zhQ/C8twdRXouiLCzdTq4xKJRIwaN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0502MB3924.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(39850400004)(396003)(376002)(346002)(5660300002)(52116002)(83380400001)(16526019)(478600001)(53546011)(26005)(186003)(8676002)(66946007)(36756003)(31696002)(86362001)(4326008)(2616005)(8936002)(6486002)(956004)(54906003)(2906002)(16576012)(110136005)(6636002)(316002)(66556008)(66476007)(31686004)(42413003)(32563001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HxON8bhIaSKiK3UoqYzukX4e51pP1z5aLvBT4RzXrTT7Xfj4vKjwgCYsaVvLGyQowNOmZvz5jBkzHNMO5UQJbYR42b6ZK7/F+rTAG68Ayu5ezf6D8fL4fxcuyxJMdRr9BDAHNIdEqoNGWr4333FMzZDIkggwOVizzkr+CAt6CwQtHO9S+9vNGvyTvxTT6y06Aq2T4RwBUG+0mhbw9u9J3WsAzFAllew2Vx7yip+Yyn+kLEmAeKShv5xvXPqTUgXPKix5AkhNqigWoCi4YnXjrdPfYPOvXCFETO0s1f5xqJVwHkw5CCRPQJ8qRS8oLJLb6dqMz+9yO5vtyNayOLp3flbw7PnN9Q5nh8DeuIrz+owGYa2aRKJn9DQ3gt3TmtXmuU1HUbS2GMJdomMVWplWHow2Y90FzuO2OcpT6maN+KV3U97gD7h4ah5k8tutXKisS+JfDD5cgDLFPa2mulcVxTcdFKNbHJTqpZwyumfOGtAOSDLEIeLyQ9FYVK/3uJdq
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f38769d5-ac52-4e02-9c7b-08d80530c392
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2020 07:03:47.2168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5h1Zn5UdJtNR+JLiEy0CbSlw51MDIOat+M9m5tuM5caLp54ebxANMFd+zkJObHAI2iG/l/X7fGrWnVoyU7PnKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3748
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wenxu,

I'll reply on behalf of Paul

On 5/28/2020 7:02 AM, wenxu wrote:
> Hi  Paul,
> 
> 
> I have a question about the size of ct and ct nat flow table.
> 
> 
> There are two global mlx5_flow_table tables ct and ct_nat for act_ct offload.
> 
> 
> The ct and ct_nat flow table create through mlx5_esw_chains_create_global_table
> 
> and get the size through mlx5_esw_chains_get_avail_sz_from_pool(esw, POOL_NEXT_SIZE);
> 
> 
> Firmware currently has 4 pool of 4 sizes that it supports (ESW_POOLS),
> 
> and a virtual memory region of 16M (ESW_SIZE).  It allocates up to 16M of each pool.
> 
> 
> ESW_POOLS[] = { 4 * 1024 * 1024,
>                               1 * 1024 * 1024,
>                               64 * 1024,
>                               128 };
> 
> So it means the biggest flow table size is 4M. The ct and ct_nat flowtable create in advance,
> 
> The size of ct and ct_nat is 4M.
> 
> It means there are almost 4M conntrack entry offload to the hardware?

Yes, the conntrack table has 4M entries.


> 
> The flow table map is fixed in the FW? And the size can be changed to 8M through the following？
> 
> ESW_POOLS[] = { 8 * 1024 * 1024,
>                               1 * 1024 * 1024,
>                               64 * 1024,
>                               128 };

The size cannot be increased due to internal FW limitations.
We are currently working on an alternative design for increased scalability.


> 
> 
> BR
> 
> wenxu
> 
> 
> 
> 
> 
> 
> 
> 
> 
