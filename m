Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2CD9F8191
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 21:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbfKKUvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 15:51:42 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:32846 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfKKUvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 15:51:42 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6DCC2153D6D2A;
        Mon, 11 Nov 2019 12:51:41 -0800 (PST)
Date:   Mon, 11 Nov 2019 12:51:40 -0800 (PST)
Message-Id: <20191111.125140.2216790607856790691.davem@davemloft.net>
To:     irtimmer@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com
Subject: Re: [PATCH net-next v3 0/2] net: dsa: mv88e6xxx: Add support for
 port mirroring
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191107211114.106310-1-irtimmer@gmail.com>
References: <20191107211114.106310-1-irtimmer@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 Nov 2019 12:51:41 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Iwan R Timmer <irtimmer@gmail.com>
Date: Thu,  7 Nov 2019 22:11:12 +0100

> This patch serie add support for port mirroring in the mv88e6xx switch driver.
              ^^^^ corrected to "series"
> The first patch changes the set_egress_port function to allow different egress
> ports for egress and ingress traffic. The second patch adds the actual code for
> port mirroring support.
> 
> Tested on a 88E6176 with:
> 
> tc qdisc add dev wan0 clsact
> tc filter add dev wan0 ingress matchall skip_sw \
>         action mirred egress mirror dev lan2
> tc filter add dev wan0 egress matchall skip_sw \
>         action mirred egress mirror dev lan3

Series applied with the reverse christmas tree problems fixed in
patch #2.

Thanks.
