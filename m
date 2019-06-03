Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99F7C32F0C
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 13:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbfFCLyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 07:54:55 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:53880 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726179AbfFCLyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 07:54:54 -0400
Received: from mailhost.synopsys.com (dc8-mailhost1.synopsys.com [10.13.135.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 09F15C0F0B;
        Mon,  3 Jun 2019 11:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1559562904; bh=r4F0ihdo90nt+TZrX0NaFOaU7SRXp0rSHZgAJyLypIg=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=g5AtdTJSN9Ura/m/klQbwSDCS6KTURAL+Ol7PwSZKKCcfmKkEiABjanli89IehNiO
         IjLIxlp2ffmVLIXMMeUFePOchbuJtCZ3p13O/RssbN5vMsBk+ey7iEBYPm95czffYJ
         tZ/8zU0amp7UykIQpGNPsK8GUNTzR1A1PKbGxqhSUdPND2vdxtKrz1E9Ek/muG/Q52
         u5R6p1U/JMpFE1tsmsVzZNvvK5hgFeK0FKku0K0Ine+8viVmxJatR6zJdFk06dgCtU
         fDdYyI44Ug7UFzAVi6aqgVrgd0E/pEJsQZ2ebHJEfHdPKintsEWLdChTA/6NgAjg0T
         LLQEC0XeMDODQ==
Received: from US01WXQAHTC1.internal.synopsys.com (us01wxqahtc1.internal.synopsys.com [10.12.238.230])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 41C56A005D;
        Mon,  3 Jun 2019 11:54:49 +0000 (UTC)
Received: from DE02WEHTCB.internal.synopsys.com (10.225.19.94) by
 US01WXQAHTC1.internal.synopsys.com (10.12.238.230) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 3 Jun 2019 04:54:49 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCB.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Mon,
 3 Jun 2019 13:54:47 +0200
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
Subject: RE: [PATCH net-next v5 0/5] net: stmmac: enable EHL SGMI
Thread-Topic: [PATCH net-next v5 0/5] net: stmmac: enable EHL SGMI
Thread-Index: AQHVF6gSDQlnqXi+Gkq6toMYkgpK1aaJ1UvQ
Date:   Mon, 3 Jun 2019 11:54:46 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B93B791@DE02WEMBXB.internal.synopsys.com>
References: <1559332694-6354-1-git-send-email-weifeng.voon@intel.com>
In-Reply-To: <1559332694-6354-1-git-send-email-weifeng.voon@intel.com>
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

This series look fine to me but unfortunately I don't have my GMAC5.10=20
setup available to test for regressions ... The changes look isolated=20
though.

Could you please run the stmmac selftests at least and add the output=20
here ?

Thanks,
Jose Miguel Abreu
