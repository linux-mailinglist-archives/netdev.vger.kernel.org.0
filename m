Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 536E845425
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 07:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725859AbfFNFoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 01:44:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37336 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbfFNFoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 01:44:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7215F14DD925B;
        Thu, 13 Jun 2019 22:44:19 -0700 (PDT)
Date:   Thu, 13 Jun 2019 22:44:19 -0700 (PDT)
Message-Id: <20190613.224419.1387298560412603697.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: let mdio read functions return
 -ETIMEDOUT
From:   David Miller <davem@davemloft.net>
In-Reply-To: <c48b74a5-d888-8338-095d-82d8a4adee6e@gmail.com>
References: <c48b74a5-d888-8338-095d-82d8a4adee6e@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Jun 2019 22:44:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Tue, 11 Jun 2019 21:04:09 +0200

> In case of a timeout currently ~0 is returned. Callers often just check
> whether a certain bit is set and therefore may behave incorrectly.
> So let's return -ETIMEDOUT in case of a timeout.
> 
> r8168_phy_ocp_read is used in r8168g_mdio_read only, therefore we can
> apply the same change.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
