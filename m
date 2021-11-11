Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B5944D7DD
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 15:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbhKKOMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 09:12:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:52740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232630AbhKKOMS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 09:12:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58C1A6112F;
        Thu, 11 Nov 2021 14:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636639769;
        bh=INsr49FrzcAlX2qg8VY1JXPInfTECovEwdq1XERk4J4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DkBsgkyzCfeJ2oZuICgrZBz1HLI/zUQkqhlF3m90v9krliSeGkzlUMTeoWkjiInnU
         ywnyt8BCfPmE8Rx2xmo7YqqiTf9VcdU/ZO4gVlwWQGdyPN43q/W62yWApqN3P9Upe6
         obzQk3c7+qyT78IyeIRBssfu1ukW783VaIFD9bRiC/6zkMv/gr9xIT+qOkQWaqEHEs
         DcuN98IGPEsoqxgftWCCSP/c14zfCe08VObUGGGx48D+Y3eCUHYGbfapRKWRYlfgO3
         lRc9Ez52peqY/e7c/7T1F+jykc1pkvuvW5W/Lpw8JiVlq8h2WJXg3svuYDx104AH3E
         GFM7xFH7KifyA==
Date:   Thu, 11 Nov 2021 06:09:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Meng Li <Meng.Li@windriver.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: socfpga: add runtime suspend/resume
 callback for stratix10 platform
Message-ID: <20211111060928.666f00e1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211111135630.24996-1-Meng.Li@windriver.com>
References: <20211111135630.24996-1-Meng.Li@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Nov 2021 21:56:30 +0800 Meng Li wrote:
> +const struct dev_pm_ops socfpga_dwmac_pm_ops = {

static
