Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 352611010B7
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 02:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbfKSB1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 20:27:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52284 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726775AbfKSB1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 20:27:03 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6FD9A150FAE85;
        Mon, 18 Nov 2019 17:27:02 -0800 (PST)
Date:   Mon, 18 Nov 2019 17:27:01 -0800 (PST)
Message-Id: <20191118.172701.853956001676795272.davem@davemloft.net>
To:     marcelo.leitner@gmail.com
Cc:     netdev@vger.kernel.org, mcroce@redhat.com
Subject: Re: [PATCH net] net/ipv4: fix sysctl max for
 fib_multipath_hash_policy
From:   David Miller <davem@davemloft.net>
In-Reply-To: <9b97a07518c119e531de8ab012d95a8f3feea038.1574080178.git.marcelo.leitner@gmail.com>
References: <9b97a07518c119e531de8ab012d95a8f3feea038.1574080178.git.marcelo.leitner@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 18 Nov 2019 17:27:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 18 Nov 2019 09:46:09 -0300

> Commit eec4844fae7c ("proc/sysctl: add shared variables for range
> check") did:
> -               .extra2         = &two,
> +               .extra2         = SYSCTL_ONE,
> here, which doesn't seem to be intentional, given the changelog.
> This patch restores it to the previous, as the value of 2 still makes
> sense (used in fib_multipath_hash()).
> 
> Fixes: eec4844fae7c ("proc/sysctl: add shared variables for range check")
> Cc: Matteo Croce <mcroce@redhat.com>
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied and queued up for -stable, thanks.
