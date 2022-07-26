Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D43580931
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 03:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbiGZBub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 21:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiGZBu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 21:50:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36071FD07;
        Mon, 25 Jul 2022 18:50:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D424EB8117D;
        Tue, 26 Jul 2022 01:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8A0FAC341CD;
        Tue, 26 Jul 2022 01:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658800225;
        bh=OsAN9HGhITAkPXlmjN57EqCCQ9DXUiETQ3Nkkd4dfrs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ltRDX9AhRzDa08ROH7fIt2dFj6PaOIWFjHdy6tyu842rJZJvY4o2XYr57wLR7vnPl
         awEjSZQBLJd+v0CkJDgMHSyDGH77QsDtBH9F5dIpJh6uD9ODjQ/NetDRl9OyCNqmHT
         QIVY4H4IlIgCQj0RNfvQ1LN0vzRhJNadFbBmQlrZKvkzfM/1qlSmf1Wl9DyjG+qTcT
         0ECHI+UuzVdUvX7BKzhwTHGtN0kLNXcU9lfHnLWJBdnS246WWONzRTpzVE2XRavnbC
         BIJ6GQTI2uRFiOgmqP8HsaSI6t9Z686a9Y6rBCAmZJEkeW4mAw+cpEBSxVQ5wP1jHa
         ACbb+Smbt2E+Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 69B48E450B3;
        Tue, 26 Jul 2022 01:50:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-next-2022-07-25
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165880022542.16692.5363435934726922878.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Jul 2022 01:50:25 +0000
References: <20220725174547.EA465C341C6@smtp.kernel.org>
In-Reply-To: <20220725174547.EA465C341C6@smtp.kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 25 Jul 2022 17:45:47 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-next-2022-07-25
    https://git.kernel.org/netdev/net-next/c/2baf8ba532a1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


