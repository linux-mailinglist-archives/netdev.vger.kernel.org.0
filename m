Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0AAE1B8297
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 01:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgDXX6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 19:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgDXX6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 19:58:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226CEC09B049;
        Fri, 24 Apr 2020 16:58:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CD3E714F72666;
        Fri, 24 Apr 2020 16:58:01 -0700 (PDT)
Date:   Fri, 24 Apr 2020 16:58:01 -0700 (PDT)
Message-Id: <20200424.165801.1457796079820198216.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: sched: remove unused inline function
 qdisc_reset_all_tx
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200424090450.44532-1-yuehaibing@huawei.com>
References: <20200424090450.44532-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Apr 2020 16:58:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Fri, 24 Apr 2020 17:04:50 +0800

> There's no callers in-tree anymore.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
