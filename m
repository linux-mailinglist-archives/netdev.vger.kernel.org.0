Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF058E307
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 05:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728758AbfHODCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 23:02:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36292 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728381AbfHODCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 23:02:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E5ABE145F4F4D;
        Wed, 14 Aug 2019 20:02:52 -0700 (PDT)
Date:   Wed, 14 Aug 2019 20:02:52 -0700 (PDT)
Message-Id: <20190814.200252.997195051229978511.davem@davemloft.net>
To:     bigeasy@linutronix.de
Cc:     netdev@vger.kernel.org, tglx@linutronix.de,
        maxime.chevallier@bootlin.com
Subject: Re: [PATCH net-next] net/mvpp2: Replace tasklet with softirq
 hrtimer
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190813080025.2j3cj6gfyzzxek7x@linutronix.de>
References: <20190813080025.2j3cj6gfyzzxek7x@linutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 14 Aug 2019 20:02:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date: Tue, 13 Aug 2019 10:00:25 +0200

> From: Thomas Gleixner <tglx@linutronix.de>
> 
> The tx_done_tasklet tasklet is used in invoke the hrtimer
> (mvpp2_hr_timer_cb) in softirq context. This can be also achieved without
> the tasklet but with HRTIMER_MODE_SOFT as hrtimer mode.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Applied.
