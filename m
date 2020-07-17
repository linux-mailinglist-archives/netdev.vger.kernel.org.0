Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D886A223DEA
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 16:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgGQOTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 10:19:08 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:35730 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbgGQOTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 10:19:07 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06HEJ3ca068989;
        Fri, 17 Jul 2020 09:19:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1594995543;
        bh=ZiJcIvBnt7JM8Vw63llL3vqfvA50vFmoxXCbD1I/cEY=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=Irchb/JwlsHP90E7oaHLM6YQmwWaH1AlkPvEbM99PfhZ1AUhFN5FMyhZgvyn/X+2J
         S/w2nXigBBHGAMNKHbv4QbklNyvts7UU3VuhQ6fEoz10H3kEvP2AS1bQVebBxvlo1n
         vJf6Bp+FprPkytnVmKZ+GGA66Y9k+z035A68lUtU=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06HEJ2w6024546
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 17 Jul 2020 09:19:03 -0500
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 17
 Jul 2020 09:19:02 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 17 Jul 2020 09:19:02 -0500
Received: from [10.250.53.226] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06HEJ1q5049963;
        Fri, 17 Jul 2020 09:19:02 -0500
Subject: Re: [net-next PATCH v2 0/9] Add PRP driver and bug fixes
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>,
        <vinicius.gomes@intel.com>
References: <20200715164012.1222-1-m-karicheri2@ti.com>
 <20200716165634.5a57d364@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <9f35282f-6822-6cd9-ed55-743429b670cc@ti.com>
Date:   Fri, 17 Jul 2020 10:19:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200716165634.5a57d364@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, Jakub,

On 7/16/20 7:56 PM, Jakub Kicinski wrote:
> Hi Murali,
> 
> thanks for the patches.
> 
> It seems like at least the first patch addresses a problem which exist
> in Linus's tree, i.e. Linux 5.8-rc.
> 
> Could you please separate bug fixes like that out to a new series
> addressed to the net tree, and add appropriate Fixes tags?
> 
Sure thing. I will send out the first two so that it gets merged.
Spin v3 without it so that it can go to net/next.

Wondering if you would be able to test PRP?
Any other volunteers?

Thanks.
-- 
Murali Karicheri
Texas Instruments
