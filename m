Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1B557CEC5
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 17:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiGUPUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 11:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGUPUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 11:20:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57EC19C03
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 08:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E73BB82579
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 15:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 059F8C341C0;
        Thu, 21 Jul 2022 15:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658416814;
        bh=h8P1bCFT3ZD2kG3/8vJzxb748Uqp+YZmu7XylMiDQGw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JkPZ6y7JMNL72afUh/cdSfqn3xJz2WdHOMz7cFKx5UmOnFKAkuOUxE1L7Hkx1vPqY
         ixAb/AI+3CwgsXJW5bgsBPwIjYD8KmKeTspx5zZivifP+kRaZq2Bp5vNn2htyzxIye
         FbF7fnhxmZOXMnI4kpQPf2z1gdO2T2O94Zr7jTvevwkq9B8DDb6aItIvOkye/MJUCo
         QXsbvk0hULu1l6lCE8Ulf+TV8R3zdfn8SFUwZ+vRktRC61UBiJ6XbIm5nTu5lgrZ24
         DXCUjIri5xDcVwhHji9WdDx9/B3VLXY4HtROfBkLNgLXfAUtyf2KMKTtAUZ41WbMO1
         nr5DwpEQlUcAA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DA313D9DDDD;
        Thu, 21 Jul 2022 15:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] vdpa: Update man page to include vdpa statistics
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165841681388.31374.12121940957879236613.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Jul 2022 15:20:13 +0000
References: <20220721060007.32250-1-elic@nvidia.com>
In-Reply-To: <20220721060007.32250-1-elic@nvidia.com>
To:     Eli Cohen <elic@nvidia.com>
Cc:     dsahern@kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org, jasowang@redhat.com,
        si-wei.liu@oracle.com, mst@redhat.com, eperezma@redhat.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Thu, 21 Jul 2022 09:00:07 +0300 you wrote:
> Update the man page to include vdpa statistics information inroduce in
> 6f97e9c9337b ("vdpa: Add support for reading vdpa device statistics")
> 
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> ---
>  man/man8/vdpa-dev.8 | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)

Here is the summary with links:
  - vdpa: Update man page to include vdpa statistics
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=50ec8f05f8cb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


