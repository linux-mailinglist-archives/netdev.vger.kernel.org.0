Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47E61FF5BD
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 22:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbfKPVL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 16:11:56 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53906 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727485AbfKPVL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 16:11:56 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 378A3151A209F;
        Sat, 16 Nov 2019 13:11:56 -0800 (PST)
Date:   Sat, 16 Nov 2019 13:11:55 -0800 (PST)
Message-Id: <20191116.131155.2082241389963519312.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: load firmware for RTL8168fp/RTL8117
From:   David Miller <davem@davemloft.net>
In-Reply-To: <927c7de5-adbb-8f96-5f77-994c7cfa7eb0@gmail.com>
References: <927c7de5-adbb-8f96-5f77-994c7cfa7eb0@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 Nov 2019 13:11:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Fri, 15 Nov 2019 22:38:25 +0100

> Load Realtek-provided firmware for RTL8168fp/RTL8117. Unlike the
> firmware for other chip versions which is for the PHY, firmware for
> RTL8168fp/RTL8117 is for the MAC.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
