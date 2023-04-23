Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59296EBF8D
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 14:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbjDWMuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 08:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjDWMuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 08:50:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F7110D1;
        Sun, 23 Apr 2023 05:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F70D60EE0;
        Sun, 23 Apr 2023 12:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 965A1C4339C;
        Sun, 23 Apr 2023 12:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682254217;
        bh=jTIdfQM1eWcNuDZK6fIyQc6YVyBhTD2oiuwh3kzg05A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DJMYMJ9fBXZKCuJLHC1v2vFdQJ2JZFDDsGfMQoqwBLunU9w79A4437bxts6OIiFYf
         HPZBwGPuNGEjXcOV81X2/u2yyuGZoDKXJD6KcPM7/hPvLBvRm0lo3QmH99QTimVEX/
         2LEc2VOk11+fnhPpiMNgvr7D3ikSwag3XCU3sVWhwGi/fOmDqfJC1BpjucRDwTskbo
         DSQ+D8/PUxX4CYscF4EdsIZdzpEheT+ettPm/pgASEPYw4JfmL2MbpsrKmK1wosckN
         I+sHFWGb7CwZ8Z2Im1i7kYRpvtvLULO0GZ6UNjDP4l2nec19CD7ps7SBXJNp8DjcwQ
         ihdyVJjab2Ipw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 79CECC395EA;
        Sun, 23 Apr 2023 12:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] rxrpc: Fix error when reading rxrpc tokens
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168225421749.16046.8327729709141933771.git-patchwork-notify@kernel.org>
Date:   Sun, 23 Apr 2023 12:50:17 +0000
References: <212125.1682093777@warthog.procyon.org.uk>
In-Reply-To: <212125.1682093777@warthog.procyon.org.uk>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, marc.dionne@auristor.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 21 Apr 2023 17:16:17 +0100 you wrote:
> From: Marc Dionne <marc.dionne@auristor.com>
> 
> When converting from ASSERTCMP to WARN_ON, the tested condition must
> be inverted, which was missed for this case.
> 
> This would cause an EIO error when trying to read an rxrpc token, for
> instance when trying to display tokens with AuriStor's "tokens" command.
> 
> [...]

Here is the summary with links:
  - [net] rxrpc: Fix error when reading rxrpc tokens
    https://git.kernel.org/netdev/net/c/fadfc57cc804

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


