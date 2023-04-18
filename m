Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACD76E6D38
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 22:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbjDRUBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 16:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232315AbjDRUBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 16:01:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72CFB768;
        Tue, 18 Apr 2023 13:01:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 074E863898;
        Tue, 18 Apr 2023 20:01:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62094C433EF;
        Tue, 18 Apr 2023 20:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681848071;
        bh=4yVirdppsgpFq7+RBk6cMfsujdtPlwmsdStMkcuRXIk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ILq8QMx6D30x0JYiLiS0OAIwdYtpLMxkUvZolQQQSn9Q7ukxzchnDERqi+9dNAqQG
         kGFtsF6t6pY46YixZPGir0hIfkgdl5C1+pqG5LS/fYGYPtiwALhVv5z8PL51vzrN9E
         exAcmUGsDzWnk22xkQlczCdRIbJZ8Y2rpdIMETV2k7cmJslvWj8cKzAySDZA2bAu3t
         DjeklqJknrq4HzFRimb1LnJk8erpP93kW8PUobf9SKylV3r6bZPGAyppO39AWWv8Cm
         mYmvB0FJNCF61k7MrQaZEp04I2iKOS4SNvJoq+1MVSwNZjUpaCavFrKbQFa8OrmEIn
         ImmQL2Iql+8xA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4CA20E330AB;
        Tue, 18 Apr 2023 20:01:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bluetooth 2023-04-10
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <168184807130.10886.15858478283038643567.git-patchwork-notify@kernel.org>
Date:   Tue, 18 Apr 2023 20:01:11 +0000
References: <20230410172718.4067798-1-luiz.dentz@gmail.com>
In-Reply-To: <20230410172718.4067798-1-luiz.dentz@gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to bluetooth/bluetooth-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 10 Apr 2023 10:27:18 -0700 you wrote:
> The following changes since commit b9881d9a761a7e078c394ff8e30e1659d74f898f:
> 
>   Merge branch 'bonding-ns-validation-fixes' (2023-04-07 08:47:20 +0100)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2023-04-10
> 
> [...]

Here is the summary with links:
  - pull-request: bluetooth 2023-04-10
    https://git.kernel.org/bluetooth/bluetooth-next/c/160c13175e39

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


