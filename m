Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57BBF4FDBBF
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 12:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239486AbiDLKGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 06:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiDLI3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 04:29:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E7A57B25;
        Tue, 12 Apr 2022 01:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DB2060B2A;
        Tue, 12 Apr 2022 08:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6BB9C385A6;
        Tue, 12 Apr 2022 08:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649750412;
        bh=rI1k/sfa+9a5NwVgtPTT47Bk8FOYvyqs6IMCVK25154=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CRLmDwD/+RKwsG+kXWpR2PNf3tTZRVxQKFEKsjrmK2eNW5i9jj62BhCHRY9gznJ/q
         lrThWvCZK2U3r+8xTyJg7JGtxB/9dzNpimv5DPSaCP5LrOVMgBnKSdK+Hmh+aYAET5
         GE11dOB/qqaauCFK4bCmjo8fsyMNdpJg0HCj1PbSQZYkeXEZ6oi9VnRKYyYYf0fPLu
         uq8qFJcT/a7fZc8dyiLpxr+hWjWwlLezHKlD9Spnl2r0mgfelQOhIPjb9eXG2TUeML
         vrSh3lHJoisz6Qf0PVI6jF4F1CCD54sjxNrlvMR0yDvNuELjKFU/CiTzyl506jWqC3
         AolrbIUA+aO5g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 96375E8DBD1;
        Tue, 12 Apr 2022 08:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] sfc: Fix spelling mistake "writting" -> "writing"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164975041261.9548.15429144260111534049.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Apr 2022 08:00:12 +0000
References: <20220411032546.2517628-1-lv.ruyi@zte.com.cn>
In-Reply-To: <20220411032546.2517628-1-lv.ruyi@zte.com.cn>
To:     CGEL <cgel.zte@gmail.com>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lv.ruyi@zte.com.cn, zealci@zte.com.cn
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 11 Apr 2022 03:25:46 +0000 you wrote:
> From: Lv Ruyi <lv.ruyi@zte.com.cn>
> 
> There are some spelling mistakes in the comment. Fix it.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - sfc: Fix spelling mistake "writting" -> "writing"
    https://git.kernel.org/netdev/net-next/c/ac6bef064f71

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


