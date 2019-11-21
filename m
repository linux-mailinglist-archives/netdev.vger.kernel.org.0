Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 589C8104AC4
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 07:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbfKUG3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 01:29:55 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38202 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfKUG3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 01:29:55 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 20BA214DF3D4F;
        Wed, 20 Nov 2019 22:29:55 -0800 (PST)
Date:   Wed, 20 Nov 2019 22:29:54 -0800 (PST)
Message-Id: <20191120.222954.1545171859106312695.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: sfp: soft status and control support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1iXP7P-0006DS-47@rmk-PC.armlinux.org.uk>
References: <E1iXP7P-0006DS-47@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 Nov 2019 22:29:55 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Wed, 20 Nov 2019 12:29:59 +0000

> Add support for the soft status and control register, which allows
> TX_FAULT and RX_LOS to be monitored and TX_DISABLE to be set.  We
> make use of this when the board does not support GPIOs for these
> signals.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied.
