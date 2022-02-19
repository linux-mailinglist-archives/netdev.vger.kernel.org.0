Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36F404BC58C
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 06:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbiBSFUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 00:20:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231442AbiBSFU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 00:20:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF92340E5
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 21:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F86F60A52
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 05:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF050C340EC;
        Sat, 19 Feb 2022 05:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645248010;
        bh=SE577SCdWOtWKWiLIVjUjn2Xy6ktqn9rt3h8JHvB+us=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IAcmt/qQSivFvImt+D+nGjK7VnMPN7DPyCa3yQsMai5UjYjJpMaEAgkjtX6Rz6rzZ
         Ulw9U+Gdy1DwEiSAffNcg5vvQh/PXRG7g7tD1BVYNBWV0ySHpDhDXlKvW1z4Vf62YB
         OCOZH5ePNBhEUnCzddqTWdrAyW/B7pgtgrz37p1HCam6fVv7QkVqNszA0uXGYBo4XE
         lsrc6LSXU/TSJm8Ij4a7+0fo6UAZpUiV1WejVi+JrXAn8UJ4lI1VqkJ39SGI0sQ4D2
         CRzqMny3VvsU6te2vM8WivingHIhv/hnkhITuvuV4iXa3m5nnLq5tjt/tbSDiO6oM0
         +AkQ41sEyyPzA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C0E2DE7BB08;
        Sat, 19 Feb 2022 05:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] nfp: flower: Fix a potential leak in
 nfp_tunnel_add_shared_mac()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164524801078.20677.8411223569362851752.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Feb 2022 05:20:10 +0000
References: <20220218131535.100258-1-simon.horman@corigine.com>
In-Reply-To: <20220218131535.100258-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, christophe.jaillet@wanadoo.fr
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 18 Feb 2022 14:15:35 +0100 you wrote:
> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> ida_simple_get() returns an id between min (0) and max (NFP_MAX_MAC_INDEX)
> inclusive.
> So NFP_MAX_MAC_INDEX (0xff) is a valid id.
> 
> In order for the error handling path to work correctly, the 'invalid'
> value for 'ida_idx' should not be in the 0..NFP_MAX_MAC_INDEX range,
> inclusive.
> 
> [...]

Here is the summary with links:
  - [net] nfp: flower: Fix a potential leak in nfp_tunnel_add_shared_mac()
    https://git.kernel.org/netdev/net/c/3a14d0888eb4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


