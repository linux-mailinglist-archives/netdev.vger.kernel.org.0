Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C21AF627AF9
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 11:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236065AbiKNKuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 05:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235809AbiKNKuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 05:50:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7493518390
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 02:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB94DB80DA0
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 10:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6BC28C4347C;
        Mon, 14 Nov 2022 10:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668423015;
        bh=X11wx0DILXEm4mgENNlU+bY2jT8UlIax54MU/oc7Prs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Xj+4dBFOpHPNNQYmyVhbbdIwlHrtA8NUgRvViF3zbR+6hAWl5CS8qi6OL8fbyooB9
         1mZjeggQdx4IeWF53DNG1YcycnlIG6GbiyRnCUp9l81C+nyl9ZOWqdehS324lrNtFl
         L1dzqqH5ARb85dniDyjhXyueE2RPXJtLXwCmcblhQhujYH6mpcZ4y7kmBqUTZhIpBI
         NiPyDl/kbnqy1shUemyKgw11neA2nTowtJ/I2VBwAw5GpV5enhtNp3ydjGxqHcgVCh
         G+K8Bo82SIaYQL99BAmTLf4Cg9VLTOV/GiJBV1rNXWYyfxnX8d6YfzzbJDfmuTz3lF
         VTO05knhzLVmQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 58F28E270C2;
        Mon, 14 Nov 2022 10:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ice: virtchnl rss hena support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166842301536.7392.6054904257341453301.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Nov 2022 10:50:15 +0000
References: <20221110130353.3040-1-wojciech.drewek@intel.com>
In-Reply-To: <20221110130353.3040-1-wojciech.drewek@intel.com>
To:     Wojciech Drewek <wojciech.drewek@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Thu, 10 Nov 2022 14:03:53 +0100 you wrote:
> From: Md Fahad Iqbal Polash <md.fahad.iqbal.polash@intel.com>
> 
> Add support for 2 virtchnl msgs:
> VIRTCHNL_OP_SET_RSS_HENA
> VIRTCHNL_OP_GET_RSS_HENA_CAPS
> 
> The first one allows VFs to clear all previously programmed
> RSS configuration and customize it. The second one returns
> the RSS HENA bits allowed by the hardware.
> 
> [...]

Here is the summary with links:
  - [net-next] ice: virtchnl rss hena support
    https://git.kernel.org/netdev/net-next/c/e384cf35bf0c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


