Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C562DA9EF1
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 11:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732614AbfIEJyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 05:54:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43882 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbfIEJys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 05:54:48 -0400
Received: from localhost (unknown [89.248.140.11])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2432C1538752B;
        Thu,  5 Sep 2019 02:54:46 -0700 (PDT)
Date:   Thu, 05 Sep 2019 11:54:42 +0200 (CEST)
Message-Id: <20190905.115442.77056976071115136.davem@davemloft.net>
To:     mdf@kernel.org
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fixed_phy: Add forward declaration for struct
 gpio_desc;
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190903184652.3148-1-mdf@kernel.org>
References: <20190903184652.3148-1-mdf@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Sep 2019 02:54:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moritz Fischer <mdf@kernel.org>
Date: Tue,  3 Sep 2019 11:46:52 -0700

> Add forward declaration for struct gpio_desc in order to address
> the following:
> 
> ./include/linux/phy_fixed.h:48:17: error: 'struct gpio_desc' declared inside parameter list [-Werror]
> ./include/linux/phy_fixed.h:48:17: error: its scope is only this definition or declaration, which is probably not what you want [-Werror]
> 
> Fixes commit 71bd106d2567 ("net: fixed-phy: Add
> fixed_phy_register_with_gpiod() API")
> Signed-off-by: Moritz Fischer <mdf@kernel.org>

Applied with Fixes tag fixed up.
