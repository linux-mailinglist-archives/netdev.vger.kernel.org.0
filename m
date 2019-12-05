Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8959E11390B
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 01:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbfLEA6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 19:58:12 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38402 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728374AbfLEA6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 19:58:11 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4A89C14F35C5D;
        Wed,  4 Dec 2019 16:58:11 -0800 (PST)
Date:   Wed, 04 Dec 2019 16:58:10 -0800 (PST)
Message-Id: <20191204.165810.2237864734064007904.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: sfp: fix hwmon
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1icHx2-00043k-4d@rmk-PC.armlinux.org.uk>
References: <E1icHx2-00043k-4d@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Dec 2019 16:58:11 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Tue, 03 Dec 2019 23:51:28 +0000

> The referenced commit below allowed more than one hwmon device to be
> created per SFP, which is definitely not what we want. Avoid this by
> only creating the hwmon device just as we transition to WAITDEV state.
> 
> Fixes: 139d3a212a1f ("net: sfp: allow modules with slow diagnostics to probe")
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied.
