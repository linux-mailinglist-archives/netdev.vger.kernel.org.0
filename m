Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFD4DBDD8A
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 13:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732148AbfIYL6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 07:58:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34866 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbfIYL6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 07:58:45 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7CF65154ECABF;
        Wed, 25 Sep 2019 04:58:42 -0700 (PDT)
Date:   Wed, 25 Sep 2019 13:58:41 +0200 (CEST)
Message-Id: <20190925.135841.865526139564943830.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     netdev@vger.kernel.org, Joao.Pinto@synopsys.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        mcoquelin.stm32@gmail.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: stmmac: selftests: Flow Control test can
 also run with ASYM Pause
From:   David Miller <davem@davemloft.net>
In-Reply-To: <efc49b6ea500115ff1442ddebe9dc7d956eb19e9.1569224900.git.Jose.Abreu@synopsys.com>
References: <efc49b6ea500115ff1442ddebe9dc7d956eb19e9.1569224900.git.Jose.Abreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Sep 2019 04:58:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Mon, 23 Sep 2019 09:49:08 +0200

> The Flow Control selftest is also available with ASYM Pause. Lets add
> this check to the test and fix eventual false positive failures.
> 
> Fixes: 091810dbded9 ("net: stmmac: Introduce selftests support")
> Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

Applied.
