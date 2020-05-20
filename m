Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A70DB1DBFDA
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 22:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbgETUCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 16:02:35 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:47190 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbgETUCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 16:02:34 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04KK2Ree059688;
        Wed, 20 May 2020 15:02:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590004947;
        bh=Jlv71XRhYvS94aqoB9HV5Z9r9HYEVNg9gj2FL6x/cOU=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=bX8NyOa8WhyNk1kme0Ol5d4SFgz4V9Pcvi0kj3nadBNqeURZ08n3uwL4ltrKmUcsY
         +hSZ01qy6SNvf1vtFrHOV1hZ2lu1r7NgxVx4LY1QMwp12Zt5hb1uqbFZHJIezOi9+E
         9bAK8kNa+qbB+Ig53lAcB5rDIqVElT4xqVSg9pq4=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04KK2Rfb071370
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 15:02:27 -0500
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 20
 May 2020 15:02:27 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 20 May 2020 15:02:27 -0500
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04KK2PFc102988;
        Wed, 20 May 2020 15:02:25 -0500
Subject: Re: [PATCH net-next v2 3/4] dt-bindings: net: Add RGMII internal
 delay for DP83869
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Florian Fainelli <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
References: <20200520121835.31190-1-dmurphy@ti.com>
 <20200520121835.31190-4-dmurphy@ti.com> <20200520135624.GC652285@lunn.ch>
 <770e42bb-a5d7-fb3e-3fc1-b6f97a9aeb83@ti.com>
 <20200520153631.GH652285@lunn.ch>
 <95ab99bf-2fb5-c092-ad14-1b0a47c782a4@ti.com>
 <20200520164313.GI652285@lunn.ch>
 <d5d46c21-0afa-0c51-9baf-4f99de94bbd5@ti.com>
 <41101897-5b29-4a9d-0c14-9b8080089850@gmail.com>
 <7e117c01-fa6e-45f3-05b7-4efe7a3c1943@ti.com>
 <20200520192719.GK652285@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <0bba1378-0847-491f-8f21-ac939ac48820@ti.com>
Date:   Wed, 20 May 2020 15:02:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200520192719.GK652285@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 5/20/20 2:27 PM, Andrew Lunn wrote:
> Hi Dan
>
>> UGH I think I just got volunteered to do make them common.
> There is code you can copy from PHY drivers. :-)
>
> What would be kind of nice is if the validate was in the core as
> well. Pass a list of possible delays in pS, and it will do a
> phydev_err() if what is in DT does not match one of the listed
> delays. Take a look around at what current drivers do and see if you
> can find a nice abstraction which will work for a few drivers. We
> cannot easily convert existing drivers without breaking DT, but a
> design which works in theory for what we currently have has a good
> chance of working for any new PHY driver.

I think adding it in the core would be a bit of a challenge.  I think 
each PHY driver needs to handle parsing and validating this property on 
its own (like fifo-depth).  It is a PHY specific setting.

Take the DP83867/9 and the ADIN1200/ADIN1300.

The 8386X devices has a delta granularity of 250pS and the AD devices is 
200pS per each setting

And the 867/9 has 3x more values (15) vs only 5 for the AD PHY.

And the Atheros AR803x PHY does use rgmii-id in the yaml, which I guess 
is what you were pointing out, that if set the PHY uses a default 2nS 
delay and it is not configurable.

Same with the Broadcomm.

Ack to not changing already existing drivers which is only 2 the AD PHY 
and the DP83867 PHY.  But I can update the yaml for the 83867 and mark 
the TI specific properties as deprecated in favor of the new properties 
like I did with fifo-depth.

Dan


>       Andrew
