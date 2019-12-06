Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFAA114F98
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 12:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfLFLFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 06:05:17 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:54604 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbfLFLFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 06:05:16 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id xB6B53Gf086517;
        Fri, 6 Dec 2019 05:05:03 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1575630303;
        bh=NQj04N73Ko2XwRvN2MeTWE69+YfdYaANdf4+pxQ7yuI=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=DTExk/liU/hLK3PCPl+jiR4CEifmVjk9YGsGxnG1ubPwWPqJO/UYTvuBPMmryeK4k
         XT5ZTgOxx7kP3pgaKocroEETq9kFwJRfHf64azx/y9VzgH1XqU8uAp8rCYIgun4RnM
         72aw1OYvyFRuYqNgWzUYXww+PjzdHmLwa1YQH18Y=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xB6B53Fm016763
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 6 Dec 2019 05:05:03 -0600
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 6 Dec
 2019 05:05:03 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 6 Dec 2019 05:05:03 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id xB6B50TX117761;
        Fri, 6 Dec 2019 05:05:01 -0600
Subject: Re: [PATCH 0/2] net: ethernet: ti: cpsw_switchdev: fix unmet direct
 dependencies detected for NET_SWITCHDEV
To:     David Miller <davem@davemloft.net>
CC:     <rdunlap@infradead.org>, <netdev@vger.kernel.org>,
        <tony@atomide.com>, <nsekhar@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
References: <20191204174533.32207-1-grygorii.strashko@ti.com>
 <20191205.143944.1644239054512253859.davem@davemloft.net>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <393acd95-7556-3d68-4e44-b940a7e9bfc8@ti.com>
Date:   Fri, 6 Dec 2019 13:04:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191205.143944.1644239054512253859.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 06/12/2019 00:39, David Miller wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> Date: Wed, 4 Dec 2019 19:45:31 +0200
> 
>> This series fixes Kconfig warning with CONFIG_COMPILE_TEST=y reported by
>> Randy Dunlap <rdunlap@infradead.org> [1]
>>
>> [1] https://lkml.org/lkml/2019/12/3/1373
> 
> I applied patch #1 to the networking tree, the defconfig update has to be routed via
> the appropriate architecture tree.
  
Thank you.
  

-- 
Best regards,
grygorii
