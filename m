Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D496D2E1E
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 06:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233365AbjDAEVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 00:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbjDAEU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 00:20:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8302B1DFA6;
        Fri, 31 Mar 2023 21:20:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 361CEB83351;
        Sat,  1 Apr 2023 04:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6B6C433D2;
        Sat,  1 Apr 2023 04:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680322855;
        bh=anl9w7Djg0Q5ow5pnOX1KAxDS3hLmGobsHRsTsmnqb4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N6Fzvb+Jzv72yOKeaNsP12TY44cQZxK48cD44iTI5CARA2esJmR8G3Fnk2etIL8ym
         /IucQL2Au/SkJzZoB+INmnQ4hzCZBWQQ9ryl905okD3PVQXwyDM1b4Hy0OKKkYhxZ6
         EqMXw00lFH69TepOvYCJWU5toT0cT3PToIHJTqOFVBzaMvyt2MBRBHWRyLKiLMPVae
         BOQcod629EBIUh15L3MvER2/8irGWw/U+XMbCxjc3hLJsX3lhSou6VyC7KEQqc8Qeq
         HSFH2NhJTY+8rSCKsESRKDpRhzjsrL/ULGQsFSUftt6nc7Kd/kVk9sC+I+yaw2/HkL
         cN+xKshpVoCnQ==
Date:   Fri, 31 Mar 2023 21:20:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        Arnd Bergmann <arnd@kernel.org>, arnd@arndb.de,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        razor@blackwall.org, kerneljasonxing@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: netcp: MAX_SKB_FRAGS is now 'int'
Message-ID: <20230331212054.6be5c0cd@kernel.org>
In-Reply-To: <20230331214444.GA1426512@dev-arch.thelio-3990X>
References: <20230331074919.1299425-1-arnd@kernel.org>
        <168025201885.3875.15510680598248652530.git-patchwork-notify@kernel.org>
        <20230331214444.GA1426512@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Mar 2023 14:44:44 -0700 Nathan Chancellor wrote:
> The commit this patch is fixing is only in net-next and my patch to fix
> this warning is already applied:
> 
> https://git.kernel.org/netdev/net-next/c/3292004c90c8
> 
> c5b959eeb7f9 should be reverted in net (I am running out of time today
> otherwise I would just send a patch).

Sorry for the mix-up, cleaned up now.
