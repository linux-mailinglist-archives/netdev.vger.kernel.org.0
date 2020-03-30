Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D43CA1973CD
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 07:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgC3FVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 01:21:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33342 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728349AbgC3FVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 01:21:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 77BDF15C70528;
        Sun, 29 Mar 2020 22:21:10 -0700 (PDT)
Date:   Sun, 29 Mar 2020 22:21:09 -0700 (PDT)
Message-Id: <20200329.222109.1183931707971302785.davem@davemloft.net>
To:     w.dauchy@criteo.com
Cc:     netdev@vger.kernel.org, nicolas.dichtel@6wind.com
Subject: Re: [PATCH v3 net] net, ip_tunnel: fix interface lookup with no key
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200327185639.71238-1-w.dauchy@criteo.com>
References: <20200327145444.61875-1-w.dauchy@criteo.com>
        <20200327185639.71238-1-w.dauchy@criteo.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 29 Mar 2020 22:21:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: William Dauchy <w.dauchy@criteo.com>
Date: Fri, 27 Mar 2020 19:56:39 +0100

> when creating a new ipip interface with no local/remote configuration,
> the lookup is done with TUNNEL_NO_KEY flag, making it impossible to
> match the new interface (only possible match being fallback or metada
> case interface); e.g: `ip link add tunl1 type ipip dev eth0`
> 
> To fix this case, adding a flag check before the key comparison so we
> permit to match an interface with no local/remote config; it also avoids
> breaking possible userland tools relying on TUNNEL_NO_KEY flag and
> uninitialised key.
> 
> context being on my side, I'm creating an extra ipip interface attached
> to the physical one, and moving it to a dedicated namespace.
> 
> Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
> Signed-off-by: William Dauchy <w.dauchy@criteo.com>

Applied and queued up for -stable, thanks.
