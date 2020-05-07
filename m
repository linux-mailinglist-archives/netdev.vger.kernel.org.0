Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9D61C7F41
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 02:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgEGAqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 20:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728832AbgEGAqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 20:46:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D502C061A0F;
        Wed,  6 May 2020 17:46:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 42228127814AF;
        Wed,  6 May 2020 17:46:06 -0700 (PDT)
Date:   Wed, 06 May 2020 17:46:05 -0700 (PDT)
Message-Id: <20200506.174605.1163916253535180269.davem@davemloft.net>
To:     o.rempel@pengutronix.de
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kuba@kernel.org, corbet@lwn.net, mkubecek@suse.cz,
        david@protonic.nl, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux@armlinux.org.uk, mkl@pengutronix.de, marex@denx.de,
        christian.herber@nxp.com
Subject: Re: [PATCH net-next v6 0/2] provide support for PHY master/slave
 configuration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200505063506.3848-1-o.rempel@pengutronix.de>
References: <20200505063506.3848-1-o.rempel@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 17:46:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>
Date: Tue,  5 May 2020 08:35:04 +0200

> changes v6:
> - use NL_SET_ERR_MSG_ATTR in ethnl_update_linkmodes
> - add sanity checks in the ioctl interface
> - use bool for ethnl_validate_master_slave_cfg()
 ...

Series applied, thank you.
