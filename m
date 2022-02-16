Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E534B8285
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 09:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiBPIDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 03:03:53 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:40288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231390AbiBPIDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 03:03:52 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BF6137741;
        Wed, 16 Feb 2022 00:03:33 -0800 (PST)
Received: from kwepemi500017.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Jz9RP6V4Szcd3N;
        Wed, 16 Feb 2022 16:02:25 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (7.193.23.3) by
 kwepemi500017.china.huawei.com (7.221.188.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Feb 2022 16:03:31 +0800
Received: from [10.174.176.245] (10.174.176.245) by
 kwepemm600001.china.huawei.com (7.193.23.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Feb 2022 16:03:31 +0800
Subject: Re: [BUG] net: ipv4: The sent udp broadcast message may be converted
 to an arp request message
To:     Ido Schimmel <idosch@idosch.org>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <edumazet@google.com>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <55a04a8f-56f3-f73c-2aea-2195923f09d1@huawei.com>
 <YgIhGhh75mR5uLaS@shredder> <f8272cf6-333a-c02a-73bf-35989f709e29@huawei.com>
 <YgynvByk/juhr+8G@shredder>
From:   "wanghai (M)" <wanghai38@huawei.com>
Message-ID: <b7af9962-dc7c-02df-e83f-6927746581ab@huawei.com>
Date:   Wed, 16 Feb 2022 16:03:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <YgynvByk/juhr+8G@shredder>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.245]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600001.china.huawei.com (7.193.23.3)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2022/2/16 15:29, Ido Schimmel Ð´µÀ:
> On Wed, Feb 16, 2022 at 11:19:01AM +0800, wanghai (M) wrote:
>> can you push this patch to the linux.git tree please?
> Yes. Will post the patch and a test later this week.
>
> BTW, since it's not fixing a regression (scenario never worked AFAICT) I
> will target it at net-next.
Ok, thank you for your help!
> .
>
-- 
Wang Hai

