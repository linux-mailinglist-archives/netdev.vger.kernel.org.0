Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6B4655414
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 21:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbiLWUD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 15:03:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiLWUDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 15:03:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82FF3175B1;
        Fri, 23 Dec 2022 12:03:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3835EB8210B;
        Fri, 23 Dec 2022 20:03:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE07DC433D2;
        Fri, 23 Dec 2022 20:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671825831;
        bh=tBwHQlmqRBeYWxGS6uKd2RdDCEZpbyIt8nBUwGIEJ38=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AF+SO8CYPY3Mh4Mr5Ilwh1TfbJw5kxgwW2ek1WmvcrNvk8ynPgL8r5Y018lRkBVRn
         8iBAT6ftBg3rwqfb2TEmn7s+radjrF1o9DwEt1KyNokZjmJoW0pK0yTcYKEcpE5Fso
         1zeg0KpmP/HAxfcMEmklDvHMwSoJach1aPXtDnRNKx0B1RY4Nc1V6wmjPUXVHGosRN
         Piwf3HCf7luTbK7NLlXGJZUNy4T9BhmDGoaBwLhHIv8M55SUmSKNyetOz3a+0ra9e4
         75xZ+4bwE5TB+hzq3qaJ2Or1CgYru5UAEbso03cXRf20NiXYU3MIhtQAnyBYgHh4MB
         ap6XS2r14MG8w==
Date:   Fri, 23 Dec 2022 12:03:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     syzbot <syzbot+e5341b984215b66e5b19@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] net-next build error (5)
Message-ID: <20221223120350.7af6afa2@kernel.org>
In-Reply-To: <00000000000060476705f07bbba5@google.com>
References: <00000000000060476705f07bbba5@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Dec 2022 01:51:38 -0800 syzbot wrote:
> syzbot found the following issue on:
> 
> HEAD commit:    1d330d4fa8ba net: alx: Switch to DEFINE_SIMPLE_DEV_PM_OPS(..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=16c71ba3880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b0e91ad4b5f69c47
> dashboard link: https://syzkaller.appspot.com/bug?extid=e5341b984215b66e5b19
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+e5341b984215b66e5b19@syzkaller.appspotmail.com
> 
> failed to run ["make" "-j" "64" "ARCH=x86_64" "bzImage"]: exit status 2

This is syzbot ooming during build or such? I don't see any error.
