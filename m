Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 998BE6E18DB
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 02:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbjDNANk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 20:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbjDNAN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 20:13:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0476265AE;
        Thu, 13 Apr 2023 17:12:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4523D642A0;
        Fri, 14 Apr 2023 00:12:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16277C433D2;
        Fri, 14 Apr 2023 00:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681431151;
        bh=jAAzjuuma9/2IwVZcDcboQyN6Rzf9sRrEKXGDtZPxKU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HIUKk0GJCz24Am0FHXuKWXotKZ341iWPdG0xy3N0v9khhPNoeqoDVYHGBQDNaa6L5
         MBDOaLZBgnxng1fSbcKI/8Ql1i1MhMFcnG8maiBk23ehCU4IEMM+xke1/t5uIuL31F
         yHOw7yIUkEr/TIrZHmOjVq84WxqQb1gY5sagzBg22DcGYZAFbXnCW6mhzMi1jTOjkU
         KC1W6OGmTLay0zVvpOzGkIpnJhCm8EH4c2q5NSkwXPoqAbRWE3g4/JxhDCECCUQjCI
         fActSUlSMUwS0o8FlJ3B44zUBc85ayDtw80VZ3UE7YDHfrE22Vy+A6nUIbx8d5ehhu
         RNanJBBdAsdvg==
Date:   Thu, 13 Apr 2023 17:12:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, ast@kernel.org,
        andrii@kernel.org, martin.lau@linux.dev, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2023-04-13
Message-ID: <20230413171230.424335b5@kernel.org>
In-Reply-To: <168143046292.7886.11250032168084435124.git-patchwork-notify@kernel.org>
References: <20230413192939.10202-1-daniel@iogearbox.net>
        <168143046292.7886.11250032168084435124.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Apr 2023 00:01:02 +0000 patchwork-bot+netdevbpf@kernel.org
wrote:
> Here is the summary with links:
>   - pull-request: bpf 2023-04-13
>     https://git.kernel.org/netdev/net-next/c/029294d01907

Two wrongs make a right? :) Maybe I should try to pull in the order
of posting to appease the bot. Both pulled, thanks!
