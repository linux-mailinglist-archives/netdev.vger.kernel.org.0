Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5702E8C37
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 13:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbhACM6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 07:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbhACM6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 07:58:52 -0500
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06513C061573
        for <netdev@vger.kernel.org>; Sun,  3 Jan 2021 04:58:12 -0800 (PST)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4D7zMQ66sfz1rspt;
        Sun,  3 Jan 2021 13:58:10 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4D7zMQ5jdXz1qqkM;
        Sun,  3 Jan 2021 13:58:10 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id cA8LRIE0n5Ce; Sun,  3 Jan 2021 13:58:09 +0100 (CET)
X-Auth-Info: Joof3i487Wyv663tH2A5PAGe9kvF1RttFzERTu3LSgg=
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sun,  3 Jan 2021 13:58:09 +0100 (CET)
Subject: Re: [PATCH 2/2] net: ks8851: Register MDIO bus and the internal PHY
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Lukas Wunner <lukas@wunner.de>
References: <20201230125358.1023502-1-marex@denx.de>
 <20201230125358.1023502-2-marex@denx.de> <X+ykIqQhtjkuDQk9@lunn.ch>
From:   Marek Vasut <marex@denx.de>
Message-ID: <4139341d-86b7-db39-6586-d61fd41d8be7@denx.de>
Date:   Sun, 3 Jan 2021 13:58:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <X+ykIqQhtjkuDQk9@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/30/20 5:00 PM, Andrew Lunn wrote:
>> +static int ks8851_mdio_read(struct mii_bus *bus, int phy_id, int reg)
>> +{
>> +	struct ks8851_net *ks = bus->priv;
>> +
>> +	if (phy_id != 0)
>> +		return 0xffffffff;
>> +
> 
> Please check for C45 and return -EOPNOTSUPP.

The ks8851_reg_read() does all the register checking already.
