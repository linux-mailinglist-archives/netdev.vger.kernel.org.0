Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5132C2A4C59
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728636AbgKCRJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:09:51 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:43914 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728465AbgKCRJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:09:50 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0A3H9jMG067737;
        Tue, 3 Nov 2020 11:09:45 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1604423385;
        bh=ODeD0x7ElO6eIdUnPijicxhwFBWPndbt6bbowDq0Z2s=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=Ez/tYUTgIkmQoJPRYb+DsbQPKRjNisw+E6xG87OqmM6X8kKWorrLGzPoQPSYA+916
         Pyf30CwVCyAkukt56d7x9s7zPmbHIOFstMyfua/TdkYc9QewkioVkgINt89A6IQD/k
         5BGh9/SF3WrF+upGXuY5r3lhD/azvCgXOtVlILkg=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0A3H9jJJ038733
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 3 Nov 2020 11:09:45 -0600
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 3 Nov
 2020 11:09:44 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 3 Nov 2020 11:09:44 -0600
Received: from [10.250.36.55] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0A3H9iXP016645;
        Tue, 3 Nov 2020 11:09:44 -0600
Subject: Re: [PATCH net-next v3 4/4] net: phy: dp83td510: Add support for the
 DP83TD510 Ethernet PHY
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <robh@kernel.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20201030172950.12767-1-dmurphy@ti.com>
 <20201030172950.12767-5-dmurphy@ti.com>
 <20201030160330.622c55a7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <5b32a56b-f054-5790-c5cf-bf1e86403bad@ti.com>
Date:   Tue, 3 Nov 2020 11:09:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201030160330.622c55a7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

On 10/30/20 6:03 PM, Jakub Kicinski wrote:
> On Fri, 30 Oct 2020 12:29:50 -0500 Dan Murphy wrote:
>> The DP83TD510E is an ultra-low power Ethernet physical layer transceiver
>> that supports 10M single pair cable.
>>
>> The device supports both 2.4-V p2p and 1-V p2p output voltage as defined
>> by IEEE 802.3cg 10Base-T1L specfications. These modes can be forced via
>> the device tree or the device is defaulted to auto negotiation to
>> determine the proper p2p voltage.
>>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> drivers/net/phy/dp83td510.c:70:11: warning: symbol 'dp83td510_feature_array' was not declared. Should it be static?
I did not see this warning. Did you use W=1?
>
>
> Also this:
>
> WARNING: ENOTSUPP is not a SUSV4 error code, prefer EOPNOTSUPP
> #429: FILE: drivers/net/phy/dp83td510.c:371:
> +		return -ENOTSUPP;
>
> WARNING: ENOTSUPP is not a SUSV4 error code, prefer EOPNOTSUPP
> #524: FILE: drivers/net/phy/dp83td510.c:466:
> +		return -ENOTSUPP;
Same with these warnings how where they reproduced?
>
> ERROR: space required before the open parenthesis '('
> #580: FILE: drivers/net/phy/dp83td510.c:522:
> +		if(phydev->autoneg) {
>
> ERROR: space required before the open parenthesis '('
> #588: FILE: drivers/net/phy/dp83td510.c:530:
> +		if(phydev->autoneg) {
>
>
> And please try to wrap the code on 80 chars on the non trivial lines:

What is the LoC limit for networking just for my clarification and I 
will align with that.

I know some maintainers like to keep the 80 LoC and some allow a longer 
line.

Dan
