Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D42474C6D78
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 14:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234820AbiB1NLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 08:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbiB1NLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 08:11:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D89178074;
        Mon, 28 Feb 2022 05:10:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC004B81157;
        Mon, 28 Feb 2022 13:10:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 60371C340F0;
        Mon, 28 Feb 2022 13:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646053830;
        bh=ZBuUlcgZuwhB4Zj01JBCKDbi1zNnOuUJtxYFgINRXVs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eCV0LMY8Aavy6n3Wa2pkNsVmy+8383KerJdnoHlIbonORPwIGyrEabKoxwhUFsp9i
         ANHucHxM1pmqeDglaLj5DRY6Nh6SNsvOmMXC2FwqeM1XSAf9Qs6Iipm2MAbuPQx4vk
         5wKETAU2grL1p+10TiaUtegaCOTZknrsNWKATqgoEqFsSGIKbkz7yxxmEzgsG23CZs
         EipN0EZiTr2ArDQK1DSiJKOFe3DNZUXMpvqo6SsuCoHN3t7JagcLg9wNPsr3CGgZnN
         npt9wZcPc6BzTP3RF6IZf9LLdRK3zXahBQoWAsO9JdF1Cz+xCx6Nd/fwjYn8F+xoWk
         H8AdkM/A1D6Og==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3BEC1E5D087;
        Mon, 28 Feb 2022 13:10:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] Update L7 BPF maintainers / mailmap
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164605383024.32298.17156248466124593273.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Feb 2022 13:10:30 +0000
References: <20220222103925.25802-1-lmb@cloudflare.com>
In-Reply-To: <20220222103925.25802-1-lmb@cloudflare.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
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

This series was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 22 Feb 2022 10:39:23 +0000 you wrote:
> Hi,
> 
> I'm leaving my position at Cloudflare, so I'm stepping down from the
> sockmap maintainership. I'm also adding a new email address where people
> can reach me.
> 
> Best
> Lorenz
> 
> [...]

Here is the summary with links:
  - [1/2] bpf: remove Lorenz Bauer from L7 BPF maintainers
    https://git.kernel.org/bpf/bpf/c/f54eeae970f4
  - [2/2] mailmap: update Lorenz Bauers address
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


