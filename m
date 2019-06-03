Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05DFE32ED4
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 13:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbfFCLks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 07:40:48 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:36000 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726798AbfFCLks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 07:40:48 -0400
Received: from mailhost.synopsys.com (dc8-mailhost2.synopsys.com [10.13.135.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 30711C1E73;
        Mon,  3 Jun 2019 11:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1559562028; bh=JNgLsT7LPunYfej4pP5aCroqrdhvEaNr8asK8r1HI7Y=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=QnpyQMXRrAFzeVwuPSVQX9syBt+Hb02uRHs7Fs7uKpQolYd8MaUOTYFEKb3Tvkqt9
         ryS1+FR7+e8qYxHQFmZexwW9ROZau/gsFbKRW8YZxLn2JNuZh0RFRNvE3Kww/Cahjm
         /VUoCFFnV/yofaYRK2uhyZ+RJ7lRutTQ9dWPb1YmY7UW8cmdF60WTBv9hcvoxI4Aa1
         tw6oUYRs/E7Xfe8+LHapSeLdJuzhzEiI2BZQ0K/HHKSB/fX0xsfVFNPqGQUdZIPVMS
         dbyLdu/ckJRdYQAGzW7p+A4V8h3eT/bTrRTjx0LBuOmQ6nw2vvbDvdGQ7gKWFrOtEn
         NrO2YR068NpfA==
Received: from us01wehtc1.internal.synopsys.com (us01wehtc1-vip.internal.synopsys.com [10.12.239.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 87BABA0067;
        Mon,  3 Jun 2019 11:40:40 +0000 (UTC)
Received: from DE02WEHTCA.internal.synopsys.com (10.225.19.92) by
 us01wehtc1.internal.synopsys.com (10.12.239.231) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 3 Jun 2019 04:40:40 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCA.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Mon,
 3 Jun 2019 13:40:37 +0200
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Biao Huang <biao.huang@mediatek.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>
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
        "boon.leong.ong@intel.com" <boon.leong.ong@intel.com>
Subject: RE: [v2, PATCH 3/4] net: stmmac: modify default value of tx-frames
Thread-Topic: [v2, PATCH 3/4] net: stmmac: modify default value of tx-frames
Thread-Index: AQHVGa/XGYfQ4t70BkaeZd4pZlVHSKaJzoyA
Date:   Mon, 3 Jun 2019 11:40:37 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B93B6DF@DE02WEMBXB.internal.synopsys.com>
References: <1559527086-7227-1-git-send-email-biao.huang@mediatek.com>
 <1559527086-7227-4-git-send-email-biao.huang@mediatek.com>
In-Reply-To: <1559527086-7227-4-git-send-email-biao.huang@mediatek.com>
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

> the default value of tx-frames is 25, it's too late when
> passing tstamp to stack, then the ptp4l will fail:
>=20
> ptp4l -i eth0 -f gPTP.cfg -m
> ptp4l: selected /dev/ptp0 as PTP clock
> ptp4l: port 1: INITIALIZING to LISTENING on INITIALIZE
> ptp4l: port 0: INITIALIZING to LISTENING on INITIALIZE
> ptp4l: port 1: link up
> ptp4l: timed out while polling for tx timestamp
> ptp4l: increasing tx_timestamp_timeout may correct this issue,
>        but it is likely caused by a driver bug
> ptp4l: port 1: send peer delay response failed
> ptp4l: port 1: LISTENING to FAULTY on FAULT_DETECTED (FT_UNSPECIFIED)
>=20
> ptp4l tests pass when changing the tx-frames from 25 to 1 with
> ethtool -C option.
> It should be fine to set tx-frames default value to 1, so ptp4l will pass
> by default.

I'm not sure if this is the right approach ... What's the timeout value=20
you have for TX Timestamp ?

Thanks,
Jose Miguel Abreu
