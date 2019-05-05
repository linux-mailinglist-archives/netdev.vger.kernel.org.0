Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99AB313E61
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 10:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727622AbfEEIGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 04:06:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46624 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbfEEIGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 04:06:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2767714C0AF80;
        Sun,  5 May 2019 01:06:15 -0700 (PDT)
Date:   Sun, 05 May 2019 01:06:14 -0700 (PDT)
Message-Id: <20190505.010614.936073435042477254.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phy: fix phy_validate_pause
From:   David Miller <davem@davemloft.net>
In-Reply-To: <9d05d207-d6f2-5771-5cf4-6d8342a4fb30@gmail.com>
References: <9d05d207-d6f2-5771-5cf4-6d8342a4fb30@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 01:06:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Wed, 1 May 2019 21:54:28 +0200

> We have valid scenarios where ETHTOOL_LINK_MODE_Pause_BIT doesn't
> need to be supported. Therefore extend the first check to check
> for rx_pause being set.
> 
> See also phy_set_asym_pause:
> rx=0 and tx=1: advertise asym pause only
> rx=0 and tx=0: stop advertising both pause modes
> 
> The fixed commit isn't wrong, it's just the one that introduced the
> linkmode bitmaps.
> 
> Fixes: 3c1bcc8614db ("net: ethernet: Convert phydev advertize and supported from u32 to link mode")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied and queued up for -stable.
