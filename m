Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6197164ED7
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 20:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgBSTX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 14:23:26 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46720 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbgBSTX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 14:23:26 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1104C15AE0883;
        Wed, 19 Feb 2020 11:23:26 -0800 (PST)
Date:   Wed, 19 Feb 2020 11:23:25 -0800 (PST)
Message-Id: <20200219.112325.2251268530784358968.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] net: phy: Better support for BCM54810
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200214233853.27217-1-f.fainelli@gmail.com>
References: <20200214233853.27217-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Feb 2020 11:23:26 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Fri, 14 Feb 2020 15:38:50 -0800

> Hi David, Andrew, Heiner,
> 
> This patch series updates the broadcom PHY driver to better support the
> BCM54810 and allow it to make use of the exiting
> bcm54xx_adjust_rxrefclk() as well as fix suspend/resume for it.

Florian, please respond to Andrew's feedback on patch #2 wrt. the checking
of PHY_BRCM_RX_REFCLK_UNUSED.

Thank you.
