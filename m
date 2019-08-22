Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFA0198A04
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 05:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729829AbfHVDvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 23:51:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37880 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbfHVDu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 23:50:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F25CB15214D9F;
        Wed, 21 Aug 2019 20:50:58 -0700 (PDT)
Date:   Wed, 21 Aug 2019 20:50:58 -0700 (PDT)
Message-Id: <20190821.205058.7560855985510600.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     csully@google.com, sagis@google.com, jonolson@google.com,
        willemb@google.com, lrizzo@google.com, hslester96@gmail.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2 net] gve: Copy and paste bug in gve_get_stats()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190820090739.GB1845@kadam>
References: <20190820090053.GA24410@mwanda>
        <20190820090739.GB1845@kadam>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 21 Aug 2019 20:50:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 20 Aug 2019 12:11:44 +0300

> There is a copy and paste error so we have "rx" where "tx" was intended
> in the priv->tx[] array.
> 
> Fixes: f5cedc84a30d ("gve: Add transmit and receive support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: fix a typo in the subject: buy -> bug (Thanks Walter Harms)

Applied, thanks.
