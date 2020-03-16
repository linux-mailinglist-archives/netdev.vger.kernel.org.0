Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D079B187559
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 23:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732767AbgCPWHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 18:07:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48614 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732731AbgCPWHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 18:07:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C8E8A156E514D;
        Mon, 16 Mar 2020 15:07:06 -0700 (PDT)
Date:   Mon, 16 Mar 2020 15:07:06 -0700 (PDT)
Message-Id: <20200316.150706.1749573279958363115.davem@davemloft.net>
To:     jszhang3@mail.ustc.edu.cn
Cc:     thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mvneta: Fix the case where the last poll did not
 process all rx
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200316225636.78b08da4@xhacker>
References: <20200316225636.78b08da4@xhacker>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Mar 2020 15:07:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jisheng Zhang <jszhang3@mail.ustc.edu.cn>
Date: Mon, 16 Mar 2020 22:56:36 +0800

> From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
> 
> For the case where the last mvneta_poll did not process all
> RX packets, we need to xor the pp->cause_rx_tx or port->cause_rx_tx
> before claculating the rx_queue.
> 
> Fixes: 2dcf75e2793c ("net: mvneta: Associate RX queues with each CPU")
> Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

Applied and queued up for -stable, thanks.
