Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE9C8F4FC
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733154AbfHOTpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:45:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49240 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729843AbfHOTpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 15:45:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 35C7614013D5B;
        Thu, 15 Aug 2019 12:45:22 -0700 (PDT)
Date:   Thu, 15 Aug 2019 12:45:21 -0700 (PDT)
Message-Id: <20190815.124521.638274291598387510.davem@davemloft.net>
To:     wenwen@cs.uga.edu
Cc:     christopher.lee@cspi.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: myri10ge: fix memory leaks
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1565764719-6488-1-git-send-email-wenwen@cs.uga.edu>
References: <1565764719-6488-1-git-send-email-wenwen@cs.uga.edu>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 Aug 2019 12:45:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>
Date: Wed, 14 Aug 2019 01:38:39 -0500

> In myri10ge_probe(), myri10ge_alloc_slices() is invoked to allocate slices
> related structures. Later on, myri10ge_request_irq() is used to get an irq.
> However, if this process fails, the allocated slices related structures are
> not deallocated, leading to memory leaks. To fix this issue, revise the
> target label of the goto statement to 'abort_with_slices'.
> 
> Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>

Applied, thanks.
