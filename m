Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F281BCE2A
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 23:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgD1VFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 17:05:05 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:51550 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbgD1VFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 17:05:05 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 03SL4tuY040669;
        Tue, 28 Apr 2020 16:04:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588107895;
        bh=do4BwFKHFK8c0cqWCxuyCnA0pQp/WVNM3LY6FxwoDJA=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=mca143oCj+GVP8p28R2KPM/yk0mssU8YEUXt52eXrzjvO6LqY3qOUStPOWMRZl4M5
         6dcvNwFh+SXIMGY3+Kc+OwBv3iiUWUhdYGw11FC0N0GYUD+8cSdCLCylkLSURf9ypB
         ysoG16t4jXRYz49AAhBEretyF2JkJUVhfOxYCuDM=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 03SL4tCM096363
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 28 Apr 2020 16:04:55 -0500
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 28
 Apr 2020 16:04:54 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 28 Apr 2020 16:04:54 -0500
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03SL4sPS123165;
        Tue, 28 Apr 2020 16:04:54 -0500
Subject: Re: [PATCH net v2 2/2] net: phy: DP83TC811: Fix WoL in config init to
 be disabled
To:     David Miller <davem@davemloft.net>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <afd@ti.com>
References: <20200427212112.25368-1-dmurphy@ti.com>
 <20200427212112.25368-3-dmurphy@ti.com>
 <20200428.130545.1878103691480474686.davem@davemloft.net>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <d150900f-7a54-2ff2-00cb-6b40ea18c468@ti.com>
Date:   Tue, 28 Apr 2020 15:59:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200428.130545.1878103691480474686.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David

On 4/28/20 3:05 PM, David Miller wrote:
> From: Dan Murphy <dmurphy@ti.com>
> Date: Mon, 27 Apr 2020 16:21:12 -0500
>
>> +		return phy_write_mmd(phydev, DP83822_DEVADDR,
>                                               ^^^^^^^^^^^^^^^^
>
> Please don't submit patches that have not even had a conversation with
> the compiler.
>
> This register define only exists in dp83822.c and you are trying to use
> it in dp83tc811.c
>
> If this doesn't compile, how did you do functional testing of this
> change?

My fault, I thought my defconfig had this turned on to compile as it did 
in v1.

I functionally tested these changes on the DP83822 as they are register 
and feature compatible for WoL

Dan

> If you compile tested these changes against a tree other than the 'net'
> tree, please don't do that.
>
> Thanks.
