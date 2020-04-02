Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04B3019C396
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 16:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388395AbgDBOFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 10:05:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47142 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731608AbgDBOFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 10:05:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AD889128A134D;
        Thu,  2 Apr 2020 07:05:12 -0700 (PDT)
Date:   Thu, 02 Apr 2020 07:05:11 -0700 (PDT)
Message-Id: <20200402.070511.202780885237451617.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     netdev@vger.kernel.org, Joao.Pinto@synopsys.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        mcoquelin.stm32@gmail.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: stmmac: xgmac: Fix VLAN register handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <daf6d10d679c24e9b33b758b249b9b70e5eb1f01.1585835790.git.Jose.Abreu@synopsys.com>
References: <daf6d10d679c24e9b33b758b249b9b70e5eb1f01.1585835790.git.Jose.Abreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Apr 2020 07:05:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Thu,  2 Apr 2020 15:57:07 +0200

> Commit 907a076881f1, forgot that we need to clear old values of
> XGMAC_VLAN_TAG register when we switch from VLAN perfect matching to
> HASH matching.
> 
> Fix it.
> 
> Fixes: 907a076881f1 ("net: stmmac: xgmac: fix incorrect XGMAC_VLAN_TAG register writting")
> Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

Applied, thanks.
