Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B26AE18A98E
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 01:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbgCSAGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 20:06:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33050 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgCSAGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 20:06:17 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0FE7515543ED8;
        Wed, 18 Mar 2020 17:06:17 -0700 (PDT)
Date:   Wed, 18 Mar 2020 17:06:16 -0700 (PDT)
Message-Id: <20200318.170616.1492855754906278476.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: realtek: read actual speed to
 detect downshift
From:   David Miller <davem@davemloft.net>
In-Reply-To: <11d0287d-2cd2-4174-9d23-1203f5f45bfb@gmail.com>
References: <11d0287d-2cd2-4174-9d23-1203f5f45bfb@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Mar 2020 17:06:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Wed, 18 Mar 2020 23:07:24 +0100

> At least some integrated PHY's in RTL8168/RTL8125 chip versions support
> downshift, and the actual link speed can be read from a vendor-specific
> register. Info about this register was provided by Realtek.
> More details about downshift configuration (e.g. number of attempts)
> aren't available, therefore the downshift tunable is not implemented.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks Heiner.
