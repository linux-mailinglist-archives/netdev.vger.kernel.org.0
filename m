Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC3A560F98
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 05:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbiF3DUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 23:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbiF3DUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 23:20:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF8140A35;
        Wed, 29 Jun 2022 20:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C432B827F9;
        Thu, 30 Jun 2022 03:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0E3D0C3411E;
        Thu, 30 Jun 2022 03:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656559214;
        bh=6j3Dl7YHO3OHtYGT4aJ+6XgyCQOD/YBJJwDRSRxfaj4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eZbgJ4bifC8aec4Qgay1cQWcRTpzBuk32N47JVLJX6KnCxBk8ZsWnUScZIzs1KkOO
         tT6P9POSlyjgDZxl9DrKgL3YNiFbK3+gxA7/Mnh727mju9zUrXgY6cFW9IyQQ3DwXE
         8IPBnY2rE3Rtv1VrTyn7HgiI9vclsl/DC8iWtZLfsyuJfd5pFqICKMnblMC0LuBewQ
         /0TKor/m+Sc5lS2jH2mg/fX+odgKoYXsrqXxsXWWVYE+602GGH+RITcPQE3MxzJ/1k
         Qo2XYqAgGpKU5dZHageyNsDZGOL9YdwLk+WcrHVRGqxW+307jbeStgQW5r5corpqKM
         vvraU+980ryoA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E10A0E49BB8;
        Thu, 30 Jun 2022 03:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] Netfilter fixes for net
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165655921391.17409.14718173715479167707.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Jun 2022 03:20:13 +0000
References: <20220629171354.208773-1-pablo@netfilter.org>
In-Reply-To: <20220629171354.208773-1-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed, 29 Jun 2022 19:13:51 +0200 you wrote:
> Hi,
> 
> The following patchset contains Netfilter fixes for net:
> 
> 1) Restore set counter when one of the CPU loses race to add elements
>    to sets.
> 
> [...]

Here is the summary with links:
  - [net,1/3] netfilter: nft_dynset: restore set element counter when failing to update
    https://git.kernel.org/netdev/net/c/05907f10e235
  - [net,2/3] netfilter: nf_tables: avoid skb access on nf_stolen
    https://git.kernel.org/netdev/net/c/e34b9ed96ce3
  - [net,3/3] netfilter: br_netfilter: do not skip all hooks with 0 priority
    https://git.kernel.org/netdev/net/c/c2577862eeb0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


