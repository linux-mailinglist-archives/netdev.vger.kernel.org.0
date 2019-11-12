Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71DF3F992A
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 19:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfKLS4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 13:56:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47736 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbfKLS4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 13:56:40 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3D44C154CC5BE;
        Tue, 12 Nov 2019 10:56:40 -0800 (PST)
Date:   Tue, 12 Nov 2019 10:56:39 -0800 (PST)
Message-Id: <20191112.105639.987579078453559560.davem@davemloft.net>
To:     zhengbin13@huawei.com
Cc:     vishal@chelsio.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] cxgb4: make function
 'cxgb4_mqprio_free_hw_resources' static
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1573542520-126327-1-git-send-email-zhengbin13@huawei.com>
References: <1573542520-126327-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 10:56:40 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhengbin <zhengbin13@huawei.com>
Date: Tue, 12 Nov 2019 15:08:40 +0800

> Fix sparse warnings:
> 
> drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c:242:6: warning: symbol 'cxgb4_mqprio_free_hw_resources' was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: 2d0cb84dd973 ("cxgb4: add ETHOFLD hardware queue support")
> Signed-off-by: zhengbin <zhengbin13@huawei.com>

Applied.
