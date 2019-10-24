Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 313C0E28FD
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 05:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392944AbfJXDoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 23:44:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41562 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390576AbfJXDoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 23:44:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::b7e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1ABF914B7A933;
        Wed, 23 Oct 2019 20:44:09 -0700 (PDT)
Date:   Wed, 23 Oct 2019 20:44:08 -0700 (PDT)
Message-Id: <20191023.204408.14381274468436728.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: never set PCI_EXP_DEVCTL_NOSNOOP_EN
From:   David Miller <davem@davemloft.net>
In-Reply-To: <25be979c-a8ff-063a-1f8e-0765b2375401@gmail.com>
References: <25be979c-a8ff-063a-1f8e-0765b2375401@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 23 Oct 2019 20:44:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Tue, 22 Oct 2019 21:30:57 +0200

> Setting PCI_EXP_DEVCTL_NOSNOOP_EN for certain chip versions had been
> added to the vendor driver more than 10 years ago, and copied from
> there to r8169. It has been removed from the vendor driver meanwhile
> and I think we can safely remove this too.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks Heiner.
