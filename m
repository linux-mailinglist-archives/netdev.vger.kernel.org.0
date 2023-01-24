Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B20767A0FD
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 19:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbjAXSPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 13:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbjAXSPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 13:15:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F84C18A9C;
        Tue, 24 Jan 2023 10:15:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAE1FB81627;
        Tue, 24 Jan 2023 18:15:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F29C433EF;
        Tue, 24 Jan 2023 18:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674584116;
        bh=Rd5xkF/cF7E/u3PgEI5wGUAi752Z3HB3dNv8+uQX9fI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iitDX4kGEgESvMEN9vsfiloiePb3zngO/h2zx1xg2pXOiduYvd1rJV5gORW1/FIrf
         1gei/g6WgprhadktlY+jtm4dZYKkHe5HLmQ/1SSUo4s/mwifuCjI1UaTdFy8ofKLPM
         BLKlf7yW3aL3v1SsHifm017nscb0xckBLzIBKZ13obE8vy98ELW8dh3Y1jhFroi6st
         S/BxGEQ1FnOH2flPXuPPdiUd0QSYh/X+mJZLlEsQpJaQZHWHcFwPFDMnOTS6AMBR+4
         Qyr6CYTYjyLQvSs/LKVrvsgqyCuMYT8QNzHewwiB0xdqmzQ8oTvCZ8tUSbUUFpI2np
         jkEUAlkVxV5yw==
Date:   Tue, 24 Jan 2023 20:15:11 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Neal Cardwell <ncardwell@google.com>, selinux@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, kernel-team@cloudflare.com,
        Marek Majkowski <marek@cloudflare.com>
Subject: Re: [PATCH net-next v6 0/2] Add IP_LOCAL_PORT_RANGE socket option
Message-ID: <Y9AgL9TlxvQCRPFO@unreal>
References: <20221221-sockopt-port-range-v6-0-be255cc0e51f@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221221-sockopt-port-range-v6-0-be255cc0e51f@cloudflare.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 02:36:43PM +0100, Jakub Sitnicki wrote:
> This patch set is a follow up to the "How to share IPv4 addresses by
> partitioning the port space" talk given at LPC 2022 [1].

<...>

> 	      
> Changelog:
> ---------
> 
> v5 -> v6:
> v5: https://lore.kernel.org/r/20221221-sockopt-port-range-v5-0-9fb2c00ad293@cloudflare.com
> 
>  * Move changelog in individual patches below the trailer. (Leon)

Thank you for doing that.

