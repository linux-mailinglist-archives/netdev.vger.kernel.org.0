Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA97657CEF2
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 17:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbiGUPaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 11:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbiGUPaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 11:30:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6C433A10
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 08:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3890161527
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 15:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 93BD8C341C6;
        Thu, 21 Jul 2022 15:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658417413;
        bh=ahfq/8V/Vp1wiBDyC5XwpCFAg/0UWpor8cyndjiRLZk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uU6H1IFFDU5gCIgYddMO0XojraBYxyo2S29roqkYXjjWTSZJ+v+r1qNtpXvNOiver
         lzLyZ3ius1WbAgnMK/08E7WBo5zo7+vybLPn41rG9HoMSnloJmvAw6nosavMb2W0Tk
         EfQNtQYQLc82mgW1yjKrEfaMvYp3hTdnEjHfCk8/IqUj8KAFcqoEd3pXCVbESFsJm0
         p0EPx6r1r2GAFkiOsgSntBWogGpfphqfMGOYXava4sdE7UDlkYgH0HzcQG5Yhyno8I
         lW62KosMBDBHEJdxoJdUivyKPwjXoCEgNrzU2J8OadHtL3sfwv593ctLM4fyJHFvL6
         D20szMpg7A/Pw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7615FE451BA;
        Thu, 21 Jul 2022 15:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch iproute2-next v3] devlink: add support for linecard show and
 type set
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165841741348.3713.13765181092456720508.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Jul 2022 15:30:13 +0000
References: <20220716112451.3392453-1-jiri@resnulli.us>
In-Reply-To: <20220716112451.3392453-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, sthemmin@microsoft.com, dsahern@gmail.com,
        mlxsw@nvidia.com, idosch@nvidia.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Sat, 16 Jul 2022 13:24:51 +0200 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Introduce a new object "lc" to add devlink support for line cards with
> two commands:
> show - to get the info about the line card state, list of supported
>        types as reported by kernel/driver.
> set - to set/clear the line card type.
> 
> [...]

Here is the summary with links:
  - [iproute2-next,v3] devlink: add support for linecard show and type set
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=4cb0bec3744a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


