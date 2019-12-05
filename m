Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72CB511390A
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 01:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbfLEA6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 19:58:05 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38386 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbfLEA6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 19:58:05 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A9D5314F35C5B;
        Wed,  4 Dec 2019 16:58:04 -0800 (PST)
Date:   Wed, 04 Dec 2019 16:58:04 -0800 (PST)
Message-Id: <20191204.165804.1021871109359194473.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: sfp: fix unbind
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1icHww-00043d-U9@rmk-PC.armlinux.org.uk>
References: <E1icHww-00043d-U9@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Dec 2019 16:58:04 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Tue, 03 Dec 2019 23:51:22 +0000

> When unbinding, we don't correctly tear down the module state, leaving
> (for example) the hwmon registration behind. Ensure everything is
> properly removed by sending a remove event at unbind.
> 
> Fixes: 6b0da5c9c1a3 ("net: sfp: track upstream's attachment state in state machine")
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied.
