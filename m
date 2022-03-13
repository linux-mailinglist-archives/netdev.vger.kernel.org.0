Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0BCA4D77FD
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 20:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235337AbiCMTjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 15:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233197AbiCMTi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 15:38:59 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62BDD6375;
        Sun, 13 Mar 2022 12:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647200267; x=1678736267;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QcQ93NfFKUvvlAYnkpLnWJz4ZOtAVwAyG2MeuEBh5o8=;
  b=laIUw12BSPRc/S3arr2RV35QkFSaiPDE0DNW0L549hRC8jNzMYyjEzfo
   kF9Lebjmgz6U55JSgT8p4HGjqA+g0pUwjwjH1wxEgAT1dyfnc+2YpCjxw
   Pm29ASpfsRO953q8Nt6ah359UAy34tLdQZOUniYzLfC8cHhedcv/163Zf
   ywFDfnb4CvBJd+Kju/iAeqEloydook+Csa02LKRMoKX0M4zcgOlxKHJjW
   hCFcHfcmS49BHb5DuPlCQu3vA98k57WfCz934quHpyTL6oGct918PjxjK
   1qnqNd6ELXB06baEokzxEz6qDUJ7wJ1vE9eWFxFXrrPElKrZxgL2pT1Rh
   g==;
X-IronPort-AV: E=Sophos;i="5.90,179,1643698800"; 
   d="scan'208";a="165583193"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Mar 2022 12:37:46 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sun, 13 Mar 2022 12:37:45 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Sun, 13 Mar 2022 12:37:45 -0700
Date:   Sun, 13 Mar 2022 20:37:44 +0100
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Richard Cochran <richardcochran@gmail.com>,
        <Woojung.Huh@microchip.com>, <linux@armlinux.org.uk>,
        <Horatiu.Vultur@microchip.com>, <Divya.Koppera@microchip.com>,
        <netdev@vger.kernel.org>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <Madhuri.Sripada@microchip.com>,
        <Manohar.Puri@microchip.com>
Subject: Re: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Message-ID: <20220313193744.6gu6l2mjj4r3wj6x@den-dk-m31684h>
References: <20220308221404.bwhujvsdp253t4g3@soft-dev3-1.localhost>
 <YifoltDp4/Fs+9op@lunn.ch>
 <20220309132443.axyzcsc5kyb26su4@soft-dev3-1.localhost>
 <Yii/9RH67BEjNtLM@shell.armlinux.org.uk>
 <20220309195252.GB9663@hoboy.vegasvil.org>
 <BL0PR11MB291347C0E4699E3B202B96DDE70C9@BL0PR11MB2913.namprd11.prod.outlook.com>
 <20220312024828.GA15046@hoboy.vegasvil.org>
 <Yiz8z3UPqNANa5zA@lunn.ch>
 <20220313024646.GC29538@hoboy.vegasvil.org>
 <Yi4IrO4Qcm1KVMaa@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Yi4IrO4Qcm1KVMaa@lunn.ch>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 13, 2022 at 04:07:24PM +0100, Andrew Lunn wrote:
> On Sat, Mar 12, 2022 at 06:46:46PM -0800, Richard Cochran wrote:
> > On Sat, Mar 12, 2022 at 09:04:31PM +0100, Andrew Lunn wrote:
> > > Do these get passed to the kernel so the hardware can act on them, or
> > > are they used purely in userspace by ptp4l?
> >
> > user space only.
I'm wondering if one-step will work if these correction values are not
applied to HW.

> > > If they has passed to the kernel, could we provide a getter as well as
> > > a setter, so the defaults hard coded in the driver can be read back?
> >
> > Any hard coded defaults in the kernel are a nuisance.
> >
> > I mean, do you want user space to say,
> >
> >    "okay, so I know the correct value is X.  But the drivers may offer
> >    random values according to kernel version.  So, I'll read out the
> >    driver value Y, and then apply X-Y."
> >
> > Insanity.
> 
> No, i would not suggests that at all.
> 
> You quoted the man page and it says the default it zero. If there was
> an API to ask the driver what correction it is doing, and an API to
> offload the delay correction to the hardware, i would simply remove
> the comment about the default being zero. If these calls return
> -EOPNOTSUPP, then user space stays the same, and does actually use a
> default of 0. If offload is supported, you can show the user the
> current absolute values, and allow the user to set the absolute
> values.
This sounds like a good approach to me (but I know it is not my opinion
you are asking for).

In all cases, if there is a desire to have such APIs, and let drivers
advertise default compensation values in this way, we can work on that.

> Anyway, it is clear you don't want the driver doing any correction, so
> lets stop this discussion.
> 
>      Andrew

-- 
/Allan
