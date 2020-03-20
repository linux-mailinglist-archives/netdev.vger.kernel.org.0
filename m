Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D311118CC4A
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 12:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgCTLIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 07:08:13 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:43806 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbgCTLIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 07:08:13 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02KB88I5035120;
        Fri, 20 Mar 2020 06:08:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584702488;
        bh=9WUktMUqDa4d61QWvx1cJ9oQzyaLfT2wrs3FrV4yau0=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=qpHxPDQtSGCzq7nwtJi21Kj85nQAHGe1Ep4qiyAwoqZmfjavHAXJywIxnw69bkplA
         ZTJYC0+T5z84AnmxIkPtCG2r8y7TSXz4jwSAhoSDJQc20sDzfVicV3nj3LhaUidYe1
         B6mzr9v9NYFPL3QGuICcNZT+Fe3rp0n+jWSB8qr4=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02KB88kC047568
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 20 Mar 2020 06:08:08 -0500
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 20
 Mar 2020 06:08:07 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 20 Mar 2020 06:08:07 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02KB84gh053481;
        Fri, 20 Mar 2020 06:08:05 -0500
Subject: Re: [PATCH net-next v2 00/10] net: ethernet: ti: cpts: add irq and
 HW_TS_PUSH events
To:     "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tony Lindgren <tony@atomide.com>
CC:     Sekhar Nori <nsekhar@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        netdev <netdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200319165802.30898-1-grygorii.strashko@ti.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <6975cb4d-8077-60ac-05b5-27a9aa67bf30@ti.com>
Date:   Fri, 20 Mar 2020 13:07:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200319165802.30898-1-grygorii.strashko@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 19/03/2020 18:57, Grygorii Strashko wrote:
> Hi Richard, All,
> 
> v2: no functional changes.
> 
> This is re-spin of patches to add CPSW IRQ and HW_TS_PUSH events support I've
> sent long time ago [1]. In this series, I've tried to restructure and split changes,
> and also add few additional optimizations comparing to initial RFC submission [1].
> 

Pls, ignore this submission. Sent by mistake.

Sorry for this.

-- 
Best regards,
grygorii
