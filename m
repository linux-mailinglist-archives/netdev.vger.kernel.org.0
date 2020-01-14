Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 083BA139FF0
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 04:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbgAND0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 22:26:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:57018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728802AbgAND0r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 22:26:47 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 299BA20CC7;
        Tue, 14 Jan 2020 03:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578972406;
        bh=K6QwoHZlKmBhi1HwYzE/vZ5jsixqOCwKPUF803F9Qxs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MOw/5NOJp9s0xnIQVt2/sEGGKIeo0Cyb1YDjbXSSkAiEBe36usdVrXv9v3vNsWHdp
         Lo9S42pGO0Awd1ZGkPJB02wF0w5FsKBNHdK5lR8g6TZWLQMD5lfU9992QlV/pbCxKP
         mtIW0MgAAVFt/IeLYY26xiacHbP42MkmI5ulPG38=
Date:   Mon, 13 Jan 2020 19:26:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     netdev@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/8] net: stmmac: ETF support
Message-ID: <20200113192645.6b9f51d1@cakuba>
In-Reply-To: <cover.1578932287.git.Jose.Abreu@synopsys.com>
References: <cover.1578932287.git.Jose.Abreu@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jan 2020 17:24:08 +0100, Jose Abreu wrote:
> This series adds the support for ETF scheduler in stmmac.
> 
> 1) Starts adding the support by implementing Enhanced Descriptors in stmmac
> main core. This is needed for ETF feature in XGMAC and QoS cores.
> 
> 2) Integrates the ETF logic into stmmac TC core.
> 
> 3) and 4) adds the HW specific support for ETF in XGMAC and QoS cores. The
> IP feature is called TBS (Time Based Scheduling).
> 
> 5) Enables ETF in GMAC5 IPK PCI entry for all Queues except Queue 0.
> 
> 6) Adds the new TBS feature and even more information into the debugFS
> HW features file.
> 
> 7) Switches the selftests mechanism to use dev_direct_xmit() so that we can
> send packets on specific Queues.
> 
> 8) Adds a new test for TBS feature.

Applied, thank you!
