Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0660A5C69
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 20:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfIBSsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 14:48:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35610 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbfIBSsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 14:48:38 -0400
Received: from localhost (unknown [63.64.162.234])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 83D9C15401AF2;
        Mon,  2 Sep 2019 11:48:37 -0700 (PDT)
Date:   Mon, 02 Sep 2019 11:48:36 -0700 (PDT)
Message-Id: <20190902.114836.1043194833851564994.davem@davemloft.net>
To:     yzhai003@ucr.edu
Cc:     csong@cs.ucr.edu, zhiyunq@cs.ucr.edu, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, mripard@kernel.org,
        wens@csie.org, mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: dwmac-sun8i: Variable "val" in function
 sun8i_dwmac_set_syscon() could be uninitialized
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190831020049.6516-1-yzhai003@ucr.edu>
References: <20190831020049.6516-1-yzhai003@ucr.edu>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 02 Sep 2019 11:48:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yizhuo <yzhai003@ucr.edu>
Date: Fri, 30 Aug 2019 19:00:48 -0700

> In function sun8i_dwmac_set_syscon(), local variable "val" could
> be uninitialized if function regmap_field_read() returns -EINVAL.
> However, it will be used directly in the if statement, which
> is potentially unsafe.
> 
> Signed-off-by: Yizhuo <yzhai003@ucr.edu>

Applied, thank you.
