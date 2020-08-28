Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364C0255BA0
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 15:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgH1NxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 09:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgH1NxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 09:53:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46016C061264
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 06:53:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4A7C41283CC1E;
        Fri, 28 Aug 2020 06:36:30 -0700 (PDT)
Date:   Fri, 28 Aug 2020 06:53:15 -0700 (PDT)
Message-Id: <20200828.065315.1411815033545543152.davem@davemloft.net>
To:     maheshb@google.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        mahesh@bandewar.net, maze@google.com, jianyang@google.com,
        rdunlap@infradead.org
Subject: Re: [PATCHv3 next] net: add option to not create fall-back tunnels
 in root-ns as well
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200826160535.1460065-1-maheshb@google.com>
References: <20200826160535.1460065-1-maheshb@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Aug 2020 06:36:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mahesh Bandewar <maheshb@google.com>
Date: Wed, 26 Aug 2020 09:05:35 -0700

> The sysctl that was added  earlier by commit 79134e6ce2c ("net: do
> not create fallback tunnels for non-default namespaces") to create
> fall-back only in root-ns. This patch enhances that behavior to provide
> option not to create fallback tunnels in root-ns as well. Since modules
> that create fallback tunnels could be built-in and setting the sysctl
> value after booting is pointless, so added a kernel cmdline options to
> change this default. The default setting is preseved for backward
> compatibility. The kernel command line option of fb_tunnels=initns will
> set the sysctl value to 1 and will create fallback tunnels only in initns
> while kernel cmdline fb_tunnels=none will set the sysctl value to 2 and
> fallback tunnels are skipped in every netns.
> 
> Signed-off-by: Mahesh Bandewar <maheshb@google.com>

Applied to net-next, thank you.
