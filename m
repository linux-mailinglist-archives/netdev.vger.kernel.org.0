Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50DCF50B68A
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 13:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447240AbiDVLxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 07:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447229AbiDVLxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 07:53:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C6C5620B;
        Fri, 22 Apr 2022 04:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E6AB61FAA;
        Fri, 22 Apr 2022 11:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B2785C385A4;
        Fri, 22 Apr 2022 11:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650628211;
        bh=PcOw9NQ5C+DnDyFKtqNAXsbbphJJFP39CACPGGQ2kPI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VLijD5h0N6yKyMZMFcvK/7sWmsVH6/KJyPrl0cZQwcGL64rg6m1cWvd+BpsDTf/dq
         kbOfxtiTIHFLWvIlpAmf0LRUu1IZbfwpLZkp1Y74pA24FApj3IF3OK0E2BiFO+Dw+L
         6U3LtvzrI0+1+L7a33rUCDdrdD+dIfisCOkOfDfEGGjc8eydJItwH60xn5vzXPnHVx
         kE+FhMh+w2d/nZL4wPngW0zli7R7krjCQD4t/4f0VPlN+VNsFon1r9lU/jKTUKdsmN
         sE2TFcoDvM3DzqEta/6vaLGY4vihu7OIE8ifrhLemQxSxLt4VeFhk5C01JObGa8czS
         /YsGxb7T9F1NQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 92D7CE8DBDA;
        Fri, 22 Apr 2022 11:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] USB2NET : SR9800 : change SR9800_BULKIN_SIZE from global to
 static
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165062821159.27289.12403848172811597562.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Apr 2022 11:50:11 +0000
References: <20220419140625.2886328-1-trix@redhat.com>
In-Reply-To: <20220419140625.2886328-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 19 Apr 2022 10:06:25 -0400 you wrote:
> Smatch reports this issue
> sr9800.h:166:53: warning: symbol 'SR9800_BULKIN_SIZE' was not declared. Should it be static?
> 
> Global variables should not be defined in header files.
> This only works because sr9800.h in only included by sr9800.c
> Change the storage-class specifier to static.
> And since it does not change add type qualifier const.
> 
> [...]

Here is the summary with links:
  - USB2NET : SR9800 : change SR9800_BULKIN_SIZE from global to static
    https://git.kernel.org/netdev/net-next/c/0844d36f771d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


