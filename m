Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B37CD1272C7
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 02:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbfLTB1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 20:27:50 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44924 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbfLTB1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 20:27:50 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 460841540B042;
        Thu, 19 Dec 2019 17:27:49 -0800 (PST)
Date:   Thu, 19 Dec 2019 17:27:48 -0800 (PST)
Message-Id: <20191219.172748.2176331477137120264.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     antoine.tenart@bootlin.com, maxime.chevallier@bootlin.com,
        w@1wt.eu, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: mvpp2: cycle comphy to power it down
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1ihF4S-0000gt-1B@rmk-PC.armlinux.org.uk>
References: <E1ihF4S-0000gt-1B@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Dec 2019 17:27:49 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Tue, 17 Dec 2019 15:47:36 +0000

> Presently, at boot time, the comphys are enabled. For firmware
> compatibility reasons, the comphy driver does not power down the
> comphys at boot. Consequently, the ethernet comphys are left active
> until the network interfaces are brought through an up/down cycle.
> 
> If the port is never used, the port wastes power needlessly. Arrange
> for the ethernet comphys to be cycled by the mvpp2 driver as if the
> interface went through an up/down cycle during driver probe, thereby
> powering them down.
> 
> This saves:
>   270mW per 10G SFP+ port on the Macchiatobin Single Shot (eth0/eth1)
>   370mW per 10G PHY port on the Macchiatobin Double Shot (eth0/eth1)
>   160mW on the SFP port on either Macchiatobin flavour (eth3)
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied, thanks.
