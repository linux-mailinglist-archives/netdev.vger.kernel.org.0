Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34EB86BBEA8
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 22:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbjCOVPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 17:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjCOVPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 17:15:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667F118B06;
        Wed, 15 Mar 2023 14:15:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16C0DB81F1B;
        Wed, 15 Mar 2023 21:15:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4160DC433EF;
        Wed, 15 Mar 2023 21:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678914939;
        bh=aAvjBSpRw+TO4+Lq8ortxcj2XTvz+PLViQbzCPm+XkA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VeqO8Kg5ZxnE1daGvP0ZxlwSmZ/rT0JHkf5O/5E5Wk+olS5Y6OqUUJZq24fn4Wqnv
         dGpiWypdNiYhx/bHr5udJp+4OUGq1VlPJb6TansBl5AGGGD4GaneWSxsgMQgxTDwnI
         SMgr1BjbH0K9Oe7Tk1GClOnynyqwy4lfSDPh0pZNQKy5qIEx02Ej9wqmb4ONvwfH3n
         ANhrR4egzPck0dBNwaSfJrMnDsNogCNoS9DD/jRRUdCZleW7ufcjSh5j+ct+g9iQgG
         x0DUaRZ1yyyQGW40JzdykpWnVqfBm0djYHkOifWCCRoES11HeCvyYJh0Vk47gFO97n
         Bk+R+lTP4zh0A==
Date:   Wed, 15 Mar 2023 14:15:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        kernel test robot <lkp@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        oe-kbuild-all@lists.linux.dev,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v6 1/1] net: dsa: hellcreek: Get rid of custom
 led_init_default_state_get()
Message-ID: <20230315141538.5a9f574c@kernel.org>
In-Reply-To: <20230315195154.GA1636193@dev-arch.thelio-3990X>
References: <20230314181824.56881-1-andriy.shevchenko@linux.intel.com>
        <202303150831.vgyKe8FD-lkp@intel.com>
        <ZBH7G+1RwX4VAKcz@smile.fi.intel.com>
        <20230315195154.GA1636193@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Mar 2023 12:51:54 -0700 Nathan Chancellor wrote:
> If you modify the GitHub link above the 'git remote' command above from
> 'commit' to 'commits', you can see that your patch was applied on top of
> mainline commit 5b7c4cabbb65 ("Merge tag 'net-next-6.3' of
> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next"), which
> was before the pull that moved led_init_default_state_get() into
> include/linux/leds.h, commit e4bc15889506 ("Merge tag 'leds-next-6.3' of
> git://git.kernel.org/pub/scm/linux/kernel/git/lee/leds"). Not sure why
> that was the base that was chosen but it explains the error.

Because they still haven't moved to using the main branch of netdev
trees, they try to pull master :| I'll email them directly, I think
they don't see the in-reply messages.
