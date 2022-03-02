Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 037BE4C9AA1
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 02:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238954AbiCBBk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 20:40:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238931AbiCBBkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 20:40:55 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED50EA2508;
        Tue,  1 Mar 2022 17:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0A825CE2082;
        Wed,  2 Mar 2022 01:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 134CEC340F0;
        Wed,  2 Mar 2022 01:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646185210;
        bh=yiu2oVO8iMfUx8EITjMvjJ0JsQ6koCRlfPLhskhPshw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mCDoiTtw0T88xtrDgZ8GvcOrpJpL/HbGqFUfXy+tPngi0wtZZm+Vqf0LIHZoyqAfY
         9JEdSVry3XnnuwwtThP4Uauz+NC4gy+p8wVhAjnpyrTLzbsSKfTfHXOKLbb5yWsiAW
         BCgz4xHr088dHv1eeltEILX8/XtrKqu4GuQ8VRgLqmvg04WIkp/8Pybofzv1sRLA9g
         0qAzWkjQnXUDvf5CY25Ektbfyv5K0TQloxTo0De9QnXTYn0/iUS3ksf7SYfbeZrbHs
         /kFsXk5CRzirj9uyuVBR+pScsPJ2O3IFfcTfnNNMPici54dhmtlxqZGm/a2v8jy28X
         6ya7T3dGJ4VsQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EA678EAC096;
        Wed,  2 Mar 2022 01:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] tun: support NAPI for packets received from
 batched XDP buffs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164618520995.21891.13359440725672676433.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Mar 2022 01:40:09 +0000
References: <20220228033805.1579435-1-baymaxhuang@gmail.com>
In-Reply-To: <20220228033805.1579435-1-baymaxhuang@gmail.com>
To:     Harold Huang <baymaxhuang@gmail.com>
Cc:     netdev@vger.kernel.org, jasowang@redhat.com, pabeni@redhat.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 28 Feb 2022 11:38:05 +0800 you wrote:
> In tun, NAPI is supported and we can also use NAPI in the path of
> batched XDP buffs to accelerate packet processing. What is more, after
> we use NAPI, GRO is also supported. The iperf shows that the throughput of
> single stream could be improved from 4.5Gbps to 9.2Gbps. Additionally, 9.2
> Gbps nearly reachs the line speed of the phy nic and there is still about
> 15% idle cpu core remaining on the vhost thread.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] tun: support NAPI for packets received from batched XDP buffs
    https://git.kernel.org/netdev/net-next/c/fb3f903769e8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


