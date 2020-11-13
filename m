Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B222B1771
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 09:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgKMIm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 03:42:28 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:48152 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgKMIm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 03:42:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1605256948; x=1636792948;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nrGKxgIDh+JmYSQC8t2GtfMIobIPHaoAB1Nzt3WA8B4=;
  b=S2ol1n3c4ZOT65cgh9v6BUYOgbc4Y7uQLETlKvDNzYQqKHZmVEBrj0Ht
   dKj5rKi18W7OloH/AUf4xeKMj6/IeROaYriJ1Hhplzs0SluyoFGe8X28W
   3xWjM44AUVENvEQbxe/vTLsztGy/y3pEm4GU8bL+8m139n6szCxLlzqV2
   P1FsISRiRj8mum3IaYDdeR1GRq83HI69ea34Yt7awzcAW2/nDHNROSKxe
   Gdkk6N5Nfd2miXutzHCVuZiWwrynadqHeAj/Usp6OiCQgsLUBfdR8+NER
   Z/O+M/ASxMIg12OihIbcvZpe8KWlvFyBQTX3yVgxtd6jnje7jW64As+n9
   Q==;
IronPort-SDR: Amh7d1vLL2c5kUVUAqh+QQ/TLQbt1nIX50dUy9OGTSbYOt0iqSykUr8Rhb1ZY52Ks7rx2bO7+9
 NSvzZCD/t62/xpTOWPUsKt7H+pv9jHia43MXK3IlYEpe3CIFbujpAKYgix72QJt8QaYyIIpZXt
 QNHWxdbzWJ8dnCMDnJgh26N1fhZjPNow1zzNgAKDwZSQNmdKRQAWyTELLjQECNVSv639ZDDojY
 nn+kY+NjtjLFRZl48J/37vViRqwKOYx7r12mh4wRzGs2uHH9r2a4hIM03PCgxW3mv8rbUb0wEr
 BDc=
X-IronPort-AV: E=Sophos;i="5.77,475,1596524400"; 
   d="scan'208";a="103376384"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Nov 2020 01:42:28 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 13 Nov 2020 01:42:27 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 13 Nov 2020 01:42:27 -0700
Date:   Fri, 13 Nov 2020 09:42:26 +0100
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <atenart@kernel.org>,
        Bryan Whitehead <Bryan.Whitehead@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        John Haechten <John.Haechten@microchip.com>,
        Netdev List <netdev@vger.kernel.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: phy: mscc: remove non-MACSec compatible phy
Message-ID: <20201113084226.ag54c2tpgeiy4atq@mchp-dev-shegelun>
References: <20201112090429.906000-1-steen.hegelund@microchip.com>
 <20201112142804.3787760c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20201112142804.3787760c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.11.2020 14:28, Jakub Kicinski wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>On Thu, 12 Nov 2020 10:04:29 +0100 Steen Hegelund wrote:
>> Selecting VSC8575 as a MACSec PHY was not correct
>>
>> The relevant datasheet can be found here:
>>   - VSC8575: https://www.microchip.com/wwwproducts/en/VSC8575
>>
>> Fixes: 0a504e9e97886 ("net: phy: mscc: macsec initialization")
>> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
>
>Fixes tag: Fixes: 0a504e9e97886 ("net: phy: mscc: macsec initialization")
>Has these problem(s):
>        - Subject does not match target commit subject
>          Just use
>                git log -1 --format='Fixes: %h ("%s")'
Hi Jacub,

Right, that sha was for a tree object, not a commit. I should have
checked that.
Thanks for the log command example.  That is really useful.

BR
Steen

---------------------------------------
Steen Hegelund
steen.hegelund@microchip.com
