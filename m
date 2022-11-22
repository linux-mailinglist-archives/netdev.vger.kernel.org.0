Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 449006332C5
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 03:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbiKVCK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 21:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiKVCKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 21:10:55 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D8EDE223D;
        Mon, 21 Nov 2022 18:10:53 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NGSQJ1tBwzHwD6;
        Tue, 22 Nov 2022 10:10:16 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 10:10:51 +0800
Subject: Re: [PATCH] can: can327: fix potential skb leak when netdev is down
To:     Max Staudt <max@enpas.org>
CC:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
References: <20221110061437.411525-1-william.xuanziyang@huawei.com>
 <20221111010412.6ca0ff1c.max@enpas.org>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <cd51300f-34cc-3222-7bd9-ec349b9cd603@huawei.com>
Date:   Tue, 22 Nov 2022 10:10:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20221111010412.6ca0ff1c.max@enpas.org>
Content-Type: text/plain; charset="gbk"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Gently ask.

Is there any other problem? And can it be applied?

Thanks.

> (CC Vincent, he may be interested)
> 
> 
> On Thu, 10 Nov 2022 14:14:37 +0800
> Ziyang Xuan <william.xuanziyang@huawei.com> wrote:
> 
>> Fix it by adding kfree_skb() in can327_feed_frame_to_netdev() when netdev
>> is down. Not tested, just compiled.
> 
> Looks correct to me, so:
> 
> Reviewed-by: Max Staudt <max@enpas.org>
> 
> 
> Thank you very much for finding and fixing this!
> 
> Max
> 
> .
> 
