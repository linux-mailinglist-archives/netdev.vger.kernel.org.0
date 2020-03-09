Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C642117D897
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 05:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgCIE3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 00:29:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53998 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgCIE3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 00:29:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3F658158B5851;
        Sun,  8 Mar 2020 21:29:12 -0700 (PDT)
Date:   Sun, 08 Mar 2020 21:29:11 -0700 (PDT)
Message-Id: <20200308.212911.623712971851173339.davem@davemloft.net>
To:     repk@triplefau.lt
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-amlogic@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] net: stmmac: dwmac1000: Disable ACS if enhanced
 descs are not used
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200308092556.23881-1-repk@triplefau.lt>
References: <20200308092556.23881-1-repk@triplefau.lt>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 08 Mar 2020 21:29:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Remi Pommarel <repk@triplefau.lt>
Date: Sun,  8 Mar 2020 10:25:56 +0100

> ACS (auto PAD/FCS stripping) removes FCS off 802.3 packets (LLC) so that
> there is no need to manually strip it for such packets. The enhanced DMA
> descriptors allow to flag LLC packets so that the receiving callback can
> use that to strip FCS manually or not. On the other hand, normal
> descriptors do not support that.
> 
> Thus in order to not truncate LLC packet ACS should be disabled when
> using normal DMA descriptors.
> 
> Fixes: 47dd7a540b8a0 ("net: add support for STMicroelectronics Ethernet controllers.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Remi Pommarel <repk@triplefau.lt>

Please don't CC: stable for networking fixes as per the netdev FAQ.

Applied and queued up for -stable, thank you.
