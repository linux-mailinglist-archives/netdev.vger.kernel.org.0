Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27F84D5748
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 20:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbfJMSTX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 13 Oct 2019 14:19:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42686 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbfJMSTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 14:19:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5475E146D832C;
        Sun, 13 Oct 2019 11:19:22 -0700 (PDT)
Date:   Sun, 13 Oct 2019 11:19:21 -0700 (PDT)
Message-Id: <20191013.111921.357704258801923369.davem@davemloft.net>
To:     clg@kaod.org
Cc:     julietk@linux.vnet.ibm.com, tlfalcon@linux.ibm.com,
        jallen@linux.ibm.com, mpe@ellerman.id.au,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net/ibmvnic: Fix EOI when running in XIVE mode.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191011055254.8347-1-clg@kaod.org>
References: <20191011055254.8347-1-clg@kaod.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 13 Oct 2019 11:19:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cédric Le Goater <clg@kaod.org>
Date: Fri, 11 Oct 2019 07:52:54 +0200

> pSeries machines on POWER9 processors can run with the XICS (legacy)
> interrupt mode or with the XIVE exploitation interrupt mode. These
> interrupt contollers have different interfaces for interrupt
> management : XICS uses hcalls and XIVE loads and stores on a page.
> H_EOI being a XICS interface the enable_scrq_irq() routine can fail
> when the machine runs in XIVE mode.
> 
> Fix that by calling the EOI handler of the interrupt chip.
> 
> Fixes: f23e0643cd0b ("ibmvnic: Clear pending interrupt after device reset")
> Signed-off-by: Cédric Le Goater <clg@kaod.org>

Applied and queued up for -stable, thanks.
