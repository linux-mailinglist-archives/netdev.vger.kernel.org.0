Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE1711860B5
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 01:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbgCPALd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 20:11:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42712 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729065AbgCPALd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 20:11:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C195F12179335;
        Sun, 15 Mar 2020 17:11:32 -0700 (PDT)
Date:   Sun, 15 Mar 2020 17:11:32 -0700 (PDT)
Message-Id: <20200315.171132.1620303075031918594.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org, vivien.didelot@gmail.com
Subject: Re: [PATCH REPOST net-next 0/8] net: dsa: improve serdes
 integration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200314101431.GF25745@shell.armlinux.org.uk>
References: <20200314101431.GF25745@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 15 Mar 2020 17:11:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Sat, 14 Mar 2020 10:14:31 +0000

> Depends on "net: mii clause 37 helpers".
> 
> Andrew Lunn mentioned that the Serdes PCS found in Marvell DSA switches
> does not automatically update the switch MACs with the link parameters.
> Currently, the DSA code implements a work-around for this.
> 
> This series improves the Serdes integration, making use of the recent
> phylink changes to support split MAC/PCS setups.  One noticable
> improvement for userspace is that ethtool can now report the link
> partner's advertisement.
> 
> This repost has no changes compared to the previous posting; however,
> the regression Andrew had found which exists even without this patch
> set has now been fixed by Andrew and merged into the net-next tree.

Series applied.
