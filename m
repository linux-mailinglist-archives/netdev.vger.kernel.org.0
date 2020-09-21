Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB0F273468
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 22:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbgIUUzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 16:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbgIUUzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 16:55:45 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC44C061755;
        Mon, 21 Sep 2020 13:55:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 92FB811E49F60;
        Mon, 21 Sep 2020 13:38:57 -0700 (PDT)
Date:   Mon, 21 Sep 2020 13:55:44 -0700 (PDT)
Message-Id: <20200921.135544.1339982326191078648.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     linux-net-drivers@solarflare.com, ecree@solarflare.com,
        mhabets@solarflare.com, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] sfc: Fix error code in probe
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918143311.GD909725@mwanda>
References: <20200918143311.GD909725@mwanda>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 21 Sep 2020 13:38:57 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Fri, 18 Sep 2020 17:33:11 +0300

> This failure path should return a negative error code but it currently
> returns success.
> 
> Fixes: 51b35a454efd ("sfc: skeleton EF100 PF driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied, thanks.
