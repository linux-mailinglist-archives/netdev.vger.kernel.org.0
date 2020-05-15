Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F601D57F5
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 19:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbgEORbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 13:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726249AbgEORbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 13:31:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA753C061A0C
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 10:31:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B7ED914DA849A;
        Fri, 15 May 2020 10:31:18 -0700 (PDT)
Date:   Fri, 15 May 2020 10:31:17 -0700 (PDT)
Message-Id: <20200515.103117.2155572998629843808.davem@davemloft.net>
To:     ioana.ciornei@nxp.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] dpaa2-eth: properly handle buffer size restrictions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200515123022.31227-1-ioana.ciornei@nxp.com>
References: <20200515123022.31227-1-ioana.ciornei@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 15 May 2020 10:31:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>
Date: Fri, 15 May 2020 15:30:22 +0300

> Depending on the WRIOP version, the buffer size on the RX path must by a
> multiple of 64 or 256. Handle this restriction properly by aligning down
> the buffer size to the necessary value. Also, use the new buffer size
> dynamically computed instead of the compile time one.
> 
> Fixes: 27c874867c4e ("dpaa2-eth: Use a single page per Rx buffer")
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Applied and queued up for -stable, thank you.
