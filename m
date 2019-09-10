Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81AEDAEED0
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 17:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436615AbfIJPpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 11:45:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58200 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbfIJPpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 11:45:50 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C02AA154F499A;
        Tue, 10 Sep 2019 08:45:47 -0700 (PDT)
Date:   Tue, 10 Sep 2019 17:45:44 +0200 (CEST)
Message-Id: <20190910.174544.945128884852877943.davem@davemloft.net>
To:     alexandru.ardelean@analog.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com
Subject: Re: [PATCH] net: stmmac: socfpga: re-use the `interface` parameter
 from platform data
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190906123054.5514-1-alexandru.ardelean@analog.com>
References: <20190906123054.5514-1-alexandru.ardelean@analog.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Sep 2019 08:45:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Ardelean <alexandru.ardelean@analog.com>
Date: Fri, 6 Sep 2019 15:30:54 +0300

> The socfpga sub-driver defines an `interface` field in the `socfpga_dwmac`
> struct and parses it on init.
> 
> The shared `stmmac_probe_config_dt()` function also parses this from the
> device-tree and makes it available on the returned `plat_data` (which is
> the same data available via `netdev_priv()`).
> 
> All that's needed now is to dig that information out, via some
> `dev_get_drvdata()` && `netdev_priv()` calls and re-use it.
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

This doesn't build even on net-next.

And if your patch does target net-next you must indicate this properly in the
Subject line as "[PATCH net-next]" vs. "[PATCH net]"
