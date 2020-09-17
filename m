Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE5926DBED
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 14:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgIQMqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 08:46:25 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13239 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726767AbgIQMqF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 08:46:05 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E810C102921E0CC10FD3;
        Thu, 17 Sep 2020 20:46:03 +0800 (CST)
Received: from [10.174.179.91] (10.174.179.91) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Thu, 17 Sep 2020 20:46:02 +0800
Subject: Re: [PATCH -next] dpaa2-eth: Convert to DEFINE_SHOW_ATTRIBUTE
To:     David Miller <davem@davemloft.net>
CC:     <gregkh@linuxfoundation.org>, <ioana.ciornei@nxp.com>,
        <ruxandra.radulescu@nxp.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200716085859.11635-1-miaoqinglang@huawei.com>
 <20200717.124751.1661646022999131740.davem@davemloft.net>
From:   miaoqinglang <miaoqinglang@huawei.com>
Message-ID: <47bdf8c1-0b5a-f772-4e13-1b4e16ae36b1@huawei.com>
Date:   Thu, 17 Sep 2020 20:46:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200717.124751.1661646022999131740.davem@davemloft.net>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.91]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



ÔÚ 2020/7/18 3:47, David Miller Ð´µÀ:
> From: Qinglang Miao <miaoqinglang@huawei.com>
> Date: Thu, 16 Jul 2020 16:58:59 +0800
> 
>> From: Yongqiang Liu <liuyongqiang13@huawei.com>
>>
>> Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
>>
>> Signed-off-by: Yongqiang Liu <liuyongqiang13@huawei.com>
> 
> This also does not apply cleanly to the net-next tree.
> .
Hi David,

I've sent new patches against linux-next(20200917), and they can
be applied to mainline cleanly now.

Thanks.
> 
