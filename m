Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE10220FD54
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 22:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbgF3UBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 16:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728874AbgF3UBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 16:01:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A70EC061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 13:01:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 24807127637A2;
        Tue, 30 Jun 2020 13:01:51 -0700 (PDT)
Date:   Tue, 30 Jun 2020 13:01:50 -0700 (PDT)
Message-Id: <20200630.130150.323289712076556518.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        kuba@kernel.org, maxime.chevallier@bootlin.com
Subject: Re: [PATCH net] net: mvneta: fix use of state->speed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1jqD84-0004hC-54@rmk-PC.armlinux.org.uk>
References: <E1jqD84-0004hC-54@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jun 2020 13:01:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Tue, 30 Jun 2020 11:04:40 +0100

> When support for short preambles was added, it incorrectly keyed its
> decision off state->speed instead of state->interface.  state->speed
> is not guaranteed to be correct for in-band modes, which can lead to
> short preambles being unexpectedly disabled.
> 
> Fix this by keying off the interface mode, which is the only way that
> mvneta can operate at 2.5Gbps.
> 
> Fixes: da58a931f248 ("net: mvneta: Add support for 2500Mbps SGMII")
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied and queued up for -stable, thanks.
