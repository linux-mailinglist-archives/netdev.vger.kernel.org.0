Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A24B22D413
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 05:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgGYDDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 23:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbgGYDDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 23:03:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61DFC0619D3;
        Fri, 24 Jul 2020 20:03:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E642312779335;
        Fri, 24 Jul 2020 19:46:58 -0700 (PDT)
Date:   Fri, 24 Jul 2020 20:03:43 -0700 (PDT)
Message-Id: <20200724.200343.2079706304039287145.davem@davemloft.net>
To:     chris.packham@alliedtelesis.co.nz
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] net: dsa: mv88e6xxx: port mtu support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200723232122.5384-1-chris.packham@alliedtelesis.co.nz>
References: <20200723232122.5384-1-chris.packham@alliedtelesis.co.nz>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jul 2020 19:46:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>
Date: Fri, 24 Jul 2020 11:21:19 +1200

> This series connects up the mv88e6xxx switches to the dsa infrastructure for
> configuring the port MTU. The first patch is also a bug fix which might be a
> candiatate for stable.
> 
> I've rebased this series on top of net-next/master to pick up Andrew's change
> for the gigabit switches. Patch 1 and 2 are unchanged (aside from adding
> Andrew's Reviewed-by). Patch 3 is reworked to make use of the existing mtu
> support.

Series applied, thanks Chris.
