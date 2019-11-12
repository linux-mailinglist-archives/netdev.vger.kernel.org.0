Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2C07F9975
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 20:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbfKLTNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 14:13:54 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48032 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbfKLTNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 14:13:54 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 806A0154CD374;
        Tue, 12 Nov 2019 11:13:53 -0800 (PST)
Date:   Tue, 12 Nov 2019 11:13:51 -0800 (PST)
Message-Id: <20191112.111351.1430395078717104988.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: [PATCH net-next] net: sfp: fix sfp_bus_add_upstream() warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1iUURo-0003A9-KA@rmk-PC.armlinux.org.uk>
References: <E1iUURo-0003A9-KA@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 11:13:53 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Tue, 12 Nov 2019 11:35:00 +0000

> When building with SFP disabled, the stub for sfp_bus_add_upstream()
> missed "inline".  Add it.
> 
> Fixes: 727b3668b730 ("net: sfp: rework upstream interface")
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied.
