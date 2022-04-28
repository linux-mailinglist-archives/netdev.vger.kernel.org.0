Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C242513A64
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 18:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350375AbiD1Qxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 12:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239774AbiD1Qxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 12:53:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4944F11173
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 09:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B8BF620DE
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 16:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8FDB8C385AA;
        Thu, 28 Apr 2022 16:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651164612;
        bh=sDnpdWv+gfnrNHTUJ8I+NWfBEw6KAfkxoT8ZvXXd0pg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XsJF1rT+tU8nq37Y+xcZMkD1B0rTudVLP2oyvdvtO7nXD09OOHGOJMzBGUOrNAdbM
         TlYpc1nRnD900JTBVb4rIaxVUJY4Ii4i3Lsq9WHD3/VuTK7mKRXav8cK7OFgrgBOwr
         xjmSzmWVPtqABQuObIdgz9AShLw8pOziDfkrV2NTFbAOBn95NbDnw29Q73Ha7u/8hd
         9gTKi+Ol+P98JmctrAAjFw7Pe1gQlvNRIVLmoH3v7t2uzLJtEJYSjIFIUoMpKP5VQ9
         gjqZlK+UloRr0WrrNOO3VQoHkkKwoMGlnRdN+fYI9z05QkV9itr7yMQDqI8KbJDMJi
         P4gJV6ccuX+HQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 745A2F03840;
        Thu, 28 Apr 2022 16:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] Revert "ibmvnic: Add ethtool private flag for
 driver-defined queue limits"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165116461247.18870.13058040891546581465.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Apr 2022 16:50:12 +0000
References: <20220427235146.23189-1-drt@linux.ibm.com>
In-Reply-To: <20220427235146.23189-1-drt@linux.ibm.com>
To:     Dany Madden <drt@linux.ibm.com>
Cc:     netdev@vger.kernel.org, tlfalcon@linux.ibm.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 27 Apr 2022 18:51:46 -0500 you wrote:
> This reverts commit 723ad916134784b317b72f3f6cf0f7ba774e5dae
> 
> When client requests channel or ring size larger than what the server
> can support the server will cap the request to the supported max. So,
> the client would not be able to successfully request resources that
> exceed the server limit.
> 
> [...]

Here is the summary with links:
  - [net] Revert "ibmvnic: Add ethtool private flag for driver-defined queue limits"
    https://git.kernel.org/netdev/net/c/aeaf59b78712

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


