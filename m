Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9115063C53
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 22:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728994AbfGIUAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 16:00:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44766 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728959AbfGIUAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 16:00:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 24649104474BD;
        Tue,  9 Jul 2019 13:00:16 -0700 (PDT)
Date:   Tue, 09 Jul 2019 13:00:15 -0700 (PDT)
Message-Id: <20190709.130015.625151689407574086.davem@davemloft.net>
To:     ilias.apalodimas@linaro.org
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org
Subject: Re: [PATCH] net: netsec: start using buffers if page_pool
 registration succeeded
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1562675753-26160-1-git-send-email-ilias.apalodimas@linaro.org>
References: <1562675753-26160-1-git-send-email-ilias.apalodimas@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Jul 2019 13:00:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date: Tue,  9 Jul 2019 15:35:53 +0300

> The current driver starts using page_pool buffers before calling
> xdp_rxq_info_reg_mem_model(). Start using the buffers after the
> registration succeeded, so we won't have to call
> page_pool_request_shutdown() in case of failure
> 
> Fixes: 5c67bf0ec4d0 ("net: netsec: Use page_pool API")
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

Applied, thanks.
