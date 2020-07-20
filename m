Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9CD2273FF
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 02:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgGUAmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 20:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgGUAmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 20:42:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163A1C061794;
        Mon, 20 Jul 2020 17:42:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 390E811E8EC0D;
        Mon, 20 Jul 2020 17:25:58 -0700 (PDT)
Date:   Mon, 20 Jul 2020 16:49:48 -0700 (PDT)
Message-Id: <20200720.164948.1294578504944144052.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        kuba@kernel.org, jiri@mellanox.com, edumazet@google.com,
        ap420073@gmail.com, xiyou.wangcong@gmail.com, maximmi@mellanox.com,
        richardcochran@gmail.com, mkubecek@suse.cz,
        linux-kernel@vger.kernel.org, olteanv@gmail.com
Subject: Re: [PATCH net-next v2 0/4] net: dsa: Setup dsa_netdev_ops
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200720034954.66895-1-f.fainelli@gmail.com>
References: <20200720034954.66895-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jul 2020 17:25:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Sun, 19 Jul 2020 20:49:50 -0700

> This patch series addresses the overloading of a DSA CPU/management
> interface's netdev_ops for the purpose of providing useful information
> from the switch side.
> 
> Up until now we had duplicated the existing netdev_ops structure and
> added specific function pointers to return information of interest. Here
> we have a more controlled way of doing this by involving the specific
> netdev_ops function pointers that we want to be patched, which is easier
> for auditing code in the future. As a byproduct we can now maintain
> netdev_ops pointer comparisons which would be failing before (no known
> in tree problems because of that though).
> 
> Let me know if this approach looks reasonable to you and we might do the
> same with our ethtool_ops overloading as well.

This looks good to me, series applied.

And yes, doing something similar for ethtool_ops is probably a good idea
too.
