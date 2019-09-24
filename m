Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6D2EBD2F9
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 21:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439372AbfIXTpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 15:45:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55714 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfIXTpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 15:45:13 -0400
Received: from localhost (231-157-167-83.reverse.alphalink.fr [83.167.157.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 76778153C42C5;
        Tue, 24 Sep 2019 12:45:10 -0700 (PDT)
Date:   Tue, 24 Sep 2019 21:45:08 +0200 (CEST)
Message-Id: <20190924.214508.1949579574079200671.davem@davemloft.net>
To:     thierry.reding@gmail.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, f.fainelli@gmail.com, jonathanh@nvidia.com,
        bbiswas@nvidia.com, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v3 0/2] net: stmmac: Enhanced addressing mode for DWMAC
 4.10
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190920170036.22610-1-thierry.reding@gmail.com>
References: <20190920170036.22610-1-thierry.reding@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Sep 2019 12:45:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <thierry.reding@gmail.com>
Date: Fri, 20 Sep 2019 19:00:34 +0200

> From: Thierry Reding <treding@nvidia.com>
> 
> The DWMAC 4.10 supports the same enhanced addressing mode as later
> generations. Parse this capability from the hardware feature registers
> and set the EAME (Enhanced Addressing Mode Enable) bit when necessary.

This looks like an enhancement and/or optimization rather than a bug fix.

Also, you're now writing to the high 32-bits unconditionally, even when
it will always be zero because of 32-bit addressing.  That looks like
a step backwards to me.

I'm not applying this.
