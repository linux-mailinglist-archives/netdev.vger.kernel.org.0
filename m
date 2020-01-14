Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5544E13B323
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 20:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbgANTqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 14:46:05 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47028 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728734AbgANTqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 14:46:05 -0500
Received: from localhost (unknown [63.64.162.234])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9ABA41549340A;
        Tue, 14 Jan 2020 11:46:03 -0800 (PST)
Date:   Tue, 14 Jan 2020 11:46:03 -0800 (PST)
Message-Id: <20200114.114603.2006132483826469750.davem@davemloft.net>
To:     antoine.tenart@bootlin.com
Cc:     sd@queasysnail.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        camelia.groza@nxp.com, Simon.Edelhaus@aquantia.com,
        Igor.Russkikh@aquantia.com, jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next v6 00/10] net: macsec: initial support for
 hardware offloading
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200113223148.746096-1-antoine.tenart@bootlin.com>
References: <20200113223148.746096-1-antoine.tenart@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Jan 2020 11:46:04 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>
Date: Mon, 13 Jan 2020 23:31:38 +0100

> This series intends to add support for offloading MACsec transformations
> to hardware enabled devices. The series adds the necessary
> infrastructure for offloading MACsec configurations to hardware drivers,
> in patches 1 to 5; then introduces MACsec offloading support in the
> Microsemi MSCC PHY driver, in patches 6 to 10.
 ...

Series applied to net-next.

I'll push this out after build testing.

Thanks.
