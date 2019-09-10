Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDC18AE581
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 10:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbfIJI3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 04:29:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53184 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbfIJI3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 04:29:39 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D8EB9154B29E5;
        Tue, 10 Sep 2019 01:29:37 -0700 (PDT)
Date:   Tue, 10 Sep 2019 10:29:36 +0200 (CEST)
Message-Id: <20190910.102936.1648930911852673896.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     tariqt@mellanox.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx4_en: ethtool: make array modes static const,
 makes object smaller
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190906115348.16621-1-colin.king@canonical.com>
References: <20190906115348.16621-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Sep 2019 01:29:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Fri,  6 Sep 2019 12:53:48 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate the array modes on the stack but instead make it
> static const. Makes the object code smaller by 303 bytes.
> 
> Before:
>    text	   data	    bss	    dec	    hex	filename
>   51240	   5008	   1312	  57560	   e0d8 mellanox/mlx4/en_ethtool.o
> 
> After:
>    text	   data	    bss	    dec	    hex	filename
>   50937	   5008	   1312	  57257	   dfa9	mellanox/mlx4/en_ethtool.o
> 
> (gcc version 9.2.1, amd64)
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied to net-next.
