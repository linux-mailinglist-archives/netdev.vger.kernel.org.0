Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBE24722B
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 22:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbfFOU60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 16:58:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39618 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfFOU6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 16:58:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0FF0B14EC46B5;
        Sat, 15 Jun 2019 13:58:25 -0700 (PDT)
Date:   Sat, 15 Jun 2019 13:58:24 -0700 (PDT)
Message-Id: <20190615.135824.1216801607764531974.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Joao.Pinto@synopsys.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com
Subject: Re: [PATCH net-next] net: stmmac: Fix wrapper drivers not
 detecting PHY
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f4f524805a81c6f680b55d8fb084b1070294a0a8.1560524776.git.joabreu@synopsys.com>
References: <f4f524805a81c6f680b55d8fb084b1070294a0a8.1560524776.git.joabreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 15 Jun 2019 13:58:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Fri, 14 Jun 2019 17:06:57 +0200

> Because of PHYLINK conversion we stopped parsing the phy-handle property
> from DT. Unfortunatelly, some wrapper drivers still rely on this phy
> node to configure the PHY.
> 
> Let's restore the parsing of PHY handle while these wrapper drivers are
> not fully converted to PHYLINK.
> 
> Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> Fixes: 74371272f97f ("net: stmmac: Convert to phylink and remove phylib logic")
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>

Applied, thanks.
