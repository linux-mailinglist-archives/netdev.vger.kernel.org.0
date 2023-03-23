Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C79186C73C8
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 00:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjCWXAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 19:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCWXAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 19:00:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 255AB3C25;
        Thu, 23 Mar 2023 16:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98965628E9;
        Thu, 23 Mar 2023 23:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1606C4339B;
        Thu, 23 Mar 2023 23:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679612419;
        bh=XozDeJU917zze4W1l+j2xZfTX5ZECoHJ48ATkyguTxg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PPfS3saBUE8SKXATBKFPa6QIHmcmheQjAnLj7RZAQdGQsKUl9KapXtaO4TWaiEph2
         JPNMdGqmud/kj8NaRcfreu53mInL9NsNIgotLZQiVzFneUS36OzMnonGEmgjYJD7i5
         AmOQlA7Ohb3VslSo9K9q3rWEU3f/W6cYodfdXkZNA1ACJB8o3JCFVTg/chFHq6yhKG
         53QRAtCHMVB3eA3ES5Mgohiym2rwz7BfGuD46UsHmJBRXi4OjZQte4As8emcnBFZsa
         LUPZu5yfP/JLiy/VsNpdEXg2XE+JhD7eCwZ/wEvCMXMOLttHZL/zLI6Cdm2slDVdeq
         5276/ijXIEiuQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D0A7DE61B85;
        Thu, 23 Mar 2023 23:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-2023-03-23
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167961241885.1188.16603465008712880291.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Mar 2023 23:00:18 +0000
References: <20230323110332.C4FE4C433D2@smtp.kernel.org>
In-Reply-To: <20230323110332.C4FE4C433D2@smtp.kernel.org>
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

On Thu, 23 Mar 2023 11:03:32 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-2023-03-23
    https://git.kernel.org/netdev/net/c/4f44d3260536

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


