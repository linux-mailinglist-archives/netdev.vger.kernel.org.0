Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6702DACF
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 12:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfE2Ka7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 06:30:59 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:42298 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725990AbfE2Ka6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 06:30:58 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id ABC78C0B59;
        Wed, 29 May 2019 10:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1559125866; bh=L/zcOt3uTfx3QhugJlownAMFQSm3dP+6sx2sVmiAnyQ=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=OfcezbJfSbiSnMClNxogVHod+fr2745De2QQ7yOrncJNWbJ4Kr7y50mxqm6okcCs/
         Si0HOCdbJBNGEzsuQUYrUt4C9vmhQ9K7tdaf1g3GBjpoJ2F/i0IXtouSu0mokP22ry
         sB0FBWiv6mm25LRF6Toev9LeuvfoW1/Kj/SJyUYQ0YUCNVha/M7+cK0FsXJjDrJ5gV
         ArF+B4G5fLTtD6CsqGcK4Z3lDZlw/8YGGL5IS4oKxnM8/xqW+v2AkcA34F2gWMJ45b
         4BeKIsRZdmUNzlOCTqRAHcoWQ6SOgtOJaNEhU3/EAmBdm+eBbWLySxOkGrXS2nozbR
         kpofpnVlRFBSQ==
Received: from US01WXQAHTC1.internal.synopsys.com (us01wxqahtc1.internal.synopsys.com [10.12.238.230])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 55124A00A3;
        Wed, 29 May 2019 10:30:49 +0000 (UTC)
Received: from DE02WEHTCA.internal.synopsys.com (10.225.19.92) by
 US01WXQAHTC1.internal.synopsys.com (10.12.238.230) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 29 May 2019 03:30:49 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCA.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Wed,
 29 May 2019 12:30:47 +0200
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
Subject: RE: [v5, PATCH] net: stmmac: add support for hash table size
 128/256 in dwmac4
Thread-Topic: [v5, PATCH] net: stmmac: add support for hash table size
 128/256 in dwmac4
Thread-Index: AQHVFgFMgnlWoV6tbES+hcM7ZfkqbqaB5uaw
Date:   Wed, 29 May 2019 10:30:46 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B9334CE@DE02WEMBXB.internal.synopsys.com>
References: <1559122268-22545-1-git-send-email-biao.huang@mediatek.com>
 <1559122268-22545-2-git-send-email-biao.huang@mediatek.com>
In-Reply-To: <1559122268-22545-2-git-send-email-biao.huang@mediatek.com>
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
Date: Wed, May 29, 2019 at 10:31:08

> 1. get hash table size in hw feature reigster, and add support
> for taller hash table(128/256) in dwmac4.
> 2. only clear GMAC_PACKET_FILTER bits used in this function,
> to avoid side effect to functions of other bits.
>=20
> stmmac selftests output log:
> 	ethtool -t eth0
> 	The test result is FAIL
> 	The test extra info:
> 	 1. MAC Loopback                 0
> 	 2. PHY Loopback                 -95
> 	 3. MMC Counters                 0
> 	 4. EEE                          -95
> 	 5. Hash Filter MC               0
> 	 6. Perfect Filter UC            0
> 	 7. MC Filter                    0
> 	 8. UC Filter                    0
> 	 9. Flow Control                 1

Thanks for testing, this patch looks good to me.

Do you want to check why Flow Control selftest is failing ?


Thanks,
Jose Miguel Abreu
