Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0D8F6AF803
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 22:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbjCGVu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 16:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbjCGVuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 16:50:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C46A5901
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 13:50:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CBA6B81A40
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 21:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EA3C0C4339B;
        Tue,  7 Mar 2023 21:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678225821;
        bh=f1/Cv29o0ia3VBcnsTC+chlEeYN/ev7FNi87UWSHfl4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=trdLkb0kF4VjmbRrGv14rVRrjBqPt+8Z7qcBqtXttaTx2fRZJDuafERG7TT1Q/HNL
         nv9W/Qiit0Z8eM/5nWPjPjtJN1806NNeZd2IgxNJi0BF4AkJqkmwdNkdCDEVlM38tN
         iyY1RTTh/gmn9hsduLb9XCAOAAT8jm6G0CxS12+qs8pf7XQdBo7tTKgLbaUHIz2T73
         BlUxw/yXkr/wnVMIp2EWO47uSdJQq+SzVuYoADmVrfy/Unq0km01G7f+X3PxwJ7wTQ
         CxdeKgeCoWp3gk4odSwfmy9sH3Nw13+UNThszFN3szAwcjeH+ua7F7Qfeig9rb9WXX
         it4DANMi5yr1A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D0213E61B63;
        Tue,  7 Mar 2023 21:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mailmap: update entries for Stephen Hemminger
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167822582083.6774.17894275712233027164.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Mar 2023 21:50:20 +0000
References: <20230306194405.108236-1-stephen@networkplumber.org>
In-Reply-To: <20230306194405.108236-1-stephen@networkplumber.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  6 Mar 2023 11:44:05 -0800 you wrote:
> Map all my old email addresses to current address.
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---
>  .mailmap | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net] mailmap: update entries for Stephen Hemminger
    https://git.kernel.org/netdev/net/c/b1649b0fe98c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


