Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A22DCAEFB
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 21:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731825AbfJCTLV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Oct 2019 15:11:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47474 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728608AbfJCTLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 15:11:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 13C4E146D0E72;
        Thu,  3 Oct 2019 12:11:20 -0700 (PDT)
Date:   Thu, 03 Oct 2019 12:11:19 -0700 (PDT)
Message-Id: <20191003.121119.1777964964781562057.davem@davemloft.net>
To:     ka-cheong.poon@oracle.com
Cc:     netdev@vger.kernel.org, santosh.shilimkar@oracle.com,
        rds-devel@oss.oracle.com
Subject: Re: [PATCH net-next v2] net/rds: Use DMA memory pool allocation
 for rds_header
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1570075868-3163-1-git-send-email-ka-cheong.poon@oracle.com>
References: <1569834480-25584-1-git-send-email-ka-cheong.poon@oracle.com>
        <1570075868-3163-1-git-send-email-ka-cheong.poon@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 03 Oct 2019 12:11:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
Date: Wed,  2 Oct 2019 21:11:08 -0700

> Currently, RDS calls ib_dma_alloc_coherent() to allocate a large piece
> of contiguous DMA coherent memory to store struct rds_header for
> sending/receiving packets.  The memory allocated is then partitioned
> into struct rds_header.  This is not necessary and can be costly at
> times when memory is fragmented.  Instead, RDS should use the DMA
> memory pool interface to handle this.  The DMA addresses of the pre-
> allocated headers are stored in an array.  At send/receive ring
> initialization and refill time, this arrary is de-referenced to get
> the DMA addresses.  This array is not accessed at send/receive packet
> processing.
> 
> Suggested-by: Håkon Bugge <haakon.bugge@oracle.com>
> Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>

Applied.
