Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C256D8C06
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 02:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233280AbjDFAkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 20:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233294AbjDFAkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 20:40:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65937687;
        Wed,  5 Apr 2023 17:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EC3C62C83;
        Thu,  6 Apr 2023 00:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D8A3BC4339B;
        Thu,  6 Apr 2023 00:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680741617;
        bh=uvfbKxyoeKpR+BxMNdk1GcWKaEw0NbbvUZD2iIA0Phs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tP5nJyr6iuF50pbInFh4ydRuPadjq8F2Y24Uhy0ewnnw1GABIfeW1dHFhX/uG8BTe
         hZfnOWU92AVRhERHDvKkDMynsBnRkgo1EeUVvT4Rqa2bAbPDwo7lgZJWeNjpd+q34R
         zVENQgrhchuMZCKMfvIZ1TWpwpZ3eqJoIaid5Dox0nzk6Zc2e4ZzMTxB2VSVsU/ZQ1
         BgJvTnMrSpA0nQLHn5lSlAerqejHoXNHcNVKwfZUA1gFpZ3J36gqLeItKsGdMyiMYg
         INXisiEPP/76lxREPxGyCC+MV8QfGwmpkDSkVN+jfugzaGojFyrpwnvW71QR3vjnIf
         QlbouloNyxP/w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AF310C395D8;
        Thu,  6 Apr 2023 00:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-2023-04-05
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168074161771.7173.12304830941591369280.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Apr 2023 00:40:17 +0000
References: <20230405105536.4E946C433D2@smtp.kernel.org>
In-Reply-To: <20230405105536.4E946C433D2@smtp.kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  5 Apr 2023 10:55:36 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-2023-04-05
    https://git.kernel.org/netdev/net/c/cbeb1c1b68d9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


