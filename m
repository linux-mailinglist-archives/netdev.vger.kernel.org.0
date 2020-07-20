Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6B22255A9
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 03:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgGTB5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 21:57:13 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8327 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726225AbgGTB5M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jul 2020 21:57:12 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 9B4F05A83FAD185F2C1B;
        Mon, 20 Jul 2020 09:57:10 +0800 (CST)
Received: from [127.0.0.1] (10.174.179.238) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Mon, 20 Jul 2020
 09:57:02 +0800
Subject: Re: [PATCH] net: neterion: vxge: reduce stack usage in
 VXGE_COMPLETE_VPATH_TX
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <jdmason@kudzu.us>,
        <christophe.jaillet@wanadoo.fr>, <john.wanghui@huawei.com>
References: <20200716173247.78912-1-cuibixuan@huawei.com>
 <20200719100522.220a6f5a@hermes.lan>
From:   Bixuan Cui <cuibixuan@huawei.com>
Message-ID: <71b4229e-f442-9e8c-d8ab-c5610db881b9@huawei.com>
Date:   Mon, 20 Jul 2020 09:57:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200719100522.220a6f5a@hermes.lan>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.238]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/7/20 1:05, Stephen Hemminger wrote:
> On Thu, 16 Jul 2020 17:32:47 +0000
> Bixuan Cui <cuibixuan@huawei.com> wrote:
> 
>> Fix the warning: [-Werror=-Wframe-larger-than=]
>>
>> drivers/net/ethernet/neterion/vxge/vxge-main.c:
>> In function'VXGE_COMPLETE_VPATH_TX.isra.37':
>> drivers/net/ethernet/neterion/vxge/vxge-main.c:119:1:
>> warning: the frame size of 1056 bytes is larger than 1024 bytes
>>
>> Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
> Dropping the NR_SKB_COMPLETED to 16 won't have much impact
> on performance, and shrink the size.
> 
> Doing 16 skb's at a time instead of 128 probably costs
> less than one allocation. Especially since it is unlikely
> that the device completed that many transmits at once.
> 
> 
I will send the v2 patch based on your suggestions.
thanks

