Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5375F6C48A5
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 12:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjCVLKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 07:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCVLKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 07:10:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3170474F8;
        Wed, 22 Mar 2023 04:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A33161FFE;
        Wed, 22 Mar 2023 11:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E19C9C4339B;
        Wed, 22 Mar 2023 11:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679483417;
        bh=6/rVKU7BBNHXroosmUd5/ctFDJhvs+fJ3gcEUfVk79g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DKSTJNXejrRqmXO2y4XFH3SvlteImrp3t69L0X5vDQFfzPoH7vEGyJZgeP3ieArKq
         MgU5OzbFrFeJxKGk3zsXAgWt7YIJgkQh2o6BChaiyp8jnAfMLuTjUTQL3Ojv/8Yn7E
         Oj1wLggZHfspRIslQiH70dGB6orE5qI+cEo2IpZHEySiqZUOKahG8MquRVVe9D0UrF
         hRUnrDW0+OiQTKnAi2hROXHDKSVRnRY4PZdnmWzdpDwJIM5iSDdDKbbf6pBEYE5Tjh
         1x3fP9honfoCzaauOlI9hEkJ/N+mIQUAcX3WsqJbVxbQnPdhP5gJQcT1AOv82uq/GN
         xtYM/zfe1XGHg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C69A0E66C8C;
        Wed, 22 Mar 2023 11:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 net-next] net-sysfs: display two backlog queue len
 separately
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167948341680.30958.12400301569850052617.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Mar 2023 11:10:16 +0000
References: <20230321015746.96994-1-kerneljasonxing@gmail.com>
In-Reply-To: <20230321015746.96994-1-kerneljasonxing@gmail.com>
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     jbrouer@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        stephen@networkplumber.org, simon.horman@corigine.com,
        sinquersw@gmail.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernelxing@tencent.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 21 Mar 2023 09:57:46 +0800 you wrote:
> From: Jason Xing <kernelxing@tencent.com>
> 
> Sometimes we need to know which one of backlog queue can be exactly
> long enough to cause some latency when debugging this part is needed.
> Thus, we can then separate the display of both.
> 
> Signed-off-by: Jason Xing <kernelxing@tencent.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> 
> [...]

Here is the summary with links:
  - [v5,net-next] net-sysfs: display two backlog queue len separately
    https://git.kernel.org/netdev/net-next/c/59da2d7b0e99

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


