Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A0450B414
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 11:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446119AbiDVJdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 05:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446092AbiDVJdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 05:33:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F064EF6C;
        Fri, 22 Apr 2022 02:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2CA661D65;
        Fri, 22 Apr 2022 09:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 05EA1C385AA;
        Fri, 22 Apr 2022 09:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650619811;
        bh=K4fhb+v7nuPqXAKuBPJ35RyTf0mZgN04+azTXGeyMfM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YvRlwerm6GgjtJfiDzbpG/rGCiX60naKJWC4rtofBpIUUAwplJyEWXjauyS3vU4dh
         aGWc6QGkuwspNt5cPZnZBQ7mv4TkBXoKEpaqkg4NJWx7SIN75FirzBMWdw7uZM03Qj
         pugVzeIcYL0BQaqROF9KEtuY6/Jjinyjg4k2PdCESkGAkPbY9BOm88TUMKnOm2Z/Kg
         gk7SL/jbMU0pHsq0GXygxsOQN1WYUDoQj06cAwsDKhmd8lyjf21dfkSAAxzJmrmaFO
         FYHE8Rzah9857QrmG4eW89rBuFPo9dBC9pV6rwHvQ3dkFc/uUUAaLQxweQxVpV1eRo
         4gVjKxIrVJEWA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D584FE8DD85;
        Fri, 22 Apr 2022 09:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: cosa: fix error check return value of register_chrdev()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165061981087.24106.7289646178993496759.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Apr 2022 09:30:10 +0000
References: <20220418105834.2558892-1-lv.ruyi@zte.com.cn>
In-Reply-To: <20220418105834.2558892-1-lv.ruyi@zte.com.cn>
To:     Lv Ruyi <cgel.zte@gmail.com>
Cc:     kas@fi.muni.cz, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lv.ruyi@zte.com.cn, zealci@zte.com.cn
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 18 Apr 2022 10:58:34 +0000 you wrote:
> From: Lv Ruyi <lv.ruyi@zte.com.cn>
> 
> If major equal 0, register_chrdev() returns error code when it fails.
> This function dynamically allocate a major and return its number on
> success, so we should use "< 0" to check it instead of "!".
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - net: cosa: fix error check return value of register_chrdev()
    https://git.kernel.org/netdev/net/c/d48fea8401cf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


