Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F09579785
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 12:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235837AbiGSKUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 06:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235826AbiGSKUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 06:20:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BCAE10FD8;
        Tue, 19 Jul 2022 03:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6D3660ED3;
        Tue, 19 Jul 2022 10:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0AA3C341CF;
        Tue, 19 Jul 2022 10:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658226013;
        bh=aX/Y8Dw+WmBJJntjZ7HIljSezkBupKaI2+OJVYcCz1Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ABwAC6eWhw7RyHoYxWcz772E2RzRnaZFYKNHmcKfTFTwb9blsAvaOJ3Y4RgqmIjOh
         WM0SvYxp8wiuE6geOdhZzddBgEyUAJV9yyC9Pm6xt2Tf/s0CN60bWAi3Yd54eWh9FU
         iEy1IeEEvj0PqgghmEyhuF3k9Q6QZzB8Ln7MGZKkcXgjdJMSAXlipZd7NPRv3w6YnG
         F6H0GByyAPV9MoqA/S3BWrE7YqwJyHljM/eUe2ptkS4FQIvyeXr2EtYly1wYB38RH+
         F4LDFQcEf68c0sWcLA7td0zaOwd0JkvQ2Hl8uEPiAR6E8LJNxJW9o6iASVhnE1XV1q
         VexFy1+SqghNA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D5AB7E451BA;
        Tue, 19 Jul 2022 10:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] be2net: Fix buffer overflow in be_get_module_eeprom
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165822601287.18997.9680200835498152031.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Jul 2022 10:20:12 +0000
References: <20220716085134.6095-1-hristo@venev.name>
In-Reply-To: <20220716085134.6095-1-hristo@venev.name>
To:     Hristo Venev <hristo@venev.name>
Cc:     netdev@vger.kernel.org, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mark.leonard@emulex.com,
        sathya.perla@emulex.com, Suresh.Reddy@emulex.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 16 Jul 2022 11:51:34 +0300 you wrote:
> be_cmd_read_port_transceiver_data assumes that it is given a buffer that
> is at least PAGE_DATA_LEN long, or twice that if the module supports SFF
> 8472. However, this is not always the case.
> 
> Fix this by passing the desired offset and length to
> be_cmd_read_port_transceiver_data so that we only copy the bytes once.
> 
> [...]

Here is the summary with links:
  - be2net: Fix buffer overflow in be_get_module_eeprom
    https://git.kernel.org/netdev/net/c/d7241f679a59

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


