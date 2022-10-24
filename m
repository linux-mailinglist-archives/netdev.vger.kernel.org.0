Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA69E60A898
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 15:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235280AbiJXNI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 09:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235299AbiJXNHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 09:07:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636819DF81;
        Mon, 24 Oct 2022 05:21:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 972F6612A5;
        Mon, 24 Oct 2022 12:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EDDD6C43142;
        Mon, 24 Oct 2022 12:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666613417;
        bh=IzrvECnkW4ley6KEBrA4rrTJmqiyY4xjW3G1gwvYFz8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MFr0R3/M5r/4aAGwjeX8G9TJkyF1TG4lxddOr1uepPZXqseQg4EYFzEtZaf6De1YW
         WF1Xb+EQDE2pz1BMHC5xukekqmbbielmA4cnSKdJbnHzre62PAVTCobCLz5szXAGUp
         oflisiqyLziBRo1sSpf/q1lMgqcy1TfJSnOmKxpBdC27Pc1g/3ljI3cJF63/3gl/RG
         0fUA4cZxAivbPsfIpRYOY8eo6KJOIbeIt6e+ofMhzUBIMSVVgVrX24n9M47uMtNt8k
         9SZOt/PzCauEi8b2hKS5hyLk6OfQULlDSmyDTUE9VxESFPEe/8px71OpVKLXyphmNl
         8obHbNUWrYxSw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D6A87E4D005;
        Mon, 24 Oct 2022 12:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 linux-next] net: remove useless parameter of
 __sock_cmsg_send
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166661341687.16761.4550987716760472862.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Oct 2022 12:10:16 +0000
References: <20221020065440.397406-1-xu.xin16@zte.com.cn>
In-Reply-To: <20221020065440.397406-1-xu.xin16@zte.com.cn>
To:     xu xin <xu.xin.sc@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        edumazet@google.com, pabeni@redhat.com, dsahern@kernel.org,
        xu.xin16@zte.com.cn, zealci@zte.com.cn, zhang.yunkai@zte.com.cn,
        kuniyu@amazon.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 20 Oct 2022 06:54:41 +0000 you wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> The parameter 'msg' has never been used by __sock_cmsg_send, so we can remove it
> safely.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> Reviewed-by: Zhang Yunkai <zhang.yunkai@zte.com.cn>
> Acked-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> 
> [...]

Here is the summary with links:
  - [PATCHv2,linux-next] net: remove useless parameter of __sock_cmsg_send
    https://git.kernel.org/netdev/net-next/c/233baf9a1bc4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


