Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF97566738
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 12:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbiGEKAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 06:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiGEKAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 06:00:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4002C5;
        Tue,  5 Jul 2022 03:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67253B81749;
        Tue,  5 Jul 2022 10:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F28CDC341CE;
        Tue,  5 Jul 2022 10:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657015213;
        bh=uyjhZ0+OrDJr4bdp2Xz/rqbgxHPp2h4uCgPTZOGNsBU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KXss+XSRPUWNPeo4G46/sYL0eRytVJFK4c7dNX5+J8Mjee6wRpMjkVKz0ejR92xyP
         YStWpoFI5c6z16tR5rUqqWeBisfzRhjXJ1CF0CafAU323SqQGxF3hcifBO6CsAbv57
         o0CjD3yUIAEnWamIm/XLJljTSR8SfoWeM5XeH+dXxJi1pWxT6Ql8yaHtZfT2DhE3h1
         e/xXcGcR5b+mOrCOaLD1Pcr/yTjwoRo9MuirzXkyh9aUfuR0g4Ha2ihqChJQEbnr4N
         M/59X4sLa2hrRgO97cFq4DZrAyJhkRgs/ZMPwdoZO/8fvOhOQgV2eXL/mHTHhJWAQ5
         cwPirv5DbQNaA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D5B6AE45BDD;
        Tue,  5 Jul 2022 10:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpftool: Rename "bpftool feature list" into "...
 feature list_builtins"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165701521287.30326.7702263018188523764.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Jul 2022 10:00:12 +0000
References: <20220701093805.16920-1-quentin@isovalent.com>
In-Reply-To: <20220701093805.16920-1-quentin@isovalent.com>
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Fri,  1 Jul 2022 10:38:05 +0100 you wrote:
> To make it more explicit that the features listed with "bpftool feature
> list" are known to bpftool, but not necessary available on the system
> (as opposed to the probed features), rename the "feature list" command
> into "feature list_builtins".
> 
> Note that "bpftool feature list" still works as before given that we
> recognise arguments from their prefixes; but the real name of the
> subcommand, in particular as displayed in the man page or the
> interactive help, will now include "_builtins".
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpftool: Rename "bpftool feature list" into "... feature list_builtins"
    https://git.kernel.org/bpf/bpf-next/c/990a6194f7e1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


