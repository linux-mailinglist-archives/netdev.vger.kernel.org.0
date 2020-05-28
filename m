Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A637F1E615E
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 14:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389910AbgE1Mtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 08:49:45 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5371 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389878AbgE1Mtk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 08:49:40 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A12B5E49FDD03BFFA4BD;
        Thu, 28 May 2020 20:49:28 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Thu, 28 May 2020
 20:49:22 +0800
Subject: Re: [PATCH net-next 00/11] net: hns3: misc updates for -next
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>
References: <1590669912-21867-1-git-send-email-tanhuazhong@huawei.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <927a292f-baef-2627-0dd9-5d0f7ad47417@huawei.com>
Date:   Thu, 28 May 2020 20:49:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <1590669912-21867-1-git-send-email-tanhuazhong@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, please ignore this patchset, will resend it later.

On 2020/5/28 20:45, Huazhong Tan wrote:
> This patchset includes some updates for the HNS3 ethernet driver.
> 
> #1 adds a missing mutex destroy.
> #2&3 refactor two function, make them more readable and maintainable.
> #4&5 fix unsuitable type of gro enable field both for PF & VF.
> #6-#10 removes some unused fields, macro and redundant definitions.
> #11 adds more debug info for parsing speed fails.
> 
> Huazhong Tan (11):
>    net: hns3: add a missing mutex destroy in hclge_init_ad_dev()
>    net: hns3: refactor hclge_config_tso()
>    net: hns3: refactor hclge_query_bd_num_cmd_send()
>    net: hns3: modify an incorrect type in struct hclge_cfg_gro_status_cmd
>    net: hns3: modify an incorrect type in struct
>      hclgevf_cfg_gro_status_cmd
>    net: hns3: remove some unused fields in struct hns3_nic_priv
>    net: hns3; remove unused HNAE3_RESTORE_CLIENT in enum
>      hnae3_reset_notify_type
>    net: hns3: remove unused struct hnae3_unic_private_info
>    net: hns3: remove two duplicated register macros in hclgevf_main.h
>    net: hns3: remove some unused fields in struct hclge_dev
>    net: hns3: print out speed info when parsing speed fails
> 
>   drivers/net/ethernet/hisilicon/hns3/hnae3.h        | 12 ------
>   drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    | 22 -----------
>   .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  4 +-
>   .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 44 ++++++++++------------
>   .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  6 ---
>   .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |  4 +-
>   .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  8 ++--
>   .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  4 +-
>   8 files changed, 29 insertions(+), 75 deletions(-)
> 

