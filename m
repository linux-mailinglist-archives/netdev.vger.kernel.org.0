Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA8C6A2C71
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 03:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727715AbfH3BkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 21:40:20 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5695 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726825AbfH3BkU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 21:40:20 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id CE00A2F40678C9E7A30A;
        Fri, 30 Aug 2019 09:40:16 +0800 (CST)
Received: from [127.0.0.1] (10.133.213.239) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Fri, 30 Aug 2019
 09:40:12 +0800
Subject: Re: [PATCH] amd-xgbe: Fix error path in xgbe_mod_init()
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
References: <20190829024600.16052-1-yuehaibing@huawei.com>
 <20190829105237.196722f9@cakuba.netronome.com>
CC:     <thomas.lendacky@amd.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <8b480542-4ec4-03b2-4426-348ac65aa4d6@huawei.com>
Date:   Fri, 30 Aug 2019 09:40:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20190829105237.196722f9@cakuba.netronome.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/8/30 1:52, Jakub Kicinski wrote:
> On Thu, 29 Aug 2019 10:46:00 +0800, YueHaibing wrote:
>> In xgbe_mod_init(), we should do cleanup if some error occurs
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Fixes: efbaa828330a ("amd-xgbe: Add support to handle device renaming")
>> Fixes: 47f164deab22 ("amd-xgbe: Add PCI device support")
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> 
> Looks correct.

Thanks!
> 
> For networking fixes please try to use [PATCH net] as a tag ([PATCH
> net-next] for normal, non-fix patches).

Ok.
> 
> 

