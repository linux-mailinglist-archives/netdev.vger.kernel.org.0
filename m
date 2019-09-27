Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89F14C00F2
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 10:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfI0ISA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 04:18:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57138 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbfI0ISA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 04:18:00 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9A91614DDE291;
        Fri, 27 Sep 2019 01:17:56 -0700 (PDT)
Date:   Fri, 27 Sep 2019 10:17:53 +0200 (CEST)
Message-Id: <20190927.101753.1158854931167184949.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     radhey.shyam.pandey@xilinx.com, alvaro.gamez@hazent.com,
        michal.simek@xilinx.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: axienet: fix a signedness bug in probe
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190925105911.GI3264@mwanda>
References: <20190925105911.GI3264@mwanda>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 01:17:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 25 Sep 2019 13:59:11 +0300

> The "lp->phy_mode" is an enum but in this context GCC treats it as an
> unsigned int so the error handling is never triggered.
> 
> Fixes: ee06b1728b95 ("net: axienet: add support for standard phy-mode binding")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
