Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2774AF118
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 13:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbiBIMLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 07:11:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbiBIMLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 07:11:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E255FE02460C;
        Wed,  9 Feb 2022 04:00:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78619616B1;
        Wed,  9 Feb 2022 12:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D9302C340EE;
        Wed,  9 Feb 2022 12:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644408009;
        bh=Fm5+OJPUurlyd7zM2elkix6JLbemo3kzsfDEOCIzb3M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mpF+E9eYevoGovtKDFnbVlmrwB6o2q6FiQ5qpxfosH+GHDDI1ivcTvfExOejGSEE/
         /MzxJOC5pExDuNgtg7LIlTm3RkAhzv5qYUCL4+Nb5jqEmO+5lIu/3VyjATXwjB9r1i
         Lk6e/g11nUfsgAgIz0zmHYk2lx3LilfyyvReqavCqDPeRx7VXwOI/MCbYoIIlkn+Yu
         EyZeLwcR6w6ClWnLE11s2uZVQRbc5sv1DeDw3SGza85pepZ/Wdf5ox0D9qmCzXdt+A
         Cxuqyn+AQSuMe4eYhX2PQEtq7DTMjyyFXHwiDxJPirWeEvVLa2hyx068W42Kr7MkwM
         ochffalcGUBfA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C1A45E5D07D;
        Wed,  9 Feb 2022 12:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ax25: fix NPD bug in ax25_disconnect
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164440800978.11178.6673926020768387853.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 12:00:09 +0000
References: <20220208154000.87070-1-duoming@zju.edu.cn>
In-Reply-To: <20220208154000.87070-1-duoming@zju.edu.cn>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-hams@vger.kernel.org, jreuter@yaina.de, ralf@linux-mips.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  8 Feb 2022 23:40:00 +0800 you wrote:
> The ax25_disconnect() in ax25_kill_by_device() is not
> protected by any locks, thus there is a race condition
> between ax25_disconnect() and ax25_destroy_socket().
> when ax25->sk is assigned as NULL by ax25_destroy_socket(),
> a NULL pointer dereference bug will occur if site (1) or (2)
> dereferences ax25->sk.
> 
> [...]

Here is the summary with links:
  - ax25: fix NPD bug in ax25_disconnect
    https://git.kernel.org/netdev/net/c/7ec02f5ac8a5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


