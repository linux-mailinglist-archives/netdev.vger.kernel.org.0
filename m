Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31507187C20
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 10:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgCQJhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 05:37:20 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:43540 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgCQJhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 05:37:20 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02H6cFG5050056;
        Tue, 17 Mar 2020 01:38:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584427095;
        bh=iwD9fU+hSWkCjRNvdoy4wCmVUDr4A/abpsz2BtBWeek=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=Dgg0TrXD5quasHUUpkARKAfWOQZL+KApGVii9A6cxIY6l/Y+EAb6ZsRCsKh7YOWOf
         S6rPc8GXCIH413VsCxrnpqi/wF06NwdYYxlBan8CJZwyvlR+Vv7pAlPFDLhV7qspfo
         IN4qit4C7sESEro529R3zAIWb/Sy+hx239G8qyL0=
Received: from DLEE110.ent.ti.com (dlee110.ent.ti.com [157.170.170.21])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02H6cFoN113556
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Mar 2020 01:38:15 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 17
 Mar 2020 01:38:15 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 17 Mar 2020 01:38:15 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02H6cB3N113828;
        Tue, 17 Mar 2020 01:38:11 -0500
Subject: Re: [PATCH net-next 5/9] net: cpsw: reject unsupported coalescing
 params
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-net-drivers@solarflare.com>,
        <ecree@solarflare.com>, <mhabets@solarflare.com>,
        <jaswinder.singh@linaro.org>, <ilias.apalodimas@linaro.org>,
        <Jose.Abreu@synopsys.com>, <andy@greyhouse.net>, <andrew@lunn.ch>,
        <michal.simek@xilinx.com>, <radhey.shyam.pandey@xilinx.com>,
        <mkubecek@suse.cz>
References: <20200316204712.3098382-1-kuba@kernel.org>
 <20200316204712.3098382-6-kuba@kernel.org>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <69e0a3ac-9058-c15c-87dc-dd1e7e19c457@ti.com>
Date:   Tue, 17 Mar 2020 08:38:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200316204712.3098382-6-kuba@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16/03/2020 22:47, Jakub Kicinski wrote:
> Set ethtool_ops->supported_coalesce_params to let
> the core reject unsupported coalescing parameters.
> 
> This driver did not previously reject unsupported parameters.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---

Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>

-- 
Best regards,
grygorii
