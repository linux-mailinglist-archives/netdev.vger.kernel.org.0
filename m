Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B198D242FEE
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 22:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgHLUNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 16:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbgHLUNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 16:13:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3690EC061383;
        Wed, 12 Aug 2020 13:13:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 51A4012905D74;
        Wed, 12 Aug 2020 12:57:01 -0700 (PDT)
Date:   Wed, 12 Aug 2020 13:13:46 -0700 (PDT)
Message-Id: <20200812.131346.1049273548567735486.davem@davemloft.net>
To:     noodles@earth.li
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/2] net: stmmac: Fix multicast filter on IPQ806x
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1597260787.git.noodles@earth.li>
References: <cover.1597260787.git.noodles@earth.li>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Aug 2020 12:57:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan McDowell <noodles@earth.li>
Date: Wed, 12 Aug 2020 20:36:54 +0100

> This pair of patches are the result of discovering a failure to
> correctly receive IPv6 multicast packets on such a device (in particular
> DHCPv6 requests and RA solicitations). Putting the device into
> promiscuous mode, or allmulti, both resulted in such packets correctly
> being received. Examination of the vendor driver (nss-gmac from the
> qsdk) shows that it does not enable the multicast filter and instead
> falls back to allmulti.
> 
> Extend the base dwmac1000 driver to fall back when there's no suitable
> hardware filter, and update the ipq806x platform to request this.

Series applied, thank you.
