Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9227D139488
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 16:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729267AbgAMPNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 10:13:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:39932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbgAMPNy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 10:13:54 -0500
Received: from cakuba (unknown [172.58.35.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E949207E0;
        Mon, 13 Jan 2020 15:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578928434;
        bh=k37G7crg/rnM1OPMgaFjdTDn+Y4irTU6HvEVxVieUjM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2hwwdBpUxEHlF/MjAnrClMUvpSXE0hViNfyJbeItXwrJg/UYJfNs7k4g0NTGgL4qg
         oB47bgNla0FdArsPtX9RFkZtKktMmYBl6EAK5tKv6DMGQWLM3whpFWy2ndFngr58H1
         e/SiSW/FESxRge2qm/qM6l5ZH530SABcPO51G5uQ=
Date:   Mon, 13 Jan 2020 07:12:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     netdev@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/8] net: stmmac: tc: Add support for ETF
 Scheduler using TBS
Message-ID: <20200113071251.1d9d51f6@cakuba>
In-Reply-To: <4a4290706a9166d67d2d455dfa9d5f259699a036.1578920366.git.Jose.Abreu@synopsys.com>
References: <cover.1578920366.git.Jose.Abreu@synopsys.com>
        <4a4290706a9166d67d2d455dfa9d5f259699a036.1578920366.git.Jose.Abreu@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jan 2020 14:02:37 +0100, Jose Abreu wrote:
> +static int tc_setup_etf(struct stmmac_priv *priv,
> +			struct tc_etf_qopt_offload *qopt)
> +{
> +

There's a couple places I spotted where continuation lines are not
aligned to the opening parenthesis, and here we have a spurious blank
line. Please run this through checkpatch --strict, I see quite a few
legit errors there.
