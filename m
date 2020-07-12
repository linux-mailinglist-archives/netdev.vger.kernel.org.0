Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C9F21CBCC
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 00:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgGLWXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 18:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbgGLWXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 18:23:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F8CAC061794
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 15:23:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 14C501284AF5F;
        Sun, 12 Jul 2020 15:23:05 -0700 (PDT)
Date:   Sun, 12 Jul 2020 15:23:03 -0700 (PDT)
Message-Id: <20200712.152303.680812448572649499.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com,
        rmk+kernel@armlinux.org.uk, cphealy@gmail.com, fugang.duan@nxp.com
Subject: Re: [PATCH net-next 0/2] Fix MTU warnings for fec/mv886xxx combo
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200711203206.1110108-1-andrew@lunn.ch>
References: <20200711203206.1110108-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 12 Jul 2020 15:23:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Sat, 11 Jul 2020 22:32:04 +0200

> Since changing the MTU of dsa slave interfaces was implemented, the
> fec/mv88e6xxx combo has been giving warnings:
> 
> [    2.275925] mv88e6085 0.2:00: nonfatal error -95 setting MTU on port 9
> [    2.284306] eth1: mtu greater than device maximum
> [    2.287759] fec 400d1000.ethernet eth1: error -22 setting MTU to include DSA overhead
> 
> This patchset adds support for changing the MTU on mv88e6xxx switches,
> which do support jumbo frames. And it modifies the FEC driver to
> support its true MTU range, which is larger than the default Ethernet
> MTU.

Series applied, thanks Andrew.
