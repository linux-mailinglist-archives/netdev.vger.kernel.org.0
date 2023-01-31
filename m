Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AADE68321F
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 17:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbjAaQDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 11:03:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbjAaQDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 11:03:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA9B01717B;
        Tue, 31 Jan 2023 08:03:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E9026151C;
        Tue, 31 Jan 2023 16:03:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A25C433D2;
        Tue, 31 Jan 2023 16:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675180981;
        bh=Ko9wlz0avLrftirGXAOobYdVcohh6ogLkckLQmvWuao=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=YkT1+C8YDPqLnjKsLUYkhBGj5Gzb+PtxnwajMvLOBa7ZGx/Fbo4SzDc0J+caLCZ2O
         rl62MWLgQoHWitVKbR5Wl9Keh3MGsQGX/aI2A7N9lLV/4wGfJE/oWNOnFa3CQ6iKKL
         aItAaSEK2+Hshzh/eXGzennZzduuXacQ7itztgweysWYEN1sXweYkzZT03srA+ZrGS
         yygepF33ErksfQnDGZSQpq0gbHSxr06kR4zncS1ko39AOGRd9/RBBdnS6zlLe4Leqq
         yakh9um7/1JG6TphPeUr+iLerW4XFCGoossci2VRol031JCZCp8rd3r6R57JmpN0A1
         z7wl5t4AXErEQ==
Message-ID: <a5c9ea73-9a00-e858-9aeb-54e0061e9172@kernel.org>
Date:   Tue, 31 Jan 2023 09:03:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH] ipv6: ICMPV6: Use swap() instead of open coding it
Content-Language: en-US
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
References: <20230131063456.76302-1-jiapeng.chong@linux.alibaba.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230131063456.76302-1-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/30/23 11:34 PM, Jiapeng Chong wrote:
> Swap is a function interface that provides exchange function. To avoid
> code duplication, we can use swap function.
> 
> ./net/ipv6/icmp.c:344:25-26: WARNING opportunity for swap().
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3896
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  net/ipv6/icmp.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

