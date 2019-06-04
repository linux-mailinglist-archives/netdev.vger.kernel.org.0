Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF9D349C8
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 16:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbfFDOJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 10:09:11 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:54730 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727137AbfFDOJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 10:09:10 -0400
Received: from mailhost.synopsys.com (dc2-mailhost1.synopsys.com [10.12.135.161])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 2C084C1E9B;
        Tue,  4 Jun 2019 14:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1559657360; bh=CNaripZJWBBGgHfQPfeFqx/UkaowmltCstrxiqbgyLI=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=PtFB4f60CQpa1hgnxV0AX7d6PikBrH2M3jt4W9ntxHV6RiAtd4igEBX6KBTFO8o9G
         gjSjzUOdycc3Bes/ioNwt7SSa5DswK0liG5LpBtZ8EgAM8OKDXN5PNeSwgElYr79ZH
         qq+1eeuOVCx86aWwi57uyd42dfQzhRC/h+TQGm+qu6/OdzOC/n2c/PHDLG5B/pjH9F
         cLmNKSsaPRtiE+YKU81JTDzpMoug91EgjFdbKoZ+Kf19MsWNhG0u9elSBvFfbMlcRz
         TMGoJa44KC1wgYdUZuNAjAFodJ/57UlAAe1W5g2AseTQtgyPxFM5Dh8vmwbzI4aLfp
         6YaVWHGZE/SxQ==
Received: from us01wehtc1.internal.synopsys.com (us01wehtc1-vip.internal.synopsys.com [10.12.239.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 3D452A009B;
        Tue,  4 Jun 2019 14:09:08 +0000 (UTC)
Received: from DE02WEHTCB.internal.synopsys.com (10.225.19.94) by
 us01wehtc1.internal.synopsys.com (10.12.239.231) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 4 Jun 2019 07:09:07 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCB.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Tue,
 4 Jun 2019 16:09:05 +0200
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Voon Weifeng <weifeng.voon@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        biao huang <biao.huang@mediatek.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>
Subject: RE: [PATCH net-next v6 0/5] net: stmmac: enable EHL SGMII
Thread-Topic: [PATCH net-next v6 0/5] net: stmmac: enable EHL SGMII
Thread-Index: AQHVGsR25h4NaxykoEO+uo0c6U7qv6aLiCVA
Date:   Tue, 4 Jun 2019 14:09:04 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B93D72D@DE02WEMBXB.internal.synopsys.com>
References: <1559674736-2190-1-git-send-email-weifeng.voon@intel.com>
In-Reply-To: <1559674736-2190-1-git-send-email-weifeng.voon@intel.com>
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

From: Voon Weifeng <weifeng.voon@intel.com>

> This patch-set is to enable Ethernet controller
> (DW Ethernet QoS and DW Ethernet PCS) with SGMII interface in Elkhart Lak=
e.
> The DW Ethernet PCS is the Physical Coding Sublayer that is between Ether=
net
> MAC and PHY and uses MDIO Clause-45 as Communication.
>=20
> Selttests results:
> root@intel-corei7-64:~# ethtool -t eth0
> The test result is PASS
> The test extra info:
>  1. MAC Loopback                 0
>  2. PHY Loopback                 -95
>  3. MMC Counters                 0
>  4. EEE                          -95
>  5. Hash Filter MC               0
>  6. Perfect Filter UC            0
>  7. MC Filter                    0
>  8. UC Filter                    0
>  9. Flow Control                 0

Thanks for testing and addressing all review comments!

Acked-by: Jose Abreu <joabreu@synopsys.com>

Thanks,
Jose Miguel=20
Abreu
