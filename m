Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13359F576A
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731490AbfKHTVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 14:21:32 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36516 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731341AbfKHTVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 14:21:31 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0E9E6153A4E28;
        Fri,  8 Nov 2019 11:21:30 -0800 (PST)
Date:   Fri, 08 Nov 2019 11:21:29 -0800 (PST)
Message-Id: <20191108.112129.271488161241865818.davem@davemloft.net>
To:     christophe.roullier@st.com
Cc:     robh@kernel.org, joabreu@synopsys.com, mark.rutland@arm.com,
        mcoquelin.stm32@gmail.com, alexandre.torgue@st.com,
        peppe.cavallaro@st.com, linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        andrew@lunn.ch
Subject: Re: [PATCH V4 net-next 1/4] net: ethernet: stmmac: Add support for
 syscfg clock
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191107084757.17910-2-christophe.roullier@st.com>
References: <20191107084757.17910-1-christophe.roullier@st.com>
        <20191107084757.17910-2-christophe.roullier@st.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 08 Nov 2019 11:21:30 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe Roullier <christophe.roullier@st.com>
Date: Thu, 7 Nov 2019 09:47:54 +0100

> Add optional support for syscfg clock in dwmac-stm32.c
> Now Syscfg clock is activated automatically when syscfg
> registers are used
> 
> Signed-off-by: Christophe Roullier <christophe.roullier@st.com>

Applied to net-next, thanks.
