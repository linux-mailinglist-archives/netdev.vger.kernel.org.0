Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98D865A0AC
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 18:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbfF1QTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 12:19:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46952 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbfF1QTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 12:19:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B37B814E03857;
        Fri, 28 Jun 2019 09:19:13 -0700 (PDT)
Date:   Fri, 28 Jun 2019 09:19:13 -0700 (PDT)
Message-Id: <20190628.091913.1877817778159344419.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Joao.Pinto@synopsys.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH net-next v2] net: stmmac: Fix case when PHY handle is
 not present
From:   David Miller <davem@davemloft.net>
In-Reply-To: <654cfe790807c6dfcc69c610c9692efb8c9a6179.1561706654.git.joabreu@synopsys.com>
References: <654cfe790807c6dfcc69c610c9692efb8c9a6179.1561706654.git.joabreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Jun 2019 09:19:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Fri, 28 Jun 2019 09:25:07 +0200

> Some DT bindings do not have the PHY handle. Let's fallback to manually
> discovery in case phylink_of_phy_connect() fails.
> 
> Changes from v1:
> 	- Fixup comment style (Sergei)
> 
> Fixes: 74371272f97f ("net: stmmac: Convert to phylink and remove phylib logic")
> Reported-by: Katsuhiro Suzuki <katsuhiro@katsuster.net>
> Tested-by: Katsuhiro Suzuki <katsuhiro@katsuster.net>
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>

Applied, thanks.
