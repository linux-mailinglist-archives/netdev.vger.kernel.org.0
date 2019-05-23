Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4898727350
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 02:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729654AbfEWAaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 20:30:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36624 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727634AbfEWAaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 20:30:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 328F615042888;
        Wed, 22 May 2019 17:30:15 -0700 (PDT)
Date:   Wed, 22 May 2019 17:30:14 -0700 (PDT)
Message-Id: <20190522.173014.1665076296422323734.davem@davemloft.net>
To:     Jisheng.Zhang@synaptics.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: move reset gpio parse & request to
 stmmac_mdio_register
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190522175752.0cdfe19d@xhacker.debian>
References: <20190522175752.0cdfe19d@xhacker.debian>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 May 2019 17:30:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Date: Wed, 22 May 2019 10:06:56 +0000

> Move the reset gpio dt parse and request to stmmac_mdio_register(),
> thus makes the mdio code straightforward.
> 
> This patch also replace stack var mdio_bus_data with data to simplify
> the code.
> 
> Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

Please rebase this on net-next when I next merge net into net-next as
this is a cleanup and therefore not appropriate for net.
