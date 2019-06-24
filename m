Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B516B4FF00
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 04:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfFXCEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 22:04:32 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:53926 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726328AbfFXCEc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Jun 2019 22:04:32 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4A23818BA10488EFC323;
        Mon, 24 Jun 2019 09:19:23 +0800 (CST)
Received: from [127.0.0.1] (10.184.225.177) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Mon, 24 Jun 2019
 09:19:17 +0800
Subject: Re: [PATCH v2 0/3] fix bugs when enable route_localnet
To:     David Miller <davem@davemloft.net>
CC:     <luoshijie1@huawei.com>, <tgraf@suug.ch>, <dsahern@gmail.com>,
        <netdev@vger.kernel.org>, <wangxiaogang3@huawei.com>,
        <mingfangsen@huawei.com>, <zhoukang7@huawei.com>
References: <1560870845-172395-1-git-send-email-luoshijie1@huawei.com>
 <e52787a0-86fe-bf5f-28f4-3a29dd8ced7b@huawei.com>
 <20190622.084611.1808368522428755652.davem@davemloft.net>
From:   Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <ffdd9ecd-1d14-5098-4a21-c6d8136fefc4@huawei.com>
Date:   Mon, 24 Jun 2019 09:19:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190622.084611.1808368522428755652.davem@davemloft.net>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.225.177]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Date: Sat, 22 Jun 2019 16:41:49 +0800
> 
>> Friendly ping ...
> 
> I'm not applying this patch series without someone reviewing it.
> 
Of course, all patches should be reviewd before deciding whether to apply.
In v2, we add a couple of test for enabling route_localnet in selftests suggested
by David Ahern.
In additon, another similar bugfix is added for arp_ignore = 3.

We would appreciate David Ahern or someone could help review the patch series.

