Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED44F228C78
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 01:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgGUXJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 19:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgGUXJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 19:09:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BAC8C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 16:09:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5427D11E45904;
        Tue, 21 Jul 2020 15:53:12 -0700 (PDT)
Date:   Tue, 21 Jul 2020 16:09:56 -0700 (PDT)
Message-Id: <20200721.160956.1015616148171478130.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, jiri@mellanox.com
Subject: Re: [PATCH net v2] netdevsim: fix unbalaced locking in
 nsim_create()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200721145150.25964-1-ap420073@gmail.com>
References: <20200721145150.25964-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jul 2020 15:53:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Tue, 21 Jul 2020 14:51:50 +0000

> In the nsim_create(), rtnl_lock() is called before nsim_bpf_init().
> If nsim_bpf_init() is failed, rtnl_unlock() should be called,
> but it isn't called.
> So, unbalanced locking would occur.
> 
> Fixes: e05b2d141fef ("netdevsim: move netdev creation/destruction to dev probe")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied and queued up for -stable, thank you.
