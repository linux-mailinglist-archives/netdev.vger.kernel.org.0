Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCBA3A897B
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731241AbfIDPVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 11:21:10 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:6211 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730299AbfIDPVJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 11:21:09 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 04C9C3C913037ED1DE6B;
        Wed,  4 Sep 2019 23:21:07 +0800 (CST)
Received: from [127.0.0.1] (10.177.29.68) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Wed, 4 Sep 2019
 23:21:02 +0800
Message-ID: <5D6FD65D.1060507@huawei.com>
Date:   Wed, 4 Sep 2019 23:21:01 +0800
From:   zhong jiang <zhongjiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To:     Markus Elfring <Markus.Elfring@web.de>
CC:     Arvid Brodin <arvid.brodin@alten.se>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: net: hsr: remove a redundant null check before kfree_skb
References: <1567566558-7764-1-git-send-email-zhongjiang@huawei.com> <ce4f53c1-fd91-af5b-7f0a-4746c3ad8de1@web.de>
In-Reply-To: <ce4f53c1-fd91-af5b-7f0a-4746c3ad8de1@web.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.29.68]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/9/4 19:55, Markus Elfring wrote:
>> kfree_skb has taken the null pointer into account.
> I suggest to take another look also at information around
> a similar update suggestion.
>
> net-hsr: Delete unnecessary checks before the function call "kfree_skb"
> https://lkml.org/lkml/2015/11/14/120
> https://lore.kernel.org/patchwork/patch/617878/
> https://lore.kernel.org/r/5647A77E.6040501@users.sourceforge.net/
>
> https://lkml.org/lkml/2015/11/24/433
> https://lore.kernel.org/r/56546951.9080101@alten.se/
Thanks you for explaination. I miss the similar patch before sending it.

Sincerely,
zhong jiang
> Regards,
> Markus
>
> .
>


