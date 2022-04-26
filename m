Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A485350F8CB
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 11:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344855AbiDZJlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 05:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348889AbiDZJkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 05:40:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1509F101CB
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 02:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDDAFB81CFE
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 09:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 95FE3C385BD;
        Tue, 26 Apr 2022 09:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650963612;
        bh=QcrG3KciO2wJ1kY69/0GB1lZbREWMESk/q7PgYjjtGU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HttUs2y+uGbXHpO3EkxhipROSeQlwTaQw0/Z6fgX8dBVVBxzjA234a9cLpTZwQgOr
         det+g2tCP6hUBzXzc4YPgU/pw5jGpu0HF/tt0vdMRdeWEw9uQfKSETIPkDgmFi4ksG
         BPqMPBWKisNfCQz5LHStKLg/7ihNXlQKznkORIaNZpROAAc0AVA/RyZLpYIdj3OU3O
         JTY+e0A4GIMSDw/+tYh9ziCDQKVxT+HdPpQm3jeGyKdsUjDkODXG5irBX+N2QqbIdQ
         luG/1YdKOUk5K4imZcdseMPuzt+XBDpj64ycyJBhC5QM5NPas9fgLm4YFGX/dKzfu7
         oHAcG7+sKA04g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 70D7EE8DD67;
        Tue, 26 Apr 2022 09:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next RESEND] net: bcmgenet: hide status block before TX
 timestamping
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165096361245.8352.8025964600416959573.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Apr 2022 09:00:12 +0000
References: <20220424165307.591145-1-jonathan.lemon@gmail.com>
In-Reply-To: <20220424165307.591145-1-jonathan.lemon@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     opendmb@gmail.com, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        kernel-team@fb.com, kuba@kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 24 Apr 2022 09:53:07 -0700 you wrote:
> The hardware checksum offloading requires use of a transmit
> status block inserted before the outgoing frame data, this was
> updated in '9a9ba2a4aaaa ("net: bcmgenet: always enable status blocks")'
> 
> However, skb_tx_timestamp() assumes that it is passed a raw frame
> and PTP parsing chokes on this status block.
> 
> [...]

Here is the summary with links:
  - [net-next,RESEND] net: bcmgenet: hide status block before TX timestamping
    https://git.kernel.org/netdev/net/c/acac0541d1d6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


