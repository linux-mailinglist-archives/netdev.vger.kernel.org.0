Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C14E9182914
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 07:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387930AbgCLGdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 02:33:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56240 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387784AbgCLGdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 02:33:17 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0F5EF14DB1AB4;
        Wed, 11 Mar 2020 23:33:16 -0700 (PDT)
Date:   Wed, 11 Mar 2020 23:33:15 -0700 (PDT)
Message-Id: <20200311.233315.1715097650969345027.davem@davemloft.net>
To:     chenzhou10@huawei.com
Cc:     willy@infradead.org, andrew@lunn.ch, hkallweit1@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] net: ibm: remove set but not used variables 'err'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200311065411.172692-1-chenzhou10@huawei.com>
References: <20200311065411.172692-1-chenzhou10@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Mar 2020 23:33:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen Zhou <chenzhou10@huawei.com>
Date: Wed, 11 Mar 2020 14:54:11 +0800

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/ethernet/ibm/emac/core.c: In function __emac_mdio_write:
> drivers/net/ethernet/ibm/emac/core.c:875:9: warning:
> 	variable err set but not used [-Wunused-but-set-variable]
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Chen Zhou <chenzhou10@huawei.com>

Applied, thank you.
