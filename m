Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912DE23C207
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 01:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbgHDXFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 19:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgHDXFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 19:05:04 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4708C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 16:05:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A9D1B12896965;
        Tue,  4 Aug 2020 15:48:18 -0700 (PDT)
Date:   Tue, 04 Aug 2020 16:05:03 -0700 (PDT)
Message-Id: <20200804.160503.345018090282944608.davem@davemloft.net>
To:     sr@denx.de
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        reto.schneider@husqvarnagroup.com, alexandre.belloni@bootlin.com,
        nicolas.ferre@microchip.com
Subject: Re: [PATCH] net: macb: Properly handle phylink on at91sam9x
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200804121716.418535-1-sr@denx.de>
References: <20200804121716.418535-1-sr@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Aug 2020 15:48:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Roese <sr@denx.de>
Date: Tue,  4 Aug 2020 14:17:16 +0200

> I just recently noticed that ethernet does not work anymore since v5.5
> on the GARDENA smart Gateway, which is based on the AT91SAM9G25.
> Debugging showed that the "GEM bits" in the NCFGR register are now
> unconditionally accessed, which is incorrect for the !macb_is_gem()
> case.
> 
> This patch adds the macb_is_gem() checks back to the code
> (in macb_mac_config() & macb_mac_link_up()), so that the GEM register
> bits are not accessed in this case any more.
> 
> Fixes: 7897b071ac3b ("net: macb: convert to phylink")
> Signed-off-by: Stefan Roese <sr@denx.de>

Applied and queued up for -stable, thanks.
