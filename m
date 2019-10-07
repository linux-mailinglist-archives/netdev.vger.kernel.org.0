Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15FD4CE481
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 16:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbfJGOA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 10:00:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52990 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbfJGOA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 10:00:59 -0400
Received: from localhost (unknown [144.121.20.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1CF581411EAF1;
        Mon,  7 Oct 2019 07:00:58 -0700 (PDT)
Date:   Mon, 07 Oct 2019 16:00:57 +0200 (CEST)
Message-Id: <20191007.160057.2276197375290462580.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: hns: make arrays static, makes object smaller
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191007105510.31858-1-colin.king@canonical.com>
References: <20191007105510.31858-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 07 Oct 2019 07:00:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Mon,  7 Oct 2019 11:55:10 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate the arrays port_map and sl_map on the stack but
> instead make them static. Makes the object code smaller by 64 bytes.
> 
> Before:
>    text	   data	    bss	    dec	    hex	filename
>   49575	   6872	     64	  56511	   dcbf	hisilicon/hns/hns_dsaf_main.o
> 
> After:
>    text	   data	    bss	    dec	    hex	filename
>   49350	   7032	     64	  56446	   dc7e	hisilicon/hns/hns_dsaf_main.o
> 
> (gcc version 9.2.1, amd64)
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
