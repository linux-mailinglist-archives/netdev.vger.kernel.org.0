Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E61A2CD0CE
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 09:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388135AbgLCIH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 03:07:56 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:23652 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728731AbgLCIH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 03:07:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1606982876; x=1638518876;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LSN0KUT7yJTZZ9i4OeFR4JBEwWeneDUsBs1/dwXw104=;
  b=zuYPQ6zh8iUkX9umDmaVjOju/2IQGzJ0+ier0910eXsbpn7TH2K5egb1
   WSz46LZ4yNx3kDrBgl7nYaxBs8V3nft7VJ2NMvMkGOap1V4ux+smV53ou
   SUftXS7m+hkknNtiYeWdD5C/EpuB+n3OvBOl6DRBKrrhc4U755ruWZfpY
   K9/ZDf7DLHjrX3i/Q1onCVcnPbPAsvyhpKdKxebeETrGXiZdk5AYyVuK3
   a9qay/VGgeBEkOAD7VerufYSSHW38BC7NRTfV1j5IJMkw9fQn2E9GinPM
   OTEJnFAfdQhPLTByAjUbfF9C3G02YcDT995DQ7YttO42iKKMP2mqAs+YS
   Q==;
IronPort-SDR: naS8rlCpLZ2/86cEDa526JaAXCfAtdZFkj7ZeVG6Pl+OgQhZiMrglK/DYL2uKkA0N+7e7YmLKs
 yt6Jjj1sAEaBEUBn5M3IxDrZGdbvsOWDhTF76mqj3RhMdMzfXNIBD3wpcYUSyeYF0WzleCx2Fd
 2qRZfMhFwNxnmhWna4KdERVEnqwqyu39nTI3zDXav+eyJ3+OPKkm7fFSYCmw6PceyNDb+jBcRL
 y+xUv2bRc8/NT8SWhWktoJEOG+1iVkqO2L8UIHfFPsmvhHr8qD+yafMFykJ662ITTGUmun9NuP
 Ruc=
X-IronPort-AV: E=Sophos;i="5.78,389,1599548400"; 
   d="scan'208";a="101237131"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Dec 2020 01:06:49 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Dec 2020 01:06:49 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 3 Dec 2020 01:06:49 -0700
Date:   Thu, 3 Dec 2020 09:06:48 +0100
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <netdev@vger.kernel.org>, Kishon Vijay Abraham I <kishon@ti.com>,
        "Vinod Koul" <vkoul@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 0/4] Adding the Sparx5 Serdes driver
Message-ID: <20201203080648.24o7oyw5h6qp4coa@mchp-dev-shegelun>
References: <20201202130438.3330228-1-steen.hegelund@microchip.com>
 <20201202222140.wzdiypc2edviy57n@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20201202222140.wzdiypc2edviy57n@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.12.2020 00:21, Vladimir Oltean wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>Hi Steen,
>
>On Wed, Dec 02, 2020 at 02:04:34PM +0100, Steen Hegelund wrote:
>> Adding the Sparx5 Serdes driver
>>
...

>> --
>> 2.29.2
>
>I think this series is interesting enough that you can at least cc the
>networking mailing list when sending these? Did that for you now.

Thanks Vladimir.  I will do that going forward.

BR
Steen

---------------------------------------
Steen Hegelund
steen.hegelund@microchip.com
