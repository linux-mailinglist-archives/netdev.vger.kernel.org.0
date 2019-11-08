Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 054EAF6172
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 21:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfKIU3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 15:29:34 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53658 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbfKIU3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 15:29:34 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 95F2C1473DC0B;
        Sat,  9 Nov 2019 12:29:33 -0800 (PST)
Date:   Fri, 08 Nov 2019 11:33:35 -0800 (PST)
Message-Id: <20191108.113335.1243186550016659990.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     vishal@chelsio.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] cxgb4: Use match_string() helper to simplify
 the code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191107143558.44208-1-yuehaibing@huawei.com>
References: <20191107143558.44208-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 09 Nov 2019 12:29:33 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Thu, 7 Nov 2019 22:35:58 +0800

> match_string() returns the array index of a matching string.
> Use it instead of the open-coded implementation.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied, thanks.
