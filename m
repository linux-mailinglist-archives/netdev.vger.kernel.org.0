Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A842C117961
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 23:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfLIWco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 17:32:44 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36572 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726169AbfLIWco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 17:32:44 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E3206154930C1;
        Mon,  9 Dec 2019 14:32:43 -0800 (PST)
Date:   Mon, 09 Dec 2019 14:32:43 -0800 (PST)
Message-Id: <20191209.143243.795934299657286960.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: sfp: avoid tx-fault with Nokia GPON
 module
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1ieJGx-0003kX-4p@rmk-PC.armlinux.org.uk>
References: <E1ieJGx-0003kX-4p@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Dec 2019 14:32:44 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Mon, 09 Dec 2019 13:40:23 +0000

> The Nokia GPON module can hold tx-fault active while it is initialising
> which can take up to 60s. Avoid this causing the module to be declared
> faulty after the SFP MSA defined non-cooled module timeout.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied.
