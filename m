Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEED69263C
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233277AbjBJTYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:24:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233216AbjBJTY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:24:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9DB7CCBF
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 11:24:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71F9CB82592
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 19:24:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA820C433EF;
        Fri, 10 Feb 2023 19:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676057064;
        bh=DF649431Nmj/ejuiHuqhTHiU8MnR+XPojUkMqF7rDYc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=URHwbHNbX9MtaswRpSmJX812ZWuR6oyApdh+ztSDu8i8+xNBvugUFbeXDwO2rX7r2
         5CjAU92VX16uUTRycwLQWjoMz2Vtl5cEA1NpUNW+HY8xpmHhf1tD7QqIW+gCrcM/Ky
         dq7y+Y5cmEGdEkXFBH5KGfx2AYEpwWZnsdItSqfDuvHh8lTR30VsKREwkHOrKR/XCe
         2MbOmhuQWdEHDwXdC/MUkXHTOwnPxe+onaQiXr19OdiX4LugegyTp1imVNDrLOiOg0
         9eXbpc/56ir0K8u2S9x0PBVyNe5QXTaN0/As+4pW3Z7D8sySLkm59YJZ6+vn2yhCw7
         leyC55JZiJI/Q==
Message-ID: <efbe9257-9b50-2194-6783-fb41300ff113@kernel.org>
Date:   Fri, 10 Feb 2023 12:24:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 2/4] net: add pskb_may_pull_reason() helper
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
References: <20230210184708.2172562-1-edumazet@google.com>
 <20230210184708.2172562-3-edumazet@google.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230210184708.2172562-3-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/10/23 11:47 AM, Eric Dumazet wrote:
> pskb_may_pull() can fail for two different reasons.
> 
> Provide pskb_may_pull_reason() helper to distinguish
> between these reasons.
> 
> It returns:
> 
> SKB_NOT_DROPPED_YET           : Success
> SKB_DROP_REASON_PKT_TOO_SMALL : packet too small
> SKB_DROP_REASON_NOMEM         : skb->head could not be resized
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  include/linux/skbuff.h | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


