Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0D60B3563
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 09:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbfIPHPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 03:15:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44402 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbfIPHPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 03:15:34 -0400
Received: from localhost (unknown [85.119.46.8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8F82715163DC1;
        Mon, 16 Sep 2019 00:15:32 -0700 (PDT)
Date:   Mon, 16 Sep 2019 09:15:31 +0200 (CEST)
Message-Id: <20190916.091531.804053772243575655.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     romieu@fr.zoreil.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net/wan: dscc4: remove broken dscc4 driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190913132817.GA13179@mwanda>
References: <20190913132817.GA13179@mwanda>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Sep 2019 00:15:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Fri, 13 Sep 2019 16:28:17 +0300

> Using static analysis, I discovered that the "dpriv->pci_priv->pdev"
> pointer is always NULL.  This pointer was supposed to be initialized
> during probe and is essential for the driver to work.  It would be easy
> to add a "ppriv->pdev = pdev;" to dscc4_found1() but this driver has
> been broken since before we started using git and no one has complained
> so probably we should just remove it.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied to net-next.
