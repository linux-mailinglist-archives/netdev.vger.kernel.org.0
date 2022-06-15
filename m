Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB4354C3B1
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 10:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346171AbiFOIkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 04:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245377AbiFOIkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 04:40:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9654A3F7;
        Wed, 15 Jun 2022 01:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDFF7B81D0C;
        Wed, 15 Jun 2022 08:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 44A68C341CA;
        Wed, 15 Jun 2022 08:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655282414;
        bh=n2fFsElexd8WEWd49S2xu0BBvap2b8KGWuyuVp2pN/8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IJqC0MYXjJT5QcMJlW+wWH3SvQFcnDHqEuYMRNsT1CI0cAlgL2QMxD2+YGzOuUAcd
         oXzzxYo/M8kKsR5K+EcNRumOlhj+k9P6SklJs4DkvxiZh5c4OOtTQI57e6WduKNUiY
         BsJi8Rue36DCqC8ehdPmxk23Y8ESbHKq27s9/0MWrM3z45Huu70lVC5vh/VLX99ETZ
         gwEyG0kRJi+nh+2opyjjhE5vCLjTIBkk3yCGjgUI4iMKOb8CKBsyUWvFYOWeK583u3
         irHmN5YyL/tQNSLn1akfJyik7eTaw11/JwsQirpsUXSYkEr/jfuJjF7QO+T/O5bXSN
         AAFYUh/nOXjRw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 30A5DE6D466;
        Wed, 15 Jun 2022 08:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] i40e: add xdp frags support to ndo_xdp_xmit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165528241419.21469.9261512838281384245.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Jun 2022 08:40:14 +0000
References: <20220613165150.439856-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220613165150.439856-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, lorenzo@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        tirthendu.sarkar@intel.com, george.kuruvinakunnel@intel.com
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 13 Jun 2022 09:51:50 -0700 you wrote:
> From: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> Add the capability to map non-linear xdp frames in XDP_TX and ndo_xdp_xmit
> callback.
> 
> Tested-by: Sarkar Tirthendu <tirthendu.sarkar@intel.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] i40e: add xdp frags support to ndo_xdp_xmit
    https://git.kernel.org/netdev/net-next/c/fe63ec97e394

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


