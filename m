Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C906BBEC45
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 09:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbfIZHAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 03:00:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44566 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727051AbfIZHAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 03:00:35 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BA5441264DFDD;
        Thu, 26 Sep 2019 00:00:33 -0700 (PDT)
Date:   Thu, 26 Sep 2019 09:00:32 +0200 (CEST)
Message-Id: <20190926.090032.1228409542844231601.davem@davemloft.net>
To:     pmalani@chromium.org
Cc:     hayeswang@realtek.com, grundler@chromium.org,
        netdev@vger.kernel.org, nic_swsd@realtek.com
Subject: Re: [PATCH] r8152: Use guard clause and fix comment typos
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190923222657.253628-1-pmalani@chromium.org>
References: <20190923222657.253628-1-pmalani@chromium.org>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Sep 2019 00:00:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prashant Malani <pmalani@chromium.org>
Date: Mon, 23 Sep 2019 15:26:57 -0700

> Use a guard clause in tx_bottom() to reduce the indentation of the
> do-while loop. In doing so, convert the do-while to a while to make the
> guard clause checks consistent.
> 
> Also, fix a couple of spelling and grammatical mistakes in the
> r8152_csum_workaround() function comment.
> 
> Change-Id: I460befde150ad92248fd85b0f189ec2df2ab8431
> Signed-off-by: Prashant Malani <pmalani@chromium.org>
> Reviewed-by: Grant Grundler <grundler@chromium.org>

This is only approiate for net-next, so please resubmit this when the
net-next tree opens back up.
