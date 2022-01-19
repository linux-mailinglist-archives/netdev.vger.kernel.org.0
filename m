Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05AF6493204
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 01:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350521AbiASAu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 19:50:27 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46548 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235175AbiASAu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 19:50:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5AD9614DC;
        Wed, 19 Jan 2022 00:50:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBE3C340E1;
        Wed, 19 Jan 2022 00:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642553425;
        bh=rzO5UClAJ3SgAR+tlxDdn1utdFlHQ8c52OzM8K1Blh0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i0VFhWRbucfzzWOLnwMiyXceFpLNJu8zn1n8IJf9/k589VWScde+1tXEItnP+iUKx
         tyFeFy5+IwGNpfuUzYBgJqBb7SvYbwDVt+ZfbPAcgWRh2akY2/3wb+xhcFEomKtnFV
         YIfLQxwFFvl70xW3rEwp8W/84PFfPUjMIfnd4kJ/6e7Td2QKct2CFsbWqSwN2MLAF6
         NqSi60/nDtNfJ1fkUdJyLBOCbemDO+gvOcLTONSwLLRs8fX4Xe0K1Q/WVLRYksMdPF
         S8MZ7PeCeXPCu16bK1wFdSM+uB2kffEZh9ubPCuROv7h0+jTSQB3GBSOVQh7ELub3D
         xfWBl8MhGAnQQ==
Date:   Tue, 18 Jan 2022 16:50:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nobuhiro1.iwamatsu@toshiba.co.jp
Subject: Re: [PATCH 0/2] net: stmmac: dwmac-visconti: Fix bit definitions
 and clock configuration for RMII mode
Message-ID: <20220118165023.559dfe3b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220118053950.2605-1-yuji2.ishikawa@toshiba.co.jp>
References: <20220118053950.2605-1-yuji2.ishikawa@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Jan 2022 14:39:48 +0900 Yuji Ishikawa wrote:
> This series is a fix for RMII/MII operation mode of the dwmac-visconti driver.
> It is composed of two parts:
> 
> * 1/2: fix constant definitions for cleared bits in ETHER_CLK_SEL register
> * 2/2: fix configuration of ETHER_CLK_SEL register for running in RMII operation mode.

Please add appropriate Fixes tag pointing to the commits where the
buggy code was introduced, even if it's the initial commit adding 
the driver.
