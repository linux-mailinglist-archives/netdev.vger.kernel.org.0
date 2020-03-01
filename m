Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46671174BF6
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 06:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgCAF7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 00:59:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38974 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgCAF7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 00:59:35 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D765C15BDA6DC;
        Sat, 29 Feb 2020 21:59:34 -0800 (PST)
Date:   Sat, 29 Feb 2020 21:59:34 -0800 (PST)
Message-Id: <20200229.215934.1263272461754132496.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: sja1105: Don't destroy not-yet-created
 xmit_worker
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200229203007.16703-1-olteanv@gmail.com>
References: <20200229203007.16703-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Feb 2020 21:59:35 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sat, 29 Feb 2020 22:30:07 +0200

> Fixes the following NULL pointer dereference on PHY connect error path
> teardown:
 ...
> Checking for NULL pointer is correct because the per-port xmit kernel
> threads are created in sja1105_probe immediately after calling
> dsa_register_switch.
> 
> Fixes: a68578c20a96 ("net: dsa: Make deferred_xmit private to sja1105")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Applied, thank you.
