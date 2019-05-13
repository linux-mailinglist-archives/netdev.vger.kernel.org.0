Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9111BB6D
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 19:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731011AbfEMRA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 13:00:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40174 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728822AbfEMRA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 13:00:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DB8D214E27EBA;
        Mon, 13 May 2019 10:00:26 -0700 (PDT)
Date:   Mon, 13 May 2019 10:00:26 -0700 (PDT)
Message-Id: <20190513.100026.93486365176104585.davem@davemloft.net>
To:     clabbe@baylibre.com
Cc:     alexandre.torgue@st.com, joabreu@synopsys.com,
        maxime.ripard@bootlin.com, peppe.cavallaro@st.com, wens@csie.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH] net: ethernet: stmmac: dwmac-sun8i: enable support of
 unicast filtering
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1557752799-9989-1-git-send-email-clabbe@baylibre.com>
References: <1557752799-9989-1-git-send-email-clabbe@baylibre.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 May 2019 10:00:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Corentin Labbe <clabbe@baylibre.com>
Date: Mon, 13 May 2019 13:06:39 +0000

> When adding more MAC address to a dwmac-sun8i interface, the device goes
> directly in promiscuous mode.
> This is due to IFF_UNICAST_FLT missing flag.
> 
> So since the hardware support unicast filtering, let's add IFF_UNICAST_FLT.
> 
> Fixes: 9f93ac8d4085 ("net-next: stmmac: Add dwmac-sun8i")
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>

Applied with s/address/addresses/

Thanks.
