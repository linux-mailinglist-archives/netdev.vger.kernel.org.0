Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 705A0123FF1
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 08:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbfLRHBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 02:01:13 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47628 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfLRHBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 02:01:13 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3D2A1150379EF;
        Tue, 17 Dec 2019 23:01:12 -0800 (PST)
Date:   Tue, 17 Dec 2019 23:01:11 -0800 (PST)
Message-Id: <20191217.230111.26076810894427486.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     netdev@vger.kernel.org, Joao.Pinto@synopsys.com,
        jakub.kicinski@netronome.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, mcoquelin.stm32@gmail.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/7] net: stmmac: Always arm TX Timer at
 end of transmission start
From:   David Miller <davem@davemloft.net>
In-Reply-To: <c76b0d51238192f81a52231b214f252b20be55c6.1576586602.git.Jose.Abreu@synopsys.com>
References: <cover.1576586602.git.Jose.Abreu@synopsys.com>
        <cover.1576586602.git.Jose.Abreu@synopsys.com>
        <c76b0d51238192f81a52231b214f252b20be55c6.1576586602.git.Jose.Abreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Dec 2019 23:01:12 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Tue, 17 Dec 2019 13:46:06 +0100

> If TX Coalesce timer is enabled we should always arm it, otherwise we
> may hit the case where an interrupt is missed and the TX Queue will
> timeout.
> 
> Arming the timer does not necessarly mean it will run the tx_clean()
> because this function is wrapped around NAPI launcher.
> 
> Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

This is a bug fix and thus appropriate for net not net-next.
