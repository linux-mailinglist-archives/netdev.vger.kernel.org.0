Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4C8FB3556
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 09:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbfIPHMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 03:12:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44370 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbfIPHMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 03:12:25 -0400
Received: from localhost (unknown [85.119.46.8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D26FE1517258D;
        Mon, 16 Sep 2019 00:12:22 -0700 (PDT)
Date:   Mon, 16 Sep 2019 09:12:20 +0200 (CEST)
Message-Id: <20190916.091220.1015956756124841222.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     netdev@vger.kernel.org, Joao.Pinto@synopsys.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        mcoquelin.stm32@gmail.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        christophe.roullier@st.com
Subject: Re: [PATCH net] net: stmmac: Hold rtnl lock in suspend/resume
 callbacks
From:   David Miller <davem@davemloft.net>
In-Reply-To: <66b6c1395e4bbc836e80083b89b2189ce7382d7b.1568360548.git.joabreu@synopsys.com>
References: <66b6c1395e4bbc836e80083b89b2189ce7382d7b.1568360548.git.joabreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Sep 2019 00:12:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Fri, 13 Sep 2019 11:50:32 +0200

> We need to hold rnl lock in suspend and resume callbacks because phylink
> requires it. Otherwise we will get a WARN() in suspend and resume.
> 
> Also, move phylink start and stop callbacks to inside device's internal
> lock so that we prevent concurrent HW accesses.
> 
> Fixes: 74371272f97f ("net: stmmac: Convert to phylink and remove phylib logic")
> Reported-by: Christophe ROULLIER <christophe.roullier@st.com>
> Tested-by: Christophe ROULLIER <christophe.roullier@st.com>
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>

Applied and queued up for v5.3 -stable.

Thanks.
