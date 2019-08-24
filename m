Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9CA9C05F
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 23:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727748AbfHXVUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 17:20:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47704 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbfHXVUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 17:20:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 97D3415248637;
        Sat, 24 Aug 2019 14:20:47 -0700 (PDT)
Date:   Sat, 24 Aug 2019 14:20:47 -0700 (PDT)
Message-Id: <20190824.142047.32032287178584562.davem@davemloft.net>
To:     ka-cheong.poon@oracle.com
Cc:     netdev@vger.kernel.org, santosh.shilimkar@oracle.com,
        rds-devel@oss.oracle.com
Subject: Re: [PATCH net-next] net/rds: Fix info leak in rds6_inc_info_copy()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566443904-12671-1-git-send-email-ka-cheong.poon@oracle.com>
References: <1566443904-12671-1-git-send-email-ka-cheong.poon@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 24 Aug 2019 14:20:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
Date: Wed, 21 Aug 2019 20:18:24 -0700

> The rds6_inc_info_copy() function has a couple struct members which
> are leaking stack information.  The ->tos field should hold actual
> information and the ->flags field needs to be zeroed out.
> 
> Fixes: 3eb450367d08 ("rds: add type of service(tos) infrastructure")
> Fixes: b7ff8b1036f0 ("rds: Extend RDS API for IPv6 support")
> Reported-by: 黄ID蝴蝶 <butterflyhuangxx@gmail.com>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>

Why would an info leak bug fix, present in current kernels, be targetted
at 'net-next' instead of 'net'?

Please retarget this at 'net' properly, thank you.
