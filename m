Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB125906D7
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 21:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235526AbiHKTJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 15:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235083AbiHKTJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 15:09:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E08A1A43;
        Thu, 11 Aug 2022 12:09:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15A09B8200A;
        Thu, 11 Aug 2022 19:09:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD31C433C1;
        Thu, 11 Aug 2022 19:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660244943;
        bh=e7+/hsuVnFf7TiLZzimRb3KiCHnwK91WXtyUVwVpXFk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jB2cs5MTBO8qGUqd8Dp/dhivdFH4wROLgdF0nBdvi8Puy3Mi86NDAGDHbaEtLvGwm
         BuOMzd9Bs1+mexJHbrPd2DN+aKcHrKsB5hOdidesUIIM9smlHU9jgZENUa0MilxRwP
         oOld7Zggob6Z5iPmNICE6cKR48l5Ux5TwAFidUCQqjlYnKTX05mw59m6IvRkhYG0Wj
         oFJrlb5Uz1dVCWH1KjZVJf9Gcm3702/mV1U4Rfd6lUGhP6EK+KYe8B3KLLBSLCCdWd
         iIrQg3bfqihf7dF0h9zC0SGtMt7E16O8El+jkjScTnGmk4OyT+Y+lutBWdT1j7aANk
         HJbrhfVWOnJQQ==
Date:   Thu, 11 Aug 2022 12:09:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PULL] Networking for 6.0-rc1
Message-ID: <20220811120902.7e82826a@kernel.org>
In-Reply-To: <20220811185102.3253045-1-kuba@kernel.org>
References: <20220811185102.3253045-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Aug 2022 11:51:02 -0700 Jakub Kicinski wrote:
> The following changes since commit f86d1fbbe7858884d6754534a0afbb74fc30bc26:
> 
>   Merge tag 'net-next-6.0' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2022-08-03 16:29:08 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.0-rc1
> 
> for you to fetch changes up to c2e75634cbe368065f140dd30bf8b1a0355158fd:
> 
>   net: atm: bring back zatm uAPI (2022-08-11 10:31:19 -0700)

Let's put this one on hold, sorry. We got a report 2 minutes after
sending that one of the BT patches broke mips and csky builds :S
I'll try to get hold of Luiz and fix that up quickly.

Speaking of build problems after merging with your tree I run into
-Werror,-Wframe-larger-than on the AMD GPU drivers (gcc and clang, both). 
Quick search of lore does not show any hits.
