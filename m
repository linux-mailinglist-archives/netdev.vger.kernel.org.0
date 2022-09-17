Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81EA85BB576
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 04:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiIQCEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 22:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiIQCEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 22:04:01 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0200BB72A6;
        Fri, 16 Sep 2022 19:03:59 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MTvM42h52zBsMS;
        Sat, 17 Sep 2022 10:01:52 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 17 Sep 2022 10:03:57 +0800
Received: from [10.67.102.67] (10.67.102.67) by kwepemm600016.china.huawei.com
 (7.193.23.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 17 Sep
 2022 10:03:56 +0800
Subject: Re: [PATCH] net: ethernet: ti: am65-cpsw: remove unused parameter of
 am65_cpsw_nuss_common_open()
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <lanhao@huawei.com>,
        <shenjian15@huawei.com>
References: <20220916023541.23415-1-huangguangbin2@huawei.com>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <5fa1abb7-a6df-b78c-0faf-af06d56e9e75@huawei.com>
Date:   Sat, 17 Sep 2022 10:03:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20220916023541.23415-1-huangguangbin2@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, please ignore this patch because target tree name is
not specified in the subject and not cc s-vadapalli@ti.com.

I will send this patch again.


On 2022/9/16 10:35, Guangbin Huang wrote:
> From: Jian Shen <shenjian15@huawei.com>
> 
> The inptu parameter 'features' is unused now. so remove it.
> 
> Signed-off-by: Jian Shen <shenjian15@huawei.com>
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> ---
>   drivers/net/ethernet/ti/am65-cpsw-nuss.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> index 7ef5d8208a4e..4f8f3dda7764 100644
> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> @@ -363,8 +363,7 @@ static void am65_cpsw_init_host_port_emac(struct am65_cpsw_common *common);
>   static void am65_cpsw_init_port_switch_ale(struct am65_cpsw_port *port);
>   static void am65_cpsw_init_port_emac_ale(struct am65_cpsw_port *port);
>   
> -static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common,
> -				      netdev_features_t features)
> +static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common)
>   {
>   	struct am65_cpsw_host *host_p = am65_common_get_host(common);
>   	int port_idx, i, ret;
> @@ -577,7 +576,7 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
>   	for (i = 0; i < common->tx_ch_num; i++)
>   		netdev_tx_reset_queue(netdev_get_tx_queue(ndev, i));
>   
> -	ret = am65_cpsw_nuss_common_open(common, ndev->features);
> +	ret = am65_cpsw_nuss_common_open(common);
>   	if (ret)
>   		return ret;
>   
> 
