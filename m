Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB58839A4
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 21:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfHFT02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 15:26:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48612 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfHFT02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 15:26:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B72511555E86C;
        Tue,  6 Aug 2019 12:26:26 -0700 (PDT)
Date:   Tue, 06 Aug 2019 12:26:26 -0700 (PDT)
Message-Id: <20190806.122626.411533304373473992.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     netdev@vger.kernel.org, Joao.Pinto@synopsys.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        mcoquelin.stm32@gmail.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/3] net: stmmac: Fixes for -net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1565097294.git.joabreu@synopsys.com>
References: <cover.1565097294.git.joabreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Aug 2019 12:26:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Tue,  6 Aug 2019 15:16:15 +0200

> Couple of fixes for -net. More info in commit log.

Series applied, thank you.
