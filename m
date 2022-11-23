Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7A3635ED4
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 14:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238687AbiKWNHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 08:07:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238866AbiKWNHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 08:07:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C4BE0B5A;
        Wed, 23 Nov 2022 04:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4814B81FA2;
        Wed, 23 Nov 2022 12:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 94CB1C43149;
        Wed, 23 Nov 2022 12:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207815;
        bh=KIU5zp/fHoYcSmyOn6tMxUQbgOWXMmNWP4dKrv8hHw8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AroRLCvktahdpG9E/1xzAbX+pLCQ4UWcDM68y5Vl2CRKd6SU0zfgyCiMDUkfqlxmM
         9DqStZMZplgx8TkXm+QTurTBPJ9Kxa/JS/+cUcpWgTXfa2xpl0vZrJ/vZXbD6TtLPd
         mj/sMk/RV9HQaZYm3GN9H5uobHiKnMDbTxuPv9dDcML/Vznqxnh1uvJ9VvrXkXsnP7
         n9tw9DID2HmpnJQA4Kbh5Jh5rqyB5/510BSaBgwVKiLt30t0H+nKp+kX6fIDDZdOns
         Qs7cxYWGMqi2Xja27yf2vk6tkrMRRoqGHFqCCrllx2S1yMbhiY12ZhDQp/iBQNKh64
         4l9tFVjCTnCWw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7F6EDE21EF9;
        Wed, 23 Nov 2022 12:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Documentation: devlink: Add blank line padding on
 numbered lists in Devlink Port documentation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166920781551.7047.17657573305612000567.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Nov 2022 12:50:15 +0000
References: <20221121035854.28411-1-bagasdotme@gmail.com>
In-Reply-To: <20221121035854.28411-1-bagasdotme@gmail.com>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, oe-kbuild-all@lists.linux.dev,
        gwml@vger.gnuweeb.org, lkp@intel.com, jiri@nvidia.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, michal.wilczynski@intel.com,
        ammarfaizi2@gnuweeb.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 21 Nov 2022 10:58:55 +0700 you wrote:
> kernel test robot reported indentation warnings:
> 
> Documentation/networking/devlink/devlink-port.rst:220: WARNING: Unexpected indentation.
> Documentation/networking/devlink/devlink-port.rst:222: WARNING: Block quote ends without a blank line; unexpected unindent.
> 
> These warnings cause lists (arbitration flow for which the warnings blame to
> and 3-step subfunction setup) to be rendered inline instead. Also, for the
> former list, automatic list numbering is messed up.
> 
> [...]

Here is the summary with links:
  - [net-next] Documentation: devlink: Add blank line padding on numbered lists in Devlink Port documentation
    https://git.kernel.org/netdev/net-next/c/c84f6f6c2bb5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


