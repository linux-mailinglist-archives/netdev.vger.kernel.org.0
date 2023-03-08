Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC0296AFB7A
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 01:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjCHArl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 19:47:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjCHArk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 19:47:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D985553D;
        Tue,  7 Mar 2023 16:47:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB0E661573;
        Wed,  8 Mar 2023 00:47:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65D0C433EF;
        Wed,  8 Mar 2023 00:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678236458;
        bh=H4rawjV0EjOntDwIMDAr9VrxvBan1HVUFaeesCDT6/o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lpzOCF3xkrv3PiJazebJCu8fXt2yCaQ+oGQYUND5AjeU53V5VnOYI6U6G0BbM7mzh
         vc59pTgbdtDOypyH7AVwLAx6FoQEOxLy4o6ZpYXm2d9vrSyYvcILAvwnDnSM3BKh6I
         7qhgDpk3WsbPhQwO7oBkPKg+hzuhxDguwVVtUh6/wKs21fvvLUccwhHITlc2ExXYsZ
         YeBj2Ds9UwYzj0Fx4jlylm+k95K+IVJS8ypvz7wQKHWRkVuQSIzGl1NVVNKRP76v3f
         KVc7sDrFAVL1JE57VyqTy1HVM8gVfIf9tah71NwOoA4PThIMhtHNv2vCJGr2XQb05K
         SJLIjbiHilGbA==
Date:   Tue, 7 Mar 2023 16:47:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Grant Grundler <grundler@chromium.org>
Cc:     Oleksij Rempel <linux@rempel-privat.de>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Eizan Miyamoto <eizan@chromium.org>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Anton Lundin <glance@acc.umu.se>
Subject: Re: [PATCHv2 1/2] TEST:net: asix: fix modprobe "sysfs: cannot
 create duplicate filename"
Message-ID: <20230307164736.37ecb2f9@kernel.org>
In-Reply-To: <20230307200502.2263655-1-grundler@chromium.org>
References: <20230307200502.2263655-1-grundler@chromium.org>
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

On Tue,  7 Mar 2023 12:05:01 -0800 Grant Grundler wrote:
> Subject: [PATCHv2 1/2] TEST:net: asix: fix modprobe "sysfs: cannot create duplicate filename"

Why the "TEST:" prefix?

The patch doesn't apply cleanly, it needs to go via this tree:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/
so rebase it onto that, please, and put [PATCH net] in the subject
rather than just [PATCH].

Keep patch 2 locally for about a week (we merge fixes and cleanup
branches once a week around Thu, and the two patches depend on each
other).

Please look thru at least the tl;dr of our doc:
https://www.kernel.org/doc/html/next/process/maintainer-netdev.html
