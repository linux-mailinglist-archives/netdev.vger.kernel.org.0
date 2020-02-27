Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE320170FCD
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 05:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgB0EsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 23:48:10 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37098 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728284AbgB0EsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 23:48:10 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 74FDD15B47C90;
        Wed, 26 Feb 2020 20:48:09 -0800 (PST)
Date:   Wed, 26 Feb 2020 20:48:09 -0800 (PST)
Message-Id: <20200226.204809.102099518712120120.davem@davemloft.net>
To:     akiyano@amazon.com
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        netanel@amazon.com, alisaidi@amazon.com, benh@amazon.com,
        ndagan@amazon.com, shayagr@amazon.com, sameehj@amazon.com
Subject: Re: [RESEND PATCH V1 net-next] net: ena: fix broken interface
 between ENA driver and FW
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1582711415-4442-1-git-send-email-akiyano@amazon.com>
References: <1582711415-4442-1-git-send-email-akiyano@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2020 20:48:10 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <akiyano@amazon.com>
Date: Wed, 26 Feb 2020 12:03:35 +0200

> From: Arthur Kiyanovski <akiyano@amazon.com>
> 
> In this commit we revert the part of
> commit 1a63443afd70 ("net/amazon: Ensure that driver version is aligned to the linux kernel"),
> which breaks the interface between the ENA driver and FW.
> 
> We also replace the use of DRIVER_VERSION with DRIVER_GENERATION
> when we bring back the deleted constants that are used in interface with
> ENA device FW.
> 
> This commit does not change the driver version reported to the user via
> ethtool, which remains the kernel version.
> 
> Fixes: 1a63443afd70 ("net/amazon: Ensure that driver version is aligned to the linux kernel")
> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>

Applied.
