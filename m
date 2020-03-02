Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B00A2175203
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 04:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgCBDGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 22:06:33 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:45424 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbgCBDGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 22:06:32 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4AD2913D68CE4;
        Sun,  1 Mar 2020 19:06:32 -0800 (PST)
Date:   Sun, 01 Mar 2020 19:06:31 -0800 (PST)
Message-Id: <20200301.190631.588611474698669933.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, linux@armlinux.org.uk,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: mscc: add constants for used
 interrupt mask bits
From:   David Miller <davem@davemloft.net>
In-Reply-To: <6503f7cf-477d-954b-ab7c-c9805cfa3692@gmail.com>
References: <6503f7cf-477d-954b-ab7c-c9805cfa3692@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 01 Mar 2020 19:06:32 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sun, 1 Mar 2020 21:57:08 +0100

> Add constants for the used interrupts bits. This avoids the magic
> number for MII_VSC85XX_INT_MASK_MASK.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied to net-next.
