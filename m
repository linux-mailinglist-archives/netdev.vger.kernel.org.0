Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27FF3AC220
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 23:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404586AbfIFVm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 17:42:57 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:52497 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404250AbfIFVmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 17:42:55 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 46Q9yj0ngdz1rQCL;
        Fri,  6 Sep 2019 23:42:45 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 46Q9yY2l3kz1qqkL;
        Fri,  6 Sep 2019 23:42:45 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id J7TSS6j0588H; Fri,  6 Sep 2019 23:42:44 +0200 (CEST)
X-Auth-Info: mIq3bsH7f7mokP6K7PXdvjCNFE5IXcDq6+jso6Nkl4M=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri,  6 Sep 2019 23:42:44 +0200 (CEST)
Subject: Re: [PATCH net-next 3/3] net: dsa: microchip: remove
 NET_DSA_TAG_KSZ_COMMON
To:     George McCollister <george.mccollister@gmail.com>,
        netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
References: <20190906213054.48908-1-george.mccollister@gmail.com>
 <20190906213054.48908-4-george.mccollister@gmail.com>
From:   Marek Vasut <marex@denx.de>
Message-ID: <4e33a69e-a9d9-39e9-4fb6-2ed0c12d9348@denx.de>
Date:   Fri, 6 Sep 2019 23:42:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190906213054.48908-4-george.mccollister@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/6/19 11:30 PM, George McCollister wrote:
> Remove the superfluous NET_DSA_TAG_KSZ_COMMON and just use the existing
> NET_DSA_TAG_KSZ. Update the description to mention the three switch
> families it supports. No functional change.
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>

Reviewed-by: Marek Vasut <marex@denx.de>

-- 
Best regards,
Marek Vasut
