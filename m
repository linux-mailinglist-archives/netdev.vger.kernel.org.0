Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A181E8C6B
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 02:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbgE3ACK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 20:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgE3ACJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 20:02:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA702C03E969
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 17:02:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6DFB312873620;
        Fri, 29 May 2020 17:02:08 -0700 (PDT)
Date:   Fri, 29 May 2020 17:02:07 -0700 (PDT)
Message-Id: <20200529.170207.886143430127735309.davem@davemloft.net>
To:     fugang.duan@nxp.com
Cc:     andrew@lunn.ch, peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, kuba@kernel.org, netdev@vger.kernel.org,
        mcoquelin.stm32@gmail.com, p.zabel@pengutronix.de
Subject: Re: [PATCH v2 net 0/3] net: ethernet: dwmac: add ethernet glue
 logic for NXP imx8 chip
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200528082625.27218-1-fugang.duan@nxp.com>
References: <20200528082625.27218-1-fugang.duan@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 29 May 2020 17:02:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: fugang.duan@nxp.com
Date: Thu, 28 May 2020 16:26:22 +0800

> From: Fugang Duan <fugang.duan@nxp.com>
> 
> NXP imx8 family like imx8mp/imx8dxl chips support Synopsys
> MAC 5.10a IP, the patch set is to add ethernet DWMAC glue
> layer including clocks, dwmac address width, phy interface
> mode selection and rgmii txclk rate adjustment in runtime.
> 
> v1 -> v2:
> - suggested by Andrew: add the "snps,dwmac-5.10a" compatible
>   string into NXP binding documentation.
> - suggested by David: adjust code sequences in order to have
>   reverse christmas tree local variable ordering.
> 
> Thanks Andrew and David for the review.

Series applied to net-next, thank you!
