Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C53327B03F
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 16:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgI1Org (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 10:47:36 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:44084 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbgI1Org (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 10:47:36 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08SElUx5053583;
        Mon, 28 Sep 2020 09:47:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1601304450;
        bh=yfkxJQwJNg/W4kZNMM/DC6f37M4WngLvwYX5Vu9mLtg=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=AsbWwzZ21b2UhhjBh854eXp61A6a1pNnqNMn5HA2fzpLbW4h91dOPhHqWa8RbGgPf
         NcA9emMoeyPmasX7NSJnm0ia6CXB8dKgAN1JnFmY7ezC8uYPNFrFX4tMoGCuDPqv5g
         UzM5c67+a/yhXhkD9v2W39D7Emkh56/1/FCJq7Vw=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 08SElUQ2114655
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 09:47:30 -0500
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 28
 Sep 2020 09:47:30 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 28 Sep 2020 09:47:30 -0500
Received: from [10.250.32.117] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08SElTVd102651;
        Mon, 28 Sep 2020 09:47:30 -0500
Subject: Re: [PATCH net-next v5 1/2] net: phy: dp83869: support Wake on LAN
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>
CC:     <mkubecek@suse.cz>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200928144623.19842-1-dmurphy@ti.com>
 <20200928144623.19842-2-dmurphy@ti.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <95260621-a76e-aed3-9874-4e9bed5a401b@ti.com>
Date:   Mon, 28 Sep 2020 09:47:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200928144623.19842-2-dmurphy@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

On 9/28/20 9:46 AM, Dan Murphy wrote:
> This adds WoL support on TI DP83869 for magic, magic secure, unicast and
> broadcast.
>
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>
> v5 - Fixed 0-day warning for u16
>
>   arch/arm/configs/ti_sdk_omap2_debug_defconfig | 2335 +++++++++++++++++

I have to repost this patch as this got added when updating the patches 
when I was testing.

Dan

