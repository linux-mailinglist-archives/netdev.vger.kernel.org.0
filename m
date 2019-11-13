Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B48FFBBB9
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 23:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfKMWii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 17:38:38 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39438 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfKMWii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 17:38:38 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C43CB128F3876;
        Wed, 13 Nov 2019 14:38:37 -0800 (PST)
Date:   Wed, 13 Nov 2019 14:38:37 -0800 (PST)
Message-Id: <20191113.143837.1464059114762484823.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     vishal@chelsio.com, rahul.lakkireddy@chelsio.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] cxgb4: Fix an error code in
 cxgb4_mqprio_alloc_hw_resources()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191113182548.vtmyryulik4gxnrv@kili.mountain>
References: <20191113182548.vtmyryulik4gxnrv@kili.mountain>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 Nov 2019 14:38:38 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 13 Nov 2019 21:25:48 +0300

> "ret" is zero or possibly uninitialized on this error path.  It
> should be a negative error code instead.
> 
> Fixes: 2d0cb84dd973 ("cxgb4: add ETHOFLD hardware queue support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
