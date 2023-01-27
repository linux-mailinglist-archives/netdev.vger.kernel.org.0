Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5BD67E5B2
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 13:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234332AbjA0MpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 07:45:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234344AbjA0MpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 07:45:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10FFF12F2F
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 04:45:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74159B820C6
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 12:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 21FD4C4339C;
        Fri, 27 Jan 2023 12:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674823217;
        bh=uv6Q/u7DV3NQAFIWa/X7bGgAa+FDup0qHhcgWf2uTIU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WgWdi0vMPbjIk5vZ14uWUqQD0MB8hbSjzViUNQpJcC9VRDMcCMYUdIVsrAAEFcsQq
         mXCNofhmZgpkojm7iuaVttfs2HUjEotFrsyjZVutu9KHYo7gkpFD3IkZRVkXEHf3nv
         gI0fFryU/YGBK+P8gb/AbRkM6A3zQ7PAh4BmVAbKr3CoQXoMmiyowVunmcXsMA+cvp
         h5BUqi3t7cFaG4W4nQw8sW/b/OEBvpjboFqlZaEyS27Vd2W6SFWeKQz3PWTBApZJpi
         5UKg/XsvZIaKk4pXtg81KXyh9o1TQbHkgKSohp3uGI03R24E+CGfgZ/7gFEgjkPqKW
         DGSEVTNZ+WXkg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 04C50C39564;
        Fri, 27 Jan 2023 12:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] ethtool: netlink: handle SET intro/outro in
 the common code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167482321701.11366.17179685426572942590.git-patchwork-notify@kernel.org>
Date:   Fri, 27 Jan 2023 12:40:17 +0000
References: <20230125230519.1069676-1-kuba@kernel.org>
In-Reply-To: <20230125230519.1069676-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 25 Jan 2023 15:05:17 -0800 you wrote:
> Factor out the boilerplate code from SET handlers to common code.
> 
> I volunteered to refactor the extack in GET in a conversation
> with Vladimir but I gave up.
> 
> The handling of failures during dump in GET handlers is a bit
> unclear to me. Some code uses presence of info as indication
> of dump and tries to avoid reporting errors altogether
> (including extack messages).
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] ethtool: netlink: handle SET intro/outro in the common code
    https://git.kernel.org/netdev/net-next/c/99132b6eb792
  - [net-next,v2,2/2] ethtool: netlink: convert commands to common SET
    https://git.kernel.org/netdev/net-next/c/04007961bfaf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


