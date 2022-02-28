Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 885374C7334
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 18:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237631AbiB1ReG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 12:34:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238618AbiB1Rdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 12:33:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C2091AD9;
        Mon, 28 Feb 2022 09:30:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3822EB815BB;
        Mon, 28 Feb 2022 17:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CC5EAC340F1;
        Mon, 28 Feb 2022 17:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646069410;
        bh=M6RlHK50m518zh9g/W6m7lS2gQjIJv2LEskTH0mM9A4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F2eTdYUVmG31/oWZlEVR6gXLyzclsyvcR2PUlLFkN7iZzxE3QbmZO/Gcg1g+swIU5
         d0e5yoDhn4ad7hqSTd7fro1hcZfi6DMKBQPEL59CECVw1ylQRqQ6vyi5zTX36emYfR
         22IHZwHKBcJLc+zg7ypFFBpo/A8SoHloXkrW9JxHvkKfXjWrHem76fCB0Zn37m5QyQ
         OPFK0IlBgzXjkx+gUcF3VqOfFNb+foT0jTloCo4LGGBfU+QO+NZBt+3A0EzYqHwr2R
         G7nxeA+6VCl0z95O1INP1KgRvj9EtSVDQ4gMaQABqsL7I3odalR+8JzJAQ3ZsjI9xV
         v3w0d8kO/ipLw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B30CAE5D087;
        Mon, 28 Feb 2022 17:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf, docs: add a missing colon in verifier.rst
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164606941072.17364.6616334283282888938.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Feb 2022 17:30:10 +0000
References: <20220228080416.1689327-1-wanjiabing@vivo.com>
In-Reply-To: <20220228080416.1689327-1-wanjiabing@vivo.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     corbet@lwn.net, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        jiabing.wan@qq.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 28 Feb 2022 16:04:16 +0800 you wrote:
> Add a missing colon to fix the document style.
> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
>  Documentation/bpf/verifier.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - bpf, docs: add a missing colon in verifier.rst
    https://git.kernel.org/bpf/bpf-next/c/43429ea74a12

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


