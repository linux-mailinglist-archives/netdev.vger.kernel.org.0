Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1225578798
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 18:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235306AbiGRQkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 12:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235214AbiGRQkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 12:40:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89620B7F2
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 09:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BA81B816A1
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 16:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DEE03C341CE;
        Mon, 18 Jul 2022 16:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658162412;
        bh=acbFGSje5RIv0UFmvkKgw5L1ga2zBFlDC+E2tSeOTYM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Laym5PPPuQmn5Tesw0ehbSzKEjncI9SNsYM6W9Ha+LcnnZKXLimJwZ/izFps42GEZ
         hCNLIaPeRK44MmiTHE813/d7cKzUQBIR+/Eqi8K1J6eBaB/iS7GPmZWTenlvdTcXF1
         mLMdISUpHJGMhqF46gkhSo/qN6uiuX83B6svmhxyoOzH/baTygMPEOeNYXa70Vq9Yc
         Lm2mWg2wTfQN8qg3/1YWaCTmk5jWk3CRLYP4jJ4XlBBxx/Po+TQafkCictkLgZwASe
         zvmEvYGD7EWlTaka2QB/5mUzthOjzg7G2gR6O+VJ+16+R9vh7rd5MEUwaYoeSRELFV
         o1gPMWo6qZsGQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C3E60E451AD;
        Mon, 18 Jul 2022 16:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] uapi: add vdpa.h
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165816241279.22901.10228940243657683172.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Jul 2022 16:40:12 +0000
References: <20220718163112.11023-1-stephen@networkplumber.org>
In-Reply-To: <20220718163112.11023-1-stephen@networkplumber.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     parav@nvidia.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Mon, 18 Jul 2022 09:31:13 -0700 you wrote:
> Iproute2 depends on kernel headers and all necessary kernel headers
> should be in iproute tree. When vdpa was added the kernel header
> file was not.
> 
> Fixes: c2ecc82b9d4c ("vdpa: Add vdpa tool")
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> 
> [...]

Here is the summary with links:
  - [iproute2] uapi: add vdpa.h
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=291898c5ff88

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


