Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33868CAF38
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 21:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731033AbfJCT13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 15:27:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47684 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbfJCT12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 15:27:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EF732146D1AB5;
        Thu,  3 Oct 2019 12:27:27 -0700 (PDT)
Date:   Thu, 03 Oct 2019 12:27:27 -0700 (PDT)
Message-Id: <20191003.122727.323519546750345405.davem@davemloft.net>
To:     o.rempel@pengutronix.de
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] net: phy: at803x: add ar9331 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191003082113.13993-1-o.rempel@pengutronix.de>
References: <20191003082113.13993-1-o.rempel@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 03 Oct 2019 12:27:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>
Date: Thu,  3 Oct 2019 10:21:11 +0200

> changes v3:
> - use PHY_ID_MATCH_EXACT only for ATH9331 PHY
> 
> changes v2:
> - use PHY_ID_MATCH_EXACT instead of leaky masking
> - remove probe and struct at803x_priv

Looks good and all the feedback has been addressed.

Applied to net-next.
