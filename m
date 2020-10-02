Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6EB281CFD
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 22:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725767AbgJBUgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 16:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgJBUgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 16:36:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1EDC0613D0;
        Fri,  2 Oct 2020 13:36:24 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1360611E3E4C0;
        Fri,  2 Oct 2020 13:19:36 -0700 (PDT)
Date:   Fri, 02 Oct 2020 13:36:23 -0700 (PDT)
Message-Id: <20201002.133623.1599844259414142485.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vladimir.oltean@nxp.com, olteanv@gmail.com
Subject: Re: [PATCH net-next 0/4] net: dsa: Improve dsa_untag_bridge_pvid()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201002024215.660240-1-f.fainelli@gmail.com>
References: <20201002024215.660240-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 02 Oct 2020 13:19:36 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu,  1 Oct 2020 19:42:11 -0700

> Hi David, Jakub,
> 
> This patch series is based on the recent discussions with Vladimir:
> 
> https://lore.kernel.org/netdev/20201001030623.343535-1-f.fainelli@gmail.com/
> 
> the simplest way forward was to call dsa_untag_bridge_pvid() after
> eth_type_trans() has been set which guarantees that skb->protocol is set
> to a correct value and this allows us to utilize
> __vlan_find_dev_deep_rcu() properly without playing or using the bridge
> master as a net_device reference.

Series applied, thanks.
