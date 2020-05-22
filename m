Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5981DDC0C
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 02:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgEVASS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 20:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbgEVASS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 20:18:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243BBC061A0E;
        Thu, 21 May 2020 17:18:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B44B4120ED48B;
        Thu, 21 May 2020 17:18:16 -0700 (PDT)
Date:   Thu, 21 May 2020 17:18:15 -0700 (PDT)
Message-Id: <20200521.171815.1268044117965833956.davem@davemloft.net>
To:     o.rempel@pengutronix.de
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kuba@kernel.org, corbet@lwn.net, mkubecek@suse.cz,
        david@protonic.nl, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux@armlinux.org.uk, mkl@pengutronix.de, marex@denx.de,
        christian.herber@nxp.com
Subject: Re: [PATCH net-next v3 0/2] provide KAPI for SQI 
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200520062915.29493-1-o.rempel@pengutronix.de>
References: <20200520062915.29493-1-o.rempel@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 May 2020 17:18:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>
Date: Wed, 20 May 2020 08:29:13 +0200

> This patches are extending ethtool netlink interface to export Signal
> Quality Index (SQI). SQI provided by 100Base-T1 PHYs and can be used for
> cable diagnostic. Compared to a typical cable tests, this value can be
> only used after link is established.
> 
> changes v3:
> - rename __ethtool_get_sqi* to linkstate_get_sqi*. And move this
>   functions to the net/ethtool/linkstate.c
> - protect linkstate_get_sqi* with locking
> 
> changes v2:
> - use u32 instead of u8 for SQI
> - add SQI_MAX field and callbacks
> - some style fixes in the rst.
> - do not convert index to shifted index.

Series applied, thank you.
