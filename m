Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0820769264B
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233312AbjBJT2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:28:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233320AbjBJT2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:28:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1A17E011
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 11:27:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E5B261DBD
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 19:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 603F4C433D2;
        Fri, 10 Feb 2023 19:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676057276;
        bh=wg9OFQ4Q9qsJ3vxC7fGfQd3yv0ZMk5tZ13vS4W5Ur8I=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=SbN0ud+eiIhxK2uE6nwlLYGopLI5QrWUB0qHN7fM6c3PmuuEZ2OqzxE+fkoys6Th7
         FBny37iTScdEqierRBAbV9VWVFZ1qZoQTnF5h8E10+0jMeZb5nzeKuXVe+/Uk+c4DI
         v3+wO5Mv16irlrriekh9S6BMyIFKj6LIGGZoS9cgLxPJUzd1bwPzc6ebz/JLk/MdWT
         E/DUlcnoYSd/xImQVVt41bi0C/BjD9w7nnWNa9ns3SqeeVlSMNEUvxfYnbiqOGLcGK
         K/C+9PG1OYaFFW+N0cdP1FE9P4vCZbojwKswenXzvKV6JB+arU3sajkjLDV2YMnhNx
         +4dOzMmwmZJBg==
Message-ID: <a43a022f-a758-a824-17c6-292e0b10ad3e@kernel.org>
Date:   Fri, 10 Feb 2023 12:27:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 4/4] ipv6: icmp6: add drop reason support to
 ndisc_rcv()
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
References: <20230210184708.2172562-1-edumazet@google.com>
 <20230210184708.2172562-5-edumazet@google.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230210184708.2172562-5-edumazet@google.com>
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
> Creates three new drop reasons:
> 
> SKB_DROP_REASON_IPV6_NDISC_FRAG: invalid frag (suppress_frag_ndisc).
> 
> SKB_DROP_REASON_IPV6_NDISC_HOP_LIMIT: invalid hop limit.
> 
> SKB_DROP_REASON_IPV6_NDISC_BAD_CODE: invalid NDISC icmp6 code.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  include/net/dropreason.h |  9 +++++++++
>  include/net/ndisc.h      |  2 +-
>  net/ipv6/icmp.c          |  2 +-
>  net/ipv6/ndisc.c         | 13 +++++++------
>  4 files changed, 18 insertions(+), 8 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


