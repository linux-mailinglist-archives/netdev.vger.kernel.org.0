Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC7B11093AF
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 19:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfKYSrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 13:47:12 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52744 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfKYSrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 13:47:12 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B1B9015008C78;
        Mon, 25 Nov 2019 10:47:11 -0800 (PST)
Date:   Mon, 25 Nov 2019 10:47:11 -0800 (PST)
Message-Id: <20191125.104711.1642645792053672224.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: add helpers phy_(un)lock_mdio_bus
From:   David Miller <davem@davemloft.net>
In-Reply-To: <c0ec9c7b-d646-c9a5-d960-8710bc5bfc65@gmail.com>
References: <c0ec9c7b-d646-c9a5-d960-8710bc5bfc65@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 Nov 2019 10:47:11 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sat, 23 Nov 2019 17:28:37 +0100

> Add helpers to make locking/unlocking the MDIO bus easier.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks.
