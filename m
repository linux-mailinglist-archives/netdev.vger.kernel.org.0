Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 883E31828B9
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 07:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387862AbgCLGFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 02:05:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56050 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387767AbgCLGFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 02:05:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2E28214CD0E6D;
        Wed, 11 Mar 2020 23:05:16 -0700 (PDT)
Date:   Wed, 11 Mar 2020 23:05:15 -0700 (PDT)
Message-Id: <20200311.230515.1148233734946906259.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     netdev@vger.kernel.org, Joao.Pinto@synopsys.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        mcoquelin.stm32@gmail.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: stmmac: selftests: Fix L3/L4 Filtering
 test
From:   David Miller <davem@davemloft.net>
In-Reply-To: <4e5d8d273498a1c1c6b8f983e5dd7590c6dfd26a.1583760590.git.Jose.Abreu@synopsys.com>
References: <4e5d8d273498a1c1c6b8f983e5dd7590c6dfd26a.1583760590.git.Jose.Abreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Mar 2020 23:05:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Mon,  9 Mar 2020 14:30:22 +0100

> Since commit 319a1d19471e, stmmac only support basic HW stats type for
> action. Set this field in the L3/L4 Filtering test so that it correctly
> setups the filter instead of returning EOPNOTSUPP.
> 
> Fixes: 319a1d19471e ("flow_offload: check for basic action hw stats type")
> Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

Applied, thanks.
