Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69BB327DDA9
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 03:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729395AbgI3BRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 21:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728968AbgI3BRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 21:17:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153EEC061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 18:17:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0D61F127ED356;
        Tue, 29 Sep 2020 18:00:47 -0700 (PDT)
Date:   Tue, 29 Sep 2020 18:17:33 -0700 (PDT)
Message-Id: <20200929.181733.1663200201931665007.davem@davemloft.net>
To:     mathew.j.martineau@linux.intel.com
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org, pabeni@redhat.com
Subject: Re: [PATCH net 0/2] mptcp: Fix for 32-bit DATA_FIN
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200929220820.278003-1-mathew.j.martineau@linux.intel.com>
References: <20200929220820.278003-1-mathew.j.martineau@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 29 Sep 2020 18:00:47 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Date: Tue, 29 Sep 2020 15:08:18 -0700

> The main fix is contained in patch 2, and that commit message explains
> the issue with not properly converting truncated DATA_FIN sequence
> numbers sent by the peer.
> 
> With patch 2 adding an unlocked read of msk->ack_seq, patch 1 cleans up
> access to that data with READ_ONCE/WRITE_ONCE.
> 
> This does introduce two merge conflicts with net-next, but both have
> straightforward resolution. Patch 1 modifies a line that got removed in
> net-next so the modification can be dropped when merging. Patch 2 will
> require a trivial conflict resolution for a modified function
> declaration.

Series applied, thank you.
