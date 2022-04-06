Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 337194F6488
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 18:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236732AbiDFPvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 11:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236503AbiDFPvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 11:51:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF1A4DFAB5;
        Wed,  6 Apr 2022 06:10:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68F2CB8238E;
        Wed,  6 Apr 2022 13:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 266F7C385B5;
        Wed,  6 Apr 2022 13:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649250614;
        bh=WOI/3Z/LteYjoTuPn50L6YBOOhoxI8VPYVqhUpjr6xI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SMv+u/J9Hy+HsR5lkTQDVZLXutCGi0qWdrRyoFQPT7wn+9SBUGDnHPUDwiOw1HWgq
         SK2D6OSaTHFPnxAaoAakqMJNtQ82pY/fNdDRWqa1O7wSHIFX9dOKx4ES8/xAmGOjJe
         aWbrYsZzf1DqGwGLRiv8ZTdABs0jSGgq6jO14qFaYV0/6Pe8eTyRXkirUif67qkhaf
         l/IsN43YEYJfAzuYarXDZYO2laORmPy0x624ayIqAAP7a/fm9GfYVD9G9EhpcXsr37
         J52GLK5nduYHU1F8llu64uSTf5n91u7Kci7rFnCFBnNAvtM8e0vbtBUnRIz96BWUXq
         U/P3beDnVxl7w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 13165E85BCB;
        Wed,  6 Apr 2022 13:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] net, uapi: remove inclusion of arpa/inet.h
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164925061407.5679.9432370761204809582.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Apr 2022 13:10:14 +0000
References: <20220404175448.46200-1-ndesaulniers@google.com>
In-Reply-To: <20220404175448.46200-1-ndesaulniers@google.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     kuba@kernel.org, jmaloy@redhat.com, ying.xue@windriver.com,
        arnd@arndb.de, masahiroy@kernel.org, dhowells@redhat.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon,  4 Apr 2022 10:54:47 -0700 you wrote:
> In include/uapi/linux/tipc_config.h, there's a comment that it includes
> arpa/inet.h for ntohs; but ntohs is not defined in any UAPI header. For
> now, reuse the definitions from include/linux/byteorder/generic.h, since
> the various conversion functions do exist in UAPI headers:
> include/uapi/linux/byteorder/big_endian.h
> include/uapi/linux/byteorder/little_endian.h
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net, uapi: remove inclusion of arpa/inet.h
    https://git.kernel.org/netdev/net-next/c/1ee375d77bb9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


