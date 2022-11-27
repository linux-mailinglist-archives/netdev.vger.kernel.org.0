Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3D36639A52
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 13:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiK0MI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 07:08:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiK0MIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 07:08:24 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF65F587
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 04:08:23 -0800 (PST)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1ozGSM-0000zd-9H; Sun, 27 Nov 2022 13:08:22 +0100
Message-ID: <06fcec0d-c8aa-d181-441b-695afe6a4e18@leemhuis.info>
Date:   Sun, 27 Nov 2022 13:08:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: RTM_DELROUTE not sent anymore when deleting (last) nexthop of
 routes in 6.1 #forregzbot
Content-Language: en-US, de-DE
From:   Thorsten Leemhuis <regressions@leemhuis.info>
To:     Network Development <netdev@vger.kernel.org>
Cc:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>
References: <CAOiHx==ddZr6mvvbzgoAwwhJW76qGNVOcNsTG-6m79Ch+=aA5Q@mail.gmail.com>
 <7206722a-f97e-5222-bea6-e327b22e4b5b@leemhuis.info>
In-Reply-To: <7206722a-f97e-5222-bea6-e327b22e4b5b@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1669550903;95239f7b;
X-HE-SMSGID: 1ozGSM-0000zd-9H
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.11.22 09:36, Thorsten Leemhuis wrote:
> On 24.11.22 10:20, Jonas Gorski wrote:
>> when an IPv4 route gets removed because its nexthop was deleted, the
>> kernel does not send a RTM_DELROUTE netlink notifications anymore in
>> 6.1. A bisect lead me to 61b91eb33a69 ("ipv4: Handle attempt to delete
>> multipath route when fib_info contains an nh reference"), and
>> reverting it makes it work again.
> 
> Thanks for the report. To be sure below issue doesn't fall through the
> cracks unnoticed, I'm adding it to regzbot, my Linux kernel regression
> tracking bot:
> 
> #regzbot ^introduced 61b91eb33a69
> #regzbot title net: RTM_DELROUTE not sent anymore when deleting (last)
> nexthop of routes
> #regzbot ignore-activity

#regzbot monitor:
https://lore.kernel.org/all/20221124210932.2470010-1-idosch@nvidia.com/
