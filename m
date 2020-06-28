Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54BD20C513
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 02:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgF1A6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 20:58:37 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:53158 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726101AbgF1A6h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 20:58:37 -0400
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 67B594389C3CEA2ED45B;
        Sun, 28 Jun 2020 08:58:33 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Sun, 28 Jun 2020 08:58:27 +0800
Received: from [10.174.61.242] (10.174.61.242) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Sun, 28 Jun 2020 08:58:26 +0800
Subject: Re: [PATCH net-next v3 0/5] hinic: add some ethtool ops support
To:     David Miller <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
References: <20200627065242.26761-1-luobin9@huawei.com>
 <20200627.175224.2220574097858458030.davem@davemloft.net>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <073f94da-c36c-e737-3b41-7671a942eb7b@huawei.com>
Date:   Sun, 28 Jun 2020 08:58:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200627.175224.2220574097858458030.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.61.242]
X-ClientProxiedBy: dggeme716-chm.china.huawei.com (10.1.199.112) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/6/28 8:52, David Miller wrote:
> From: Luo bin <luobin9@huawei.com>
> Date: Sat, 27 Jun 2020 14:52:37 +0800
> 
>> patch #1: support to set and get pause params with
>>           "ethtool -A/a" cmd
>> patch #2: support to set and get irq coalesce params with
>>           "ethtool -C/c" cmd
>> patch #3: support to do self test with "ethtool -t" cmd
>> patch #4: support to identify physical device with "ethtool -p" cmd
>> patch #5: support to get eeprom information with "ethtool -m" cmd
> 
> In general,  I want you to decrease the amount of log messages.
> 
> You should only use them when the device or the kernel does something
> unexpected which should be notifier to the user.
> 
> Kernel log messages are not for informating the user of limitations
> of what they can perform with "ethtool".
> 
> For example, when setting pause paramenters, you complain in the logs
> if the autonet setting is different.
> 
> This is completely inappropriate.
> 
> Then in patch #2 you have these crazy macros that print out state
> changes with netdev_info().  That is also inappropriate.  The user
> gets a success status, and they can query the settings later if
> they like as well.
> 
> Please stop abusing kernel log messaging, it isn't a framework for
> giving more detailed ethtool command result statuses.
> 
> Thank you.
> .
> 
Okay, I'll remove these normal kernel logs. Thank you for your review.
