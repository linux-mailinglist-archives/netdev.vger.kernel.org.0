Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C33B6B3296
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 01:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728644AbfIOXMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 19:12:17 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:45552 "EHLO
        violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728438AbfIOXMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 19:12:16 -0400
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Sep 2019 19:12:15 EDT
Received: from violet.fr.zoreil.com (localhost [127.0.0.1])
        by violet.fr.zoreil.com (8.14.9/8.14.9) with ESMTP id x8FN6fx3007397;
        Mon, 16 Sep 2019 01:06:41 +0200
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.14.9/8.14.5/Submit) id x8FN6e0i007396;
        Mon, 16 Sep 2019 01:06:40 +0200
Date:   Mon, 16 Sep 2019 01:06:40 +0200
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net/wan: dscc4: remove broken dscc4 driver
Message-ID: <20190915230640.GA7382@electric-eye.fr.zoreil.com>
References: <20190913132817.GA13179@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190913132817.GA13179@mwanda>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> :
> Using static analysis, I discovered that the "dpriv->pci_priv->pdev"
> pointer is always NULL.  This pointer was supposed to be initialized
> during probe and is essential for the driver to work.  It would be easy
> to add a "ppriv->pdev = pdev;" to dscc4_found1() but this driver has
> been broken since before we started using git and no one has complained
> so probably we should just remove it.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Francois Romieu <romieu@fr.zoreil.com>

-- 
Ueimor
