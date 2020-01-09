Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0747135048
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 01:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbgAIAHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 19:07:36 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50074 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbgAIAHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 19:07:36 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6D5301539F83E;
        Wed,  8 Jan 2020 16:07:35 -0800 (PST)
Date:   Wed, 08 Jan 2020 16:07:34 -0800 (PST)
Message-Id: <20200108.160734.1737202371253374740.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     doshir@vmware.com, pv-drivers@vmware.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] vmxnet3: Remove always false conditional
 statement
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200108140822.47016-1-yuehaibing@huawei.com>
References: <20200108140822.47016-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jan 2020 16:07:35 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Wed, 8 Jan 2020 22:08:22 +0800

> From: yuehaibing <yuehaibing@huawei.com>
> 
> param->rx_mini_pending is __u32 variable, it will never
> be less than zero.
> 
> Signed-off-by: yuehaibing <yuehaibing@huawei.com>

Applied, thanks.
