Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 262E912229E
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 04:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfLQDXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 22:23:43 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59314 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbfLQDXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 22:23:43 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C1F341425E491;
        Mon, 16 Dec 2019 19:23:42 -0800 (PST)
Date:   Mon, 16 Dec 2019 19:23:42 -0800 (PST)
Message-Id: <20191216.192342.1930212472590896192.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/5] WireGuard CI and housekeeping
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191215210804.143919-1-Jason@zx2c4.com>
References: <20191215210804.143919-1-Jason@zx2c4.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Dec 2019 19:23:42 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Sun, 15 Dec 2019 22:07:59 +0100

> This is a collection of commits gathered during the last 1.5 weeks since
> merging WireGuard. If you'd prefer, I can send tree pull requests
> instead, but I figure it might be best for now to just send things as
> full patch sets to netdev. 
> 
> The first part of this adds in the CI test harness that we've been using
> for quite some time with success. You can type `make` and get the
> selftests running in a fresh VM immediately. This has been an
> instrumental tool in developing WireGuard, and I think it'd benefit most
> from being in-tree alongside the selftests that are already there. Once
> this lands, I plan to get build.wireguard.com building wireguard-
> linux.git and net-next.git on every single commit pushed, and do so on a
> bunch of different architectures. As this migrates into Linus' tree
> eventually and then into net.git, I'll get net.git building there too on
> every commit. Future work with this involves generalizing it to include
> more networking subsystem tests beyond just WireGuard, but one step at a
> time. In the process of porting this to the tree, the builder uncovered
> a mistake in the config menu file, which the second commit fixes.
> 
> The last three commits are small housekeeping things, fixing spelling
> mistakes, replacing call_rcu with kfree_rcu, and removing an unused
> include.

Series applied.
