Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E86D3E3E9F
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 23:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729829AbfJXV5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 17:57:18 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52420 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729763AbfJXV5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 17:57:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 66D8814B6977C;
        Thu, 24 Oct 2019 14:57:17 -0700 (PDT)
Date:   Thu, 24 Oct 2019 14:57:16 -0700 (PDT)
Message-Id: <20191024.145716.1208414850964996816.davem@davemloft.net>
To:     dwagner@suse.de
Cc:     UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org, woojung.huh@microchip.com,
        maz@kernel.org, andrew@lunn.ch, wahrenst@gmx.net,
        Jisheng.Zhang@synaptics.com, bigeasy@linutronix.de,
        tglx@linutronix.de
Subject: Re: [PATCH] net: usb: lan78xx: Use phy_mac_interrupt() for
 interrupt handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191018082817.111480-1-dwagner@suse.de>
References: <20191018082817.111480-1-dwagner@suse.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 24 Oct 2019 14:57:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Wagner <dwagner@suse.de>
Date: Fri, 18 Oct 2019 10:28:17 +0200

> handle_simple_irq() expect interrupts to be disabled. The USB
> framework is using threaded interrupts, which implies that interrupts
> are re-enabled as soon as it has run.
 ...

Where are we with this patch?  I'm tossing it.

It seems Sebastian made a suggestion, someone else said his suggestion
should be tried, then everything died.

Please follow up and post when something is ready.
