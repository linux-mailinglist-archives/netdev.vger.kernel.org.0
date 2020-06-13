Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF811F85B4
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 00:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgFMWiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 18:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgFMWiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jun 2020 18:38:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0719FC03E96F;
        Sat, 13 Jun 2020 15:38:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4801B11F5F637;
        Sat, 13 Jun 2020 15:38:02 -0700 (PDT)
Date:   Sat, 13 Jun 2020 15:38:01 -0700 (PDT)
Message-Id: <20200613.153801.1383724005122062451.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, m-karicheri2@ti.com,
        nsekhar@ti.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: ti: ale: fix allmulti for nu type ale
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200613145414.17190-1-grygorii.strashko@ti.com>
References: <20200613145414.17190-1-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 13 Jun 2020 15:38:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Sat, 13 Jun 2020 17:54:14 +0300

> On AM65xx MCU CPSW2G NUSS and 66AK2E/L NUSS allmulti setting does not allow
> unregistered mcast packets to pass.
> 
> This happens, because ALE VLAN entries on these SoCs do not contain port
> masks for reg/unreg mcast packets, but instead store indexes of
> ALE_VLAN_MASK_MUXx_REG registers which intended for store port masks for
> reg/unreg mcast packets.
> This path was missed by commit 9d1f6447274f ("net: ethernet: ti: ale: fix
> seeing unreg mcast packets with promisc and allmulti disabled").
> 
> Hence, fix it by taking into account ALE type in cpsw_ale_set_allmulti().
> 
> Fixes: 9d1f6447274f ("net: ethernet: ti: ale: fix seeing unreg mcast packets with promisc and allmulti disabled")
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Applied and queued up for v5.7 -stable.
