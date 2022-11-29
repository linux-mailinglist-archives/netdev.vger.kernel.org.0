Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC1C63B746
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 02:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235072AbiK2Baf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 20:30:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233573AbiK2Bae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 20:30:34 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDB240938;
        Mon, 28 Nov 2022 17:30:34 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NLlBQ4JCTzHwGC;
        Tue, 29 Nov 2022 09:29:50 +0800 (CST)
Received: from [10.174.178.41] (10.174.178.41) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 29 Nov 2022 09:30:31 +0800
Message-ID: <dfdc6968-90f4-5ba2-4822-b844dab185bd@huawei.com>
Date:   Tue, 29 Nov 2022 09:30:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH 0/2] Add check for nla_nest_start()
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20221126100634.106887-1-yuancan@huawei.com>
 <20221128141816.3df481d0@kernel.org>
From:   Yuan Can <yuancan@huawei.com>
In-Reply-To: <20221128141816.3df481d0@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.41]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/11/29 6:18, Jakub Kicinski 写道:
> On Sat, 26 Nov 2022 10:06:32 +0000 Yuan Can wrote:
>>    udp_tunnel: Add checks for nla_nest_start() in
>>      __udp_tunnel_nic_dump_write()
>>    wifi: nl80211: Add checks for nla_nest_start() in nl80211_send_iface()
> Please post these separately (with David's feedback addressed)
> they need to go to different trees so making them as series is
> counter-productive.
Ok, thanks for the suggestion!

-- 
Best regards,
Yuan Can

