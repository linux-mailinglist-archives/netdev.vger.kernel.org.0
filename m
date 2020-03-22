Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDD6F18E62B
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 04:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbgCVC7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 22:59:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34332 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbgCVC7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 22:59:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1990E15AC0C0F;
        Sat, 21 Mar 2020 19:59:48 -0700 (PDT)
Date:   Sat, 21 Mar 2020 19:59:47 -0700 (PDT)
Message-Id: <20200321.195947.2027395800786640789.davem@davemloft.net>
To:     kernel@esmil.dk
Cc:     netdev@vger.kernel.org, david.wu@rock-chips.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: dwmac-rk: fix error path in rk_gmac_probe
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200321143619.91533-1-kernel@esmil.dk>
References: <20200321143619.91533-1-kernel@esmil.dk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 21 Mar 2020 19:59:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emil Renner Berthing <kernel@esmil.dk>
Date: Sat, 21 Mar 2020 15:36:19 +0100

> Make sure we clean up devicetree related configuration
> also when clock init fails.
> 
> Fixes: fecd4d7eef8b ("net: stmmac: dwmac-rk: Add integrated PHY support")
> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>

Applied and queued up for -stable, thank you.
