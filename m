Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77B45BF408
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 04:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiIUC7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 22:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiIUC7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 22:59:45 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CADF6585;
        Tue, 20 Sep 2022 19:59:38 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MXNM55S3qzlWkj;
        Wed, 21 Sep 2022 10:55:29 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 10:59:36 +0800
Received: from [10.67.102.67] (10.67.102.67) by kwepemm600016.china.huawei.com
 (7.193.23.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 21 Sep
 2022 10:59:35 +0800
Subject: Re: [PATCH net-next 0/4] net: hns3: updates for -next
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <lanhao@huawei.com>,
        <shenjian15@huawei.com>
References: <20220916023803.23756-1-huangguangbin2@huawei.com>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <c5627413-d3e6-a29f-14a7-41a18b8ed6f4@huawei.com>
Date:   Wed, 21 Sep 2022 10:59:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20220916023803.23756-1-huangguangbin2@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gentle ping. Any comment or suggestion is appreciated. Thanks!


On 2022/9/16 10:37, Guangbin Huang wrote:
> This series includes some updates for the HNS3 ethernet driver.
> 
> Guangbin Huang (2):
>    net: hns3: optimize converting dscp to priority process of
>      hns3_nic_select_queue()
>    net: hns3: add judge fd ability for sync and clear process of flow
>      director
> 
> Hao Lan (1):
>    net: hns3: refactor function hclge_mbx_handler()
> 
> Yonglong Liu (1):
>    net: hns3: add support for external loopback test
> 
>   .../net/ethernet/hisilicon/hns3/hclge_mbx.h   |  11 +
>   drivers/net/ethernet/hisilicon/hns3/hnae3.h   |   6 +
>   .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  64 ++-
>   .../net/ethernet/hisilicon/hns3/hns3_enet.h   |   3 +
>   .../ethernet/hisilicon/hns3/hns3_ethtool.c    |  61 ++-
>   .../hisilicon/hns3/hns3pf/hclge_dcb.c         |  28 +-
>   .../hisilicon/hns3/hns3pf/hclge_debugfs.c     |  17 +-
>   .../hisilicon/hns3/hns3pf/hclge_main.c        |  46 +-
>   .../hisilicon/hns3/hns3pf/hclge_main.h        |   4 -
>   .../hisilicon/hns3/hns3pf/hclge_mbx.c         | 415 ++++++++++++------
>   .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.c |  18 +-
>   11 files changed, 454 insertions(+), 219 deletions(-)
> 
