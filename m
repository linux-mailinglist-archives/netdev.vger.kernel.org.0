Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 713E960F636
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 13:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235301AbiJ0LaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 07:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235309AbiJ0LaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 07:30:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3783AB10
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 04:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59876B825AE
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 11:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D1B0BC433D7;
        Thu, 27 Oct 2022 11:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666870215;
        bh=QAOAR5FO/Ew59zPEf406SCNCFka6K6G6XuxKS5XPk3U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hO1fKVEozrblFJ8TRq9cJ6Op3AQTA0SIcuIk2RPHFeyUBb7/lxTbzbwlpV5p5VvJ3
         vpgDZAFFY9cdETxrHrLhnjPBGy8wx1+qM4nayKBMAKlMIYEftRd9jyZ8VXJGP7Lr67
         NzDdTvSmXRmCwzEQQ2yt1veZgWg3+hDgK5aPhxajdNvib+ItCx73qQccQWx0ykKi7R
         ssImcXYwsKkNqVrCj91e0Zb6yzN7corT9Y1DQfp3S1ypvfCgzUiX8tHpfgvkS8S/Hj
         RXMn9vx8Ve0936v198djg8chX/SgvzwouICROxi/g00ZryX5NeXlA4qIjFTPWiMAUN
         g5WlXxqlZUg9g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B3A55E270DA;
        Thu, 27 Oct 2022 11:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ice: Add support Flex RXD
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166687021572.14168.11569468623615544864.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Oct 2022 11:30:15 +0000
References: <20221025161252.1952939-1-jacob.e.keller@intel.com>
In-Reply-To: <20221025161252.1952939-1-jacob.e.keller@intel.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        michalx.jaron@intel.com, leyi.rong@intel.com, ting.xu@intel.com,
        mateusz.palczewski@intel.com, maxime.coquelin@redhat.com,
        konrad0.jankowski@intel.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 25 Oct 2022 09:12:52 -0700 you wrote:
> From: Michal Jaron <michalx.jaron@intel.com>
> 
> Add new VIRTCHNL_VF_OFFLOAD_RX_FLEX_DESC flag, opcode
> VIRTCHNL_OP_GET_SUPPORTED_RXDIDS and add member rxdid
> in struct virtchnl_rxq_info to support AVF Flex RXD
> extension.
> 
> [...]

Here is the summary with links:
  - [net-next] ice: Add support Flex RXD
    https://git.kernel.org/netdev/net-next/c/e753df8fbca5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


