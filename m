Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC26169B9EB
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 13:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjBRMKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 07:10:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjBRMKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 07:10:44 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D852B196AA;
        Sat, 18 Feb 2023 04:10:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676722241; x=1708258241;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XgK8JESFaNh4bVZiSwCnZwjVSOv0FE9HQgF5rfAuGLI=;
  b=IiN70xBb1c/3aqZlXubu84iKn9tVKF7Ki/QJwpo2tdsRAWkjccaRbWTb
   utP5i6hwMW9Mcsam5sx67OUzQboIctwhvPcsw+luhCJC4ai99tA6HzAmg
   /GDvaFpSImpIcvuM+M1jv51xdSit97UFnvxj7bLdLn2MkbU/YE/2eQqXy
   ESVp+AvY9CbTwITZUGOBHqzaxvwDDaxYVRWAJJDNEJME5WFfvLkvU+dRX
   joJn2iBNKsQGlprgoQjoeHJmU3RA3Cpn5wRUjZONS1eiLhQi04sZk2sfS
   MkP6RmPZut3/7utO4e64MYoI2TDaX3hqnEgCfW4SYnOMOLaffieT1RL4E
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,307,1669100400"; 
   d="scan'208";a="201248346"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Feb 2023 05:10:40 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 18 Feb 2023 05:10:40 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Sat, 18 Feb 2023 05:10:40 -0700
Date:   Sat, 18 Feb 2023 13:10:39 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>
Subject: Re: [PATCH net-next] net: phy: micrel: Add support for PTP_PF_PEROUT
 for lan8841
Message-ID: <20230218121039.4kgejvhbi4ppkij6@soft-dev3-1>
References: <20230217075213.2366042-1-horatiu.vultur@microchip.com>
 <Y/Ah/MRYKdohtXZH@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Y/Ah/MRYKdohtXZH@lunn.ch>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 02/18/2023 01:55, Andrew Lunn wrote:
> 
> > +static void lan8841_ptp_update_target(struct kszphy_ptp_priv *ptp_priv,
> > +                                   const struct timespec64 *ts);
> > +
> 
> Please avoid this. Move the code around so everything is in
> order. Generally, i do such moves in an initial patch which only moves
> code, making it easy to review.

Thanks for the suggestion. I will update this in the next version.

> 
>       Andrew

-- 
/Horatiu
