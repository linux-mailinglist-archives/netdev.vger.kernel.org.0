Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAE3506466
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 08:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348770AbiDSGaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 02:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348769AbiDSGa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 02:30:29 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D24240A2;
        Mon, 18 Apr 2022 23:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1650349665; x=1681885665;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iOqdApx4bR1Mpbme/Zm3fofbE/saRcmdrI2mEPKRRB4=;
  b=fz+rsWUPKNDCL7DFcEvyXAt+re4M/uj9JPzoHjlh86ccXcxNs/hiWbQ0
   ypoORsNo6F7euYHIheGacBNQ2wgMxyN2Zhs80fcBbW26GhOPgdwNEG71h
   9yJvxxjwyeNo7vSlLiI0JkNu9Eqz+cXx6/3lgoCsL5q3V10hmJbwjO59M
   WDDKYnzCzX2Fyoi8FVPYVr2Z/O5+j/wi2jr+pczve/Ztch2MJ/piwkQvy
   UmiijqBRptseH850QfxREnCVLbsyU5MR9XAu8ViJGCDbLnq0l4Z3wrb/9
   8JE+TJIo2lpSaoYcQhpov3YL0J+1K5Oc2lu+HzHvVU/QMWV73qLM5wpDF
   A==;
X-IronPort-AV: E=Sophos;i="5.90,272,1643698800"; 
   d="scan'208";a="92757492"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Apr 2022 23:27:44 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 18 Apr 2022 23:27:43 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Mon, 18 Apr 2022 23:27:43 -0700
Date:   Tue, 19 Apr 2022 08:30:57 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <pabeni@redhat.com>
Subject: Re: [PATCH net] net: lan966x: Make sure to release ptp interrupt
Message-ID: <20220419063057.gv262tcgq3kvlqc7@soft-dev3-1.localhost>
References: <20220413195716.3796467-1-horatiu.vultur@microchip.com>
 <20220415210139.2d338f4b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220415210139.2d338f4b@kernel.org>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/15/2022 21:01, Jakub Kicinski wrote:
> 
> On Wed, 13 Apr 2022 21:57:16 +0200 Horatiu Vultur wrote:
> > When the lan966x driver is removed make sure to remove also the ptp_irq
> > IRQ.
> 
> I presume it's because you want to disable the IRQ so it doesn't fire
> during / after remove? Would be good to have such justifications
> spelled out in the commit message in the future!

Sorry about this. I will improve the commit messages in the future.

> 
> > Fixes: e85a96e48e3309 ("net: lan966x: Add support for ptp interrupts")
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

-- 
/Horatiu
