Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4BBB170FD1
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 05:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgB0Ewv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 23:52:51 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37138 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728273AbgB0Ewv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 23:52:51 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AB20915B47CA6;
        Wed, 26 Feb 2020 20:52:50 -0800 (PST)
Date:   Wed, 26 Feb 2020 20:52:50 -0800 (PST)
Message-Id: <20200226.205250.1647452826316197149.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     manivannan.sadhasivam@linaro.org, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: qrtr: Fix error pointer vs NULL bugs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200226145153.a7u2jzhseaipas54@kili.mountain>
References: <20200226145153.a7u2jzhseaipas54@kili.mountain>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2020 20:52:50 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 26 Feb 2020 17:51:53 +0300

> The callers only expect NULL pointers, so returning an error pointer
> will lead to an Oops.
> 
> Fixes: 0c2204a4ad71 ("net: qrtr: Migrate nameservice to kernel from userspace")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied, thanks Dan.
