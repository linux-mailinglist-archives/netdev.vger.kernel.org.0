Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5806A1272C5
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 02:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbfLTB0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 20:26:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44910 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbfLTB0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 20:26:31 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0713F15405EC5;
        Thu, 19 Dec 2019 17:26:30 -0800 (PST)
Date:   Thu, 19 Dec 2019 17:26:26 -0800 (PST)
Message-Id: <20191219.172626.2055144187966212031.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: sfp: report error on failure to read sfp
 soft status
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1ihDF7-0002Hr-S3@rmk-PC.armlinux.org.uk>
References: <E1ihDF7-0002Hr-S3@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Dec 2019 17:26:31 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Tue, 17 Dec 2019 13:50:29 +0000

> Report a rate-limited error if we fail to read the SFP soft status,
> and preserve the current status in that case. This avoids I2C bus
> errors from triggering a link flap.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied.
