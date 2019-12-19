Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E163A12707B
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 23:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfLSWOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 17:14:36 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43060 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbfLSWOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 17:14:36 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B8E4B153CA22B;
        Thu, 19 Dec 2019 14:14:35 -0800 (PST)
Date:   Thu, 19 Dec 2019 14:14:33 -0800 (PST)
Message-Id: <20191219.141433.159371363914521057.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     rmk+kernel@armlinux.org.uk, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phy: make phy_error() report which PHY has
 failed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191219210503.GR17475@lunn.ch>
References: <E1ihCLZ-0001Vo-Nw@rmk-PC.armlinux.org.uk>
        <20191219.125010.1105219757379875134.davem@davemloft.net>
        <20191219210503.GR17475@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Dec 2019 14:14:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Thu, 19 Dec 2019 22:05:03 +0100

>> I think I agree with Heiner that it is valuable to know whether the
>> error occurred from the interrupt handler or the state machine (and
>> if the state machine, where that got called from).
>> 
>> So I totally disagree with removing the backtrace, sorry.
> 
> Russell does have a point about the backtrace not giving an indication
> of which phy experienced the error. So adding the phydev_err() call,
> which will prefix the print with an identifier for the PHY, is a good
> idea. So we should add that, and keep the WARN().

Agreed.
