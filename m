Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC3A117964
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 23:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbfLIWeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 17:34:50 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36608 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726169AbfLIWeu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 17:34:50 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8F722154930D4;
        Mon,  9 Dec 2019 14:34:49 -0800 (PST)
Date:   Mon, 09 Dec 2019 14:34:49 -0800 (PST)
Message-Id: <20191209.143449.1221575502285244589.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] Add support for slow-to-probe-PHY copper
 SFP modules
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191209141525.GK25745@shell.armlinux.org.uk>
References: <20191209141525.GK25745@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Dec 2019 14:34:49 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Mon, 9 Dec 2019 14:15:25 +0000

> This series, following on from the previous adding SFP+ copper support,
> adds support for a range of Copper SFP modules, made by a variety of
> companies, all of which have a Marvell 88E1111 PHY on them, but take
> far longer than the Marvell spec'd 15ms to start communicating on the
> I2C bus.
> 
> Researching the Champion One 1000SFPT module reveals that TX_DISABLE is
> routed through a MAX1971 switching regulator and reset IC which adds a
> 175ms delay to releasing the 88E1111 reset.
> 
> It is not known whether other modules use a similar setup, but there
> are a range of modules that are slow for the Marvell PHY to appear.
> 
> This patch series adds support for these modules by repeatedly trying
> to probe the PHY for up to 600ms.

Patch #3 gets full rejects when I try to apply this series.

Please respin, adding Andrew's ACKs.

Thank you.
