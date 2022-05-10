Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45D9C520A28
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 02:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233671AbiEJAeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 20:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233637AbiEJAeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 20:34:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70FCA29279C
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 17:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27436B819FC
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 00:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C4FEBC385C2;
        Tue, 10 May 2022 00:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652142613;
        bh=ewe6IS4L9xbRfep1erjJY3aldMtoEXCTa0Y/1MzvgcE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d16d+wCOERJSr9ltVvFcXc/9UtvkU+wIYmGrzwp8pdJb11mPoXX67Ra1bFl8Pgptb
         oLPe1QxEmTLAPH1lhKA5CAMqhK6XDSNuNA1tfkLF8TRpMNgB6xvf9EyIpbufukxsXm
         5V26fcnja7rlkpr1Ohuc9XfoT8u/Un92xn+HJhUlsytAOzRurHs/KBAJP0UnbuEkvJ
         u+SZSHFH0mQ857JFOLNcpkLyW1mu6yvy8LEi8Fi6N0LEPM3ZmDS12nMYhxovYvOHrA
         Aja/SrtZdBEtX6w1S91bTtNcDyF/eTCQu80ry2jQjBe6gbWjdOW9MaoaaAYsbJJIYh
         XNscbSBgYnk1g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A107FF0392B;
        Tue, 10 May 2022 00:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 00/11]: Move Siena into a separate subdirectory
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165214261365.23610.13788193533410601676.git-patchwork-notify@kernel.org>
Date:   Tue, 10 May 2022 00:30:13 +0000
References: <165211018297.5289.9658523545298485394.stgit@palantir17.mph.net>
In-Reply-To: <165211018297.5289.9658523545298485394.stgit@palantir17.mph.net>
To:     Martin Habets <habetsm.xilinx@gmail.com>
Cc:     kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        davem@davemloft.net, netdev@vger.kernel.org, ecree.xilinx@gmail.com
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

This series was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Mon, 09 May 2022 16:31:06 +0100 you wrote:
> The Siena NICs (SFN5000 and SFN6000 series) went EOL in November 2021.
> Most of these adapters have been remove from our test labs, and testing
> has been reduced to a minimum.
> 
> This patch series creates a separate kernel module for the Siena architecture,
> analogous to what was done for Falcon some years ago.
> This reduces our maintenance for the sfc.ko module, and allows us to
> enhance the EF10 and EF100 drivers without the risk of breaking Siena NICs.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,01/11] sfc: Move Siena specific files
    https://git.kernel.org/bpf/bpf-next/c/bfa92e0bdc8e
  - [net-next,v4,02/11] sfc: Copy shared files needed for Siena (part 1)
    https://git.kernel.org/bpf/bpf-next/c/bfa92e0bdc8e
  - [net-next,v4,03/11] sfc: Copy shared files needed for Siena (part 2)
    https://git.kernel.org/bpf/bpf-next/c/bfa92e0bdc8e
  - [net-next,v4,04/11] sfc/siena: Remove build references to missing functionality
    (no matching commit)
  - [net-next,v4,05/11] sfc/siena: Rename functions in efx headers to avoid conflicts with sfc
    (no matching commit)
  - [net-next,v4,06/11] sfc/siena: Rename RX/TX functions to avoid conflicts with sfc
    (no matching commit)
  - [net-next,v4,07/11] sfc/siena: Rename peripheral functions to avoid conflicts with sfc
    (no matching commit)
  - [net-next,v4,08/11] sfc/siena: Rename functions in mcdi headers to avoid conflicts with sfc
    (no matching commit)
  - [net-next,v4,09/11] sfc/siena: Rename functions in nic_common.h to avoid conflicts with sfc
    (no matching commit)
  - [net-next,v4,10/11] sfc/siena: Inline functions in sriov.h to avoid conflicts with sfc
    (no matching commit)
  - [net-next,v4,11/11] sfc: Add a basic Siena module
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


