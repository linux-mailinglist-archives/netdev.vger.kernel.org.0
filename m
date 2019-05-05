Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 050A314170
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 19:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbfEER3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 13:29:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52898 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfEER3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 13:29:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 27E6614DA6460;
        Sun,  5 May 2019 10:29:47 -0700 (PDT)
Date:   Sun, 05 May 2019 10:29:46 -0700 (PDT)
Message-Id: <20190505.102946.1600019216217248155.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     esben@geanix.com, michal.simek@xilinx.com, andrew@lunn.ch,
        yang.wei9@zte.com.cn, yuehaibing@huawei.com, mcgrof@kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2 net-next] net: ll_temac: Fix an NULL vs IS_ERR()
 check in temac_open()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190503125024.GF29695@mwanda>
References: <20190503125024.GF29695@mwanda>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 10:29:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Fri, 3 May 2019 15:50:24 +0300

> The phy_connect() function doesn't return NULL pointers.  It returns
> error pointers on error, so I have updated the check.
> 
> Fixes: 8425c41d1ef7 ("net: ll_temac: Extend support to non-device-tree platforms")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
