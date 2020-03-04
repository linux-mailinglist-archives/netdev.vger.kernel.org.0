Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 465631786D2
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 01:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgCDAGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 19:06:16 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37528 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727604AbgCDAGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 19:06:16 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2C8A515AB0D1B;
        Tue,  3 Mar 2020 16:06:15 -0800 (PST)
Date:   Tue, 03 Mar 2020 16:06:14 -0800 (PST)
Message-Id: <20200303.160614.1176351857930966618.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     rmk+kernel@armlinux.org.uk, f.fainelli@gmail.com,
        hkallweit1@gmail.com, antoine.tenart@bootlin.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/3] net: phy: marvell10g: add mdix control
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200303195352.GC1092@lunn.ch>
References: <20200303180747.GT25745@shell.armlinux.org.uk>
        <E1j9By6-0003pB-UH@rmk-PC.armlinux.org.uk>
        <20200303195352.GC1092@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Mar 2020 16:06:15 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Tue, 3 Mar 2020 20:53:52 +0100

> It would be nice to have Antoine test this before it get merged, but:
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Ok, I'll give Antoine a chance to test it out.
