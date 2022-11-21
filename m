Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A95A5631CB6
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 10:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbiKUJUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 04:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiKUJUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 04:20:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB4031EEE
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 01:20:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79F86B80CC4
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 09:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 45752C433D7;
        Mon, 21 Nov 2022 09:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669022415;
        bh=CDut/qlquzGzoiycS8CXTl5kDTBmhGjk9OeP9MuNXh4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Pu/H+GaKr4z1HS26tZwkt2ONi4brPjtR+elOAICnrVj29cTwlnTp07Y4U71MBIPPM
         AHSAaMznFyycx0GeMgLc1jmBIAR8Vxiw9vf1eVR6LJiIcdzKskL9VVIwLvhd+JbDw1
         L6zxPKi+G5eDSw0EAc1DZrwD5AXF4boH3IZDcvj3Q4GWAeKXYIAoIKFEyYotf+/0VP
         JXTbUpKm4Y6CGKwS++8GUkWDlbDz+tj/D/TsIeNXMAfec3dLVeK9iI3/wWZ13bdwtO
         IJsD4NNTfm/PA5I1if0H6rX2kINgfcuLOYdZ5Uts7GwWPMLVip1xm+OC0ot7P3BegO
         WSteKIb1sYstA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2D19FE29F3E;
        Mon, 21 Nov 2022 09:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 ethtool] fsl_enetc: add support for NXP ENETC driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166902241518.21031.996207350163239469.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Nov 2022 09:20:15 +0000
References: <20221116192705.660337-1-vladimir.oltean@nxp.com>
In-Reply-To: <20221116192705.660337-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz, claudiu.manoil@nxp.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to ethtool/ethtool.git (master)
by Michal Kubecek <mkubecek@suse.cz>:

On Wed, 16 Nov 2022 21:27:05 +0200 you wrote:
> Add pretty printer for the registers which the enetc PF and VF drivers
> support since their introduction in kernel v5.1. The selection of
> registers parsed is the selection exported by the kernel as of v6.1-rc2.
> Unparsed registers are printed as raw.
> 
> One register is printed field by field (MAC COMMAND_CONFIG), I didn't
> have time/interest in printing more than 1. The rest are printed in hex.
> 
> [...]

Here is the summary with links:
  - [v2,ethtool] fsl_enetc: add support for NXP ENETC driver
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=7c856b4e1d87

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


