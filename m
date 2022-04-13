Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2218D4FF5B1
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 13:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiDMLck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 07:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235128AbiDMLcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 07:32:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7478134BAE;
        Wed, 13 Apr 2022 04:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BFC061DC7;
        Wed, 13 Apr 2022 11:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B0799C385B1;
        Wed, 13 Apr 2022 11:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649849412;
        bh=lYZwM62lSPSEPPxpG6/zjgEXhke96Vy+w33ZwNIn0no=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=guasWZTNytEVX6hF7ILcutWkrigV9gVr1/uR7csImbaV58jpOcwrhWdVnuc+wS6Bq
         MypZathzsO+EJBFYfDI6rJAY2IVLqc97VNB8Jc82pLMvaBnaCLGVCQx/pVriqTAqs8
         XnuQrgd0qEhlPLe3jZXjy7Q72LbGYqHnloLeHlaGixHSfMPACa2NxXyXSPja9SFtHu
         KYMRi+Tq5emszgrEPd2gAVFjhBspVZg5qXFucjSmjCciVbaH1Nun23NUVE6zfAXuG/
         wXFaS+1wsIG3maHoM9DbikwIbWE5AmfL+rpXv+H0iJrCFbSTUG8XD7OmWoLXPKLH2G
         wrDs1KjALAHuQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 98F05E8DD6A;
        Wed, 13 Apr 2022 11:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ipv6: exthdrs: use swap() instead of open coding it
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164984941262.14313.12229725514053203170.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Apr 2022 11:30:12 +0000
References: <20220412032058.14136-1-guozhengkui@vivo.com>
In-Reply-To: <20220412032058.14136-1-guozhengkui@vivo.com>
To:     Guo Zhengkui <guozhengkui@vivo.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhengkui_guo@outlook.com
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
by David S. Miller <davem@davemloft.net>:

On Tue, 12 Apr 2022 11:20:58 +0800 you wrote:
> Address the following coccicheck warning:
> net/ipv6/exthdrs.c:620:44-45: WARNING opportunity for swap()
> 
> by using swap() for the swapping of variable values and drop
> the tmp (`addr`) variable that is not needed any more.
> 
> Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
> 
> [...]

Here is the summary with links:
  - ipv6: exthdrs: use swap() instead of open coding it
    https://git.kernel.org/netdev/net-next/c/5ee6ad1dcae8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


