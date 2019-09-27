Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 194AAC0AFB
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 20:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbfI0SYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 14:24:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35210 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbfI0SYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 14:24:01 -0400
Received: from localhost (231-157-167-83.reverse.alphalink.fr [83.167.157.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B41BF153ED97F;
        Fri, 27 Sep 2019 11:23:59 -0700 (PDT)
Date:   Fri, 27 Sep 2019 20:23:57 +0200 (CEST)
Message-Id: <20190927.202357.261337567048947149.davem@davemloft.net>
To:     rdunlap@infradead.org
Cc:     netdev@vger.kernel.org, uwe@kleine-koenig.org, talgi@mellanox.com,
        saeedm@mellanox.com
Subject: Re: [PATCH] lib: dimlib: fix help text typos
From:   David Miller <davem@davemloft.net>
In-Reply-To: <445cadc0-8b22-957f-47f6-2e6250124ae3@infradead.org>
References: <445cadc0-8b22-957f-47f6-2e6250124ae3@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 11:24:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Date: Wed, 25 Sep 2019 17:20:42 -0700

> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix help text typos for DIMLIB.
> 
> Fixes: 4f75da3666c0 ("linux/dim: Move implementation to .c files")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Applied.
