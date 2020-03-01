Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E957F174B88
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 06:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgCAFen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 00:34:43 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38760 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgCAFen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 00:34:43 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5314715BD952B;
        Sat, 29 Feb 2020 21:34:42 -0800 (PST)
Date:   Sat, 29 Feb 2020 21:34:41 -0800 (PST)
Message-Id: <20200229.213441.595621985906352706.davem@davemloft.net>
To:     o.rempel@pengutronix.de
Cc:     chris.snook@gmail.com, jcliburn@gmail.com, linux@armlinux.org.uk,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        vivien.didelot@gmail.com
Subject: Re: [PATCH v9] net: ag71xx: port to phylink
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200228145049.17602-1-o.rempel@pengutronix.de>
References: <20200228145049.17602-1-o.rempel@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Feb 2020 21:34:42 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>
Date: Fri, 28 Feb 2020 15:50:49 +0100

> The port to phylink was done as close as possible to initial
> functionality.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Applied to net-next, thank you.
