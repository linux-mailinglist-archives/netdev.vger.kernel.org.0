Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6714F1C0CD6
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 05:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgEADyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 23:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbgEADya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 23:54:30 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB06C035494;
        Thu, 30 Apr 2020 20:54:30 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7BE4912777A88;
        Thu, 30 Apr 2020 20:54:30 -0700 (PDT)
Date:   Thu, 30 Apr 2020 20:54:29 -0700 (PDT)
Message-Id: <20200430.205429.1968774502632115295.davem@davemloft.net>
To:     michael@walle.cc
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk
Subject: Re: [PATCH net-next] net: phy: at803x: add downshift support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200428211502.1290-1-michael@walle.cc>
References: <20200428211502.1290-1-michael@walle.cc>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 20:54:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Walle <michael@walle.cc>
Date: Tue, 28 Apr 2020 23:15:02 +0200

> The AR8031 and AR8035 support the link speed downshift. Add driver
> support for it. One peculiarity of these PHYs is that it needs a
> software reset after changing the setting, thus add the .soft_reset()
> op and do a phy_init_hw() if necessary.
> 
> This was tested on a custom board with the AR8031.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Applied, thank you.
