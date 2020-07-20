Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D301D225598
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 03:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgGTBsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 21:48:25 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:44898 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726225AbgGTBsZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jul 2020 21:48:25 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 93000E02998C18DC669A;
        Mon, 20 Jul 2020 09:48:22 +0800 (CST)
Received: from [127.0.0.1] (10.174.179.81) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Mon, 20 Jul 2020
 09:48:18 +0800
Subject: Re: [PATCH -next] net: ena: use NULL instead of zero
To:     Joe Perches <joe@perches.com>, <netanel@amazon.com>,
        <akiyano@amazon.com>, <gtzalik@amazon.com>, <saeedb@amazon.com>,
        <zorik@amazon.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <sameehj@amazon.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200718115633.37464-1-wanghai38@huawei.com>
 <3093bc36c2ad86170e2e90a3451e5962d0815122.camel@perches.com>
From:   "wanghai (M)" <wanghai38@huawei.com>
Message-ID: <fd191d1c-a9ae-eac8-9446-1d90695178f0@huawei.com>
Date:   Mon, 20 Jul 2020 09:48:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <3093bc36c2ad86170e2e90a3451e5962d0815122.camel@perches.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.81]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2020/7/18 23:06, Joe Perches Ð´µÀ:
> On Sat, 2020-07-18 at 19:56 +0800, Wang Hai wrote:
>> Fix sparse build warning:
>>
>> drivers/net/ethernet/amazon/ena/ena_netdev.c:2193:34: warning:
>>   Using plain integer as NULL pointer
> Better to remove the initialization altogether and
> move the declaration into the loop.
Thanks for your advice. I'll send a v2 patch.

