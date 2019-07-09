Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69CEF63BCE
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 21:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfGITU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 15:20:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44266 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfGITU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 15:20:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3E07D1403896D;
        Tue,  9 Jul 2019 12:20:28 -0700 (PDT)
Date:   Tue, 09 Jul 2019 12:20:27 -0700 (PDT)
Message-Id: <20190709.122027.77005575861873161.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     netdev@vger.kernel.org, Joao.Pinto@synopsys.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        mcoquelin.stm32@gmail.com, maxime.ripard@bootlin.com,
        wens@csie.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 0/3] net: stmmac: Some improvements and a
 fix
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1562659012.git.joabreu@synopsys.com>
References: <cover.1562659012.git.joabreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Jul 2019 12:20:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Tue,  9 Jul 2019 10:02:57 +0200

> Some performace improvements (01/03 and 03/03) and a fix (02/03),
> all for -next.

Series applied, thanks Jose.
