Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E121658F3B
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 17:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbiL2QuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 11:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiL2QuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 11:50:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E5DB00
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 08:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEFB2B819FC
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 16:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F580C433EF;
        Thu, 29 Dec 2022 16:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672332615;
        bh=qtqi5NFg9tJxmGHt5PswOPt2T7FyZjsCD8JNncqXBjM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bjonzCWV3547zX7aujF96p08zbx7h5i0oMy9StVINTy1Mb1QSjagiYY8KO9GakD0T
         QsQQUgvAGhFxomArru7ClkWDJn763fm0vby5VXxFkE2JzEMXydSwae5NF9SPLcGKEh
         sYV1z9eQtEvl9cq68NAt4YWokB2U6fHnrTWqIw96Ab+3P0ukmTeEg1ap5eko3J5YM3
         Bh+wXLYHpyQBczgw+El3mmzQnB/J6oW6INrk2HPVDSqhpH3uo7fjZRrwZrEzCY+Vyi
         fmzeulwVzXGS3ZdeX7KHI0cjiR3RXWA3zb7+UFGnvzPETSlpXMjgG3o7aebDVsg11Q
         8TkbA19vMi6EA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6FAC0E4D029;
        Thu, 29 Dec 2022 16:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] dcb: Do not leave ACKs in socket receive buffer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167233261544.30800.10653820168692161796.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Dec 2022 16:50:15 +0000
References: <20221227110318.2899056-1-idosch@nvidia.com>
In-Reply-To: <20221227110318.2899056-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com, chenjunxin1@huawei.com, petrm@nvidia.com,
        mlxsw@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 27 Dec 2022 13:03:18 +0200 you wrote:
> Originally, the dcb utility only stopped receiving messages from a
> socket when it found the attribute it was looking for. Cited commit
> changed that, so that the utility will also stop when seeing an ACK
> (NLMSG_ERROR message), by setting the NLM_F_ACK flag on requests.
> 
> This is problematic because it means a successful request will leave an
> ACK in the socket receive buffer, causing the next request to bail
> before reading its response.
> 
> [...]

Here is the summary with links:
  - [iproute2] dcb: Do not leave ACKs in socket receive buffer
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=d0e02f35af33

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


