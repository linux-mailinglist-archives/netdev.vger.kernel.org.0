Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 797365D9DF
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbfGCAzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:55:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45364 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbfGCAzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 20:55:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 428AA1400CB15;
        Tue,  2 Jul 2019 15:23:59 -0700 (PDT)
Date:   Tue, 02 Jul 2019 15:23:58 -0700 (PDT)
Message-Id: <20190702.152358.586281786791539430.davem@davemloft.net>
To:     martin.blumenstingl@googlemail.com
Cc:     netdev@vger.kernel.org, colin.king@canonical.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: make "snps,reset-delays-us" optional again
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190701224225.19701-1-martin.blumenstingl@googlemail.com>
References: <20190701224225.19701-1-martin.blumenstingl@googlemail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Jul 2019 15:23:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Tue,  2 Jul 2019 00:42:25 +0200

> Commit 760f1dc2958022 ("net: stmmac: add sanity check to
> device_property_read_u32_array call") introduced error checking of the
> device_property_read_u32_array() call in stmmac_mdio_reset().
> This results in the following error when the "snps,reset-delays-us"
> property is not defined in devicetree:
>   invalid property snps,reset-delays-us
> 
> This sanity check made sense until commit 84ce4d0f9f55b4 ("net: stmmac:
> initialize the reset delay array") ensured that there are fallback
> values for the reset delay if the "snps,reset-delays-us" property is
> absent. That was at the cost of making that property mandatory though.
> 
> Drop the sanity check for device_property_read_u32_array() and thus make
> the "snps,reset-delays-us" property optional again (avoiding the error
> message while loading the stmmac driver with a .dtb where the property
> is absent).
> 
> Fixes: 760f1dc2958022 ("net: stmmac: add sanity check to device_property_read_u32_array call")
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
> This is a fix for a patch in net-next and should either go into net-next
> or 5.3-rcX.

Ok, applied to net-next.
