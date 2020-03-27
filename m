Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 830FE196191
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 23:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbgC0W5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 18:57:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40406 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbgC0W5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 18:57:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E690D15BBCE60;
        Fri, 27 Mar 2020 15:57:54 -0700 (PDT)
Date:   Fri, 27 Mar 2020 15:57:53 -0700 (PDT)
Message-Id: <20200327.155753.1558332088898122758.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, cwhuang@android-x86.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] r8169: fix PHY driver check on platforms w/o
 module softdeps
From:   David Miller <davem@davemloft.net>
In-Reply-To: <40373530-6d40-4358-df58-13622a4512c2@gmail.com>
References: <40373530-6d40-4358-df58-13622a4512c2@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Mar 2020 15:57:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Fri, 27 Mar 2020 17:33:32 +0100

> On Android/x86 the module loading infrastructure can't deal with
> softdeps. Therefore the check for presence of the Realtek PHY driver
> module fails. mdiobus_register() will try to load the PHY driver
> module, therefore move the check to after this call and explicitly
> check that a dedicated PHY driver is bound to the PHY device.
> 
> Fixes: f32593773549 ("r8169: check that Realtek PHY driver module is loaded")
> Reported-by: Chih-Wei Huang <cwhuang@android-x86.org>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
> Please apply fix back to 5.4 only. On 4.19 it would break processing.

Applied, but am I missing something here?  The Fixes: tag is a v5.6 change
which was not sent to -stable.
