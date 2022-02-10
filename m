Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12B44B1549
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 19:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245746AbiBJSdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 13:33:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239195AbiBJSdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 13:33:51 -0500
Received: from smtp.smtpout.orange.fr (smtp02.smtpout.orange.fr [80.12.242.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B32D195
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 10:33:47 -0800 (PST)
Received: from [192.168.1.18] ([90.126.236.122])
        by smtp.orange.fr with ESMTPA
        id IEGEnOlbgeKJJIEGEn3FAs; Thu, 10 Feb 2022 19:33:44 +0100
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Thu, 10 Feb 2022 19:33:44 +0100
X-ME-IP: 90.126.236.122
Message-ID: <a7e2e7db-fd32-d30c-32f4-8850a00f35d9@wanadoo.fr>
Date:   Thu, 10 Feb 2022 19:33:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] net: ethernet: cavium: use div64_u64() instead of
 do_div()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     patchwork-bot+netdevbpf@kernel.org, Qing Wang <wangqing@vivo.com>,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1644395960-4232-1-git-send-email-wangqing@vivo.com>
 <164441341163.22778.9220881439999777663.git-patchwork-notify@kernel.org>
 <056a7276-c6f0-cd7e-9e46-1d8507a0b6b1@wanadoo.fr>
 <20220209180113.3b3f0f5d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20220209180113.3b3f0f5d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 10/02/2022 à 03:01, Jakub Kicinski a écrit :
> On Wed, 9 Feb 2022 21:01:35 +0100 Christophe JAILLET wrote:
>> Le 09/02/2022 à 14:30, patchwork-bot+netdevbpf@kernel.org a écrit :
>>> Here is the summary with links:
>>>     - net: ethernet: cavium: use div64_u64() instead of do_div()
>>>       https://git.kernel.org/netdev/net-next/c/038fcdaf0470
>>>
>>> You are awesome, thank you!
>>
>> Hi,
>>
>> I think that this patch should be reverted because do_div() and
>> div64_u64() don't have the same calling convention.
>>
>> See [1]
>>
>> [1]:
>> https://lore.kernel.org/linux-kernel/20211117112559.jix3hmx7uwqmuryg@pengutronix.de/
> 
> Would you mind sending a revert?
> 

I don't work on net-next, only linux-next.

I can send a revert once it reaches linux-next but I would be better if 
it is fixed before that.

CJ
