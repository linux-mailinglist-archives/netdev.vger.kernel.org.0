Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C10FA3A6765
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 15:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbhFNNG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 09:06:28 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:6469 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233226AbhFNNG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 09:06:26 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G3WmS1kJXzZh5N;
        Mon, 14 Jun 2021 21:01:28 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 14 Jun 2021 21:04:19 +0800
Received: from [10.67.102.67] (10.67.102.67) by dggemi759-chm.china.huawei.com
 (10.1.198.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Mon, 14
 Jun 2021 21:04:18 +0800
Subject: Re: [PATCH V2 net-next 00/11] net: z85230: clean up some code style
 issues
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>
References: <1623670131-49973-1-git-send-email-huangguangbin2@huawei.com>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <17dc444e-2a28-eaf0-7426-30bf9e6f2825@huawei.com>
Date:   Mon, 14 Jun 2021 21:04:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1623670131-49973-1-git-send-email-huangguangbin2@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/6/14 19:28, Guangbin Huang wrote:
> From: Peng Li <lipeng321@huawei.com>
> 
> This patchset clean up some code style issues.
> 
> 
> ---
> Change Log:
> V1 -> V2:
> 1, fix the comments from Andrew, add commit message to [patch 04/11]
>     about remove volatile.
> ---
> 
> Peng Li (11):
>    net: z85230: remove redundant blank lines
>    net: z85230: add blank line after declarations
>    net: z85230: fix the code style issue about EXPORT_SYMBOL(foo)
>    net: z85230: remove redundant initialization for statics
>    net: z85230: replace comparison to NULL with "!skb"
>    net: z85230: fix the comments style issue
>    net: z85230: fix the code style issue about "if..else.."
>    net: z85230: remove trailing whitespaces
>    net: z85230: add some required spaces
>    net: z85230: fix the code style issue about open brace {
>    net: z85230: remove unnecessary out of memory message
> 
>   drivers/net/wan/z85230.c | 995 ++++++++++++++++++++---------------------------
>   1 file changed, 423 insertions(+), 572 deletions(-)
> 

Please ignore this series, there is new comment has not been dealt with.
