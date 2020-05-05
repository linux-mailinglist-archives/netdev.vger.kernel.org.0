Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC2D1C6147
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 21:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729284AbgEETqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 15:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729273AbgEETqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 15:46:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C2EFC061A0F;
        Tue,  5 May 2020 12:46:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B95331280591F;
        Tue,  5 May 2020 12:46:45 -0700 (PDT)
Date:   Tue, 05 May 2020 12:46:45 -0700 (PDT)
Message-Id: <20200505.124645.166643723797391974.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     tglx@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: microchip: Remove unused inline function
 is_bits_set
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200505084421.40052-1-yuehaibing@huawei.com>
References: <20200505084421.40052-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 May 2020 12:46:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Tue, 5 May 2020 16:44:21 +0800

> There's no callers in-tree.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
