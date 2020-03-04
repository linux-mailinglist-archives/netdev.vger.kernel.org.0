Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F23C51787ED
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 03:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387469AbgCDCBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 21:01:53 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38308 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387452AbgCDCBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 21:01:53 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5F87615ADAAFF;
        Tue,  3 Mar 2020 18:01:52 -0800 (PST)
Date:   Tue, 03 Mar 2020 18:01:51 -0800 (PST)
Message-Id: <20200303.180151.1173371841870109441.davem@davemloft.net>
To:     hauke@hauke-m.de
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: [PATCH] phylink: Improve error message when validate failed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200301235502.17872-1-hauke@hauke-m.de>
References: <20200301235502.17872-1-hauke@hauke-m.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Mar 2020 18:01:52 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hauke Mehrtens <hauke@hauke-m.de>
Date: Mon,  2 Mar 2020 00:55:02 +0100

> This should improve the error message when the PHY validate in the MAC
> driver failed. I ran into this problem multiple times that I put wrong
> interface values into the device tree and was searching why it is
> failing with -22 (-EINVAL). This should make it easier to spot the
> problem.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Applied, thank you.
