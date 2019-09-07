Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2F62AC736
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 17:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406047AbfIGPRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 11:17:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46044 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388430AbfIGPRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 11:17:38 -0400
Received: from localhost (unknown [88.214.184.0])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C29341528CDC7;
        Sat,  7 Sep 2019 08:17:36 -0700 (PDT)
Date:   Sat, 07 Sep 2019 17:17:32 +0200 (CEST)
Message-Id: <20190907.171732.225166591073177009.davem@davemloft.net>
To:     zhongjiang@huawei.com
Cc:     kstewart@linuxfoundation.org, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ethernet: micrel: Use DIV_ROUND_CLOSEST directly to
 make it readable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1567698828-26825-1-git-send-email-zhongjiang@huawei.com>
References: <1567698828-26825-1-git-send-email-zhongjiang@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Sep 2019 08:17:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhong jiang <zhongjiang@huawei.com>
Date: Thu, 5 Sep 2019 23:53:48 +0800

> The kernel.h macro DIV_ROUND_CLOSEST performs the computation (x + d/2)/d
> but is perhaps more readable.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>

Applied to net-next.
