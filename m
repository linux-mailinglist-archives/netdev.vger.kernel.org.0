Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56F3B2829F
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 18:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731519AbfEWQSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 12:18:18 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48320 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730860AbfEWQSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 12:18:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EB6B81509B028;
        Thu, 23 May 2019 09:18:14 -0700 (PDT)
Date:   Thu, 23 May 2019 09:18:14 -0700 (PDT)
Message-Id: <20190523.091814.750814773629903183.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Joao.Pinto@synopsys.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, clabbe.montjoie@gmail.com, andrew@lunn.ch
Subject: Re: [PATCH net-next 00/18] net: stmmac: Improvements and Selftests
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190523.090928.974790678055823460.davem@davemloft.net>
References: <cover.1558596599.git.joabreu@synopsys.com>
        <20190523.090928.974790678055823460.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 May 2019 09:18:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 23 May 2019 09:09:28 -0700 (PDT)

> Series applied.

I'm reverting, this doesn't even build.

ERROR: "dev_set_rx_mode" [drivers/net/ethernet/stmicro/stmmac/stmmac.ko] undefined!
make[1]: *** [scripts/Makefile.modpost:91: __modpost] Error 1
make: *** [Makefile:1290: modules] Error 2

Always test your driver both modular and static when referencing new symbols.
