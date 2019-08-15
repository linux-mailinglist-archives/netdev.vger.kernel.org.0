Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34EBF8F482
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731120AbfHOT2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:28:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48910 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfHOT2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 15:28:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9554E1400EC49;
        Thu, 15 Aug 2019 12:28:07 -0700 (PDT)
Date:   Thu, 15 Aug 2019 12:28:07 -0700 (PDT)
Message-Id: <20190815.122807.860855109257448352.davem@davemloft.net>
To:     jonathan.lemon@gmail.com
Cc:     netdev@vger.kernel.org, brouer@redhat.com,
        ilias.apalodimas@linaro.org, saeedm@mellanox.com,
        ttoukan.linux@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH net-next] page_pool: fix logic in __page_pool_get_cached
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190813174509.494723-1-jonathan.lemon@gmail.com>
References: <20190813174509.494723-1-jonathan.lemon@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 Aug 2019 12:28:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <jonathan.lemon@gmail.com>
Date: Tue, 13 Aug 2019 10:45:09 -0700

> __page_pool_get_cached() will return NULL when the ring is
> empty, even if there are pages present in the lookaside cache.
> 
> It is also possible to refill the cache, and then return a
> NULL page.
> 
> Restructure the logic so eliminate both cases.
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Applied.
