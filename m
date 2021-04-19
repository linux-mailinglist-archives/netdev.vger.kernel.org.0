Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE03364DB2
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 00:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhDSWet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 18:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhDSWes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 18:34:48 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AEA0C06174A;
        Mon, 19 Apr 2021 15:34:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 9D8F44D25407D;
        Mon, 19 Apr 2021 15:34:10 -0700 (PDT)
Date:   Mon, 19 Apr 2021 15:34:05 -0700 (PDT)
Message-Id: <20210419.153405.1531590596849653615.davem@davemloft.net>
To:     gustavo@embeddedor.com
Cc:     patchwork-bot+netdevbpf@kernel.org, gustavoars@kernel.org,
        vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, kuba@kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] sctp: Fix out-of-bounds warning in
 sctp_process_asconf_param()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <8f37be96-04dd-f948-4913-54da6c4ae9b2@embeddedor.com>
References: <20210416191236.GA589296@embeddedor>
        <161861761155.26880.11889736067176146088.git-patchwork-notify@kernel.org>
        <8f37be96-04dd-f948-4913-54da6c4ae9b2@embeddedor.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 19 Apr 2021 15:34:11 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Date: Fri, 16 Apr 2021 19:07:05 -0500

> Dave,
> 
> On 4/16/21 19:00, patchwork-bot+netdevbpf@kernel.org wrote:
>> Hello:
>> 
>> This patch was applied to netdev/net-next.git (refs/heads/master):
>> 
>> On Fri, 16 Apr 2021 14:12:36 -0500 you wrote:
>>> Fix the following out-of-bounds warning:
>>>
>>> net/sctp/sm_make_chunk.c:3150:4: warning: 'memcpy' offset [17, 28] from the object at 'addr' is out of the bounds of referenced subobject 'v4' with type 'struct sockaddr_in' at offset 0 [-Warray-bounds]
>>>
>>> This helps with the ongoing efforts to globally enable -Warray-bounds
>>> and get us closer to being able to tighten the FORTIFY_SOURCE routines
>>> on memcpy().
>>>
>>> [...]
>> 
>> Here is the summary with links:
>>   - [next] sctp: Fix out-of-bounds warning in sctp_process_asconf_param()
>>     https://git.kernel.org/netdev/net-next/c/e5272ad4aab3
> 
> Thanks for this. Can you take these other two, as well, please?
> 
> https://lore.kernel.org/linux-hardening/20210416201540.GA593906@embeddedor/
> https://lore.kernel.org/linux-hardening/20210416193151.GA591935@embeddedor/
> 

Done.
