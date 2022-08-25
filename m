Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2B0F5A0C6D
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 11:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239505AbiHYJU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 05:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238826AbiHYJUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 05:20:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A223B941
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 02:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CB41B827CF
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 09:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 03A21C43140;
        Thu, 25 Aug 2022 09:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661419215;
        bh=uN+ltrGn7ZlDMoXCucnNjNGSuQrhiqFENi//7sqsrtY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UbBy1164NBNkn4y+9fYiQU5B4yQnTTlEI+8dH/O82avWx8P4KoAppBZFCzHwe9VlL
         pSqGjl425Yy/t2nkqfQ6cfwfvvNKZaIBbsllLxuq0Lv8eR63aArJMvD5Ng0EM2fX+t
         YzAEUcYmOILj0TWHugDJ8c4qXAvd5ZExJ1UcOATjVNzWx6eFyhbHeFvsU3qNunUwPW
         MJTaU+DzyGbNWL3yylGhQf0u//1Kc8NJ8azsEUMTmk0UQAubL5tX6LWBQslWv2IgM5
         /FtAraNqs1VGc3fF3JV2Pi+uZe5XcDz95+HrcYmRPYbTtGVuAfKuLM3RMGEpuT3M9b
         3fwf+PR6dxmtQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DD06DC004EF;
        Thu, 25 Aug 2022 09:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: flower: support case of match on
 ct_state(0/0x3f)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166141921490.14119.14804004118564255552.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Aug 2022 09:20:14 +0000
References: <20220823090122.403631-1-simon.horman@corigine.com>
In-Reply-To: <20220823090122.403631-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        wenjuan.geng@corigine.com
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

On Tue, 23 Aug 2022 11:01:22 +0200 you wrote:
> From: Wenjuan Geng <wenjuan.geng@corigine.com>
> 
> is_post_ct_flow() function will process only ct_state ESTABLISHED,
> then offload_pre_check() function will check FLOW_DISSECTOR_KEY_CT flag.
> When config tc filter match ct_state(0/0x3f), dissector->used_keys
> with FLOW_DISSECTOR_KEY_CT bit, function offload_pre_check() will
> return false, so not offload. This is a special case that can be handled
> safely.
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: flower: support case of match on ct_state(0/0x3f)
    https://git.kernel.org/netdev/net-next/c/ff763011ee7b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


