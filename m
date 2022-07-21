Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE6857D401
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 21:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiGUTU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 15:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiGUTUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 15:20:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067D5193E1;
        Thu, 21 Jul 2022 12:20:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9609B62084;
        Thu, 21 Jul 2022 19:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC206C341C0;
        Thu, 21 Jul 2022 19:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658431223;
        bh=W05HymhqzZ2/pgDnQOnSSiXG3hYoa3dkCKd25PiLmwc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XTsXuBQaylyi/yykcaa6fq3RyUIC+7EHnmVhSNJYHdynGUOwvgTnPxqB5v/RWZe2f
         V9NqCq0Bt0ao1KeCGMkuxyQl6ZrU4baN9iGI1ehEzfsbOXFeWsvJU9UQnygoAQtZd8
         MV43ltTyfMRhwv4tbbXAw0JHjK1jahZWvWa3zrgAMLmbW17ctASh75VYUc8ZDZM//H
         b+NsmEpLQTnBJlk72RMjbBNDu/PAyQrLwokoDbr9IMKET+68fHG4taQjdPmws4WvOi
         WfDXnk2O2FWBT8jOeY6Ij+1CAspP1+37TMOu7Tk/koq2WgCv7Ni/+Hbf71YlYvc7SU
         dKVKqhNgz3vMw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D1D8AE451B8;
        Thu, 21 Jul 2022 19:20:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Networking for 5.19-rc8
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165843122285.6393.5400949047459171467.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Jul 2022 19:20:22 +0000
References: <20220721093051.14504-1-pabeni@redhat.com>
In-Reply-To: <20220721093051.14504-1-pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Linus Torvalds <torvalds@linux-foundation.org>:

On Thu, 21 Jul 2022 11:30:51 +0200 you wrote:
> Hi Linus!
> 
> Still no major regressions, most of the changes are still
> due to data races fixes, plus the usual bunch of drivers
> fixes.
> 
> The following changes since commit db886979683a8360ced9b24ab1125ad0c4d2cf76:
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] Networking for 5.19-rc8
    https://git.kernel.org/netdev/net/c/7ca433dc6ded

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


