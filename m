Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C98234EC2
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 01:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgGaX42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 19:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgGaX42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 19:56:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1296C06174A
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 16:56:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9FE8E11E58FA6;
        Fri, 31 Jul 2020 16:39:42 -0700 (PDT)
Date:   Fri, 31 Jul 2020 16:56:27 -0700 (PDT)
Message-Id: <20200731.165627.166873468993268295.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        pabeni@redhat.com
Subject: Re: [PATCH v2 net-next 0/9] mptcp: add syncookie support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200730192558.25697-1-fw@strlen.de>
References: <20200730192558.25697-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 Jul 2020 16:39:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Thu, 30 Jul 2020 21:25:49 +0200

> Changes in v2:
 ...
> When syn-cookies are used the SYN?ACK never contains a MPTCP option,
> because the code path that creates a request socket based on a valid
> cookie ACK lacks the needed changes to construct MPTCP request sockets.
> 
> After this series, if SYN carries MP_CAPABLE option, the option is not
> cleared anymore and request socket will be reconstructed using the
> MP_CAPABLE option data that is re-sent with the ACK.
> 
> This means that no additional state gets encoded into the syn cookie or
> the TCP timestamp.
 ...

Series applied, thanks Florian.
