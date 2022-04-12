Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 317514FE2A3
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbiDLN3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355995AbiDLN0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:26:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 344D41E9
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1324B81D74
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 13:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 822B8C385BA;
        Tue, 12 Apr 2022 13:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649769612;
        bh=9i0m19kEL/yrkm41fQQ1VM5WXdDZuPXgZKfbG2a30xU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CqkCiOeXTW9G+zKtFSJpiWlmYcgKWdy4kIkk+f5qb2WDl5JKnddJ0GqrAKs85t7zH
         afjiWqaHZKvKFlt9DQImsQshHnk6eKxMybD6hSY1VGO+uS1m+cLa+xy6LqQxrh2vq5
         vDCxEGG7OAUY/qyzWX4dW2sVs76telkRqOHobPE9HaBJ2YcMBq4AJCBc0ZBCHciVbR
         z4cgZd3KyklN7u5ooXzz00opc9m69V7O4GGh8gWAcnnwFDE5kKGFQ5+RYaxCs08qIA
         hmDkGhf6wBSPPr+akKbHrS4eElLSlPKOKNnf7QOiFUx1QNla+APzR1WyRdkjoS1TEs
         AtFhaiE9eYEPA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 64091E85D15;
        Tue, 12 Apr 2022 13:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] net: remove noblock parameter from recvmsg()
 entities
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164976961240.419.4686522872467353374.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Apr 2022 13:20:12 +0000
References: <20220411124955.154876-1-socketcan@hartkopp.net>
In-Reply-To: <20220411124955.154876-1-socketcan@hartkopp.net>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 11 Apr 2022 14:49:55 +0200 you wrote:
> The internal recvmsg() functions have two parameters 'flags' and 'noblock'
> that were merged inside skb_recv_datagram(). As a follow up patch to commit
> f4b41f062c42 ("net: remove noblock parameter from skb_recv_datagram()")
> this patch removes the separate 'noblock' parameter for recvmsg().
> 
> Analogue to the referenced patch for skb_recv_datagram() the 'flags' and
> 'noblock' parameters are unnecessarily split up with e.g.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: remove noblock parameter from recvmsg() entities
    https://git.kernel.org/netdev/net-next/c/ec095263a965

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


