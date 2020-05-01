Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F721C0CE2
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 05:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbgEAD4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 23:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728092AbgEAD4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 23:56:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E6E0C035494;
        Thu, 30 Apr 2020 20:56:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F280312777A8D;
        Thu, 30 Apr 2020 20:56:06 -0700 (PDT)
Date:   Thu, 30 Apr 2020 20:56:06 -0700 (PDT)
Message-Id: <20200430.205606.219525759145278874.davem@davemloft.net>
To:     michael@walle.cc
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk
Subject: Re: [PATCH net-next v2 2/4] net: phy: bcm54140: fix phy_id_mask
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200428230659.7754-2-michael@walle.cc>
References: <20200428230659.7754-1-michael@walle.cc>
        <20200428230659.7754-2-michael@walle.cc>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 20:56:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Walle <michael@walle.cc>
Date: Wed, 29 Apr 2020 01:06:57 +0200

> Broadcom defines the bits for this PHY as follows:
>   { oui[24:3], model[6:0], revision[2:0] }
> 
> Thus we have to mask the lower three bits only.
> 
> Fixes: 6937602ed3f9 ("net: phy: add Broadcom BCM54140 support")
> Signed-off-by: Michael Walle <michael@walle.cc>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Applied.
