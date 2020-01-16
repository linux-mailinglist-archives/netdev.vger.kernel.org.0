Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5032513DAB5
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 13:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgAPM6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 07:58:20 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38292 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbgAPM6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 07:58:19 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1C72515B5D393;
        Thu, 16 Jan 2020 04:58:17 -0800 (PST)
Date:   Thu, 16 Jan 2020 04:57:53 -0800 (PST)
Message-Id: <20200116.045753.1672747031363850521.davem@davemloft.net>
To:     m.grzeschik@pengutronix.de
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kernel@pengutronix.de
Subject: Re: [PATCH v3] net: phy: dp83867: Set FORCE_LINK_GOOD to default
 after reset
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200115080105.15641-1-m.grzeschik@pengutronix.de>
References: <1871867b-717d-ba43-4a6e-1b469867b0aa@gmail.com>
        <20200115080105.15641-1-m.grzeschik@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 16 Jan 2020 04:58:19 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Grzeschik <m.grzeschik@pengutronix.de>
Date: Wed, 15 Jan 2020 09:01:07 +0100

> According to the Datasheet this bit should be 0 (Normal operation) in
> default. With the FORCE_LINK_GOOD bit set, it is not possible to get a
> link. This patch sets FORCE_LINK_GOOD to the default value after
> resetting the phy.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

This doesn't apply to the 'net' GIT tree, please respin.
