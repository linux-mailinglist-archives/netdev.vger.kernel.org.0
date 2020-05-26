Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65D341E32A4
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 00:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392167AbgEZWcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 18:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390038AbgEZWcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 18:32:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DE3C061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 15:32:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4E2231210A3FB;
        Tue, 26 May 2020 15:32:01 -0700 (PDT)
Date:   Tue, 26 May 2020 15:32:00 -0700 (PDT)
Message-Id: <20200526.153200.1285528080976081028.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org, jeremy.linton@arm.com
Subject: Re: [PATCH net-next] net: mdiobus: add clause 45 mdiobus accessors
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1jdbWK-00083w-Ot@rmk-PC.armlinux.org.uk>
References: <E1jdbWK-00083w-Ot@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 May 2020 15:32:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Tue, 26 May 2020 16:29:36 +0100

> There is a recurring pattern throughout some of the PHY code converting
> a devad and regnum to our packed clause 45 representation. Rather than
> having this scattered around the code, let's put a common translation
> function in mdio.h, and provide some register accessors.
> 
> Convert the phylib core, phylink, bcm87xx and cortina to use these.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied, thank you.
