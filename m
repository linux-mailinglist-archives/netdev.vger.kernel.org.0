Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 177846207E9
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 05:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbiKHEA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 23:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232847AbiKHEAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 23:00:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE88FD32
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 20:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86507B818AA
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 04:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1BADAC433B5;
        Tue,  8 Nov 2022 04:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667880018;
        bh=7nx95+HFMaN48K/kwWTKKPQYUhAvvifjLXmI+cLeTrU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Zh7JSzsZMz2nz2fX1cL9RrYRik27M2DCNPr6wWuyj99ig+3U6DgbKia/4f5X6y0os
         y/VBBOv/0jVvhH/E09Nx1SxDlvOR+xvDi2V8JEo8EUNkj1K0VVLSEpdR09zz4neRzm
         CUcrSBvhSrIoD8OvOTDDvjuhE+Mjr4aLrSGCuA3v4uvcsv840v/wwdkbNgns0JvLlf
         WCQQCQyH8j6ShH6gXqykxE8UlwZ26IpHCgqBGbdlhHVMiJi1DrC0JCmtbO0if65mYf
         JdB8ieLX4S1psoiKn2Y+ltDpUaUBaPhFE0aLo3M54ZoBi3SgH8S0SMeVKFcsLeqzaQ
         e+LkJtM5e6ZJw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ED2FDC4166D;
        Tue,  8 Nov 2022 04:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tipc: fix the msg->req tlv len check in
 tipc_nl_compat_name_table_dump_header
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166788001795.28960.1534785876466386639.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Nov 2022 04:00:17 +0000
References: <ccd6a7ea801b15aec092c3b532a883b4c5708695.1667594933.git.lucien.xin@gmail.com>
In-Reply-To: <ccd6a7ea801b15aec092c3b532a883b4c5708695.1667594933.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, jmaloy@redhat.com, ying.xue@windriver.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  4 Nov 2022 16:48:53 -0400 you wrote:
> This is a follow-up for commit 974cb0e3e7c9 ("tipc: fix uninit-value
> in tipc_nl_compat_name_table_dump") where it should have type casted
> sizeof(..) to int to work when TLV_GET_DATA_LEN() returns a negative
> value.
> 
> syzbot reported a call trace because of it:
> 
> [...]

Here is the summary with links:
  - [net] tipc: fix the msg->req tlv len check in tipc_nl_compat_name_table_dump_header
    https://git.kernel.org/netdev/net/c/1c075b192fe4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


