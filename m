Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5D72794B1
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 01:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbgIYX0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 19:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbgIYX0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 19:26:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07D1C0613CE;
        Fri, 25 Sep 2020 16:26:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E7B0413B9D46A;
        Fri, 25 Sep 2020 16:09:25 -0700 (PDT)
Date:   Fri, 25 Sep 2020 16:26:12 -0700 (PDT)
Message-Id: <20200925.162612.1706734858463106489.davem@davemloft.net>
To:     martin.blumenstingl@googlemail.com
Cc:     netdev@vger.kernel.org, linux-amlogic@lists.infradead.org,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: dwmac-meson8b: add calibration registers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200925215629.545233-1-martin.blumenstingl@googlemail.com>
References: <20200925215629.545233-1-martin.blumenstingl@googlemail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 25 Sep 2020 16:09:26 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Fri, 25 Sep 2020 23:56:29 +0200

> The Amlogic dwmac Ethernet IP glue has two registers:
> - PRG_ETH0 with various configuration bits
> - PRG_ETH1 with various calibration and information related bits
> 
> Add the register definitions with comments from different drivers in
> Amlogic's vendor u-boot and Linux.
> 
> The most important part is PRG_ETH1_AUTO_CALI_IDX_VAL which is needed on
> G12A (and later: G12B, SM1) with RGMII PHYs. Ethernet is only working up
> to 100Mbit/s speeds if u-boot does not initialize these bits correctly.
> On 1Gbit/s links no traffic is flowing (similar to when the RGMII delays
> are set incorrectly). The logic to write this register will be added
> later.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Please add these definitions alongside actual uses of them.

Thank you.
