Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE58C185AE1
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 08:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbgCOHNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 03:13:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36004 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbgCOHNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 03:13:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1039113D50B39;
        Sun, 15 Mar 2020 00:13:11 -0700 (PDT)
Date:   Sun, 15 Mar 2020 00:13:10 -0700 (PDT)
Message-Id: <20200315.001310.532649434165573576.davem@davemloft.net>
To:     shahjada@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net] cxgb4: fix delete filter entry fail in unload path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200313090257.26733-1-shahjada@chelsio.com>
References: <20200313090257.26733-1-shahjada@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 15 Mar 2020 00:13:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shahjada Abul Husain <shahjada@chelsio.com>
Date: Fri, 13 Mar 2020 14:32:57 +0530

> Currently, the hardware TID index is assumed to start from index 0.
> However, with the following changeset,
> 
> commit c21939998802 ("cxgb4: add support for high priority filters")
> 
> hardware TID index can start after the high priority region, which
> has introduced a regression resulting in remove filters entry
> failure for cxgb4 unload path. This patch fix that.
> 
> Fixes: c21939998802 ("cxgb4: add support for high priority filters")
> Signed-off-by: Shahjada Abul Husain <shahjada@chelsio.com>

Applied, thanks.
