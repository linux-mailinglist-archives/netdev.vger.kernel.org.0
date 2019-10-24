Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19C23E3F4A
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 00:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731482AbfJXWTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 18:19:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52636 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730505AbfJXWTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 18:19:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 28FCA14B79EBE;
        Thu, 24 Oct 2019 15:19:53 -0700 (PDT)
Date:   Thu, 24 Oct 2019 15:19:52 -0700 (PDT)
Message-Id: <20191024.151952.183800816459145037.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     varkabhadram@gmail.com, alex.aring@gmail.com,
        stefan@datenfreihafen.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] ieee802154: remove set but not used variable
 'status'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191023070618.30044-1-yuehaibing@huawei.com>
References: <20191023070618.30044-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 24 Oct 2019 15:19:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Wed, 23 Oct 2019 15:06:18 +0800

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/ieee802154/cc2520.c:221:5: warning:
>  variable status set but not used [-Wunused-but-set-variable]
> 
> It is never used, so can be removed.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

I am assuming the WPAN folks will pick this up, thanks.
