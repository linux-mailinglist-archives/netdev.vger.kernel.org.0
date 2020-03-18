Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 322FE1894B2
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 04:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgCRD6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 23:58:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35420 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgCRD6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 23:58:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EF19413EC66BB;
        Tue, 17 Mar 2020 20:58:43 -0700 (PDT)
Date:   Tue, 17 Mar 2020 20:58:43 -0700 (PDT)
Message-Id: <20200317.205843.1649558746994587425.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: phy: improve phy_driver callback
 handle_interrupt
From:   David Miller <davem@davemloft.net>
In-Reply-To: <49afbad9-317a-3eff-3692-441fae3c4f49@gmail.com>
References: <49afbad9-317a-3eff-3692-441fae3c4f49@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Mar 2020 20:58:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Mon, 16 Mar 2020 22:31:48 +0100

> did_interrupt() clears the interrupt, therefore handle_interrupt() can
> not check which event triggered the interrupt. To overcome this
> constraint and allow more flexibility for customer interrupt handlers,
> let's decouple handle_interrupt() from parts of the phylib interrupt
> handling. Custom interrupt handlers now have to implement the
> did_interrupt() functionality in handle_interrupt() if needed.
> 
> Fortunately we have just one custom interrupt handler so far (in the
> mscc PHY driver), convert it to the changed API and make use of the
> benefits.

Series applied, thanks Heiner.
