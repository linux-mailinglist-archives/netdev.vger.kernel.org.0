Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5420311D66F
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 19:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730503AbfLLSzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 13:55:46 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42630 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730421AbfLLSzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 13:55:46 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 842BC153DF647;
        Thu, 12 Dec 2019 10:55:45 -0800 (PST)
Date:   Thu, 12 Dec 2019 10:55:44 -0800 (PST)
Message-Id: <20191212.105544.1239200588810264031.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phylink: fix interface passed to mac_link_up
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1ifLlX-0004U8-Of@rmk-PC.armlinux.org.uk>
References: <E1ifLlX-0004U8-Of@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Dec 2019 10:55:45 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Thu, 12 Dec 2019 10:32:15 +0000

> A mismerge between the following two commits:
> 
> c678726305b9 ("net: phylink: ensure consistent phy interface mode")
> 27755ff88c0e ("net: phylink: Add phylink_mac_link_{up, down} wrapper functions")
> 
> resulted in the wrong interface being passed to the mac_link_up()
> function. Fix this up.
> 
> Fixes: b4b12b0d2f02 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net")
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Does not apply to the 'net' tree.
