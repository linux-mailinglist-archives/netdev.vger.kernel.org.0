Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66A9270EAA
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 03:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731461AbfGWBag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 21:30:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52628 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728108AbfGWBag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 21:30:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 21AD915305EB2;
        Mon, 22 Jul 2019 18:30:35 -0700 (PDT)
Date:   Mon, 22 Jul 2019 18:30:34 -0700 (PDT)
Message-Id: <20190722.183034.1093194142173051399.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     netdev@vger.kernel.org, Joao.Pinto@synopsys.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        mcoquelin.stm32@gmail.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        megi@xff.cz
Subject: Re: [PATCH net] net: stmmac: Do not cut down 1G modes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f9b8245ef4fbaca463a6084166c7f72793cb799b.1563804016.git.joabreu@synopsys.com>
References: <f9b8245ef4fbaca463a6084166c7f72793cb799b.1563804016.git.joabreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jul 2019 18:30:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Mon, 22 Jul 2019 16:07:21 +0200

> Some glue logic drivers support 1G without having GMAC/GMAC4/XGMAC.
> 
> Let's allow this speed by default.
> 
> Reported-by: Ondrej Jirman <megi@xff.cz>
> Tested-by: Ondrej Jirman <megi@xff.cz>
> Fixes: 5b0d7d7da64b ("net: stmmac: Add the missing speeds that XGMAC supports")
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>

Applied.
