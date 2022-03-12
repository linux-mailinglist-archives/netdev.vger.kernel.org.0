Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22EE4D708F
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 20:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbiCLThc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 14:37:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiCLTha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 14:37:30 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C7B1E5A41;
        Sat, 12 Mar 2022 11:36:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647113782; x=1678649782;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Lz8K0dUPGpc/1uRH8Zcl398VD5Ti2+GvTusojZY7Lz4=;
  b=Sy5WXcuPH/cSFTiY8y9kgo5US3JfEsKk7SVf/oTzFSqedIEaS90BZ4FF
   FBerzNS5+gYtpTeBFnQP5PpSsL/10IeBvN3f5sWZJgTFJ1Rn2J/jlwN4+
   1vyYldLpGPZ+yRuozbKM8twfUMxM/6xQ+kufokK6nxA0jh4gfi/Je7m07
   08WeVP8yhj3+aWsDHSkpyVXzPRSyziY8WhHXSoY0AyhmL0ggIEdOqqeAf
   nvhbMvzCR9qwPseAulf/zs6cQwQRhJ2X6vsNrnZ3yLWvz7ZKOwRfMXF9X
   15wPFSyw1Wd80N/AZIK7E52r60JYY7aAiiHHWIlLCUlPCvImWTeTmJpIW
   g==;
X-IronPort-AV: E=Sophos;i="5.90,177,1643698800"; 
   d="scan'208";a="165542644"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Mar 2022 12:36:21 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 12 Mar 2022 12:36:21 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Sat, 12 Mar 2022 12:36:21 -0700
Date:   Sat, 12 Mar 2022 20:36:20 +0100
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, <Divya.Koppera@microchip.com>,
        <netdev@vger.kernel.org>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <Madhuri.Sripada@microchip.com>,
        <Manohar.Puri@microchip.com>
Subject: Re: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Message-ID: <20220312193620.owhfd43dzzxtytgs@den-dk-m31684h>
References: <YidgHT8CLWrmhbTW@lunn.ch>
 <20220308154345.l4mk2oab4u5ydn5r@soft-dev3-1.localhost>
 <YiecBKGhVui1Gtb/@lunn.ch>
 <20220308221404.bwhujvsdp253t4g3@soft-dev3-1.localhost>
 <YifoltDp4/Fs+9op@lunn.ch>
 <20220309132443.axyzcsc5kyb26su4@soft-dev3-1.localhost>
 <Yii/9RH67BEjNtLM@shell.armlinux.org.uk>
 <20220309195252.GB9663@hoboy.vegasvil.org>
 <20220311142814.z3h5nystnrkvbzek@soft-dev3-1.localhost>
 <20220311150842.GC7817@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220311150842.GC7817@hoboy.vegasvil.org>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

On Fri, Mar 11, 2022 at 07:08:42AM -0800, Richard Cochran wrote:
> On Fri, Mar 11, 2022 at 03:28:14PM +0100, Horatiu Vultur wrote:
> 
> > What about adding only some sane values in the driver like here [1].
> > And the allow the user to use linuxptp to fine tune all this.
> 
> I mean, that is the point.  Users will surely have to tune it
> themselves, second guessing the driver in any case.  So having hard
> coded constants in the driver is useless.
> 
> Probably even the tuned values will differ by link speed, so having
> the per-link speed constants in the driver doesn't help either.
> 
> (And yes, linuxptp should offer configuration variables per link
> speed, monitor actual link speed, and switch automatically.  So far no
> one is demanding that loudly)

I did skim through the articles, and as you hinted he does find small
latency differences across different packets. (but as I understood, very
few PHYs was tested).

Also, I know that we (Vitesse -> Microsemi -> Microchip) have been
offering ways to calibrate the individual PHYs in other PTP-SW products.
So, this makes good sense.

With this in mind, I do agree with you that it does not make much sense
to compensate they few cm of PCB tracks without also calibrating for
differences from packet to packet.

But this is not really an argument for not having _default_ values
hard-coded in the driver (or DT, but lets forget about DT for now).
Looking at the default compensation numbers provided in the driver, they
are a lot larger than what we expect to find in calibration.

As pointed out by other, most users will not care about the small error
introduced by the few cm PCB track. My claim is that if we provide
default hard-coded delay values in the driver, most users will not care
about the few ns noise that each packet differs. And those who do care,
have all the hooks and handle to calibrate further by using PTP4L.

If we do not offer default delays directly in the driver, everybody will
have to calibrate all boards just to have decent results, we will not
have a good way to provide default delay numbers, and this will be
different from what is done in other drivers.

I do understand that you have a concern that these numbers may change in
future updates. But this has not been a problem in other drivers doing
the same. But if this is still a concern, we can add a comment to say
that these numbers must be treated as UAPI, and chancing them, may
cause regressions on calibrated PHYs.

Long story short, I can see any real down-sides of adding these delay
numbers, and I see plenty in not doing so.

/Allan

