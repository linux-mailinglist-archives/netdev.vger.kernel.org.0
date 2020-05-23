Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D42F1DFBE0
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 01:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388135AbgEWXdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 19:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388010AbgEWXdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 19:33:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A87C061A0E;
        Sat, 23 May 2020 16:33:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 523D01286F3A5;
        Sat, 23 May 2020 16:33:11 -0700 (PDT)
Date:   Sat, 23 May 2020 16:33:10 -0700 (PDT)
Message-Id: <20200523.163310.1379038150697586579.davem@davemloft.net>
To:     antoine.tenart@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: phy: mscc: fix initialization of the
 MACsec protocol mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200522155545.881263-1-antoine.tenart@bootlin.com>
References: <20200522155545.881263-1-antoine.tenart@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 23 May 2020 16:33:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>
Date: Fri, 22 May 2020 17:55:45 +0200

> At the very end of the MACsec block initialization in the MSCC PHY
> driver, the MACsec "protocol mode" is set. This setting should be set
> based on the PHY id within the package, as the bank used to access the
> register used depends on this. This was not done correctly, and only the
> first bank was used leading to the two upper PHYs being unstable when
> using the VSC8584. This patch fixes it.
> 
> Fixes: 1bbe0ecc2a1a ("net: phy: mscc: macsec initialization")
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Applied and queued up for -stable, thanks.
