Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A316C1470
	for <lists+netdev@lfdr.de>; Sun, 29 Sep 2019 14:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbfI2MVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Sep 2019 08:21:48 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3172 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725924AbfI2MVs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Sep 2019 08:21:48 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id F1C9CB4A00544FB17528;
        Sun, 29 Sep 2019 20:21:44 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Sun, 29 Sep 2019
 20:21:37 +0800
Subject: Re: [question] About triggering a region snapshot through the devlink
 cmd
To:     Jiri Pirko <jiri@resnulli.us>
CC:     <jiri@mellanox.com>, <valex@mellanox.com>, <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>
References: <f1436c35-e8be-7b9d-c2f5-b6403348f87a@huawei.com>
 <20190927081333.GF3742@nanopsycho>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <7e013acc-8506-87a5-1c73-67703b9aa5ff@huawei.com>
Date:   Sun, 29 Sep 2019 20:21:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20190927081333.GF3742@nanopsycho>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/9/27 16:13, Jiri Pirko wrote:
> Fri, Sep 27, 2019 at 09:40:47AM CEST, linyunsheng@huawei.com wrote:
>> Hi, Jiri & Alex
>>
>>    It seems that a region' snapshot is only created through the
>> driver when some error is detected, for example:
>> mlx4_crdump_collect_fw_health() -> devlink_region_snapshot_create()
>>
>>    We want to trigger a region' snapshot creation through devlink
>> cmd, maybe by adding the "devlink region triger", because we want
>> to check some hardware register/state when the driver or the hardware
>> does not detect the error sometimes.
>>
>> Does about "devlink region triger" make sense?
>>
>> If yes, is there plan to implement it? or any suggestion to implement
>> it?
> 
> Actually, the plan is co convert mlx4 to "devlink health" api. Mlx5
> already uses that.
> 
> You should look into "devlink health".

Thanks for mentioning the "devlink health" api.

I has sent a RFC adding the support of the dump hardware mac table.
Please have a look, any comment or suggestion will be very helpful.

> 
>>
> 
> 

