Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDD8698B1C
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 04:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjBPDUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 22:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBPDUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 22:20:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311944C0C
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 19:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D956FB8250D
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 03:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 908D5C4339C;
        Thu, 16 Feb 2023 03:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676517617;
        bh=8NHn6VdKmI/xRIUDKwYgIbZ3NyPBK5jc5xiBk/fK0YQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l4uLC7pb5PmD8rliE0qMqrCPgILviXBnl/Y7u//1esBfQzvBWbqu9GlSuNwzd8tFo
         OAm+VVQjxei6iBqBAi1N37Opc2y3gQSy12xJver+G95gUjQgTH8I9SxZ/TJdvOIsHH
         radNvm9ZwjvGC+ApuFTsJdSyfKlZXWifO9ntdT1QSMGIm9ZpUKa5f1/00NaoN2pGDz
         p72ncjx77djdTTpimkaBpqBiYqIHmwZKHqcjPelD8n2vMBMQUMzlFWUUuQPolF+9qb
         nkcDsOeVnnhy65aDJxI3b2HPcqPvghasLT2FohDwc96r2ZJKmG31ww/1ukn63gCd7X
         DRO3flQhvwVLA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 78C57E29F41;
        Thu, 16 Feb 2023 03:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] ice: update xdp_features with xdp multi-buff
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167651761749.25163.14521954005933969050.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Feb 2023 03:20:17 +0000
References: <8a4781511ab6e3cd280e944eef69158954f1a15f.1676385351.git.lorenzo@kernel.org>
In-Reply-To: <8a4781511ab6e3cd280e944eef69158954f1a15f.1676385351.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        intel-wired-lan@lists.osuosl.org, lorenzo.bianconi@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 14 Feb 2023 15:39:27 +0100 you wrote:
> Now ice driver supports xdp multi-buffer so add it to xdp_features.
> Check vsi type before setting xdp_features flag.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> Changes since v1:
> - rebase on top of net-next
> - check vsi type before setting xdp_features flag
> 
> [...]

Here is the summary with links:
  - [v2,net-next] ice: update xdp_features with xdp multi-buff
    https://git.kernel.org/netdev/net-next/c/b6a4103c3538

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


