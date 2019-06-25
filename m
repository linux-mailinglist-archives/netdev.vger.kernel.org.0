Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22F2F528F8
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 12:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731850AbfFYKEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 06:04:54 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:56120 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbfFYKEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 06:04:54 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id x5PA4nub062386;
        Tue, 25 Jun 2019 05:04:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1561457089;
        bh=P/SKDRzg6dvG83d820OF33YKZOlXQ/dcokiyRm5jtFc=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=tnNPtYBvq0/Yfx2zSsRQaGvcpfIolg/EwKSFKH62pwS3DTWQrENKYwZThgO4UKpwB
         7nZMth6gzj/dQZsxl4dGNtlIJIfXnee87fJptL0wZGptuNDWWgb/QY9nhiRwbApnk2
         P7O6MfDgHUY6eOl2Fo7xUNEvE0KsnGK8cbjoIhFg=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x5PA4nro037894
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 25 Jun 2019 05:04:49 -0500
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Tue, 25
 Jun 2019 05:04:49 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Tue, 25 Jun 2019 05:04:49 -0500
Received: from [10.250.132.197] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id x5PA4g3K005525;
        Tue, 25 Jun 2019 05:04:43 -0500
Subject: Re: [PATCH V2] net: ethernet: ti: cpsw: Fix suspend/resume break
To:     David Miller <davem@davemloft.net>
CC:     <ivan.khoronzhuk@linaro.org>, <andrew@lunn.ch>,
        <ilias.apalodimas@linaro.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <t-kristo@ti.com>, <grygorii.strashko@ti.com>, <nsekhar@ti.com>
References: <20190624051619.20146-1-j-keerthy@ti.com>
 <20190624.072333.2300932810459542260.davem@davemloft.net>
From:   keerthy <j-keerthy@ti.com>
Message-ID: <e8e07695-d3dc-6a67-aede-a84d6cd3dbcc@ti.com>
Date:   Tue, 25 Jun 2019 15:34:41 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190624.072333.2300932810459542260.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/24/2019 7:53 PM, David Miller wrote:
> From: Keerthy <j-keerthy@ti.com>
> Date: Mon, 24 Jun 2019 10:46:19 +0530
> 
>> Commit bfe59032bd6127ee190edb30be9381a01765b958 ("net: ethernet:
>> ti: cpsw: use cpsw as drv data")changes
>> the driver data to struct cpsw_common *cpsw. This is done
>> only in probe/remove but the suspend/resume functions are
>> still left with struct net_device *ndev. Hence fix both
>> suspend & resume also to fetch the updated driver data.
>>
>> Fixes: bfe59032bd6127ee1 ("net: ethernet: ti: cpsw: use cpsw as drv data")
>> Signed-off-by: Keerthy <j-keerthy@ti.com>
> 
> Applied but please make it clear that changes are targetting net-next in the
> future by saying "[PATCH net-next v2] ...." in your Subject line.

Sure will do that. Thanks.

> 
> Thank you.
> 
