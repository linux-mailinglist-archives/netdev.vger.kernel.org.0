Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 637E6E9472
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 02:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbfJ3BJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 21:09:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33996 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbfJ3BJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 21:09:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C0F5C1433DDBF;
        Tue, 29 Oct 2019 18:09:06 -0700 (PDT)
Date:   Tue, 29 Oct 2019 18:09:06 -0700 (PDT)
Message-Id: <20191029.180906.71140804338490537.davem@davemloft.net>
To:     christophe.roullier@st.com
Cc:     robh@kernel.org, joabreu@synopsys.com, mark.rutland@arm.com,
        mcoquelin.stm32@gmail.com, alexandre.torgue@st.com,
        peppe.cavallaro@st.com, linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        andrew@lunn.ch
Subject: Re: [PATCH 0/5] net: ethernet: stmmac: some fixes and optimizations
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191029101441.17290-1-christophe.roullier@st.com>
References: <20191029101441.17290-1-christophe.roullier@st.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 18:09:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe Roullier <christophe.roullier@st.com>
Date: Tue, 29 Oct 2019 11:14:36 +0100

> Some improvements (manage syscfg as optional clock, update slew rate of
> ETH_MDIO pin, Enable gating of the MAC TX clock during TX low-power mode)
> Fix warning build message when W=1

Please fix up several issues with this submission:

1) Bug fixes should target the 'net' GIT tree.  Anything else, and this
   means cleanups, new features, and optimizations, should all target
   the 'net-next' GIT tree.

2) Your subject lines are too much, for example:

   [net: ethernet: stmmac: some fixes and optimizations 1/5] net: ethernet: stmmac: Add support for syscfg clock

   The "net: ethernet: stmmac: some fixes and optimizations" part
   should be completely removed.  'net' should be separate to indicate
   the target GIT tree (or 'net-next' as could be the case) and then
   we're left with, for example:

   [PATCH net-next 1/5] net: ethernet: stmmac: Add support for syscfg clock

3) There should be a seprate series with the bug fixes targetting 'net',
   then you should wait for those fixes to propagate into 'net-next', at which
   time you can submit a second patch series targetting 'net-next' with all
   the cleanups, feature additions, and optimizations.

Thank you.
