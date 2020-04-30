Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578B81C0641
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 21:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgD3TXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 15:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbgD3TXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 15:23:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F5FC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 12:23:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5281312894FB1;
        Thu, 30 Apr 2020 12:23:51 -0700 (PDT)
Date:   Thu, 30 Apr 2020 12:23:50 -0700 (PDT)
Message-Id: <20200430.122350.1535307324828560479.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        kuba@kernel.org, cpaasch@apple.com, mptcp@lists.01.org
Subject: Re: [PATCH net v2 0/5] mptcp: fix incoming options parsing
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1588243786.git.pabeni@redhat.com>
References: <cover.1588243786.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 12:23:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Thu, 30 Apr 2020 15:01:50 +0200

> This series addresses a serious issue in MPTCP option parsing.
> 
> This is bigger than the usual -net change, but I was unable to find a
> working, sane, smaller fix.
> 
> The core change is inside patch 2/5 which moved MPTCP options parsing from
> the TCP code inside existing MPTCP hooks and clean MPTCP options status on
> each processed packet.
> 
> The patch 1/5 is a needed pre-requisite, and patches 3,4,5 are smaller,
> related fixes.
> 
> v1 -> v2:
>  - cleaned-up patch 1/5
>  - rebased on top of current -net

Series applied, thanks.
