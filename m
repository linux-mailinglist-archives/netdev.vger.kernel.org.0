Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B51D2199C84
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 19:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730770AbgCaRHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 13:07:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53072 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730149AbgCaRHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 13:07:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5C1E215CF9D4D;
        Tue, 31 Mar 2020 10:07:10 -0700 (PDT)
Date:   Tue, 31 Mar 2020 10:07:09 -0700 (PDT)
Message-Id: <20200331.100709.2105796491018062899.davem@davemloft.net>
To:     codrin.ciubotariu@microchip.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        nicolas.ferre@microchip.com, antoine.tenart@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, cristian.birsan@microchip.com
Subject: Re: [PATCH] net: macb: Fix handling of fixed-link node
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200331093935.23542-1-codrin.ciubotariu@microchip.com>
References: <20200331093935.23542-1-codrin.ciubotariu@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 31 Mar 2020 10:07:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Date: Tue, 31 Mar 2020 12:39:35 +0300

> fixed-link nodes are treated as PHY nodes by of_mdiobus_child_is_phy().
> We must check if the interface is a fixed-link before looking up for PHY
> nodes.
> 
> Fixes: 7897b071ac3b ("net: macb: convert to phylink")
> Tested-by: Cristian Birsan <cristian.birsan@microchip.com>
> Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>

Applied and queued up for -stable, thanks.
