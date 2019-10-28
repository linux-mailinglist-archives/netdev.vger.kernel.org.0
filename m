Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9E9E7D09
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 00:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732390AbfJ1Xfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 19:35:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46666 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731587AbfJ1Xfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 19:35:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C7AFD14BEC4E3;
        Mon, 28 Oct 2019 16:35:42 -0700 (PDT)
Date:   Mon, 28 Oct 2019 16:35:42 -0700 (PDT)
Message-Id: <20191028.163542.651907517920532587.davem@davemloft.net>
To:     dwagner@suse.de
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, woojung.huh@microchip.com,
        maz@kernel.org, andrew@lunn.ch, wahrenst@gmx.net,
        Jisheng.Zhang@synaptics.com, bigeasy@linutronix.de,
        tglx@linutronix.de
Subject: Re: [PATCH] net: usb: lan78xx: Disable interrupts before calling
 generic_handle_irq()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191025080413.22665-1-dwagner@suse.de>
References: <20191025080413.22665-1-dwagner@suse.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 28 Oct 2019 16:35:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Wagner <dwagner@suse.de>
Date: Fri, 25 Oct 2019 10:04:13 +0200

> lan78xx_status() will run with interrupts enabled due to the change in
> ed194d136769 ("usb: core: remove local_irq_save() around ->complete()
> handler"). generic_handle_irq() expects to be run with IRQs disabled.
 ...
> Fixes: ed194d136769 ("usb: core: remove local_irq_save() around ->complete() handler")
 ...
> Signed-off-by: Daniel Wagner <dwagner@suse.de>

Applied and queued up for -stable, thanks Daniel.
