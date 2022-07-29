Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5630584F77
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 13:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235994AbiG2LUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 07:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235968AbiG2LUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 07:20:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7836409;
        Fri, 29 Jul 2022 04:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69A6761EA4;
        Fri, 29 Jul 2022 11:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6309C43141;
        Fri, 29 Jul 2022 11:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659093614;
        bh=eEPEsg3j+el7T1esBcS83NVmA/pqk197S9EqxSKz7MI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=culyKAeUUbECUpEsKznpPKviwh+mEbnm53wD/yjCrHt3PtY8p2ongVUvWr1V1fDU9
         mBMKQpxMpN9l4xUiLEulJ8U3oHQvqIVNdKlwtOr/Dpf8XfuLrt0v+iT5FEcPRAfHX8
         Jtz2x7HkW9BbYRMcZqMcbb5WXvA3MUFT+X4aQY3jV3xE7ivGfp2u2hPsmkckh5byCT
         ANIHoau5lFEnd+5nZHJyp1frBLlPo56TyC9jFNI2N6KqaaGu6Oo65BuNeLRFQz0TsV
         CNfZyfJ2NRu7W8VFmm5SYmWqf8BVcT/ipi+F8JxL9P3ByI9vg2DfWa1k+n9JScdSbv
         hwwcLeq2rijng==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9C259C43144;
        Fri, 29 Jul 2022 11:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v5 0/4] seg6: add support for SRv6 Headend Reduced 
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165909361463.23060.15495009897031154291.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jul 2022 11:20:14 +0000
References: <20220727185408.7077-1-andrea.mayer@uniroma2.it>
In-Reply-To: <20220727185408.7077-1-andrea.mayer@uniroma2.it>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        shuah@kernel.org, anton.makarov11235@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, stefano.salsano@uniroma2.it,
        paolo.lungaroni@uniroma2.it, ahabdels.dev@gmail.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 27 Jul 2022 20:54:04 +0200 you wrote:
> This patchset adds support for SRv6 Headend behavior with Reduced
> Encapsulation. It introduces the H.Encaps.Red and H.L2Encaps.Red versions
> of the SRv6 H.Encaps and H.L2Encaps behaviors, according to RFC 8986 [1].
> 
> In details, the patchset is made of:
>  - patch 1/4: add support for SRv6 H.Encaps.Red behavior;
>  - Patch 2/4: add support for SRv6 H.L2Encaps.Red behavior;
>  - patch 2/4: add selftest for SRv6 H.Encaps.Red behavior;
>  - patch 3/4: add selftest for SRv6 H.L2Encaps.Red behavior.
> 
> [...]

Here is the summary with links:
  - [net-next,v5,1/4] seg6: add support for SRv6 H.Encaps.Red behavior
    https://git.kernel.org/netdev/net-next/c/b07c8cdbe918
  - [net-next,v5,2/4] seg6: add support for SRv6 H.L2Encaps.Red behavior
    https://git.kernel.org/netdev/net-next/c/13f0296be8ec
  - [net-next,v5,3/4] selftests: seg6: add selftest for SRv6 H.Encaps.Red behavior
    https://git.kernel.org/netdev/net-next/c/6ab4eb5a52a7
  - [net-next,v5,4/4] selftests: seg6: add selftest for SRv6 H.L2Encaps.Red behavior
    https://git.kernel.org/netdev/net-next/c/95baa4e8fe69

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


