Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8596B125793
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 00:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfLRXQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 18:16:01 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57624 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfLRXQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 18:16:01 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 780EB153FF934;
        Wed, 18 Dec 2019 15:16:00 -0800 (PST)
Date:   Wed, 18 Dec 2019 15:15:59 -0800 (PST)
Message-Id: <20191218.151559.778932260429804628.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     netdev@vger.kernel.org, Joao.Pinto@synopsys.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        mcoquelin.stm32@gmail.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: stmmac: tc: Fix TAPRIO division operation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <b8ffd4685fac31a39ef5ba91485e685b21ead753.1576709577.git.Jose.Abreu@synopsys.com>
References: <b8ffd4685fac31a39ef5ba91485e685b21ead753.1576709577.git.Jose.Abreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Dec 2019 15:16:00 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Wed, 18 Dec 2019 23:55:01 +0100

> For ARCHs that don't support 64 bits division we need to use the
> helpers.
> 
> Fixes: b60189e0392f ("net: stmmac: Integrate EST with TAPRIO scheduler API")
> Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
> 
> ---
> Completely untested as my setup is offline due to power-outrage. Carefull
> review needed.

It looks correct to me and should fix the build, so applied, thanks.
