Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA5A51785FC
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 23:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbgCCWy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 17:54:29 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36938 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728070AbgCCWy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 17:54:29 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AD12A15A0CF86;
        Tue,  3 Mar 2020 14:54:28 -0800 (PST)
Date:   Tue, 03 Mar 2020 14:54:28 -0800 (PST)
Message-Id: <20200303.145428.1341062818121267356.davem@davemloft.net>
To:     o.rempel@pengutronix.de
Cc:     mkl@pengutronix.de, olteanv@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, david@protonic.nl
Subject: Re: [PATCH v1] net: dsa: sja1105: add 100baseT1_Full support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200303074414.30693-1-o.rempel@pengutronix.de>
References: <20200303074414.30693-1-o.rempel@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Mar 2020 14:54:29 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>
Date: Tue,  3 Mar 2020 08:44:14 +0100

> Validate 100baseT1_Full to make this driver work with TJA1102 PHY.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Applied to net-next, thank you.
