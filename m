Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0500B55A461
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 00:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbiFXWaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 18:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbiFXWaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 18:30:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D7D87D47;
        Fri, 24 Jun 2022 15:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65D59623E4;
        Fri, 24 Jun 2022 22:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B80E6C3411C;
        Fri, 24 Jun 2022 22:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656109812;
        bh=46jOEpmGjXiyFeBBgverTvj9yURNB8k6scYDNE2OVUw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JXzf7Jt2Sw2z2I2Q/CId2rIq5Z9b5oQzzxtz8RRub0AkCd/EDSv085gS3dSin8v7q
         aJ1MERQtiwGe76Z2IpfIGJILroPmsiiRoxgl6g7qnQ/uFnWnG5NGjIvZsqF7uZLSOL
         ptaY4/k7oqLFIGJmGh+543gRJ7iez94j7LsjQCCWy/Kn7kcDjuI3TmncnK6+b+TyDa
         w3EF34VndDj5dJl4QiaPy5Iou9rRmM0baREOxTkVudTQC4JUViKambtoJMkSlLl/8v
         /kSlT+wgV97iLrZFaFr2Q9xpshzH7yeFngICrj549UkOwktKi1cpaNCRZYqYIqwquV
         sW6sl8J1mL2iw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9BFD0E85DBE;
        Fri, 24 Jun 2022 22:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] fprobe, samples: Add module parameter descriptions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165610981263.18572.3699045881023144660.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Jun 2022 22:30:12 +0000
References: <165602349520.56016.1314423560740428008.stgit@devnote2>
In-Reply-To: <165602349520.56016.1314423560740428008.stgit@devnote2>
To:     Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        jolsa@kernel.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
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

This patch was applied to bpf/bpf.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Fri, 24 Jun 2022 07:31:35 +0900 you wrote:
> From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> 
> Add module parameter descriptions for the fprobe_example module.
> 
> Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> ---
>  samples/fprobe/fprobe_example.c |    7 +++++++
>  1 file changed, 7 insertions(+)

Here is the summary with links:
  - [bpf] fprobe, samples: Add module parameter descriptions
    https://git.kernel.org/bpf/bpf/c/179a93f74b29

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


