Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75C8C4A7E88
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 05:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349275AbiBCEAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 23:00:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349270AbiBCEAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 23:00:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359D6C061714
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 20:00:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD071B83314
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 04:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7F291C340EB;
        Thu,  3 Feb 2022 04:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643860808;
        bh=WUMURnmGcngGXJ8+9yqCP5SdOQDqeD371Inz3GzLX14=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PWgx4Ta1pD6//dl446GZ4lHevUUnCmOUSsJWb5QQoobinSovh+PlEtK1GD1qrpwN0
         jcZ04pa5cesoF38jRMSVaRT69wcaAwRGIA8RAWtV6z0QCoKBmmkt9yoc7NzqRcFfHo
         h7ULOR9t68sfe4iIsdy+aPa1ZrO1spdg5E74G64kPtsfVs3Sd2DTinQu9CEfNxW6A9
         WnNOflATo2YuUeK+hhPEhmxMSvwLJDG7h2yK+yAY6/fICXZmKTsXkZEQlhslENnuDN
         vQA1nYL2uTcBxWZVChdGoaR6BDTrrXCsx7TfigYZsYT8oPLhZimLuVVzxmU9f7M58s
         bntsXCEQPRB5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 63D07E5D08C;
        Thu,  3 Feb 2022 04:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2 v5 0/2] add json support on tc u32
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164386080840.30998.4417724474283023510.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Feb 2022 04:00:08 +0000
References: <cover.1643225596.git.liangwen12year@gmail.com>
In-Reply-To: <cover.1643225596.git.liangwen12year@gmail.com>
To:     Wen Liang <liangwen12year@gmail.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com, aclaudi@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Wed, 26 Jan 2022 14:44:46 -0500 you wrote:
> This adds support for json output on tc u32.
> - The first patch is replacing with proper json functions in `u32_print_opt()`
> - The second patch is fixing the json support in u32 `print_raw()`, `print_ipv4()`
>   and `print_ipv6()`
> 
> The patches were tested with jq parser.
> 
> [...]

Here is the summary with links:
  - [iproute2,v5,1/2] tc: u32: add support for json output
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=c733722b993c
  - [iproute2,v5,2/2] tc: u32: add json support in `print_raw`, `print_ipv4`, `print_ipv6`
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=721435dcfd92

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


