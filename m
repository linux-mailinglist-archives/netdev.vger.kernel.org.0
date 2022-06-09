Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD9B654426A
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 06:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237203AbiFIEUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 00:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235294AbiFIEUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 00:20:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9556BE3DF5;
        Wed,  8 Jun 2022 21:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F25161CCD;
        Thu,  9 Jun 2022 04:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 81283C341C8;
        Thu,  9 Jun 2022 04:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654748412;
        bh=dIUaXAb8JvdExVmLmSfZD2I3zXBIqIGH+YOHQiEOWhU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h2R27x8HPrjU1msxKqyvS+J400vNxerOUKREFoCnB56VtLkohU7c0fxvU7elGi3Qk
         ix6DLQijmN2uYAeeW/TotCKhYdSxZHrgZx9pwYsYwrYbv5aUqCzsdgAbgGnfHkVZB5
         AUtRrZDo7K7CHVEiHfZiXP9681ELjQnmE4m/IBhgMdWyY58Ookooj7K8Pe34QlxnyS
         x2yn+VhZodnjxbrnsQ9kVMSBU2rrC0nyyJ+6F0/qhOzW3NMXNSLBO46T6OZ3dxk7uz
         unE9J0e/oRI4Amct/G74g3xwhLtEGd72eADNlRKh6kBsMaQIXH67DSXcEQg+o4HxGR
         hn9tQSq1qNZIw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6D140E737FE;
        Thu,  9 Jun 2022 04:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH Resend] xen/netback: do some code cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165474841244.6883.11725233073993264776.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Jun 2022 04:20:12 +0000
References: <20220608043726.9380-1-jgross@suse.com>
In-Reply-To: <20220608043726.9380-1-jgross@suse.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei.liu@kernel.org, paul@xen.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Jun 2022 06:37:26 +0200 you wrote:
> Remove some unused macros and functions, make local functions static.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Acked-by: Wei Liu <wei.liu@kernel.org>
> ---
>  drivers/net/xen-netback/common.h    | 12 ------------
>  drivers/net/xen-netback/interface.c | 16 +---------------
>  drivers/net/xen-netback/netback.c   |  4 +++-
>  drivers/net/xen-netback/rx.c        |  2 +-
>  4 files changed, 5 insertions(+), 29 deletions(-)

Here is the summary with links:
  - [Resend] xen/netback: do some code cleanup
    https://git.kernel.org/netdev/net-next/c/5834e72eda0b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


