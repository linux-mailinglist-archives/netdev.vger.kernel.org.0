Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03930E583D
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 05:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfJZDVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 23:21:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40236 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbfJZDVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 23:21:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AB40614B7C532;
        Fri, 25 Oct 2019 20:21:51 -0700 (PDT)
Date:   Fri, 25 Oct 2019 20:21:51 -0700 (PDT)
Message-Id: <20191025.202151.228948446610669283.davem@davemloft.net>
To:     rajur@chelsio.com
Cc:     netdev@vger.kernel.org, vishal@chelsio.com, nirranjan@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net] cxgb4: request the TX CIDX updates to status page
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191023173355.11341-1-rajur@chelsio.com>
References: <20191023173355.11341-1-rajur@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 25 Oct 2019 20:21:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raju Rangoju <rajur@chelsio.com>
Date: Wed, 23 Oct 2019 23:03:55 +0530

> For adapters which support the SGE Doorbell Queue Timer facility,
> we configured the Ethernet TX Queues to send CIDX Updates to the
> Associated Ethernet RX Response Queue with CPL_SGE_EGR_UPDATE
> messages to allow us to respond more quickly to the CIDX Updates.
> But, this was adding load to PCIe Link RX bandwidth and,
> potentially, resulting in higher CPU Interrupt load.
> 
> This patch requests the HW to deliver the CIDX updates to the TX
> queue status page rather than generating an ingress queue message
> (as an interrupt). With this patch, the load on RX bandwidth is
> reduced and a substantial improvement in BW is noticed at lower
> IO sizes.
> 
> Fixes: d429005fdf2c ("cxgb4/cxgb4vf: Add support for SGE doorbell queue timer")
> Signed-off-by: Raju Rangoju <rajur@chelsio.com>

Applied and queued up for -stable.
