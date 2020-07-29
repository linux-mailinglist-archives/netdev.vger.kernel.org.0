Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E402F2316F3
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 02:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730953AbgG2Asi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 20:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730837AbgG2Asi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 20:48:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66625C061794;
        Tue, 28 Jul 2020 17:48:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9F6E6128D3F97;
        Tue, 28 Jul 2020 17:31:52 -0700 (PDT)
Date:   Tue, 28 Jul 2020 17:48:37 -0700 (PDT)
Message-Id: <20200728.174837.591128375744536882.davem@davemloft.net>
To:     Jisheng.Zhang@synaptics.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] net: stmmac: improve WOL
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200727190045.36f247cc@xhacker.debian>
References: <20200727190045.36f247cc@xhacker.debian>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Jul 2020 17:31:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Date: Mon, 27 Jul 2020 19:01:07 +0800

> Currently, stmmac driver relies on the HW PMT to support WOL. We want
> to support phy based WOL.
> 
> patch1 is a small improvement to disable WAKE_MAGIC for PMT case if
> no pmt_magic_frame.
> patch2 and patch3 are two prepation patches.
> patch4 implement the phy based WOL
> patch5 tries to save a bit energy if WOL is enabled.

Series applied to net-next, thanks.
