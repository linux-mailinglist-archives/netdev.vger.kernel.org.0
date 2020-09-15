Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C762126AEB4
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 22:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbgIOUdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 16:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728060AbgIOUb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 16:31:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDB3C06174A
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 13:31:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7762213684403;
        Tue, 15 Sep 2020 13:15:10 -0700 (PDT)
Date:   Tue, 15 Sep 2020 13:31:56 -0700 (PDT)
Message-Id: <20200915.133156.1580615428345209072.davem@davemloft.net>
To:     jesse.brandeburg@intel.com
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v2 00/10] make drivers/net/ethernet W=1 clean
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200915014455.1232507-1-jesse.brandeburg@intel.com>
References: <20200915014455.1232507-1-jesse.brandeburg@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 15 Sep 2020 13:15:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>
Date: Mon, 14 Sep 2020 18:44:45 -0700

> After applying the patches below, the drivers/net/ethernet
> directory can be built as modules with W=1 with no warnings (so
> far on x64_64 arch only!).
> As Jakub pointed out, there is much more work to do to clean up
> C=1, but that will be another series of changes.
> 
> This series removes 1,283 warnings and hopefully allows the
> ethernet directory to move forward from here without more
> warnings being added. There is only one objtool warning now.
> 
> Some of these patches are already sent to Intel Wired Lan, but
> the rest of the series titled drivers/net/ethernet affects other
> drivers. The changes are all pretty straightforward.
> 
> As part of testing this series I realized that I have ~1,500 more
> kdoc warnings to fix due to being in other arch or not compiled
> with my x86_64 .config. Feel free to run
> $ 'git ls-files *.[ch] | grep drivers/net/ethernet | xargs
> scripts/kernel-doc -none'
> to see the remaining issues.

Jesse, in all of these patches, I want to see the warning you are
fixing in the commit message.

Especially for the sh_eth.c one because I have no idea what the
compiler is actually warning about just by reading your commit
message and patch on it's own.

Thank you.
