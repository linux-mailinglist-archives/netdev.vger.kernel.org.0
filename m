Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAAA234EDF
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 02:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbgHAAST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 20:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727116AbgHAAST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 20:18:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D12C06174A;
        Fri, 31 Jul 2020 17:18:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0A16711E4590A;
        Fri, 31 Jul 2020 17:01:33 -0700 (PDT)
Date:   Fri, 31 Jul 2020 17:18:17 -0700 (PDT)
Message-Id: <20200731.171817.1478408613409998661.davem@davemloft.net>
To:     jasowang@redhat.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com
Subject: Re: [PATCH net-next] tun: add missing rcu annotation in
 tun_set_ebpf()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200731041720.61187-1-jasowang@redhat.com>
References: <20200731041720.61187-1-jasowang@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 Jul 2020 17:01:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Fri, 31 Jul 2020 00:17:20 -0400

> We expecte prog_p to be protected by rcu, so adding the rcu annotation
> to fix the following sparse warning:
> 
> drivers/net/tun.c:3003:36: warning: incorrect type in argument 2 (different address spaces)
> drivers/net/tun.c:3003:36:    expected struct tun_prog [noderef] __rcu **prog_p
> drivers/net/tun.c:3003:36:    got struct tun_prog **prog_p
> drivers/net/tun.c:3292:42: warning: incorrect type in argument 2 (different address spaces)
> drivers/net/tun.c:3292:42:    expected struct tun_prog **prog_p
> drivers/net/tun.c:3292:42:    got struct tun_prog [noderef] __rcu **
> drivers/net/tun.c:3296:42: warning: incorrect type in argument 2 (different address spaces)
> drivers/net/tun.c:3296:42:    expected struct tun_prog **prog_p
> drivers/net/tun.c:3296:42:    got struct tun_prog [noderef] __rcu **
> 
> Reported-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied, thanks.
