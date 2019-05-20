Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3572222A08
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 04:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730121AbfETCpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 22:45:13 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7660 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730076AbfETCpN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 May 2019 22:45:13 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 385CCC396D7FB5628B17;
        Mon, 20 May 2019 10:45:11 +0800 (CST)
Received: from [127.0.0.1] (10.184.191.73) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Mon, 20 May 2019
 10:45:04 +0800
Subject: Re: [PATCH v3] tipc: fix modprobe tipc failed after switch order of
 device registration
To:     Stephen Rothwell <sfr@canb.auug.org.au>
CC:     <davem@davemloft.net>, <willemdebruijn.kernel@gmail.com>,
        <jon.maloy@ericsson.com>, <ying.xue@windriver.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        <tipc-discussion@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <mingfangsen@huawei.com>
References: <529aff15-5f3a-1bf1-76fa-691911ff6170@huawei.com>
 <20190519214805.520960ec@canb.auug.org.au>
From:   hujunwei <hujunwei4@huawei.com>
Message-ID: <3eaefb19-eb72-06a7-04c2-3378d9c2c1a6@huawei.com>
Date:   Mon, 20 May 2019 10:43:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190519214805.520960ec@canb.auug.org.au>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.191.73]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/5/19 19:48, Stephen Rothwell wrote:
> Hi,
> 
> On Sun, 19 May 2019 17:13:45 +0800 hujunwei <hujunwei4@huawei.com> wrote:
>>
>> Fixes: 7e27e8d6130c
>> ("tipc: switch order of device registration to fix a crash")
> 
> Please don't split Fixes tags over more than one line.  It is OK if
> they are too long.
> 

Hi, Stephen
Thanks for your suggestion, I will update it later.

Regards,
Junwei

