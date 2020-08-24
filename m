Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8428A24FF1F
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 15:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgHXNkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 09:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727915AbgHXNkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 09:40:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C79C061573
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 06:40:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C0D2B128286F4;
        Mon, 24 Aug 2020 06:23:44 -0700 (PDT)
Date:   Mon, 24 Aug 2020 06:40:30 -0700 (PDT)
Message-Id: <20200824.064030.508387089672625330.davem@davemloft.net>
To:     tklauser@distanz.ch
Cc:     kuba@kernel.org, netdev@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH net] ipv6: ndisc: adjust ndisc_ifinfo_sysctl_change
 prototype
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200824114622.26400-1-tklauser@distanz.ch>
References: <20200824114622.26400-1-tklauser@distanz.ch>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Aug 2020 06:23:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Klauser <tklauser@distanz.ch>
Date: Mon, 24 Aug 2020 13:46:22 +0200

> Commit 32927393dc1c ("sysctl: pass kernel pointers to ->proc_handler")
> changed ndisc_ifinfo_sysctl_change to take a kernel pointer. Adjust its
> prototype in net/ndisc.h as well to fix the following sparse warning:
> 
> net/ipv6/ndisc.c:1838:5: error: symbol 'ndisc_ifinfo_sysctl_change' redeclared with different type (incompatible argument 3 (different address spaces)):
> net/ipv6/ndisc.c:1838:5:    int extern [addressable] [signed] [toplevel] ndisc_ifinfo_sysctl_change( ... )
> net/ipv6/ndisc.c: note: in included file (through include/net/ipv6.h):
> ./include/net/ndisc.h:496:5: note: previously declared as:
> ./include/net/ndisc.h:496:5:    int extern [addressable] [signed] [toplevel] ndisc_ifinfo_sysctl_change( ... )
> net/ipv6/ndisc.c: note: in included file (through include/net/ip6_route.h):
> 
> Fixes: 32927393dc1c ("sysctl: pass kernel pointers to ->proc_handler")
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>

Applied, thank you.
