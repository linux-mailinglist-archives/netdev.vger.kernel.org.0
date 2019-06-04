Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2F9134FF5
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 20:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbfFDSoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 14:44:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50260 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfFDSoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 14:44:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3205114FA8373;
        Tue,  4 Jun 2019 11:44:01 -0700 (PDT)
Date:   Tue, 04 Jun 2019 11:44:00 -0700 (PDT)
Message-Id: <20190604.114400.2034212374424468218.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: phylink: avoid reducing support mask
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1hXREE-0005KM-Jy@rmk-PC.armlinux.org.uk>
References: <E1hXREE-0005KM-Jy@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Jun 2019 11:44:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Sun, 02 Jun 2019 15:12:54 +0100

> Avoid reducing the support mask as a result of the interface type
> selected for SFP modules, or when setting the link settings through
> ethtool - this should only change when the supported link modes of
> the hardware combination change.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied, thank you.
