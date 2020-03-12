Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01075183CB6
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 23:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbgCLWni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 18:43:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36044 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbgCLWnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 18:43:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0B05C15842384;
        Thu, 12 Mar 2020 15:43:36 -0700 (PDT)
Date:   Thu, 12 Mar 2020 15:43:36 -0700 (PDT)
Message-Id: <20200312.154336.1295319497057805539.davem@davemloft.net>
To:     antoine.tenart@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/3] net: phy: mscc: split the driver into
 separate files
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200312221033.777437-3-antoine.tenart@bootlin.com>
References: <20200312221033.777437-1-antoine.tenart@bootlin.com>
        <20200312221033.777437-3-antoine.tenart@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Mar 2020 15:43:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>
Date: Thu, 12 Mar 2020 23:10:32 +0100

> +inline int vsc8584_macsec_init(struct phy_device *phydev)
> +{
> +	return 0;
> +}
> +inline void vsc8584_handle_macsec_interrupt(struct phy_device *phydev)
> +{
> +}
> +inline void vsc8584_config_macsec_intr(struct phy_device *phydev)
> +{
> +}

Please use "static inline", as otherwise if this file is included multiple times it
will cause the compiler to emit potentially two uninlined copies which will result
in a linking error.
