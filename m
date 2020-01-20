Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6EB142784
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 10:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgATJnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 04:43:45 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55196 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgATJnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 04:43:45 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D20C2153D7D2C;
        Mon, 20 Jan 2020 01:43:43 -0800 (PST)
Date:   Mon, 20 Jan 2020 10:43:42 +0100 (CET)
Message-Id: <20200120.104342.1983065114704874863.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: phy: add generic ndo_do_ioctl
 handler phy_do_ioctl
From:   David Miller <davem@davemloft.net>
In-Reply-To: <520c07a1-dd26-1414-0a2f-7f0d491589d1@gmail.com>
References: <520c07a1-dd26-1414-0a2f-7f0d491589d1@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jan 2020 01:43:44 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sun, 19 Jan 2020 14:31:06 +0100

> A number of network drivers has the same glue code to use phy_mii_ioctl
> as ndo_do_ioctl handler. So let's add such a generic ndo_do_ioctl
> handler to phylib. As first user convert r8169.

Series applied, thanks Heiner.
