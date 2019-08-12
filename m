Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8A648A8F6
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 23:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbfHLVGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 17:06:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51310 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbfHLVGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 17:06:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 28173154D32CB;
        Mon, 12 Aug 2019 14:06:19 -0700 (PDT)
Date:   Mon, 12 Aug 2019 14:06:18 -0700 (PDT)
Message-Id: <20190812.140618.1288127671943783439.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     netdev@vger.kernel.org, Joao.Pinto@synopsys.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        mcoquelin.stm32@gmail.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 04/12] net: stmmac: Add Split Header
 support and enable it in XGMAC cores
From:   David Miller <davem@davemloft.net>
In-Reply-To: <6279e35421e17256ac023227ec8cd5c8498d34d0.1565602974.git.joabreu@synopsys.com>
References: <cover.1565602974.git.joabreu@synopsys.com>
        <cover.1565602974.git.joabreu@synopsys.com>
        <6279e35421e17256ac023227ec8cd5c8498d34d0.1565602974.git.joabreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 12 Aug 2019 14:06:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Mon, 12 Aug 2019 11:44:03 +0200

> 	- Add performance info (David)

Ummm...

Whilst cpu utilization is interesting, I might be mainly interested in
how this effects "networking" performance.  I find it very surprising
that it isn't obvious that this is what I wanted.

Do you not do performance testing on the networking level when you
make fundamental changes to how packets are processed by the
hardware/driver?
