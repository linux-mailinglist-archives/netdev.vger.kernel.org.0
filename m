Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 585A4653A30
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 01:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234636AbiLVAuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 19:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiLVAuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 19:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7840248DE;
        Wed, 21 Dec 2022 16:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58A576199A;
        Thu, 22 Dec 2022 00:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA232C433F0;
        Thu, 22 Dec 2022 00:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671670216;
        bh=qFCUrtDLsFp8sIV4ZsFx3FGlYXo0JH76avX45gQbjRs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V2m3BRN6PVqBIPjNdQwrctkOkoMkuLH3IlWIeNhPAhtRnwP/7mlrVwB6A971s6RPH
         Eqs/SC5l6n488oygSlGMjkBz4qRoiRlOF6DhGCBSMEq2/L5L31v4nOQHz2BxMYRIIy
         yY0upARFQx/W5k7wyCp+vSqZjoN/rYgmGcptheExFkr8x7Bv5hNMs8DN8Tw2Ke52lm
         LNOjJZ/kWq5LMfDtqXHcNXBRcHskVId2SHUl+eEBQq6NyiJMRn1Iw/62TkqjqngM3p
         pgYaAJT/ll1l1n7XNeXHZKa6EptJdOiupGDggRqGsPClYi2psO/ur2x+LY2xlCtmEi
         Zos7kBOusLJNQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 96722C5C7C4;
        Thu, 22 Dec 2022 00:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-2022-12-21
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167167021661.10797.13522333053068452512.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Dec 2022 00:50:16 +0000
References: <20221221180808.96A8AC433EF@smtp.kernel.org>
In-Reply-To: <20221221180808.96A8AC433EF@smtp.kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 21 Dec 2022 18:08:08 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-2022-12-21
    https://git.kernel.org/netdev/net/c/aa6c3961a3ee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


