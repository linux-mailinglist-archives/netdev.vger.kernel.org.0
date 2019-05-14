Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83CE51E50E
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 00:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfENWUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 18:20:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59486 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbfENWUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 18:20:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2D10A14BFF4EE;
        Tue, 14 May 2019 15:20:52 -0700 (PDT)
Date:   Tue, 14 May 2019 15:20:51 -0700 (PDT)
Message-Id: <20190514.152051.1295024883277849866.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        jiri@resnulli.us
Subject: Re: [PATCH] net: Always descend into dsa/
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190513210624.10876-1-f.fainelli@gmail.com>
References: <20190513210624.10876-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 May 2019 15:20:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Mon, 13 May 2019 14:06:24 -0700

> Jiri reported that with a kernel built with CONFIG_FIXED_PHY=y,
> CONFIG_NET_DSA=m and CONFIG_NET_DSA_LOOP=m, we would not get to a
> functional state where the mock-up driver is registered. Turns out that
> we are not descending into drivers/net/dsa/ unconditionally, and we
> won't be able to link-in dsa_loop_bdinfo.o which does the actual mock-up
> mdio device registration.
> 
> Reported-by: Jiri Pirko <jiri@resnulli.us>
> Fixes: 40013ff20b1b ("net: dsa: Fix functional dsa-loop dependency on FIXED_PHY")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied and queued up for -stable, thanks.
