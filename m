Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC6DA1BE6D6
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbgD2TAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726423AbgD2TAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 15:00:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F03C03C1AE;
        Wed, 29 Apr 2020 12:00:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0E60E1210A3E3;
        Wed, 29 Apr 2020 12:00:55 -0700 (PDT)
Date:   Wed, 29 Apr 2020 12:00:54 -0700 (PDT)
Message-Id: <20200429.120054.531415145411760190.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     kuba@kernel.org, ap420073@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: hsr: remove unused inline functions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200429132430.29948-1-yuehaibing@huawei.com>
References: <20200429132430.29948-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Apr 2020 12:00:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Wed, 29 Apr 2020 21:24:30 +0800

> There's no callers in-tree anymore.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
