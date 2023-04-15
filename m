Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2526E2E7F
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 04:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjDOCHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 22:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjDOCHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 22:07:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9774C22
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 19:07:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43CE761719
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 02:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F421C433D2;
        Sat, 15 Apr 2023 02:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681524421;
        bh=DkfNw8WLrcKXv/xxb67fcoCm7DZ9a3zFfkaBPpIpkMc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZN63nGV129Zw4NABtfmZcBxG+NBe3QTd8gMzbeBVNyuiaelGT1r4TRvzRgTZAypqZ
         RxNFEBTGYE/O4lLEUIrKPIcbQydnt5Chw4zgHKDLn+IARvZVWWKBLSeJWUmtee5Zhv
         ObRQs9Z++bNEQKr1bKqZn2HCb22XIFaTamJAweG6pgUeef++jWCN7aoPy7X0Gitbx1
         WX/km0xCbyrlz9vZ28yGEc7tuCut72NvTOKBG3LNZZJ69YqCtGQFm8X4peNM5xTiji
         a0K20u6Iz7JvKf0gJm9M24fHKrSh1RQh/AlrOiIFfC153nLuroXTL6RfD9BvZYXBGk
         nqRktYVof+i6w==
Date:   Fri, 14 Apr 2023 22:06:59 -0400
From:   Chuck Lever <cel@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org,
        kernel-tls-handshake@lists.linux.dev
Subject: Re: [PATCH v9 3/3] net/handshake: Add Kunit tests for the handshake
 consumer API
Message-ID: <ZDoGw3nVG+jNWrwV@manet.1015granger.net>
References: <168141287044.157208.15120359741792569671.stgit@manet.1015granger.net>
 <168141324822.157208.14911977368369619191.stgit@manet.1015granger.net>
 <20230414183113.318ee353@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414183113.318ee353@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 14, 2023 at 06:31:13PM -0700, Jakub Kicinski wrote:
> On Thu, 13 Apr 2023 15:14:08 -0400 Chuck Lever wrote:
> >  net/Kconfig                    |   15 +
> >  net/handshake/.kunitconfig     |   11 +
> >  net/handshake/Makefile         |    2 
> >  net/handshake/handshake-test.c |  523 ++++++++++++++++++++++++++++++++++++++++
> >  net/handshake/netlink.c        |   22 ++
> >  net/handshake/request.c        |    5 
> >  6 files changed, 578 insertions(+)
> >  create mode 100644 net/handshake/.kunitconfig
> >  create mode 100644 net/handshake/handshake-test.c
> 
> We're getting:
> 
> net/handshake/.kunitconfig: warning: ignored by one of the .gitignore files
> 
> during allmodconfig build, any idea where that's coming from?

As far as I know, all of the .kunitconfig files in the kernel tree
are marked "ignored". I'm not sure why, nor if it's a significant
problem.
