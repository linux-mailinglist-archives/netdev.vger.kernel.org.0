Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC4AFA9F7C
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 12:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732408AbfIEKUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 06:20:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44208 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbfIEKUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 06:20:15 -0400
Received: from localhost (unknown [89.248.140.11])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B424C153878EE;
        Thu,  5 Sep 2019 03:20:12 -0700 (PDT)
Date:   Thu, 05 Sep 2019 12:20:10 +0200 (CEST)
Message-Id: <20190905.122010.1750302920131764544.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     netdev@vger.kernel.org, Joao.Pinto@synopsys.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        mcoquelin.stm32@gmail.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 00/13] net: stmmac: Improvements for -next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1567602867.git.joabreu@synopsys.com>
References: <cover.1567602867.git.joabreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Sep 2019 03:20:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Wed,  4 Sep 2019 15:16:52 +0200

> Couple of improvements for -next tree. More info in commit logs.

Series applied, thank you.
