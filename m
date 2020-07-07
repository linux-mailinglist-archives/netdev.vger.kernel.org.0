Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E010217886
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 22:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgGGUDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 16:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbgGGUDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 16:03:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6BDC061755;
        Tue,  7 Jul 2020 13:03:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6F237120F93E2;
        Tue,  7 Jul 2020 13:03:39 -0700 (PDT)
Date:   Tue, 07 Jul 2020 13:03:38 -0700 (PDT)
Message-Id: <20200707.130338.363103542607640933.davem@davemloft.net>
To:     mcroce@linux.microsoft.com
Cc:     netdev@vger.kernel.org, sven.auhagen@voleatech.de,
        linux-kernel@vger.kernel.org, colin.king@canonical.com
Subject: Re: [PATCH net-next] mvpp2: fix pointer check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200707131913.25534-1-mcroce@linux.microsoft.com>
References: <20200707131913.25534-1-mcroce@linux.microsoft.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jul 2020 13:03:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@linux.microsoft.com>
Date: Tue,  7 Jul 2020 15:19:13 +0200

> From: Matteo Croce <mcroce@microsoft.com>
> 
> priv->page_pool is an array, so comparing against it will always return true.
> Do a meaningful check by checking priv->page_pool[0] instead.
> While at it, clear the page_pool pointers on deallocation, or when an
> allocation error happens during init.
> 
> Reported-by: Colin Ian King <colin.king@canonical.com>
> Fixes: c2d6fe6163de ("mvpp2: XDP TX support")
> Signed-off-by: Matteo Croce <mcroce@microsoft.com>

Applied.
