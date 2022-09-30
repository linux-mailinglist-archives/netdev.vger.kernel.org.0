Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD1C5F10DE
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 19:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbiI3Rax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 13:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232099AbiI3Ram (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 13:30:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34A1DF067;
        Fri, 30 Sep 2022 10:30:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97B90623E3;
        Fri, 30 Sep 2022 17:30:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 02448C433C1;
        Fri, 30 Sep 2022 17:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664559040;
        bh=YI3fTE+YUPEZHz4M4pjQG4oQDEu6FbpcbEokxBvp8gM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lj+eHhVjqNZfwnPo3FNUS8ruoYiJwPyYcKKWAe8GLt91PEeW4MGuOq1h3SrL/snNe
         un/kIjuVep+g73vahQE9NgoSNvff8eq82N8QEpFn3SpHkUyFQKLpjPqgd4WSi7yOEL
         VxwN222vJD+06XNn3SEhTjL/bUBuNyh36kIa0DGtAG4VzHj4kj2fQ47vofdVOyCbfT
         8ztHp/71taNHd4R+Tk7/v1jHk9CsRJ0yFYGua+SwthdXaGqyML8M7ghbq5+O5QxaH7
         5/qBHOkHliwhqnktNoGEODmCovWXoN2YJVazt1gwnVY2ZwMfCNXQwPNLSBnW8+FWb6
         eXwO6wrTWh6fA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D2A84E524CC;
        Fri, 30 Sep 2022 17:30:39 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-next-2022-09-30
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166455903985.10719.15682843428383635942.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Sep 2022 17:30:39 +0000
References: <20220930150413.A7984C433D6@smtp.kernel.org>
In-Reply-To: <20220930150413.A7984C433D6@smtp.kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 30 Sep 2022 15:04:13 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-next-2022-09-30
    https://git.kernel.org/netdev/net-next/c/915b96c52763

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


