Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 016401C9FBA
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 02:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgEHAke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 20:40:34 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:54122 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbgEHAkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 20:40:33 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0480eTnb053648;
        Thu, 7 May 2020 19:40:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588898429;
        bh=sZLqc6bcUyrr7YvApm7EgW/hqpn5lokyznG7/dwl9Q4=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=Shlav7+D1aY0m3636dTmu/xp9CH0EpC2xAasUq9An7zHGalx6giqVV4UWT171oQw1
         Lil3Psl+Q0XLgmA94qPA/Q0l26whowWdJHsAnAtWnUoavoPrDPUmU/9vGsj6yhQR32
         Lee5TYqKGkn+mR7hBTxL0KXeCi+fA3715en3nXEg=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0480eTGM072433
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 7 May 2020 19:40:29 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 7 May
 2020 19:40:28 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 7 May 2020 19:40:28 -0500
Received: from [10.250.52.63] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0480eLZN024416;
        Thu, 7 May 2020 19:40:24 -0500
Subject: Re: [PATCH net/master] net: ethernet: ti: cpts: Fix linker issue when
 TI_CPTS is defined
To:     <davem@davemloft.net>, <richardcochran@gmail.com>,
        <ivan.khoronzhuk@linaro.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
References: <20200507214740.14693-1-dmurphy@ti.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <ab0a9a19-c96b-f90f-827d-aa10bf49a4b7@ti.com>
Date:   Thu, 7 May 2020 19:31:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200507214740.14693-1-dmurphy@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All

On 5/7/20 4:47 PM, Dan Murphy wrote:
> Fix build issue when CONFIG_TI_CPTS is defined in the defconfig but
> CONFIG_TI_CPTS_MOD is not set.

I see this already has a pending patch to fix this so unless this 
solution is better I will drop the patch

https://lore.kernel.org/patchwork/patch/1235642/

Dan

