Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD714FDAB
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 20:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfFWSfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 14:35:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43588 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbfFWSfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 14:35:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 507CE12D8C1AE;
        Sun, 23 Jun 2019 11:35:21 -0700 (PDT)
Date:   Sun, 23 Jun 2019 11:35:20 -0700 (PDT)
Message-Id: <20190623.113520.819087494032482606.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        corbet@lwn.net, netdev@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] doc: phy: document some
 PHY_INTERFACE_MODE_xxx settings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1heL0P-00075z-An@rmk-PC.armlinux.org.uk>
References: <E1heL0P-00075z-An@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Jun 2019 11:35:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Fri, 21 Jun 2019 15:59:09 +0100

> There seems to be some confusion surrounding three PHY interface modes,
> specifically 1000BASE-X, 2500BASE-X and SGMII.  Add some documentation
> to phylib detailing precisely what these interface modes refer to.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied.
