Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 950FF50BC17
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 17:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449613AbiDVPxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 11:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449639AbiDVPxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 11:53:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E2C10FD6;
        Fri, 22 Apr 2022 08:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CACD1B82CC2;
        Fri, 22 Apr 2022 15:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7D947C385A8;
        Fri, 22 Apr 2022 15:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650642611;
        bh=jYrUQp+pDfLbTkFft6bbJHQenAJP3cgQa2l9HU6YEjQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=szs10bFbJGUjZ4FN4qDdLzh8x76Tj9GusytZGuGGwfoLNKYxamXaI5pL5stBFCTyl
         kSx35IO4VUMOQBRJSULBCe2BoTUhqto+YXXIZPNbF2g6AkSj+v/BpArXpKV2Uc6azJ
         rE0km5nDrayiEtdEPTWSnj5NWS5flUq+LYzDcZuceU8w1yi8cjCxyvTfuokTIUxVmD
         NlWGug9/g/iIsRABpC4I/NErzreBwDLvHeOWSJJjICLIHccAVL5h1r9lWgAdk6barS
         7QvDDJWSW48ZG5q9VIr02neJQqhP2li+WsoK6PM7gjopg7octYLyhgPmTDYQilzZdE
         lDh/1MRiCjOtA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 60134EAC09C;
        Fri, 22 Apr 2022 15:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] lwt_bpf: fix crash when using bpf_skb_set_tunnel_key()
 from bpf_xmit lwt hook
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165064261138.24747.17100827889991262378.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Apr 2022 15:50:11 +0000
References: <20220420165219.1755407-1-eyal.birger@gmail.com>
In-Reply-To: <20220420165219.1755407-1-eyal.birger@gmail.com>
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, mkl@pengutronix.de,
        tgraf@suug.ch, shmulik.ladkani@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, stable@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Wed, 20 Apr 2022 19:52:19 +0300 you wrote:
> xmit_check_hhlen() observes the dst for getting the device hard header
> length to make sure a modified packet can fit. When a helper which changes
> the dst - such as bpf_skb_set_tunnel_key() - is called as part of the xmit
> program the accessed dst is no longer valid.
> 
> This leads to the following splat:
> 
> [...]

Here is the summary with links:
  - [bpf] lwt_bpf: fix crash when using bpf_skb_set_tunnel_key() from bpf_xmit lwt hook
    https://git.kernel.org/bpf/bpf/c/b02d196c44ea

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


