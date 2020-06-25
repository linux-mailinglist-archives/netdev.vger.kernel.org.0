Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD6120A88A
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 01:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407654AbgFYXCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 19:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407645AbgFYXCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 19:02:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330F3C08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 16:02:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C98F8153808EA;
        Thu, 25 Jun 2020 16:02:43 -0700 (PDT)
Date:   Thu, 25 Jun 2020 16:02:43 -0700 (PDT)
Message-Id: <20200625.160243.1383996098072893228.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net-next] net: phylink: only restart AN if the link
 mode is using in-band AN
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1jo3bQ-0006QS-Nx@rmk-PC.armlinux.org.uk>
References: <E1jo3bQ-0006QS-Nx@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jun 2020 16:02:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Wed, 24 Jun 2020 12:30:04 +0100

> If we are not using in-band autonegotiation, there is no point passing
> the request to restart autonegotiation on to the driver.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied, thank you.
