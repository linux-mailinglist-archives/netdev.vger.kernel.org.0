Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56800170FD0
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 05:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgB0EwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 23:52:00 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37122 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728284AbgB0EwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 23:52:00 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 51C8915B47CA6;
        Wed, 26 Feb 2020 20:51:59 -0800 (PST)
Date:   Wed, 26 Feb 2020 20:51:58 -0800 (PST)
Message-Id: <20200226.205158.18451706389192569.davem@davemloft.net>
To:     antoine.tenart@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk
Subject: Re: [PATCH net-next] net: phy: mscc: add missing shift for media
 operation mode selection
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200226144034.1519658-1-antoine.tenart@bootlin.com>
References: <20200226144034.1519658-1-antoine.tenart@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2020 20:51:59 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>
Date: Wed, 26 Feb 2020 15:40:34 +0100

> This patch adds a missing shift for the media operation mode selection.
> This does not fix the driver as the current operation mode (copper) has
> a value of 0, but this wouldn't work for other modes.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Applied.
