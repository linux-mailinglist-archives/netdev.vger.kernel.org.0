Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 492A7E7D2D
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 00:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbfJ1Xri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 19:47:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46856 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfJ1Xrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 19:47:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5973414BF467A;
        Mon, 28 Oct 2019 16:47:37 -0700 (PDT)
Date:   Mon, 28 Oct 2019 16:47:36 -0700 (PDT)
Message-Id: <20191028.164736.150119177615014814.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atm: remove unneeded semicolon
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191025093030.956-1-yuehaibing@huawei.com>
References: <20191025093030.956-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 28 Oct 2019 16:47:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Fri, 25 Oct 2019 17:30:30 +0800

> remove unneeded semicolon.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied to net-next.
