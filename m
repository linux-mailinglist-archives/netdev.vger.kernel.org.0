Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12F714E5D92
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 04:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344815AbiCXDbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 23:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235030AbiCXDbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 23:31:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA5795A04
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 20:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B4E9B8220E
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 03:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BB00BC340E9;
        Thu, 24 Mar 2022 03:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648092610;
        bh=pHix/1yng0yZb/bAjNgkFL2iKbYAeQv3MaRiFqL2+IU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ophUKo9wq8iCg2ATlAhbjpam7Se6pCmy8wfpivH4P+MhNzsQpXbAOXhWuo6ZwcxpT
         DI7lUpjn86fTAV/deTjS66bjDUSQFi7wLocLMfCwNI5pk5DsTHwsumJhDeah06ckgg
         +k+zhz93rBLi7VMvRtj7AhjVxqa2lj7KgHxRHji+QGKZKZd7yK8mbn+OmCpxddVCam
         sHj+QDe8yywHCUCmbCI2LaUW6oGqDzivU0VdAIvt70A4aluk6c5k0POs9otFoDSErb
         hmaEvCRI9mgEQJwb4cfLf3napP3PTXkZl6v/KGre/LGVuFZYOmdPenzo3/g2D6nzM4
         HCBhhHmBopfdQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9F2E1E6D44B;
        Thu, 24 Mar 2022 03:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next 0/2] ss: remove implicit dependency on rpcinfo
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164809261064.4724.12273301402459681800.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Mar 2022 03:30:10 +0000
References: <cover.1647455133.git.aclaudi@redhat.com>
In-Reply-To: <cover.1647455133.git.aclaudi@redhat.com>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Wed, 16 Mar 2022 19:52:12 +0100 you wrote:
> ss uses rpcinfo to get info about rpc service sockets. However, rpcinfo
> is not part of iproute2 and it's an implicit dependency for ss.
> 
> This series uses libtirpc[1] API to implement the same feature of
> rpcinfo for ss. This makes it possible to get info about rpc sockets,
> provided ss is compiled with libtirpc support.
> 
> [...]

Here is the summary with links:
  - [iproute2-next,1/2] configure: add check_libtirpc()
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=1ee309a49aa0
  - [iproute2-next,2/2] ss: remove an implicit dependency on rpcinfo
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=292509f95dd4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


