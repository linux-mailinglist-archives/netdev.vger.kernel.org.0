Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73DA417E028
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 13:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgCIMZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 08:25:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgCIMZD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 08:25:03 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2921E20828;
        Mon,  9 Mar 2020 12:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583756703;
        bh=D8K98eEMrO/fabIW+dg5uOZeVp6gPEd7yCkmVuGM7ec=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=KvjlKBD2IIvGErKam0vR1X6fEkTmY907A/Raolb0Lhh469x6mOxdNamstWMKKR80v
         MQ0XX74xfAQ/etxpDw8XlsaCs/8ykFg44mbzfQRSjP+y1amuO2SF4eOuQBaBmcDJh3
         nIFap8PNdYI4lauVwG8hzB69FSWmZ/c/vuIY+Pyo=
Date:   Mon, 09 Mar 2020 12:25:02 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Remi Pommarel <repk@triplefau.lt>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2] net: stmmac: dwmac1000: Disable ACS if enhanced descs are not used
In-Reply-To: <20200308092556.23881-1-repk@triplefau.lt>
References: <20200308092556.23881-1-repk@triplefau.lt>
Message-Id: <20200309122503.2921E20828@mail.kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 47dd7a540b8a ("net: add support for STMicroelectronics Ethernet controllers.").

The bot has tested the following trees: v5.5.8, v5.4.24, v4.19.108, v4.14.172, v4.9.215, v4.4.215.

v5.5.8: Build OK!
v5.4.24: Build OK!
v4.19.108: Build OK!
v4.14.172: Build failed! Errors:
    drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c:48:35: error: dereferencing pointer to incomplete type ‘struct stmmac_priv’

v4.9.215: Failed to apply! Possible dependencies:
    270c7759fbbc ("net: stmmac: add set_mac to the stmmac_ops")
    8cad443eacf6 ("net: stmmac: Fix reception of Broadcom switches tags")
    9f93ac8d4085 ("net-next: stmmac: Add dwmac-sun8i")
    d8256121a91a ("stmmac: adding new glue driver dwmac-dwc-qos-eth")

v4.4.215: Failed to apply! Possible dependencies:
    0e80bdc9a72d ("stmmac: first frame prep at the end of xmit routine")
    270c7759fbbc ("net: stmmac: add set_mac to the stmmac_ops")
    293e4365a1ad ("stmmac: change descriptor layout")
    2a6d8e172639 ("stmmac: add last_segment field to dma data")
    477286b53f55 ("stmmac: add GMAC4 core support")
    553e2ab3130e ("stmmac: add length field to dma data")
    753a71090f33 ("stmmac: add descriptors function for GMAC 4.xx")
    8cad443eacf6 ("net: stmmac: Fix reception of Broadcom switches tags")
    be434d5075d6 ("stmmac: optimize tx desc management")
    c1fa3212be55 ("stmmac: merge get_rx_owner into rx_status routine.")
    d0225e7de622 ("stmmac: rework the routines to show the ring status")
    e3ad57c96715 ("stmmac: review RX/TX ring management")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
