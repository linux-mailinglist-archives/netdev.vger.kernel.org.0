Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96A4E75D94
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 06:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbfGZEAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 00:00:51 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:45462 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725781AbfGZEAu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 00:00:50 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id EA591B93D0F1E7FBFBFD;
        Fri, 26 Jul 2019 12:00:45 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Fri, 26 Jul 2019
 12:00:39 +0800
Subject: Re: [PATCH V2 net-next 00/11] net: hns3: some code optimizations &
 bugfixes & features
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>
References: <1564111502-15504-1-git-send-email-tanhuazhong@huawei.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <cd8eb84d-54ab-0632-7558-426fac314aa9@huawei.com>
Date:   Fri, 26 Jul 2019 12:00:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <1564111502-15504-1-git-send-email-tanhuazhong@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, please ignore this patchset. Will resend it later:)

On 2019/7/26 11:24, Huazhong Tan wrote:
> This patch-set includes code optimizations, bugfixes and features for
> the HNS3 ethernet controller driver.
> 
> [patch 1/11] checks reset status before setting channel.
> 
> [patch 2/11] adds a NULL pointer checking.
> 
> [patch 3/11] removes reset level upgrading when current reset fails.
> 
> [patch 4/11] fixes a bug related to IRQ vector number initialization.
> 
> [patch 5/11] fixes a GFP flags errors when holding spin_lock.
> 
> [patch 6/11] modifies firmware version format.
> 
> [patch 7/11] adds some print information which is off by default.
> 
> [patch 8/11 - 9/11] adds two code optimizations about interrupt handler
> and work task.
> 
> [patch 10/11] adds support for using order 1 pages with a 4K buffer.
> 
> [patch 11/11] modifies messages prints with dev_info() instead of
> pr_info().
> 
> Change log:
> V1->V2: fixes comments from Saeed Mahameed and
> 	removes previous [patch 11/11] which needs further discussion,
> 	adds a new patch [11/11] suggested by Saeed Mahameed.
> 
> Guangbin Huang (1):
>    net: hns3: add a check for get_reset_level
> 
> Huazhong Tan (2):
>    net: hns3: remove upgrade reset level when reset fail
>    net: hns3: use dev_info() instead of pr_info()
> 
> Jian Shen (1):
>    net: hns3: add reset checking before set channels
> 
> Yonglong Liu (2):
>    net: hns3: fix mis-counting IRQ vector numbers issue
>    net: hns3: adds debug messages to identify eth down cause
> 
> Yufeng Mo (2):
>    net: hns3: change GFP flag during lock period
>    net: hns3: modify firmware version display format
> 
> Yunsheng Lin (3):
>    net: hns3: make hclge_service use delayed workqueue
>    net: hns3: add interrupt affinity support for misc interrupt
>    net: hns3: Add support for using order 1 pages with a 4K buffer
> 
>   drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   9 ++
>   drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  39 +++++-
>   drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  15 ++-
>   drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  41 +++++-
>   .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |  10 +-
>   .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c |  14 +++
>   .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 137 ++++++++++++---------
>   .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   7 +-
>   .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |  10 +-
>   .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  15 ++-
>   10 files changed, 223 insertions(+), 74 deletions(-)
> 

