Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07295692640
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbjBJT02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:26:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233259AbjBJT01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:26:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2835D80751
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 11:26:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B288C61E6F
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 19:26:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C678AC433EF;
        Fri, 10 Feb 2023 19:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676057185;
        bh=u7CFwtxA8aUAQq1DfuzE7DibHgwtP/q1Albw8wTe7dU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=jfjzGO7CbSXd1JlbkkclqyDsq2lYzghywE6NMK8jp0uLLtiLrI5jUJaM7NbDBdeV8
         zk5NIeIJ8C+P98aL/nreRkTn+x+BDlaTRYuXUP0/FQWah56E5Im+8pAnMRQ7mywawr
         FGpoD0ikLkENZX4Q93VmZ7lZYNIlOjirPIeH/zDKhhSaIUoEgcjB+LieSRY96A6HEg
         zHND5NYnBu8V3gL/wo6dCop6P2lGGvQLEfxgr5rEgJfXSb+SK6MWwxZRKoNy18jw6R
         /UFXC7gQ0GB9JX5bs1EbZHf0TAOBjO927iT+W5xWT+XPrvoNJF4S3KpY3HsvfAxiSh
         lmg5UYi3iA2qA==
Message-ID: <f6aea761-9ec6-8e4e-6c4c-871d99000bdd@kernel.org>
Date:   Fri, 10 Feb 2023 12:26:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 3/4] ipv6: icmp6: add drop reason support to
 icmpv6_notify()
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
References: <20230210184708.2172562-1-edumazet@google.com>
 <20230210184708.2172562-4-edumazet@google.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230210184708.2172562-4-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/10/23 11:47 AM, Eric Dumazet wrote:
> Accurately reports what happened in icmpv6_notify() when handling
> a packet.
> 
> This makes use of the new IPV6_BAD_EXTHDR drop reason.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  include/net/ipv6.h |  3 ++-
>  net/ipv6/icmp.c    | 25 +++++++++++++++++--------
>  2 files changed, 19 insertions(+), 9 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


