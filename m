Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F761C4352
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730125AbgEDRwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729937AbgEDRwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 13:52:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C45C061A0E;
        Mon,  4 May 2020 10:52:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7616915D15A63;
        Mon,  4 May 2020 10:52:34 -0700 (PDT)
Date:   Mon, 04 May 2020 10:52:33 -0700 (PDT)
Message-Id: <20200504.105233.141268457994511921.davem@davemloft.net>
To:     zhengdejin5@gmail.com
Cc:     claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andy.shevchenko@gmail.com
Subject: Re: [PATCH net v1] net: enetc: fix an issue about leak system
 resources
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200504120127.4482-1-zhengdejin5@gmail.com>
References: <20200504120127.4482-1-zhengdejin5@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 May 2020 10:52:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dejin Zheng <zhengdejin5@gmail.com>
Date: Mon,  4 May 2020 20:01:27 +0800

> the related system resources were not released when enetc_hw_alloc()
> return error in the enetc_pci_mdio_probe(), add iounmap() for error
> handling label "err_hw_alloc" to fix it.
> 
> Fixes: 6517798dd3432a ("enetc: Make MDIO accessors more generic and export to include/linux/fsl")
> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>

Applied, thank you.
