Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7197FE3E7
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 15:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbfD2NpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 09:45:00 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:36654 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725838AbfD2NpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 09:45:00 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id C3891C00C7;
        Mon, 29 Apr 2019 13:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1556545497; bh=KFEGEBvc2AV2G1HibQZsWwJ5igLQZzg0nEiClSfL5jw=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=TqMoLK/Dm8I9AH4ZobnzVJoyE5b13wyfv3pwZEMumuCuuFMr1Zdr4+oicb9Q4y4Mi
         D7yMGG4UstHCJAuuF+3W1QBuYe0x6jlnti/pyVKJN37Xy2/FqlUBZEmW9s2+waqYWU
         LPl4sCAWoyIpsyJoN39JsCqtrGb2Qiv6uWPF1C+S+QXqJFyfjoLsjOFTLPyRNbpLPC
         jG4V4r5a37GRJ3ZwjiNTOSoBUMsHijXBrBEQNR0HP9SdsRG0xS5OJUdQxRD4vyCgym
         aErimVjsElxcowsxtjp6lm9kdSCw8TioGZqmaYIrsXtCQdDXjFL4+B+K7LxBs471xB
         5LxTTNJYqv+bQ==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 3FFC0A0066;
        Mon, 29 Apr 2019 13:44:58 +0000 (UTC)
Received: from DE02WEHTCB.internal.synopsys.com (10.225.19.94) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 29 Apr 2019 06:44:58 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCB.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Mon,
 29 Apr 2019 15:44:57 +0200
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
CC:     "Voon, Weifeng" <weifeng.voon@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: RE: [PATCH 0/7] net: stmmac: enable EHL SGMII
Thread-Topic: [PATCH 0/7] net: stmmac: enable EHL SGMII
Thread-Index: AQHU+n6UM7GU7OtY/UWKCWYebuRSxqZLMmUAgAEn3oCAAFapgIAAIdQAgAAMagCABaWxAIAAfmcAgAAqzmA=
Date:   Mon, 29 Apr 2019 13:44:56 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B46E367@DE02WEMBXB.internal.synopsys.com>
References: <1556126241-2774-1-git-send-email-weifeng.voon@intel.com>
 <20190424134854.GP28405@lunn.ch>
 <D6759987A7968C4889FDA6FA91D5CBC8146EF128@PGSMSX103.gar.corp.intel.com>
 <20190425123801.GD8117@lunn.ch>
 <AF233D1473C1364ABD51D28909A1B1B75C0B205D@pgsmsx114.gar.corp.intel.com>
 <20190425152332.GD23779@lunn.ch>
 <AF233D1473C1364ABD51D28909A1B1B75C0B8B35@pgsmsx114.gar.corp.intel.com>
 <20190429131016.GE10772@lunn.ch>
In-Reply-To: <20190429131016.GE10772@lunn.ch>
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

From: Andrew Lunn <andrew@lunn.ch>
Date: Mon, Apr 29, 2019 at 14:10:16

> Yes, if all i can do is SGMII, hard coding SGMII is fine. But you
> should probably check phy-mode and return an error if it has a value
> other than SGMII,

+1 because XPCS supports 1000Base-X but it seems this SoC doesn't.

Thanks,
Jose Miguel Abreu
