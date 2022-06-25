Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8045255A758
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 07:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbiFYFkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 01:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231690AbiFYFkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 01:40:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3FE50B19
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 22:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B82EAB8269B
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 05:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 50463C341C0;
        Sat, 25 Jun 2022 05:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656135614;
        bh=naLtc46QaxFkdSNqkiZnw1gHhtwmn1jA4nv7sJY4wE8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dDtvdcN93lk9HTSd46LWS8+CGOsvRQsBfn3L2M+OwovdX4hpnZmdcoqw3VN+oPJtj
         5WBsH7+ViWj9Fi6FH63PkfAbc26TDkJ5nYfpGvYR51fUs+fN01QxJnIyqFwSv+rQZq
         4HYsrWZrsf90QlXhUWCL4pxsd1ikrXFcPIN1IJ4xsSZEUXCQe2odlyzBIXJ3TUJ0a+
         7WjE1K1o+zfNe/Rr8YEQ+lMrgpNR6DCfP6CYGGy0s5xt3YSXbiwqsScrygKk047HA5
         3L9/t7lKW2OX75ukULr71W5CO2HrJjg6m/CPq59+qDjSUkfOSJjxqM45VanCa0Gyje
         F9PLHsEWWqCeA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 32F39E85C6D;
        Sat, 25 Jun 2022 05:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net: helper function skb_len_add
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165613561420.1389.16868299843480315588.git-patchwork-notify@kernel.org>
Date:   Sat, 25 Jun 2022 05:40:14 +0000
References: <20220622160853.GA6478@debian>
In-Reply-To: <20220622160853.GA6478@debian>
To:     Richard Gobert <richardbgobert@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        willemb@google.com, imagedong@tencent.com, talalahmad@google.com,
        kafai@fb.com, vasily.averin@linux.dev, luiz.von.dentz@intel.com,
        jk@codeconstruct.com.au, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 22 Jun 2022 18:09:03 +0200 you wrote:
> Move the len fields manipulation in the skbs to a helper function.
> There is a comment specifically requesting this and there are several
> other areas in the code displaying the same pattern which can be
> refactored.
> This improves code readability.
> 
> Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
> 
> [...]

Here is the summary with links:
  - [v3] net: helper function skb_len_add
    https://git.kernel.org/netdev/net-next/c/ede57d58e6f3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


