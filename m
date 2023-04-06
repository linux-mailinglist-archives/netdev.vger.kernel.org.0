Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27ED96D9897
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 15:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238771AbjDFNu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 09:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238827AbjDFNuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 09:50:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D478A6D
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 06:50:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86F886481C
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 13:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E10CDC4339B;
        Thu,  6 Apr 2023 13:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680789019;
        bh=jzwVHo2yS36TIQl8R0Iwi1Iy8UhlJE/Msk6QsqYSd8k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iJMrD7QJHnvvlZ89IHVmqbneLgky2dodFjSensOwb2s1OHlhGGTuETF4QEWdF/7AV
         N+6oxiT0iVyDCzQzmhMbSuvECWh56izi1WZQpqOBk6l1Xw6vSzppgkDiaeQKHjZEUC
         CwIDgP2kqPnzDOR0bOeKB+VKhx+QHUuE25Zl1nyflYJrN3GVGdDT8pJycK+FuM6Od7
         TnqEv0YOyoOG3LlDr4WckBOn9Pb2SHDeFHo6ODh3VJkNcZEXKobaBTAe5BxnCB+Tu1
         /hFSO0hnn4O5kCCcZYuhmHXtSfgoPME7NFI+KCL6daRVE5Hk1DFHVzib5fgbIu9zu7
         AiNaNpgDJx+YA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C676EE5EA85;
        Thu,  6 Apr 2023 13:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] nfp: initialize netdev's dev_port with correct id
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168078901880.17216.8863252682451924859.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Apr 2023 13:50:18 +0000
References: <20230405120829.28817-1-louis.peens@corigine.com>
In-Reply-To: <20230405120829.28817-1-louis.peens@corigine.com>
To:     Louis Peens <louis.peens@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        leonro@nvidia.com, simon.horman@corigine.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com
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

On Wed,  5 Apr 2023 14:08:29 +0200 you wrote:
> From: Yinjun Zhang <yinjun.zhang@corigine.com>
> 
> `dev_port` is used to differentiate devices that instantiate from
> the same function, which is the case in most of NFP NICs.
> 
> In some customized scenario, `dev_port` is used to rename netdev
> instead of `phys_port_name`. Example rules using `dev_port`:
> 
> [...]

Here is the summary with links:
  - [net-next,v2] nfp: initialize netdev's dev_port with correct id
    https://git.kernel.org/netdev/net-next/c/0ebd4fd6b906

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


