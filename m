Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD536F04F3
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 13:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243711AbjD0LZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 07:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243647AbjD0LZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 07:25:28 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33BDA5FF2
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 04:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682594696; x=1714130696;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QFrG1LiuezqfIsJUmSCz9JgMPl1lFzpRebQO+TNtYgg=;
  b=Y6AG81DWIBXvzIFTvsFP99kaKHvSsASclAikLqR+bzTqiET71esqHwLb
   vl9+1S+fqefA3uNZLWB2PtEZm1Hy+W53WqwL5AXlrjKOeBdrdsw+i67CC
   OvyCXp/RMxG3zOpMKVBb0OlVfJe8Ckw9/2nChOdYTu3Glv024SuE0q4tc
   jfpcDvga7y2ul5HCY2X9cjsBrZgYjYmZw+MJBBPbRxm352ysBEJ8fORab
   duiKJ4nn/UOls3iVHwbxhR9oMBAg5hU36qUJDwTUKymcoQrqRlZWf+LVC
   4gcT9rg/EKi84Lh9niWW3w7XXq0kRBj1/a0M9yIdbc76QNa8+LdqER1S/
   w==;
X-IronPort-AV: E=Sophos;i="5.99,230,1677567600"; 
   d="scan'208";a="212566989"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Apr 2023 04:24:27 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 27 Apr 2023 04:24:22 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 27 Apr 2023 04:24:22 -0700
Date:   Thu, 27 Apr 2023 13:24:21 +0200
From:   Horatiu Vultur - M31836 <Horatiu.Vultur@microchip.com>
To:     Parthiban Veerasooran - I17164 
        <Parthiban.Veerasooran@microchip.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Jan Huber - M16721" <Jan.Huber@microchip.com>,
        Thorsten Kummermehr - M21127 
        <Thorsten.Kummermehr@microchip.com>,
        "ramon.nordin.rodriguez@ferroamp.se" 
        <ramon.nordin.rodriguez@ferroamp.se>
Subject: Re: [PATCH net-next 0/2] add driver support for Microchip LAN865X
 Rev.B0 Internal PHYs
Message-ID: <20230427112421.sqnitutjti3yu2yc@soft-dev3-1>
References: <20230426114655.93672-1-Parthiban.Veerasooran@microchip.com>
 <20230426205049.xlfqluzwcvlm6ihh@soft-dev3-1>
 <c1fca21d-00a6-be18-b5b5-4aa5dac94fb3@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <c1fca21d-00a6-be18-b5b5-4aa5dac94fb3@microchip.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/27/2023 07:07, Parthiban Veerasooran - I17164 wrote:
> Hi Horatiu,
> 
> On 27/04/23 2:20 am, Horatiu Vultur wrote:
> > The 04/26/2023 17:16, Parthiban Veerasooran wrote:
> > 
> > Hi Parthiban,
> > 
> > net-next is closed, so please wait until it opens again to send this
> > patch series.
> 
> Ah ok, thanks for letting me know.
> 
> Do I need to wait until it opens again or shall I continue to fix the 
> review comments and sending the next version for the review again until 
> the window opens?

Yes, you need to wait until it opens again to send the new version.
Until then, please make sure to answear to all the questions/comments that
you had to the series from all the other people.


> > 
> >>
-- 
/Horatiu
