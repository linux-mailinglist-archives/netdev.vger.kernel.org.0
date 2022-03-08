Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1314D2404
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 23:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344087AbiCHWML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 17:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiCHWML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 17:12:11 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E43947AEA;
        Tue,  8 Mar 2022 14:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646777473; x=1678313473;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kQ5srqxv0waYBab8nwYT1ubD1rarswGHiGwSxhd9OF8=;
  b=etZFsZ2Wig4gasV5YZAuGDzJyrEZmJC0VvZ7qosJ+W8piWzJQGk5/F0x
   3C9xmhSR2vcyZGu0x2TOnkiL7IbuwutMZAuPmevAsmkaduKlY/8JWriPW
   Q8M++YpWNDBtAWbfWW1tuFGXSPrU78nH8OGBPw9QfmZT0wLzdU8Uu+FEU
   2/tK8btvGLuHd5CwggHjFsi7xAYjVTLL+n4OHSJo7+ryp3tqc6ANbP0vK
   QNAOJ4JPsbCd6rFmYMO9O9/7Vlr4JALhs4xV2THFY0USlHeePUKWOPVkJ
   XYeOklkK2/CPtgkYjQFJz9RZFrrAGwAEb42bRV4ilwF4FBf/idJihLiku
   w==;
X-IronPort-AV: E=Sophos;i="5.90,165,1643698800"; 
   d="scan'208";a="165010573"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Mar 2022 15:11:12 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 8 Mar 2022 15:11:11 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 8 Mar 2022 15:11:11 -0700
Date:   Tue, 8 Mar 2022 23:14:04 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <Divya.Koppera@microchip.com>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <devicetree@vger.kernel.org>, <richardcochran@gmail.com>,
        <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <Madhuri.Sripada@microchip.com>, <Manohar.Puri@microchip.com>
Subject: Re: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Message-ID: <20220308221404.bwhujvsdp253t4g3@soft-dev3-1.localhost>
References: <20220304093418.31645-1-Divya.Koppera@microchip.com>
 <20220304093418.31645-3-Divya.Koppera@microchip.com>
 <YiILJ3tXs9Sba42B@lunn.ch>
 <CO1PR11MB4771237FE3F53EBE43B614F6E2089@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YiYD2kAFq5EZhU+q@lunn.ch>
 <CO1PR11MB4771F7C1819E033EC613E262E2099@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YidgHT8CLWrmhbTW@lunn.ch>
 <20220308154345.l4mk2oab4u5ydn5r@soft-dev3-1.localhost>
 <YiecBKGhVui1Gtb/@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <YiecBKGhVui1Gtb/@lunn.ch>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 03/08/2022 19:10, Andrew Lunn wrote:
> 
> > > So this is a function of the track length between the MAC and the PHY?
> >
> > Nope.
> > This latency represents the time it takes for the frame to travel from RJ45
> > module to the timestamping unit inside the PHY. To be more precisely,
> > the timestamping unit will do the timestamp when it detects the end of
> > the start of the frame. So it represents the time from when the frame
> > reaches the RJ45 to when the end of start of the frame reaches the
> > timestamping unit inside the PHY.
> 
> I must be missing something here. How do you measure the latency
> difference for a 1 meter cable vs a 100m cable?

In the same way because the end result will be the same.
Lets presume that the cable introduce a 5ns latency per meter.
So, if we use a 1m cable and the mean path delay is 11, then
the latency is 11 - 5.
If we use a 100m cable then the mean path delay will be 506(if is not
506 then is something wrong) then the latency is 506 - 500.

> Does 100m cable plus 1cm of track from the RJ45 to the PHY make a difference
> compared to 100m cable plus 1.5cm of track?

In that case I don't think you will see any difference.

> Isn't this error all just in the noise?

I am not sure I follow this question.

> 
>    Andrew

-- 
/Horatiu
