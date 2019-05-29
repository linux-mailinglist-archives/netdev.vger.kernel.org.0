Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42F4F2D68B
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 09:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfE2HkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 03:40:02 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:39686 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726057AbfE2HkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 03:40:01 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 305D0C263A;
        Wed, 29 May 2019 07:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1559115584; bh=u0bHvq09qbXFfPIAKp6YPrwchkqDTwxdAG0Y1BAOgdk=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=lkJyzDP25Iq5Bo1MkV7iN3kRiuFWrghtGGqU3Xu15XD6DGkmrZI7mPOucZQPcX281
         /3XhmhGqVJEOtctZctfG9bKvjGYFF3JZjyaURA28P+YVo1r5hEcZxhm571aN26dbrd
         qw+1xHh8xk+/Iz64V1t+Iqj+fdW8AWDQq/LMlpn3o6r89wsXuo9eCrZATweQ3EaPEH
         pPKdptPsTFlx/0EnN3fG/Fx9g6hG67rKjHFhuoM7Q7IvrV6VpTRqJidrxwHCvLZalE
         QWryRDqmQIzyaAghUme5LnU+WnwIYs4PyNZzjjHS0CIH7Lnr1C5DoRQ9cTFghvDj+M
         RQLMD2AF8w2DQ==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 74DCBA0070;
        Wed, 29 May 2019 07:39:52 +0000 (UTC)
Received: from DE02WEHTCA.internal.synopsys.com (10.225.19.92) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 29 May 2019 00:39:51 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCA.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Wed,
 29 May 2019 09:39:49 +0200
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Biao Huang <biao.huang@mediatek.com>
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
        "jianguo.zhang@mediatek.com" <jianguo.zhang@mediatek.com>,
        "boon.leong.ong@intel.com" <boon.leong.ong@intel.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: RE: [v4, PATCH] net: stmmac: add support for hash table size
 128/256 in dwmac4
Thread-Topic: [v4, PATCH] net: stmmac: add support for hash table size
 128/256 in dwmac4
Thread-Index: AQHVFb9bD/NyYV8x/ESH/6Rc+9wGiKaBtu5A
Date:   Wed, 29 May 2019 07:39:49 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B932F51@DE02WEMBXB.internal.synopsys.com>
References: <1559093924-7791-1-git-send-email-biao.huang@mediatek.com>
 <1559093924-7791-2-git-send-email-biao.huang@mediatek.com>
In-Reply-To: <1559093924-7791-2-git-send-email-biao.huang@mediatek.com>
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
Date: Wed, May 29, 2019 at 02:38:44

>  	} else if (!netdev_mc_empty(dev)) {
> -		u32 mc_filter[2];
> +		u32 mc_filter[8];
>  		struct netdev_hw_addr *ha;

The reverse christmas tree also applies here.

I also see some coding-style errors, like missing line breaks, etc...=20
that checkpatch should complain about.

Also, please run this patch against stmmac selftests and add the output=20
to the commit log.

Thanks,
Jose Miguel Abreu
