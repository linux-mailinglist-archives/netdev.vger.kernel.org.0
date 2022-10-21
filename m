Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC0D606F37
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 07:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiJUFLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 01:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiJUFKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 01:10:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48439182C73;
        Thu, 20 Oct 2022 22:10:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C5BB61DDA;
        Fri, 21 Oct 2022 05:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E351FC43140;
        Fri, 21 Oct 2022 05:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666329021;
        bh=F/tMApnh/5WoApY+2keidp9qeW8jwikBGU0pQPU4Y7Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p7gDyh7VB4CHHiykHCxcvnRGO3QP+jr+M2gPudXzlB0kmsE7jETV0DclVAcA7ll4z
         DpkY8MqVi5lJBC8jnj9/7cRVUU6e8c5cswohlZahRWdJT6Vf3Haxk7173uJp0sTEhH
         JD1ixhtApGsrLEDvFDJ8zW+BMWer8t1wlfhays4qvxiLu6jucVL6uXRA1WhDcaEApP
         lVvyZgHV6isq9CbTRmIgY4/af1QpByvyYvcB7TcLTX+Sv9GSRI4BEXkXC9aAxvYxLK
         nMkm7kvWLAKCioaT3UycTzPKQSMSuWmffAvMEQuUZ/yhHD3x5vWo2GGWNyVv1Af+X3
         +2ZxaAXpKZ7jg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D0971E270DF;
        Fri, 21 Oct 2022 05:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/3] sctp: remove unnecessary NULL check in
 sctp_association_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166632902185.25874.4878921134477638550.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Oct 2022 05:10:21 +0000
References: <20221019180735.161388-1-aleksei.kodanev@bell-sw.com>
In-Reply-To: <20221019180735.161388-1-aleksei.kodanev@bell-sw.com>
To:     Alexey Kodanev <aleksei.kodanev@bell-sw.com>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 19 Oct 2022 21:07:33 +0300 you wrote:
> '&asoc->ulpq' passed to sctp_ulpq_init() as the first argument,
> then sctp_qlpq_init() initializes it and eventually returns the
> address of the struct member back. Therefore, in this case, the
> return pointer cannot be NULL.
> 
> Moreover, it seems sctp_ulpq_init() has always been used only in
> sctp_association_init(), so there's really no need to return ulpq
> anymore.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] sctp: remove unnecessary NULL check in sctp_association_init()
    https://git.kernel.org/netdev/net-next/c/6fdfdef7fdb5
  - [net-next,2/3] sctp: remove unnecessary NULL check in sctp_ulpq_tail_event()
    https://git.kernel.org/netdev/net-next/c/b66aeddbe30c
  - [net-next,3/3] sctp: remove unnecessary NULL checks in sctp_enqueue_event()
    https://git.kernel.org/netdev/net-next/c/377eb9aab084

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


