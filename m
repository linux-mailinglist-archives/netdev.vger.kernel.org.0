Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE9AE104AC3
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 07:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbfKUG3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 01:29:08 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37980 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfKUG3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 01:29:08 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AC88C14DE165C;
        Wed, 20 Nov 2019 22:29:07 -0800 (PST)
Date:   Wed, 20 Nov 2019 22:29:07 -0800 (PST)
Message-Id: <20191120.222907.2217072137925598366.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] Add rudimentary SFP module quirk support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191120113900.GP25745@shell.armlinux.org.uk>
References: <20191120113900.GP25745@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 Nov 2019 22:29:07 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Wed, 20 Nov 2019 11:39:00 +0000

> The SFP module EEPROM describes the capabilities of the module, but
> doesn't describe the host interface.  We have a certain amount of
> guess-work to work out how to configure the host - which works most
> of the time.
> 
> However, there are some (such as GPON) modules which are able to
> support different host interfaces, such as 1000BASE-X and 2500BASE-X.
> The module will switch between each mode until it achieves link with
> the host.
> 
> There is no defined way to describe this in the SFP EEPROM, so we can
> only recognise the module and handle it appropriately.  This series
> adds the necessary recognition of the modules using a quirk system,
> and tweaks the support mask to allow them to link with the host at
> 2500BASE-X, thereby allowing the user to achieve full line rate.

Series applied, thanks.
