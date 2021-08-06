Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B26B3E280E
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 12:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244834AbhHFKHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 06:07:34 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:33164 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244807AbhHFKHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 06:07:32 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 176A7EkG111096;
        Fri, 6 Aug 2021 05:07:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1628244434;
        bh=1LIVV0FOPPHH49OPrMa5dNbSXfrReLd+bC9KO8MpyhQ=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=wfxNkdtyN420Z2jGH8la4QoUdbRljW4SChH65dYFDyw0+sRK7Bk8BrxzjiMlB6UQE
         +LwS1+FNBhVq9eA/lnmUf3YH0kqlvh0nzX6kOSUmrX/fi0dS08HuaHHsqxcaL1vH8v
         aeGawkGO7mPgzkLnyAPCnHHk5/jtnHBxUNsO1y1I=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 176A7ETT010820
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 6 Aug 2021 05:07:14 -0500
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 6 Aug
 2021 05:07:14 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Fri, 6 Aug 2021 05:07:14 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 176A7BXs038129;
        Fri, 6 Aug 2021 05:07:12 -0500
Subject: Re: [PATCH net-next 0/3] net: ethernet: ti: cpsw/emac: switch to use
 skb_put_padto()
To:     David Miller <davem@davemloft.net>
CC:     <patchwork-bot+netdevbpf@kernel.org>, <netdev@vger.kernel.org>,
        <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        <ben.hutchings@essensium.com>, <vigneshr@ti.com>,
        <linux-omap@vger.kernel.org>, <lokeshvutla@ti.com>
References: <20210805145555.12182-1-grygorii.strashko@ti.com>
 <162824220602.18289.6086651097784470216.git-patchwork-notify@kernel.org>
 <49dbe558-cf18-484b-9167-e43ad1c83db5@ti.com>
 <20210806.110444.1042687466668709790.davem@davemloft.net>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <cd881a8e-e137-13a6-7a5d-a543e49cfbd1@ti.com>
Date:   Fri, 6 Aug 2021 13:07:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210806.110444.1042687466668709790.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 06/08/2021 13:04, David Miller wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> Date: Fri, 6 Aug 2021 13:00:30 +0300
> 
>>
>> I'm very sorry again - can it be dropped?
> 
> Easiest is for you to send a fixup or a revert to the list, thanks.
> 
> 

Only Patch 3 need to be reverted - i'll send revert. Thank you.

-- 
Best regards,
grygorii
