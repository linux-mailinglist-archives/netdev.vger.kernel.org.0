Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185E925FE3A
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730284AbgIGQKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:10:30 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:39414 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729916AbgIGOd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 10:33:27 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 087EXOUX079209;
        Mon, 7 Sep 2020 09:33:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599489204;
        bh=KCPnGV1i/mXb3dwVsRcfzbm3+yvLIM1pM8h2rceZWm4=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=v5W+SMP/ll1uyPqrH7gdBF4EFtvlq87kJLQ2ypsZqIFeP+2a3giWkZuWe7JUi60SE
         Mi3/0tXELvzSlDLYJ49yQOV5r0EDi7RdDunMKs6JCYsbbSmuIk8uG3+S4VuU2q+PLl
         fZVUoX5ufMMAY7QYgdGnLs1UcUiG3/qBdmQ86FRM=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 087EXOZc004527;
        Mon, 7 Sep 2020 09:33:24 -0500
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 7 Sep
 2020 09:33:24 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 7 Sep 2020 09:33:24 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 087EXMIG052342;
        Mon, 7 Sep 2020 09:33:22 -0500
Subject: Re: [PATCH net-next 9/9] net: ethernet: ti: ale: add support for
 multi port k3 cpsw versions
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
References: <20200904230924.9971-1-grygorii.strashko@ti.com>
 <20200904230924.9971-10-grygorii.strashko@ti.com>
 <20200904171022.63f103fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <282d021a-976f-df42-6e20-4af8d6812a19@ti.com>
Date:   Mon, 7 Sep 2020 17:33:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200904171022.63f103fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On 05/09/2020 03:10, Jakub Kicinski wrote:
> On Sat, 5 Sep 2020 02:09:24 +0300 Grygorii Strashko wrote:
>> The TI J721E (CPSW9g) ALE version is similar, in general, to Sitara AM3/4/5
>> CPSW ALE, but has more extended functions and different ALE VLAN entry
>> format.
>>
>> This patch adds support for for multi port TI J721E (CPSW9g) ALE variant.
> 
> and:
> 
> drivers/net/ethernet/ti/cpsw_ale.c:195:28: warning: symbol 'vlan_entry_k3_cpswxg' was not declared. Should it be static?
> 

Thank you for your report, I've posted v2.
I've had to install latest sparse version (0.6.2) manually to make it work properly.

-- 
Best regards,
grygorii
