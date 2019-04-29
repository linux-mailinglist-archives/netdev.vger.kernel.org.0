Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70298DE95
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 11:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbfD2JBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 05:01:02 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:50178 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727560AbfD2JBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 05:01:02 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 8D1C3C00B0;
        Mon, 29 Apr 2019 09:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1556528460; bh=f+Cu/athXgOTZCGbWOkD1x70otBzc7nrCuSU1nPo2XY=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=ETWv8pqP/VDfCRlvwlPl6QM4T+AXFjYWarpa2e2JcO6fVTn9lVI2T2l/L5OM7f11p
         ha7P7e4QLjFqxjLUUSqvXbTeqXMc7M5jpW+91mVRhZgjvK74P4F0gOFai2p6XWYkzA
         CW1JwjzrltvOXd5mlhRvKxbtciEqkBClo4TNeDYirq/qPzFVQ4OhZzXo9FvBOWBSbw
         xZYMVLPuo0csKLsibII5U7qCLZEis4K4E1gWyb3cElcsReR7FQoCMOY0bFekXLK2sa
         ESuTklDQp3FrxSv9LLeZFAoY1y6rOaEQ5n+SDhe9DP1lNvHU/GgvZ2VbKFY7hCzJQd
         6832nLyvCB99Q==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id D0F87A0066;
        Mon, 29 Apr 2019 09:00:55 +0000 (UTC)
Received: from DE02WEHTCA.internal.synopsys.com (10.225.19.92) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 29 Apr 2019 02:00:55 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCA.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Mon,
 29 Apr 2019 11:00:53 +0200
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Biao Huang <biao.huang@mediatek.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "yt.shen@mediatek.com" <yt.shen@mediatek.com>,
        "jianguo.zhang@mediatek.com" <jianguo.zhang@mediatek.com>
Subject: RE: [PATCH 1/2] net-next: stmmac: add support for hash table size
 128/256 in dwmac4
Thread-Topic: [PATCH 1/2] net-next: stmmac: add support for hash table size
 128/256 in dwmac4
Thread-Index: AQHU/lXC7igBXFx5K0O3QkQ2RyP1CKZS1qXA
Date:   Mon, 29 Apr 2019 09:00:53 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B46DE20@DE02WEMBXB.internal.synopsys.com>
References: <1556519724-1576-1-git-send-email-biao.huang@mediatek.com>
 <1556519724-1576-2-git-send-email-biao.huang@mediatek.com>
In-Reply-To: <1556519724-1576-2-git-send-email-biao.huang@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.107.19.176]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Biao Huang <biao.huang@mediatek.com>
Date: Mon, Apr 29, 2019 at 07:35:23

> +#define GMAC_HASH_TAB(x)		(0x10 + x * 4)

You need to guard x here with parenthesis.

>  	void __iomem *ioaddr =3D (void __iomem *)dev->base_addr;
> -	unsigned int value =3D 0;
> +	unsigned int value;
> +	int i;
> +	int numhashregs =3D (hw->multicast_filter_bins >> 5);
> +	int mcbitslog2 =3D hw->mcast_bits_log2;

Reverse Christmas tree order here please.

Thanks,
Jose Miguel Abreu
