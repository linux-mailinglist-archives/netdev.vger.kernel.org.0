Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7609EC0088
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 10:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfI0IAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 04:00:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56976 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbfI0IAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 04:00:40 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D925F14DB8499;
        Fri, 27 Sep 2019 01:00:38 -0700 (PDT)
Date:   Fri, 27 Sep 2019 10:00:37 +0200 (CEST)
Message-Id: <20190927.100037.1433103283572314359.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     vishal@chelsio.com, ganeshgr@chelsio.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] cxgb4: Signedness bug in init_one()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190925105459.GB3264@mwanda>
References: <20190925105459.GB3264@mwanda>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 01:00:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 25 Sep 2019 13:54:59 +0300

> The "chip" variable is an enum, and it's treated as unsigned int by GCC
> in this context so the error handling isn't triggered.
> 
> Fixes: e8d452923ae6 ("cxgb4: clean up init_one")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
