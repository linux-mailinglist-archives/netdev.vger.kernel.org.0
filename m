Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 668131B155D
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 21:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgDTTHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 15:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725896AbgDTTHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 15:07:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD18EC061A0C;
        Mon, 20 Apr 2020 12:07:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 01E54127EE236;
        Mon, 20 Apr 2020 12:07:43 -0700 (PDT)
Date:   Mon, 20 Apr 2020 12:07:43 -0700 (PDT)
Message-Id: <20200420.120743.1080400138709523286.davem@davemloft.net>
To:     michael@walle.cc
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, vladimir.oltean@nxp.com
Subject: Re: [PATCH net-next] net: phy: mscc: use mdiobus_get_phy()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200419082757.5650-1-michael@walle.cc>
References: <20200419082757.5650-1-michael@walle.cc>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Apr 2020 12:07:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Walle <michael@walle.cc>
Date: Sun, 19 Apr 2020 10:27:57 +0200

> Don't use internal knowledge of the mdio bus core, instead use
> mdiobus_get_phy() which does the same thing.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Applied, thanks.
