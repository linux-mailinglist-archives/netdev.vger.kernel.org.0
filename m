Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A089172880
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 20:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbgB0TV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 14:21:56 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43968 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727186AbgB0TV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 14:21:56 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AD89D121103E5;
        Thu, 27 Feb 2020 11:21:55 -0800 (PST)
Date:   Thu, 27 Feb 2020 11:21:55 -0800 (PST)
Message-Id: <20200227.112155.1232656432625812585.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: marvell10g: read copper results
 from CSSR1
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1j7Fka-0003lI-No@rmk-PC.armlinux.org.uk>
References: <E1j7Fka-0003lI-No@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Feb 2020 11:21:55 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Thu, 27 Feb 2020 09:46:36 +0000

> Read the copper autonegotiation results from the copper specific
> status register, rather than decoding the advertisements. Reading
> what the link is actually doing will allow us to support downshift
> modes.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied.
