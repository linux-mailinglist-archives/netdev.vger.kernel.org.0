Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA7F4DDCDF
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 16:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238016AbiCRPbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 11:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238005AbiCRPbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 11:31:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03EA6FD3C;
        Fri, 18 Mar 2022 08:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93F9960C7E;
        Fri, 18 Mar 2022 15:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09289C340EC;
        Fri, 18 Mar 2022 15:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647617415;
        bh=MwYwxbv4H2vDZdYzgYQgazWn6tOyO+Fl3u/lBvW2CK8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E9iCYBuvEUsRgGpoS6qT+iTNuw4CYlbnfQomOy1e7u6EZ2b2WsYMvil+JqDT99x+K
         kQOvV6zMaMrVa1gsmhoK8dEPyT92+fz61tADi9fXvQ77wMsiIrVClXRhE3JHjIessT
         XHYeuC+ia4hdAlQ5f3dov67eV1c89HDCeCtzk0wlpgcCScm526pDZ3PV6COtosZ3fp
         XYTNxmLJM72TLrYl27j5tahh9ISK5BOuXTuy+wDfUNoPiOxr2ZbRbTmvlWqujwcyCj
         Z5/J34qqKve8fioCM1cXem1RwjkJvG5tvQPP37u/tH97bSH9iuG6P870if4bpDAI3V
         +fmG0B1UDutdw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E0DF9E6D402;
        Fri, 18 Mar 2022 15:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/2] af_vsock: add two new tests for
 SOCK_SEQPACKET
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164761741491.31796.2986635907714259777.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Mar 2022 15:30:14 +0000
References: <97d6d8c6-f7b2-1b03-a3d9-f312c33134ec@sberdevices.ru>
In-Reply-To: <97d6d8c6-f7b2-1b03-a3d9-f312c33134ec@sberdevices.ru>
To:     Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
Cc:     sgarzare@redhat.com, oxffffaa@gmail.com, DDRokosov@sberdevices.ru,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 17 Mar 2022 08:29:50 +0000 you wrote:
> This adds two tests: for receive timeout and reading to invalid
> buffer provided by user. I forgot to put both patches to main
> patchset.
> 
> Arseniy Krasnov(2):
> 
> af_vsock: SOCK_SEQPACKET receive timeout test
> af_vsock: SOCK_SEQPACKET broken buffer test
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/2] af_vsock: SOCK_SEQPACKET receive timeout test
    https://git.kernel.org/netdev/net-next/c/efb3719f4ab0
  - [net-next,v4,2/2] af_vsock: SOCK_SEQPACKET broken buffer test
    https://git.kernel.org/netdev/net-next/c/e89600ebeeb1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


