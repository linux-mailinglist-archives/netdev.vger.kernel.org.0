Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080061B8BC1
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 05:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgDZDo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 23:44:28 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3297 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726100AbgDZDo2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Apr 2020 23:44:28 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8532E37D87923294FFF5;
        Sun, 26 Apr 2020 11:44:24 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Sun, 26 Apr 2020
 11:44:18 +0800
Subject: Re: [PATCH V2 net-next 0/9] net: hns3: refactor for MAC table
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>
References: <1587867228-9955-1-git-send-email-tanhuazhong@huawei.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <f1d27955-7ffc-7569-9038-17bff854af02@huawei.com>
Date:   Sun, 26 Apr 2020 11:44:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <1587867228-9955-1-git-send-email-tanhuazhong@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, david.

This V2 only adds patch #9 in V1. Since V1 has applied, could you pick 
patch #9 from V2, or i just resend patch #9?

Thanks:)

On 2020/4/26 10:13, Huazhong Tan wrote:
> This patchset refactors the MAC table management, configure
> the MAC address asynchronously, instead of synchronously.
> Base on this change, it also refines the handle of promisc
> mode and filter table entries restoring after reset.
> 
> change logs:
> V2: add patch #9 to remove an unnecessary NULL check suggested
>      by Jakub Kicinski.
> 
> Huazhong Tan (1):
>    net: hns3: remove an unnecessary check in hclge_set_umv_space()
> 
> Jian Shen (8):
>    net: hns3: refine for unicast MAC VLAN space management
>    net: hns3: remove unnecessary parameter 'is_alloc' in
>      hclge_set_umv_space()
>    net: hns3: replace num_req_vfs with num_alloc_vport in
>      hclge_reset_umv_space()
>    net: hns3: refactor the MAC address configure
>    net: hns3: add support for dumping UC and MC MAC list
>    net: hns3: refactor the promisc mode setting
>    net: hns3: use mutex vport_lock instead of mutex umv_lock
>    net: hns3: optimize the filter table entries handling when resetting
> 
>   drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |   5 +
>   drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   8 +-
>   drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   2 +
>   drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 152 +---
>   drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  10 +-
>   drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   2 +-
>   .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |  51 ++
>   .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 868 ++++++++++++++++-----
>   .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  33 +-
>   .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  70 +-
>   .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 368 ++++++++-
>   .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  26 +
>   12 files changed, 1166 insertions(+), 429 deletions(-)
> 

