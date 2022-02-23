Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 588A54C1F63
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 00:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244720AbiBWXKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 18:10:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239752AbiBWXKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 18:10:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8070412765;
        Wed, 23 Feb 2022 15:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02A97B82239;
        Wed, 23 Feb 2022 23:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8D23AC340EC;
        Wed, 23 Feb 2022 23:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645657810;
        bh=voS6pUfXQQIovJB7tLQ5G94jrhXxJ6AIIFEawrsdfEk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WFqJPSRckwhticpQDOBKzzXucI7+dhLSSnXb6Hz4tpSCVJ28o+u1A4VYatRzprEC5
         nypzJ9+rEr7SNIob1kuEOvGzJpBam4q4XeoPWxSTO2XyqipN3r0RxfJCZ0VHmn0Ji9
         dyZ0e8+dj4KZnnWVpWnWahfNMYT3JUEggmvMxDqqbsuJNgaKmE76Zq8GCxNiJen4dp
         Wq42kEO1CGcbSidH6iODCUX5PpvKH/6j6oYvdUHPrBsIsh57MLayf2EfmmM+ewM2wO
         sihUGzxt3GDnrj7Z6tBDXCBCrx1i1Aq3SL/hhPitBG35pHjNCNO80+jJEC2OvaoxKh
         lzM3JBPHDm9ig==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6F94BEAC096;
        Wed, 23 Feb 2022 23:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] libbpf: Simplify the find_elf_sec_sz() function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164565781045.27751.16899329046615535946.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Feb 2022 23:10:10 +0000
References: <20220223085244.3058118-1-ytcoode@gmail.com>
In-Reply-To: <20220223085244.3058118-1-ytcoode@gmail.com>
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Wed, 23 Feb 2022 16:52:44 +0800 you wrote:
> The check in the last return statement is unnecessary, we can just return
> the ret variable.
> 
> But we can simplify the function further by returning 0 immediately if we
> find the section size and -ENOENT otherwise.
> 
> Thus we can also remove the ret variable.
> 
> [...]

Here is the summary with links:
  - [bpf-next] libbpf: Simplify the find_elf_sec_sz() function
    https://git.kernel.org/bpf/bpf-next/c/08894d9c647a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


