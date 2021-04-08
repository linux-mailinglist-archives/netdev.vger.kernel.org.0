Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916A33590AC
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 01:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbhDHXwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 19:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbhDHXwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 19:52:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41876C061761;
        Thu,  8 Apr 2021 16:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=LU1RKOg9Ty5gEYs1E3Gy29EzlLyMqbqk0DiPluV23tI=; b=UxDIQ16rNqhRmjMqBQj5EOwLKk
        vPohMnD6x/HogTu5o5wYWsBSX0Uu/tplYZ3seA3vP0O1jPxOaDAbnDWk2ghfNG0xAInFolxGJ6xw0
        74G+/egioKXbS/wgVWZ1dcS0cZ8dNF0qq2SUhhgjFmGEDXIWov+eZDXTGRau7fX73ul4XrWoVy42j
        eQzobavpQcjUlowkR4Cz6iN2kw8FtvtjyrU2po1azOabYHrgTvUfRONnOjjixg6aExyyVsYiOS98Y
        MGWoOpfGiZVY8zrmUe7Vx4m5LQMygmSU4zQanKWc3FcMmBYIYUZ/CyeEyP5+UlZCdNKfo+L/lLvp6
        IBY2P80A==;
Received: from [2601:1c0:6280:3f0::e0e1]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lUeQi-00H4c4-TQ; Thu, 08 Apr 2021 23:51:37 +0000
Subject: Re: [PATCH v3 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
To:     decui@microsoft.com, davem@davemloft.net, kuba@kernel.org,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, liuwe@microsoft.com, netdev@vger.kernel.org,
        leon@kernel.org, andrew@lunn.ch, bernd@petrovitsch.priv.at
Cc:     linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
References: <20210408225840.26304-1-decui@microsoft.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <1f16733a-d720-87de-76bb-c82c72a23fe4@infradead.org>
Date:   Thu, 8 Apr 2021 16:51:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210408225840.26304-1-decui@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/8/21 3:58 PM, Dexuan Cui wrote:
> Changes in v3:
>     Changed the Kconfig file:
>         Microsoft Azure Network Device ==> Microsoft Network Devices
>         Drop the default m
>         validated ==> supported

Hi,
I am satisfied with the Kconfig changes.

thanks.
-- 
~Randy

