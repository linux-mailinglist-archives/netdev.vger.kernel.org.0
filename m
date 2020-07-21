Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E067B22749F
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbgGUBgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgGUBgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 21:36:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC78C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 18:36:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 506F911FFCC48;
        Mon, 20 Jul 2020 18:19:25 -0700 (PDT)
Date:   Mon, 20 Jul 2020 18:36:09 -0700 (PDT)
Message-Id: <20200720.183609.1291892507136297053.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, noodles@earth.li,
        mnhagan88@gmail.com
Subject: Re: [PATCH net-next] net: dsa: use the ETH_MIN_MTU and
 ETH_DATA_LEN default values
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200718180418.255098-1-olteanv@gmail.com>
References: <20200718180418.255098-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jul 2020 18:19:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sat, 18 Jul 2020 21:04:18 +0300

> Now that DSA supports MTU configuration, undo the effects of commit
> 8b1efc0f83f1 ("net: remove MTU limits on a few ether_setup callers") and
> let DSA interfaces use the default min_mtu and max_mtu specified by
> ether_setup(). This is more important for min_mtu: since DSA is
> Ethernet, the minimum MTU is the same as of any other Ethernet
> interface, and definitely not zero. For the max_mtu, we have a callback
> through which drivers can override that, if they want to.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Applied, thanks.
