Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A6A2046A0
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 03:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731819AbgFWBTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 21:19:08 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:41018 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731797AbgFWBTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 21:19:08 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05N1J14g035835;
        Mon, 22 Jun 2020 20:19:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1592875141;
        bh=WevWNQY8HlxM1Yek3NFPCVCxXsm01sjtKnnbriNny9Y=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=qEFYfbQze0Ixjs6oX01mlrpxxDN0Oi15gVe+EJ8Nb5CbaYV0cHmzOSoUfVr030YuF
         PMtwfFOLSiJnY1ny7u3Qvrl713BDR8z1vEQS85qIcm26rrbaWfoCLaKx1RzrTRKVPL
         8IxWcUey8t1YCvAPjt0Kla3iPue3HLsdMKW2MjQQ=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05N1J1QF105462;
        Mon, 22 Jun 2020 20:19:01 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 22
 Jun 2020 20:19:01 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 22 Jun 2020 20:19:01 -0500
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05N1J0cY114760;
        Mon, 22 Jun 2020 20:19:00 -0500
Subject: Re: [PATCH net-next v9 2/5] net: phy: Add a helper to return the
 index for of the internal delay
To:     David Miller <davem@davemloft.net>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <robh@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
References: <20200619161813.2716-1-dmurphy@ti.com>
 <20200619161813.2716-3-dmurphy@ti.com>
 <20200622.154047.909380525276436349.davem@davemloft.net>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <43e0247e-a62a-b34e-016f-c2e540591df2@ti.com>
Date:   Mon, 22 Jun 2020 20:19:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200622.154047.909380525276436349.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David

On 6/22/20 5:40 PM, David Miller wrote:
> From: Dan Murphy <dmurphy@ti.com>
> Date: Fri, 19 Jun 2020 11:18:10 -0500
>
>> +s32 phy_get_internal_delay(struct phy_device *phydev, struct device *dev,
>> +			   const int *delay_values, int size, bool is_rx)
>> +{
>> +	int i;
>> +	s32 delay;
> Please use reverse christmas tree ordering for local variables.

OK.

Dan

