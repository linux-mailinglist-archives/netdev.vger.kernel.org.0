Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA502BE817
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 00:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbfIYWJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 18:09:57 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:37477 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727735AbfIYWJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 18:09:57 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 46dsg74kz8z1rNlN;
        Thu, 26 Sep 2019 00:09:55 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 46dsg70pbWz1qqkB;
        Thu, 26 Sep 2019 00:09:55 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id lcFtB59L1zJ6; Thu, 26 Sep 2019 00:09:53 +0200 (CEST)
X-Auth-Info: 1ruFF5w5G9cLKAtV4GB+h8Bt2CKrKFLfzxPVDjjTPWQ=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 26 Sep 2019 00:09:53 +0200 (CEST)
Subject: Re: [PATCH] net: dsa: microchip: Always set regmap stride to 1
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        george.mccollister@gmail.com, Tristram.Ha@microchip.com,
        vivien.didelot@savoirfairelinux.com, woojung.huh@microchip.com
References: <20190921175309.2195-1-marex@denx.de>
 <20190925.134424.1566106400449419934.davem@davemloft.net>
From:   Marek Vasut <marex@denx.de>
Message-ID: <b1d256eb-85d0-4bdc-e49a-1ec00d2a2cb7@denx.de>
Date:   Thu, 26 Sep 2019 00:09:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190925.134424.1566106400449419934.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/25/19 1:44 PM, David Miller wrote:
> From: Marek Vasut <marex@denx.de>
> Date: Sat, 21 Sep 2019 19:53:09 +0200
> 
>> The regmap stride is set to 1 for regmap describing 8bit registers already.
>> However, for 16/32/64bit registers, the stride is 2/4/8 respectively. This
>> is not correct, as the switch protocol supports unaligned register reads
>> and writes and the KSZ87xx even uses such unaligned register accesses to
>> read e.g. MIB counter.
>>
>> This patch fixes MIB counter access on KSZ87xx.
>>
>> Signed-off-by: Marek Vasut <marex@denx.de>
> 
> Please resubmit with an appropriate Fixes: tag as per Florian's feedback.

Done
