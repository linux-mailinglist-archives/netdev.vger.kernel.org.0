Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B34513A07
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 18:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349939AbiD1Qn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 12:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236388AbiD1Qn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 12:43:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE9BDEEB
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 09:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 945FD620CA
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 16:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EEE9CC385AE;
        Thu, 28 Apr 2022 16:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651164012;
        bh=7rqH5CspXrao7+mRMg8hUfVwxs32pmsGueGRsfLmdbg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ji0JUueXvUZcKEJ+ZKdDj0/ukoRU+ma5sS7vB0LU7NT2VGy7zoHDSb6gpYyOXKOjo
         R4C1942ilL3g8B9eaodtXZWglM1EvPs2EQHuPYP1mz//aI4HDOiSp6WPNIJFSTOhJ/
         ewrSLPlnpb59FcggtS5+7Lp+VerIBJ6RlHi+h0weelZ03q/RiqfjHk6asIXdWe80oj
         QewItLXj+SM/Qa3+ZDDxGPk5BLvj1leIBcW7KILFYTKFkabOn1VXXwFuycuGJQQlvw
         7nGsoL4STvUf+eGGFf0dwFDMxqD7V6OfPGwgt7wmcRvys/IsY0WsGHC73tUe1Hw+3x
         oZdch2L4m1hBw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D0C4EE85D90;
        Thu, 28 Apr 2022 16:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] MAINTAINERS: Update BNXT entry with firmware files
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165116401185.12114.11229479081459967799.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Apr 2022 16:40:11 +0000
References: <20220427163606.126154-1-f.fainelli@gmail.com>
In-Reply-To: <20220427163606.126154-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        zajec5@gmail.com, andy@kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 27 Apr 2022 09:36:06 -0700 you wrote:
> There appears to be a maintainer gap for BNXT TEE firmware files which
> causes some patches to be missed. Update the entry for the BNXT Ethernet
> controller with its companion firmware files.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> Changes in v2:
> 
> [...]

Here is the summary with links:
  - [v2] MAINTAINERS: Update BNXT entry with firmware files
    https://git.kernel.org/netdev/net/c/126858db81a5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


