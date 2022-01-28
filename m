Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0902D49FA62
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 14:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbiA1NMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 08:12:40 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:56479 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243254AbiA1NMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 08:12:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643375559; x=1674911559;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/ejLmChYenH18764UxenA4ND6LEmeX84jKu63tda12w=;
  b=BHFFFtKWJW3zGkQF13LAJlmN/QX1jhamF8Uuiwhmg+e4wJWrxXqVrrTF
   KomTCq/XNFy68wLC3JpHHddI7rQPksoBox9ULB1GFuHdLnDHzwAxBJY+E
   EQ3lEYlKx+0MzcVPzofsPn78NoJPPRpi43lT3DVV8iE5DrPlPgcF5T1iz
   41rxh7ig6QiN/QrsnRJihfHiJIN0O4SYT7+5NwUN3/Grrhl+cgkXsZknC
   ssQUgni2x7V5p4CSZgIuG3tfO0bgglTUYStMynDNGYhqYluC0jh1J5/th
   Pj0KVGs6FBNaYiaSN1Xx8YY/IqTPgtmA7s7mGV+brBPeot47dGKCrR+59
   g==;
IronPort-SDR: zwSyQreqDgtyTnr3R42rblV8WywKmgIDum0hI7VPbJ1jYrcZz2faTtxDFB6PI0e40Z9rxTseFB
 qU6YqT9o9C51OKewBcglYl3rnruoPwcF8TIiqEdb6OrvtvPpKYJrTaQAHxYkE7Oe9q0d9GRFQy
 KvoyP1AY8vHYbueZsZqIvHlzJZMhDf3WHK4dqdv+20vIbFS/yW01jMfy4lgp/HIkspgY49BJcd
 ORF4SfZySy3YBJ2krdwYhbxnj1IsnWs9ufCVJxzg2DVv8yQ23ZWya0Mw+A/bDwLZkalkwP9RK0
 Q4Vy4MjvAv/5DzeYGSV5Ky1i
X-IronPort-AV: E=Sophos;i="5.88,324,1635231600"; 
   d="scan'208";a="144206746"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Jan 2022 06:12:37 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 28 Jan 2022 06:12:37 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Fri, 28 Jan 2022 06:12:37 -0700
Date:   Fri, 28 Jan 2022 14:15:04 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <vladimir.oltean@nxp.com>, <andrew@lunn.ch>
Subject: Re: [PATCH net-next 2/7] net: lan966x: Add registers that are use
 for ptp functionality
Message-ID: <20220128131504.onazx77qag32bbjc@soft-dev3-1.localhost>
References: <20220127102333.987195-1-horatiu.vultur@microchip.com>
 <20220127102333.987195-3-horatiu.vultur@microchip.com>
 <20220127151836.GA20642@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220127151836.GA20642@hoboy.vegasvil.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 01/27/2022 07:18, Richard Cochran wrote:

Hi Richard,

> 
> On Thu, Jan 27, 2022 at 11:23:28AM +0100, Horatiu Vultur wrote:
> > This patch adds the registers that will be used to configure the PHC in
> > the HW.
> 
> See "This patch" in Documentation/process/submitting-patches.rst

Yes, I will update this in the next version.

> 
> Thanks,
> Richard

-- 
/Horatiu
