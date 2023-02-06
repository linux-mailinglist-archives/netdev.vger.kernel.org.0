Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E908E68BFBD
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 15:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbjBFOO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 09:14:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbjBFOOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 09:14:10 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A780283E4
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 06:13:44 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4P9SMY50MjzRrrc;
        Mon,  6 Feb 2023 21:50:49 +0800 (CST)
Received: from [10.67.102.37] (10.67.102.37) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 6 Feb
 2023 21:53:10 +0800
Subject: Re: [PATCH net-next 0/2] net: hns3: support wake on lan for hns3
To:     <davem@davemloft.net>, <kuba@kernel.org>
References: <20230206134933.32700-1-lanhao@huawei.com>
CC:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <shenjian15@huawei.com>,
        <netdev@vger.kernel.org>
From:   Hao Lan <lanhao@huawei.com>
Message-ID: <51370b7d-935a-e6bb-dec7-97005b8b073f@huawei.com>
Date:   Mon, 6 Feb 2023 21:53:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20230206134933.32700-1-lanhao@huawei.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.37]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am sorry, this email is wrong. Please ignore it.

On 2023/2/6 21:49, Hao Lan wrote:
> HNS3 (HiSilicon Network System 3) supports Wake-on-LAN,
> magic mode and magic security mode on each pf.
> This patch supports the ethtool LAN wake-up configuration and
> query interfaces and debugfs query interfaces. It does not
> support the suspend resume interface because there is no
> corresponding application scenario.
> 
> Hao Lan (2):
>   net: hns3: support wake on lan configuration and query
>   net: hns3: support debugfs for wake on lan
> 
>  drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  13 ++
>  .../hns3/hns3_common/hclge_comm_cmd.c         |   1 +
>  .../hns3/hns3_common/hclge_comm_cmd.h         |   3 +
>  .../ethernet/hisilicon/hns3/hns3_debugfs.c    |  10 +
>  .../ethernet/hisilicon/hns3/hns3_ethtool.c    |  27 +++
>  .../hisilicon/hns3/hns3pf/hclge_cmd.h         |  24 ++
>  .../hisilicon/hns3/hns3pf/hclge_debugfs.c     |  62 ++++++
>  .../hisilicon/hns3/hns3pf/hclge_main.c        | 206 ++++++++++++++++++
>  .../hisilicon/hns3/hns3pf/hclge_main.h        |  10 +
>  9 files changed, 356 insertions(+)
> 
