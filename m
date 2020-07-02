Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666CD21212F
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 12:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728498AbgGBK1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 06:27:22 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34790 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728485AbgGBK1V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 06:27:21 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A965DD26198CC5F5A182;
        Thu,  2 Jul 2020 18:27:19 +0800 (CST)
Received: from [10.174.178.65] (10.174.178.65) by smtp.huawei.com
 (10.3.19.207) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 2 Jul 2020
 18:27:12 +0800
Subject: Re: [PATCH net-next] mlx4: Mark PM functions as __maybe_unused
To:     Leon Romanovsky <leon@kernel.org>
CC:     Hulk Robot <hulkci@huawei.com>, Tariq Toukan <tariqt@mellanox.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
References: <20200702091946.5144-1-weiyongjun1@huawei.com>
 <20200702093601.GB4837@unreal>
From:   Wei Yongjun <weiyongjun1@huawei.com>
Message-ID: <8c2f2afc-7aab-f8d5-e53b-6d1f1a446773@huawei.com>
Date:   Thu, 2 Jul 2020 18:27:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200702093601.GB4837@unreal>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.65]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/7/2 17:36, Leon Romanovsky wrote:
> On Thu, Jul 02, 2020 at 05:19:46PM +0800, Wei Yongjun wrote:
>> In certain configurations without power management support, the
>> following warnings happen:
>>
>> drivers/net/ethernet/mellanox/mlx4/main.c:4388:12:
>>  warning: 'mlx4_resume' defined but not used [-Wunused-function]
>>  4388 | static int mlx4_resume(struct device *dev_d)
>>       |            ^~~~~~~~~~~
>> drivers/net/ethernet/mellanox/mlx4/main.c:4373:12: warning:
>>  'mlx4_suspend' defined but not used [-Wunused-function]
>>  4373 | static int mlx4_suspend(struct device *dev_d)
>>       |            ^~~~~~~~~~~~
>>
>> Mark these functions as __maybe_unused to make it clear to the
>> compiler that this is going to happen based on the configuration,
>> which is the standard for these types of functions.
>>
>> Fixes: 0e3e206a3e12 ("mlx4: use generic power management")
> 
> I can't find this SHA-1, where did you get it?

It is in the net-next tree.

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=0e3e206a3e12

> And why doesn't mlx5 need this change?
> 
> Fixes: 86a3e5d02c20 ("net/mlx4_core: Add PCI calls for suspend/resume")
> 
> Thanks
> 
