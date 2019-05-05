Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2683D141A1
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 19:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbfEERtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 13:49:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53224 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbfEERtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 13:49:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3F41914DA770F;
        Sun,  5 May 2019 10:49:13 -0700 (PDT)
Date:   Sun, 05 May 2019 10:49:12 -0700 (PDT)
Message-Id: <20190505.104912.1247842313501822570.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     jakub.kicinski@netronome.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netdevsim: Make nsim_num_vf static
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190504081207.22764-1-yuehaibing@huawei.com>
References: <20190504081207.22764-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 10:49:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Sat, 4 May 2019 16:12:07 +0800

> Fix sparse warning:
> 
> drivers/net/netdevsim/bus.c:253:5: warning:
>  symbol 'nsim_num_vf' was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
