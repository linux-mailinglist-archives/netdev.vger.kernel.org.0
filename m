Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 245105F9A49
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 09:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbiJJHoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 03:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbiJJHnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 03:43:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADCF1FCE7
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 00:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 350E3B80E5E
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 07:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D9829C433C1;
        Mon, 10 Oct 2022 07:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665387614;
        bh=WJPdxJxP7i1QVsJqpVp1bmEOYi1iUoaCrPPIz7NLKgc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cBBdE9IQTuSGgOaKMkwIsF2+Y2lx6xY8EsmLJ9T4PUmPpVYw2wIp2al2v1Hnj9gXz
         AEDI+nOT7Q8RTV0H2iDxVRLl9PVDewFla5boGoe7f0v5xMa3+uEsVYH1+tN9NabduM
         fUI4Om1m4rSEog2O1rcYe2VN3cR+lsDFSBpiYablggClM/fQ1kvQu+PDKO4WASGv7h
         FuLJqF/I0dHiyjqW7HA2X1+rGget3xD+BUF4aa3AhnUdqPF2zTW6KssMXg/FhtjhPW
         KAN31pkN3mALKJzRJME4g5Y00MhYO7OcChotoP8JCAx2qDtdjfSYIRDYkpjBXvFb2b
         lvOcBaqkGDVbg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C65B9E2A05A;
        Mon, 10 Oct 2022 07:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [[PATCH net]] ptp: ocp: remove symlink for second GNSS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166538761480.497.15047580142546251473.git-patchwork-notify@kernel.org>
Date:   Mon, 10 Oct 2022 07:40:14 +0000
References: <20221010012934.25639-1-vfedorenko@novek.ru>
In-Reply-To: <20221010012934.25639-1-vfedorenko@novek.ru>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     jonathan.lemon@gmail.com, netdev@vger.kernel.org, vadfed@fb.com
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
by David S. Miller <davem@davemloft.net>:

On Mon, 10 Oct 2022 04:29:34 +0300 you wrote:
> Destroy code doesn't remove symlink for ttyGNSS2 device introduced
> earlier. Add cleanup code.
> 
> Fixes: 71d7e0850476 ("ptp: ocp: Add second GNSS device")
> Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
> ---
>  drivers/ptp/ptp_ocp.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [[PATCH,net] ] ptp: ocp: remove symlink for second GNSS
    https://git.kernel.org/netdev/net/c/84cdf5bcbdce

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


