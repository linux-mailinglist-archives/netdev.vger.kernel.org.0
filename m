Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 339CB137AB9
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 01:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbgAKAoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 19:44:12 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42642 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727647AbgAKAoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 19:44:12 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7DED1158586BD;
        Fri, 10 Jan 2020 16:44:11 -0800 (PST)
Date:   Fri, 10 Jan 2020 16:44:10 -0800 (PST)
Message-Id: <20200110.164410.1751160713890330692.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 00/15] r8169: factor out chip-specific PHY
 configuration to a separate source file
From:   David Miller <davem@davemloft.net>
In-Reply-To: <7e03fe05-ba95-c3c0-9a68-306b6450a141@gmail.com>
References: <7e03fe05-ba95-c3c0-9a68-306b6450a141@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Jan 2020 16:44:11 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Thu, 9 Jan 2020 20:24:22 +0100

> Basically every chip version needs its own PHY configuration.
> To improve maintainability of the driver move all these PHY
> configurations to a separate source file. To allow this we first have
> to change all PHY configurations to use phylib functions wherever
> possible.

Series applied.

This driver is almost unrecognizable compared to when you started
making changes to it. :-)

Thanks for all of your hard work!
