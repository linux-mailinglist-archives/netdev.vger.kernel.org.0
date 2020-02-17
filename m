Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2213161DC5
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 00:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgBQXRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 18:17:07 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56508 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgBQXRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 18:17:07 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6034F15AACD84;
        Mon, 17 Feb 2020 15:17:06 -0800 (PST)
Date:   Mon, 17 Feb 2020 15:17:03 -0800 (PST)
Message-Id: <20200217.151703.130825896503926278.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: allow bcm84881 to be a module
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1j3irX-0006JO-FW@rmk-PC.armlinux.org.uk>
References: <E1j3irX-0006JO-FW@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Feb 2020 15:17:06 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Mon, 17 Feb 2020 16:03:11 +0000

> Now that the phylib module loading issue has been resolved, we can
> allow this PHY driver to be built as a module.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied.
