Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22CB058D28F
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 06:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbiHIEAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 00:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233488AbiHIEAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 00:00:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A0CEB1;
        Mon,  8 Aug 2022 21:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01048B8118D;
        Tue,  9 Aug 2022 04:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9E173C43470;
        Tue,  9 Aug 2022 04:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660017614;
        bh=KyvX/gILUlR+8s7n8GEyEi0pPMpiGZvg9KqKkd9tYeY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p3Hje8Nos/gTvlUZZfwvFqEZ+DZ2H/Q0j8AI/oG+airfMltUEccqLK0JZbqpwGMd6
         W+gdg5RsR89qVc/3eYdACTsLmzJG7cX+ag33m1pY6Sjs/IyBic/ASejquaauf5cG1Q
         KMVOC1ziftnE2pQCpVWSZvZlJoK3Sn5JSmpR1m1INRT10KwNnX3tcfGycOzO0ClJ4V
         u3D8uIUDBldTIUVQroJBLPVpzDb7d+qxzqxXsUkAD7CtgNC9GwejhOazaicTQgJ3rX
         7chL/kH6ctSeXPx1u5tK6uIC83YCbWYecQFkV1VFpCgMHJM5YeJ0/6Z7K/bjnPK8s0
         fhp+raoOUOP8Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8556CC43146;
        Tue,  9 Aug 2022 04:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: phy: dp83867: fix get nvmem cell fail
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166001761454.6286.13550371941501693473.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Aug 2022 04:00:14 +0000
References: <20220805084843.24542-1-nikita.shubin@maquefel.me>
In-Reply-To: <20220805084843.24542-1-nikita.shubin@maquefel.me>
To:     Nikita Shubin <nikita.shubin@maquefel.me>
Cc:     linux@yadro.com, n.shubin@yadro.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@rasmusvillemoes.dk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri,  5 Aug 2022 11:48:43 +0300 you wrote:
> From: Nikita Shubin <n.shubin@yadro.com>
> 
> If CONFIG_NVMEM is not set of_nvmem_cell_get, of_nvmem_device_get
> functions will return ERR_PTR(-EOPNOTSUPP) and "failed to get nvmem
> cell io_impedance_ctrl" error would be reported despite "io_impedance_ctrl"
> is completely missing in Device Tree and we should use default values.
> 
> [...]

Here is the summary with links:
  - net: phy: dp83867: fix get nvmem cell fail
    https://git.kernel.org/netdev/net/c/546b9d3f406a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


