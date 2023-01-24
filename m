Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77801679077
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 06:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbjAXFvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 00:51:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbjAXFvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 00:51:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFF23A9D
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 21:50:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C759B81077
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 05:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0825FC4339E;
        Tue, 24 Jan 2023 05:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674539418;
        bh=xZjfbEP6UoY4X+czZeyDSjHs3Y/vP9XJwFY8vcN2kH4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KO0/iLg+QOunXO1SPmwoHL6dXYfMEKJz9dFqkbGRVX/S30vl9NRNQGiEKoNIZbTmm
         0/FZhbSSkC+XgQOPOBfRFDJ5wjdHT682PEM2On1fSCWFWqm8dmAgvhuF+mqS94bxx6
         XWGbAo06mTXvTxDSpKrnyhhUsY60yVvcwrbqkOkFBspSP4vx7+H+l7QbC0Q9j2y7IW
         VSbn64dXDND93RE6Gh4gHZ6j9YY7Li60eLjdOt5LN1CLf7PPdg6B15vFWPm3ZmkqfQ
         MX8+9ev0dFEgSxMDo3DOgAEgsYhHgQP8cfUuTwuN1/6iA+3tjV3MyyRSxa9yMkhNnG
         Rw/GA8fBC4Ceg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DF18DE52508;
        Tue, 24 Jan 2023 05:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv4: prevent potential spectre v1 gadget in
 ip_metrics_convert()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167453941791.4419.3874462938838006078.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Jan 2023 05:50:17 +0000
References: <20230120133040.3623463-1-edumazet@google.com>
In-Reply-To: <20230120133040.3623463-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 20 Jan 2023 13:30:40 +0000 you wrote:
> if (!type)
> 		continue;
> 	if (type > RTAX_MAX)
> 		return -EINVAL;
> 	...
> 	metrics[type - 1] = val;
> 
> [...]

Here is the summary with links:
  - [net] ipv4: prevent potential spectre v1 gadget in ip_metrics_convert()
    https://git.kernel.org/netdev/net/c/1d1d63b61280

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


