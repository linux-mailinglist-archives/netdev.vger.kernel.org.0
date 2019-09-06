Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B168EAC194
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 22:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392213AbfIFUqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 16:46:08 -0400
Received: from forward103p.mail.yandex.net ([77.88.28.106]:39010 "EHLO
        forward103p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392054AbfIFUqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 16:46:07 -0400
Received: from mxback17g.mail.yandex.net (mxback17g.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:317])
        by forward103p.mail.yandex.net (Yandex) with ESMTP id 9737B18C02F6;
        Fri,  6 Sep 2019 23:46:04 +0300 (MSK)
Received: from smtp1p.mail.yandex.net (smtp1p.mail.yandex.net [2a02:6b8:0:1472:2741:0:8b6:6])
        by mxback17g.mail.yandex.net (nwsmtp/Yandex) with ESMTP id 6grgB9ORQa-k3aeCSwI;
        Fri, 06 Sep 2019 23:46:04 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cloudbear.ru; s=mail; t=1567802764;
        bh=QX99Iwf1KlBdQ7cEwNw6HW39hp9YBOZaqqwXCeA5hBs=;
        h=In-Reply-To:From:To:Subject:Cc:Date:References:Message-ID;
        b=xHnF1vVH7OpnDfxv3nHX9bqZ1xwt5PZLN143I+I2/Hh9S1fTzhc1LbsR/SLHt07Ok
         ytYluzaLnM+lton5QMiBO+eUjVokyiI/piFLbzPvKd3QAF1AoAaeLOVHfSDiaLJXRb
         hMk2ZKAfy5tB0LgRWwZ6lepFZXrZGFKwqFMLxtcs=
Authentication-Results: mxback17g.mail.yandex.net; dkim=pass header.i=@cloudbear.ru
Received: by smtp1p.mail.yandex.net (nwsmtp/Yandex) with ESMTPSA id Gm3J5T2Tcf-k240dJfn;
        Fri, 06 Sep 2019 23:46:02 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Subject: Re: [PATCH 1/2] net: phy: dp83867: Add documentation for SGMII mode
 type
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, robh+dt@kernel.org, f.fainelli@gmail.com,
        Mark Rutland <mark.rutland@arm.com>,
        Trent Piepho <tpiepho@impinj.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1567700761-14195-1-git-send-email-vitaly.gaiduk@cloudbear.ru>
 <1567700761-14195-2-git-send-email-vitaly.gaiduk@cloudbear.ru>
 <20190906192919.GA2339@lunn.ch>
From:   Vitaly Gaiduk <vitaly.gaiduk@cloudbear.ru>
Message-ID: <23dc47ea-209f-9f51-d4a5-161e62e2a69e@cloudbear.ru>
Date:   Fri, 6 Sep 2019 23:45:56 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190906192919.GA2339@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Andrew.

I'm not familiar with generic PHY HW archs but suppose that it is 
proprietary to TI.

I'v never seen such feature so moved it in TI dts field.

Vitaly.

06.09.2019 22:29, Andrew Lunn wrote:
> On Thu, Sep 05, 2019 at 07:26:00PM +0300, Vitaly Gaiduk wrote:
>> Add documentation of ti,sgmii-type which can be used to select
>> SGMII mode type (4 or 6-wire).
> Hi Vitaly
>
> Is 4 vs 6-wire a generic SGMII property? Or is it proprietary to TI?
>
> I did a quick search and i could not find any other PHYs supporting
> it.
>
> 	Andrew
