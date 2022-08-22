Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14FBA59C12C
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 16:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235526AbiHVOAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 10:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234860AbiHVOAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 10:00:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A3139B93;
        Mon, 22 Aug 2022 07:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51202B8123A;
        Mon, 22 Aug 2022 14:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF5ADC4314A;
        Mon, 22 Aug 2022 14:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661176816;
        bh=orT3QMvkSoHHqPhUrfOeoGgvMUqUg3YkbuOk1NRLzD0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AWbqZa3ljQPak3jKFSQ9qYXmSiFK4hkUob7qCQFNQAUGaf1kp6Spcd33go1QpR+uy
         C4QENOLNHYb8BXD7FxbLFhq40cQZpByYuo34BmLObmzo0ORKUULTibjpwiak5uU1J9
         /G+QNaQm1L6JePN9koM9Mz6rg3LH89BwWhUIfi9o2SlSCnJWsFwb1hjBLeUsF8WbFp
         ikutXfke0k5TpTFeQaYJ+JSlGTx45Hxo7Xd6LaXx0Vuw7hgXqHFGhHG/M6FnjYiNeM
         cyHi85/7+k/qLiXoV9UJD21wRjOIMM6oa888vL93CW3OCApUE/j9zmndxo+/GumxdH
         ZOAVoif43f5HQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BDFF9E2A040;
        Mon, 22 Aug 2022 14:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Remove DECnet support from kernel
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166117681677.22523.5504877991738164971.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Aug 2022 14:00:16 +0000
References: <20220818004357.375695-1-stephen@networkplumber.org>
In-Reply-To: <20220818004357.375695-1-stephen@networkplumber.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org, corbet@lwn.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, tsbogend@alpha.franken.de, mpe@ellerman.id.au,
        npiggin@gmail.com, christophe.leroy@csgroup.eu,
        pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        bp@suse.de, paulmck@kernel.org, akpm@linux-foundation.org,
        quic_neeraju@quicinc.com, rdunlap@infradead.org,
        damien.lemoal@opensource.wdc.com, songmuchun@bytedance.com,
        hmukos@yandex-team.ru, atenart@kernel.org, lucien.xin@gmail.com,
        jgross@suse.com, hdegoede@redhat.com, nathan.fontenot@amd.com,
        martin.petersen@oracle.com, suma.hegde@amd.com,
        yu.c.chen@intel.com, vilhelm.gray@gmail.com,
        xieyongji@bytedance.com, pali@kernel.org, arnd@arndb.de,
        alexandre.ghiti@canonical.com, chuck.lever@oracle.com,
        jlayton@kernel.org, paul.gortmaker@windriver.com,
        razor@blackwall.org, bigeasy@linutronix.de, imagedong@tencent.com,
        petrm@nvidia.com, daniel@iogearbox.net, roopa@nvidia.com,
        wangyuweihx@gmail.com, shakeelb@google.com, kuniyu@amazon.com,
        keescook@chromium.org, sgarzare@redhat.com, f.fainelli@gmail.com,
        wangqing@vivo.com, yuzhe@nfschina.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
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

On Wed, 17 Aug 2022 17:43:21 -0700 you wrote:
> DECnet is an obsolete network protocol that receives more attention
> from kernel janitors than users. It belongs in computer protocol
> history museum not in Linux kernel.
> 
> It has been "Orphaned" in kernel since 2010. The iproute2 support
> for DECnet was dropped in 5.0 release. The documentation link on
> Sourceforge says it is abandoned there as well.
> 
> [...]

Here is the summary with links:
  - [net-next] Remove DECnet support from kernel
    https://git.kernel.org/netdev/net-next/c/1202cdd66531

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


