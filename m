Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0951BF66F
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 13:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgD3LTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 07:19:23 -0400
Received: from mail-am6eur05on2054.outbound.protection.outlook.com ([40.107.22.54]:19840
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725280AbgD3LTX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 07:19:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kxDXOCDT5TxWmnl9YpZSm3gCgML+92P+a8MW3E+h9/2+hCLw8me9fDnI5OS9j5RpNmEHnbBTz5Yar+oCJIYfDE8xDZAvcXFL9G3hcjAhbZMpIgxOxXSUKaaMT4e9fI3OWH6nBlAbpACHdYFWLBE1DjthXce8i1CCXx7rSVLxSoafgX/KV1+SKGmAkZJw8hJ7Hj0JpWqrvWMzU7i9V+ECfKltvFJswOA6yRwolmL+YjMo/DNmo52S5nXxkpXAjq7hKOK/dLYVEUVrc1LUGMwaoOTZLzAl6RLHIS+jtcNL42+CjOWWpNHKcD5j5mHFMcwTwQqzmzZQRX4uB4gG2MrPmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bBtnms6l+lf4YliKxWCIXJxAAZPCjtWHzXx5mNozj2g=;
 b=n0E7p+7UFsKUw03h/43NaN051SJWbEyOYbQE9nBALjATVVMCCjH99TxZFKB64YUn/eXnsYweq+Z+64PbS7kTajsdPGMs3jFBtLf0DLU4+W4ayPpj3n6VVxBcj5PDhS40zHFz7mg+S2vwFKkkNzcDLC+JFD/PNTKffT1suFFDMxxR+RMevcUooj/rI0Gl5E/L1vz0Vw1pj1X8qmgrGSLsc7Q+wUb3+67fPQg/mNUrIhXsr0o0p/hKWGXhcrW3ksn6QgJEDn+zjxsqGc3lYTvM7lAJVON0JahO7d8dlTGnW0j2NZnFOIMAQ1RarwUDJ9RmgYSuxHBBmQGe9YgEjwIf1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bBtnms6l+lf4YliKxWCIXJxAAZPCjtWHzXx5mNozj2g=;
 b=Q/jGU9s9bwWWURLiCKUE6sJB7mWaMH5IFpXBWFvsVzL3ilxkwNX4aIWOmVzjYFs3Ab3awqTl+9dMOYQn+Onojew9IO6cKbXXzkVSCk6+IQZBBigDRKAWURrEcZ2j7eV9PjhRGrbec00+adLNq6td8Dab3ae5koJuQRJAPS6qcJk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from VI1PR05MB4157.eurprd05.prod.outlook.com (2603:10a6:803:4d::20)
 by VI1PR05MB6383.eurprd05.prod.outlook.com (2603:10a6:803:f6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Thu, 30 Apr
 2020 11:19:18 +0000
Received: from VI1PR05MB4157.eurprd05.prod.outlook.com
 ([fe80::90af:a464:b72d:e314]) by VI1PR05MB4157.eurprd05.prod.outlook.com
 ([fe80::90af:a464:b72d:e314%5]) with mapi id 15.20.2937.023; Thu, 30 Apr 2020
 11:19:17 +0000
Subject: Re: [PATCH net-next 3/3] net/mlx5e: Fix the code style
To:     xiangxia.m.yue@gmail.com, paulb@mellanox.com, saeedm@mellanox.com,
        gerlitz.or@gmail.com
Cc:     netdev@vger.kernel.org
References: <1588051455-42828-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1588051455-42828-3-git-send-email-xiangxia.m.yue@gmail.com>
From:   Roi Dayan <roid@mellanox.com>
Message-ID: <e593b24a-4cf5-cc26-0f26-ba8e0ca25894@mellanox.com>
Date:   Thu, 30 Apr 2020 14:19:15 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <1588051455-42828-3-git-send-email-xiangxia.m.yue@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR07CA0023.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::36) To VI1PR05MB4157.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.170] (176.231.113.172) by AM0PR07CA0023.eurprd07.prod.outlook.com (2603:10a6:208:ac::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.11 via Frontend Transport; Thu, 30 Apr 2020 11:19:16 +0000
X-Originating-IP: [176.231.113.172]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6f083814-d58f-42d4-9105-08d7ecf85288
X-MS-TrafficTypeDiagnostic: VI1PR05MB6383:|VI1PR05MB6383:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6383C788608A3176AFB2DFD8B5AA0@VI1PR05MB6383.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:126;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kj5ly9kD2qU8hv6h3SroFC7h7Syu8x4xT1/TbCZFgHXqGsS/alSoph1vQDQhBXNOm9EQ2ROwvC+1ypcE6mAjIVWGyUkTQfYEhW6mSrgaja6gPnDu02de8WjLhiiWLHsvokmDP2nrPLuZZ87QvmQrW3lKJ0y005urMEEEA42IjT32pTDa++beJvTBGvEavEEsNTr1xrvN3FkXPU79pyno/oqptx0zMDlR3uN60zZktNKV5cG8h7Lkdh6Eyr/8Cnn8VtvNKcbS38yKhKIcaflJTkyqcJBrMz1KSxcWBtYL8dChsB5pkouZ/dXP88vkWe/rrLa7ukT2K3vBIuRi8d57mExjvc3zrA1XjPtH+l+DXftCNokdXwxsWr6j0pvpxftRAqOYVy5jukl/8iUIyEqHH2chozELfAS61c/6v4HwPHcp10y+KfLUYhzc5DUlrvnw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4157.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(66556008)(66946007)(52116002)(16576012)(316002)(4326008)(53546011)(4744005)(2906002)(8676002)(478600001)(31686004)(66476007)(8936002)(16526019)(6486002)(5660300002)(956004)(186003)(26005)(86362001)(31696002)(2616005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: jQ5vPF/z7guEiT7WxFd5t0JoYdrqjPxyuafbFF9Dkk+yhTP404TZPqfEwly+QyuOABOgq0sqUdxYXzMNeJKQy1veSrqGEC7KcxkQ5TF0+/JfNOT3MPDGQmW72tWWOClF94NTVjcIPghj1S9nJN/nkmtwWPJscMh4eSOat6hNdGhcMntKle52711Au83pZ291HHT9v4aoXK+nglxQmQ4DkVbzysjIia7nTtz0D9mXx/3HwsbSr6khgv5FFiZvQdY5s2rDGVd3CNcGQwtVLf9J/Lb7kmsd+7Ti/jvjb0z+ZhfOdqNcxM9HM7VCS/SM11HB1JltLf4D/9/UK0CP151tJ769x+kGmou7pqZwKBhl8f36T2Avuy+cMTqY+8Y81URIWsbUU34lrwXACUkI8Ja64OHZpzTiub94RirQTF0eytUYiJ3q/qFAaOzf372uJm8gCHKmWdt17ABA/Eu1/s5PnFAmtSTkF7YXmnh/VpvkipngaI3V5+U7IbyA7w56/fyYcqhEr5G9WnR9DkFjkNxRe76hk3QBpXKs7V5Vuk5Y8L0oEzS6n7vqr91IpMYotJWjPTN9Ih/A47yAWe634iQ+pp6EVpDiAGrFl9wuUzI9LMtKKU6kd+q7RSHuM4G/bszOR2jWB5XiZ2AAGr1zEPBA+KN+ErDAelqCZkZSrH1fSSS1JSFXOQyTvlKSazC77txW3JaVW96HNc2+Ozi347tCzCpjLY8VqBjr+gyFC3mOdN+1O+DEBltVXpo6P9ltJd33hjNADxG2Zrk+iTLTjnvLPfmAN5YKtAW/5Vkvr0vVHvrp5eBFsIAsRcm92iC0cy4L
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f083814-d58f-42d4-9105-08d7ecf85288
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 11:19:17.8869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZUeXfZ4lyAjzNO5G6I0YH+4U5ZmHUIAj8A5U0+BPepsCKQnbVcJKwesitYRcc9lI5zHdvI1jFQa1mq3zxIANQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6383
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020-04-28 8:24 AM, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> index 55457f268495..6b68f47e7024 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> @@ -1367,7 +1367,7 @@ static bool mlx5e_rep_has_offload_stats(const struct net_device *dev, int attr_i
>  {
>  	switch (attr_id) {
>  	case IFLA_OFFLOAD_XSTATS_CPU_HIT:
> -			return true;
> +		return true;
>  	}
>  
>  	return false;
> 


Reviewed-by: Roi Dayan <roid@mellanox.com>
