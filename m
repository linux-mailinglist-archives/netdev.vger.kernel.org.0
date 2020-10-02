Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 791A6280C1F
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 03:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387511AbgJBBuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 21:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727780AbgJBBuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 21:50:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 274C6C0613D0;
        Thu,  1 Oct 2020 18:50:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B075D128616E5;
        Thu,  1 Oct 2020 18:33:34 -0700 (PDT)
Date:   Thu, 01 Oct 2020 18:50:21 -0700 (PDT)
Message-Id: <20201001.185021.757329080393673415.davem@davemloft.net>
To:     willy.liu@realtek.com
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ryankao@realtek.com
Subject: Re: [PATCH net v1] net: phy: realtek: Modify 2.5G PHY name to
 RTL8226
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1601448538-18004-1-git-send-email-willy.liu@realtek.com>
References: <1601448538-18004-1-git-send-email-willy.liu@realtek.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 01 Oct 2020 18:33:35 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willy Liu <willy.liu@realtek.com>
Date: Wed, 30 Sep 2020 14:48:58 +0800

> Realtek single-chip Ethernet PHY solutions can be separated as below:
> 10M/100Mbps: RTL8201X
> 1Gbps: RTL8211X
> 2.5Gbps: RTL8226/RTL8221X
> RTL8226 is the first version for realtek that compatible 2.5Gbps single PHY.
> Since RTL8226 is single port only, realtek changes its name to RTL8221B from
> the second version.
> PHY ID for RTL8226 is 0x001cc800 and RTL8226B/RTL8221B is 0x001cc840.
> 
> RTL8125 is not a single PHY solution, it integrates PHY/MAC/PCIE bus
> controller and embedded memory.
> 
> Signed-off-by: Willy Liu <willy.liu@realtek.com>

Applied to net-next as this is just renaming rather than a functional
change.
