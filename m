Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3804AFE638
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 21:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfKOUMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 15:12:48 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40466 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbfKOUMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 15:12:43 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0E55414DE8719;
        Fri, 15 Nov 2019 12:12:42 -0800 (PST)
Date:   Fri, 15 Nov 2019 12:12:41 -0800 (PST)
Message-Id: <20191115.121241.1718858679030793641.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net/tls: Fix unused function warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191114073946.46340-1-yuehaibing@huawei.com>
References: <20191114073946.46340-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 15 Nov 2019 12:12:42 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Thu, 14 Nov 2019 15:39:46 +0800

> If PROC_FS is not set, gcc warning this:
> 
> net/tls/tls_proc.c:23:12: warning:
>  'tls_statistics_seq_show' defined but not used [-Wunused-function]
> 
> Use #ifdef to guard this.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
