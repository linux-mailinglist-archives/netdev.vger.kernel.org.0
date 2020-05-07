Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA96F1C9B6D
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 21:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbgEGTzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 15:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726320AbgEGTzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 15:55:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED6EC05BD43;
        Thu,  7 May 2020 12:55:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 599CF11F5F667;
        Thu,  7 May 2020 12:55:50 -0700 (PDT)
Date:   Thu, 07 May 2020 12:55:47 -0700 (PDT)
Message-Id: <20200507.125547.2132876805338214835.davem@davemloft.net>
To:     zhengzengkai@huawei.com
Cc:     andrew@lunn.ch, rjui@broadcom.com, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: Make iproc_mdio_resume static
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200507080326.111896-1-zhengzengkai@huawei.com>
References: <20200507080326.111896-1-zhengzengkai@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 May 2020 12:55:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Zengkai <zhengzengkai@huawei.com>
Date: Thu, 7 May 2020 16:03:26 +0800

> Fix sparse warnings:
> 
> drivers/net/phy/mdio-bcm-iproc.c:182:5: warning:
>  symbol 'iproc_mdio_resume' was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zheng Zengkai <zhengzengkai@huawei.com>

Applied.
