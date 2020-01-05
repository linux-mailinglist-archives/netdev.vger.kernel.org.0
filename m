Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B62B6130AAF
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 00:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbgAEXLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 18:11:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42554 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbgAEXLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 18:11:03 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6BB8415714134;
        Sun,  5 Jan 2020 15:11:02 -0800 (PST)
Date:   Sun, 05 Jan 2020 15:11:01 -0800 (PST)
Message-Id: <20200105.151101.2143611033494270762.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        corbet@lwn.net, kishon@ti.com, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/2] Fix 10G PHY interface types
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200103204241.GB18808@shell.armlinux.org.uk>
References: <20200103204241.GB18808@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 Jan 2020 15:11:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Fri, 3 Jan 2020 20:42:42 +0000

> Recent discussion has revealed that our current usage of the 10GKR
> phy_interface_t is not correct. This is based on a misunderstanding
> caused in part by the various specifications being difficult to
> obtain. Now that a better understanding has been reached, we ought
> to correct this.
> 
> This series introduce PHY_INTERFACE_MODE_10GBASER to replace the
> existing usage of 10GKR mode, and document their differences in the
> phylib documentation. Then switch PHY, SFP/phylink, the Marvell
> PP2 network driver, and its associated comphy driver over to use
> the correct interface mode. None of the existing platform usage
> was actually using 10GBASE-KR.
 ...

Series applied, thank you.
