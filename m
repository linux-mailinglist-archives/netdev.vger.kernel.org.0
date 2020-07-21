Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C829D22749B
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgGUBe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgGUBe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 21:34:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF2AC061794;
        Mon, 20 Jul 2020 18:34:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3077911FFCC40;
        Mon, 20 Jul 2020 18:17:44 -0700 (PDT)
Date:   Mon, 20 Jul 2020 18:34:28 -0700 (PDT)
Message-Id: <20200720.183428.2152272813009297053.davem@davemloft.net>
To:     noodles@earth.li
Cc:     olteanv@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org, mnhagan88@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: dsa: qca8k: implement the port MTU callbacks
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200718163214.GA2634@earth.li>
References: <20200718093555.GA12912@earth.li>
        <20200718163214.GA2634@earth.li>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jul 2020 18:17:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan McDowell <noodles@earth.li>
Date: Sat, 18 Jul 2020 17:32:14 +0100

> This switch has a single max frame size configuration register, so we
> track the requested MTU for each port and apply the largest.
> 
> v2:
> - Address review feedback from Vladimir Oltean
> 
> Signed-off-by: Jonathan McDowell <noodles@earth.li>

Applied to net-next, thanks.
