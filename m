Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B77E4F8E9E
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 08:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234188AbiDHEM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 00:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234105AbiDHEMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 00:12:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 785BE1EB80B
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 21:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E9F67CE2A03
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 04:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 589B6C385AD;
        Fri,  8 Apr 2022 04:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649391012;
        bh=CJOb3rkIKnfWt/V1zNi4AdNSI7fi2M1t/klz5o9I/IM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=n17g0ejp40vZAB7NPq2Eem69sF3+U0r/CUnp+2cKbp6GJdQ5/DwxsKVVpGMt3/vA3
         l8YW3S+4DF/ti9MvtOt/9w05TozpkBHFkhEmzg48uj74NGFyUnzwam0P5c3XWJyZPf
         orf7PMvK5ZvVl7Pj+xUvzE5yHQ73hd6QGq/PgNrxNp6kedoQkF+sIOsSfWddyGwHTe
         a8D7UMIgNh4mrluVLc/NoDOVBue47NFY++KvVFuQUww9pn6EtuXB5a9uFonVI1BzzH
         JRFPQrmuZD6azm0Xfi6otdQjpfsTu6CN+d0YQUWCjj0lTqSQhygDs7DvCS+WmCezo9
         PG68SePf8Sh+g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 34BF7E8DCCE;
        Fri,  8 Apr 2022 04:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net/ethernet : set default assignment identifier to
 NET_NAME_ENUM
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164939101221.29309.13533045214799771590.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Apr 2022 04:10:12 +0000
References: <20220406093635.1601506-1-iwienand@redhat.com>
In-Reply-To: <20220406093635.1601506-1-iwienand@redhat.com>
To:     Ian Wienand <iwienand@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        teg@jklm.no, dh.herrmann@gmail.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  6 Apr 2022 19:36:36 +1000 you wrote:
> As noted in the original commit 685343fc3ba6 ("net: add
> name_assign_type netdev attribute")
> 
>   ... when the kernel has given the interface a name using global
>   device enumeration based on order of discovery (ethX, wlanY, etc)
>   ... are labelled NET_NAME_ENUM.
> 
> [...]

Here is the summary with links:
  - [v3] net/ethernet : set default assignment identifier to NET_NAME_ENUM
    https://git.kernel.org/netdev/net-next/c/e9f656b7a214

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


