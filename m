Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D318A24D6
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729881AbfH2S0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:26:12 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:58459 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729870AbfH2S0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 14:26:09 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 46K9zM0gLzz1rQBj;
        Thu, 29 Aug 2019 20:26:07 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 46K9zL75jVz1qqkx;
        Thu, 29 Aug 2019 20:26:06 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id U_MBfZAf4_hY; Thu, 29 Aug 2019 20:26:05 +0200 (CEST)
X-Auth-Info: ijHftztuK6kPdwkwi6JWYpXS5BXnHp0fBad+qNPkLj4=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 29 Aug 2019 20:26:05 +0200 (CEST)
Subject: Re: [PATCH] net: dsa: microchip: fill regmap_config name
To:     George McCollister <george.mccollister@gmail.com>,
        netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        linux-kernel@vger.kernel.org
References: <20190829141441.70063-1-george.mccollister@gmail.com>
From:   Marek Vasut <marex@denx.de>
Message-ID: <8ddc67de-22f8-ccfa-d6af-500d4c92935d@denx.de>
Date:   Thu, 29 Aug 2019 17:06:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190829141441.70063-1-george.mccollister@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/29/19 4:14 PM, George McCollister wrote:
> Use the register value width as the regmap_config name to prevent the
> following error when the second and third regmap_configs are
> initialized.
>  "debugfs: Directory '${bus-id}' with parent 'regmap' already present!"
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>

Reviewed-by: Marek Vasut <marex@denx.de>
