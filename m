Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 635CF9F8E0
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 05:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbfH1Dqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 23:46:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54364 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbfH1Dqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 23:46:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 99941153B9733;
        Tue, 27 Aug 2019 20:46:39 -0700 (PDT)
Date:   Tue, 27 Aug 2019 20:46:39 -0700 (PDT)
Message-Id: <20190827.204639.197707480276450895.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] Simplify DSA handling of VLAN
 subinterface offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190825194630.12404-1-olteanv@gmail.com>
References: <20190825194630.12404-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 27 Aug 2019 20:46:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sun, 25 Aug 2019 22:46:28 +0300

> Depends on Vivien Didelot's patchset:
> https://patchwork.ozlabs.org/project/netdev/list/?series=127197&state=*
> 
> This patchset removes a few strange-looking guards for -EOPNOTSUPP in
> dsa_slave_vlan_rx_add_vid and dsa_slave_vlan_rx_kill_vid, making that
> code path no longer possible.
> 
> It also disables the code path for the sja1105 driver, which does
> support editing the VLAN table, but not hardware-accelerated VLAN
> sub-interfaces, therefore the check in the DSA core would be wrong.
> There was no better DSA callback to do this than .port_enable, i.e.
> at ndo_open time.

Series applied.
