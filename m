Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFAC22D5EDF
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 16:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389928AbgLJPBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 10:01:01 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:28279 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729979AbgLJPAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 10:00:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607612453; x=1639148453;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UqMkvKL7D8SiD3dwz7dJFaadhU8wN/9oUbsLA7y6BBs=;
  b=h0ql8Y8Mr2FEnK6WNEwyVgedGxs3JutllsUqxQL4XHEz+RulKBJnwU79
   ozE4anMARd5NGJ7p23KEL/phBZ4r0LmHhXbTmlNh7jUSL2+Gt8Xhswghk
   N1+MvvSpzA4dXw7YrvDnrfDQa/ahgzvqY8gW6cD1vfdHtitZXxNa6GXOl
   PGFgE5lGeQNnj+gDfLtmfkePlUjvhxT9lwOKiUS2+0y1DWDFcN2ACVtbq
   Dn25wqvke324/6lr302F7r1Hosv/OV5vdO0PMC9lF8u2mlQPzmDCQh5Hf
   tzXdZjdMTWXIVZSl5fBHJQJwCMq9rD5HcgAZhTNkgrDyEuoXvy1NGdgwN
   A==;
IronPort-SDR: R3MJaP3nvzHZiidlIW4RrQ7dWRWphe6WNKjns6lRGwVl67uDBH1GvIQ5YmIHTkqYmUfE0wRLDc
 kInbCicGpSSFFjeHQxGlInx6cNvrsz64ClS3jGpWs25RVDGkvIJVBNPWsxq7rGt4S5GQW+RyiU
 VdlKiwdO1k5LNzChrE6WPp2SPJcYlzMbGg2Qe2vc3GbnLUw2ZBEcwusVYF3KIF7I+UCn5dtLE8
 iu08kAFZUgviptzKSklFTEpjOo8b7wZhgJpaf6T8Zbi+gazz1XPtmj1TPxkLZQMbImhyZaPD2A
 T58=
X-IronPort-AV: E=Sophos;i="5.78,408,1599548400"; 
   d="scan'208";a="96633051"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Dec 2020 07:59:37 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 10 Dec 2020 07:59:37 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 10 Dec 2020 07:59:36 -0700
Date:   Thu, 10 Dec 2020 15:59:35 +0100
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 3/4] phy: Add Sparx5 ethernet serdes PHY driver
Message-ID: <20201210145935.see4n6csnomsl2rx@mchp-dev-shegelun>
References: <20201207121345.3818234-1-steen.hegelund@microchip.com>
 <20201207121345.3818234-4-steen.hegelund@microchip.com>
 <20201210021134.GD2638572@lunn.ch>
 <20201210125706.saub7c2rarifhbx4@mchp-dev-shegelun>
 <20201210141610.GG2638572@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20201210141610.GG2638572@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.12.2020 15:16, Andrew Lunn wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>> > So why are returning link up information?
>>
>> Yes that was a bit of a hijacking of the function.  I will remove that.
>> I also removed the dependency on this behaviour in the client driver in the
>> meantime.
>>
>> I think a status function on the generic phy would be useful, but I will
>> take that as separate issue.
>
>In this context of an Ethernet SERDES, do you actually need it? You
>would normally look at the PCS link status to determine if the link is
>up.  But it is useful debug information. If the PCS is down, but the
>PHY indicates up, you can guess you have a protocol misconfiguration.

Yes - you are probably right about that.  I have been exposing this via
a procfs interface during the development phase, and it was really
useful to have, to track down the origin of the problem in certain situations.

But on a system level, the PCS link would have the final say anyway.
>
>What exactly does link at this level mean? And thinking of the wider
>uses of the PHY subsystem, what would link mean at this level for
>SATA, PCIe, USB? Don't these all have some protocol level above
>similar to Ethernet PCS which is the real determiner of link?

Yes - I think this is really only a debug feature.  No need to force
this on the other PHY categories.


>
>     Andrew

Thanks for your comments, Andrew.

BR
Steen

---------------------------------------
Steen Hegelund
steen.hegelund@microchip.com
