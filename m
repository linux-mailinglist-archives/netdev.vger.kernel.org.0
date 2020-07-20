Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B2D22552A
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 03:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgGTBGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 21:06:44 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7783 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726510AbgGTBGo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jul 2020 21:06:44 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id F288A6ECD4060FCFE69E;
        Mon, 20 Jul 2020 09:06:39 +0800 (CST)
Received: from [127.0.0.1] (10.174.179.91) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Mon, 20 Jul 2020
 09:06:37 +0800
Subject: Re: [PATCH -next] hsr: Convert to DEFINE_SHOW_ATTRIBUTE
To:     David Miller <davem@davemloft.net>
CC:     <gregkh@linuxfoundation.org>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200716084728.7944-1-miaoqinglang@huawei.com>
 <20200717.124613.2212753865989960466.davem@davemloft.net>
From:   miaoqinglang <miaoqinglang@huawei.com>
Message-ID: <07dcfba6-0fce-e262-0bc3-6b7941e64f6d@huawei.com>
Date:   Mon, 20 Jul 2020 09:06:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200717.124613.2212753865989960466.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.91]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2020/7/18 3:46, David Miller 写道:
> From: Qinglang Miao <miaoqinglang@huawei.com>
> Date: Thu, 16 Jul 2020 16:47:28 +0800
> 
>> Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
>>
>> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
> 
> This does not apply to the net-next tree.
> .
> 
Hi David,

I'm sorry but​ this patch is based on linux-next rather than net-next.

​There's a little diffrence because commit <4d4901c6d7>  in Linux-next 
has switched over direct seq_read method calls to seq_read_iter should 
applied.(linkage listed as below).

https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next/+/4d4901c6d748efab8aab6e7d2405dadaed0bea50

​I will send a new patch based on net-next tree if you don't mind.

Thanks.

Qinglang

.

