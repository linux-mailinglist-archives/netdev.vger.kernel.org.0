Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40411E818D
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 07:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbfJ2Gy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 02:54:59 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33981 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfJ2Gy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 02:54:59 -0400
Received: by mail-wm1-f66.google.com with SMTP id v3so1270719wmh.1
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 23:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5Ru1pUr7RiA4h1nPvPG4KS1xAEIbA3h93Cum6uaNuCI=;
        b=j2Fpf+CZKY136UeSkN78xL5/4OGDu+2kkerWpVfLTkwWvaB6mlp5bw+hmYtMy9VkTW
         PYAiZF1emZDd5DiP8fGSffx1JU0Z4qaylbJ9su6e05rp22tQrMvAbZlACpLkgqhGzy+k
         3EYN2Aa0xOv5XJwE2gG3c8EUuQhPYOMYRhCh7+xkJVxZUh2FwiPdapr6ug4Lvr8LKaqu
         qNwXei/krxR+7vGjs/d/czzPrpNKSIholDqxFOt/H0zekbqpxtqV2hD8x1muHiO2Gg40
         q8nWoGq9CrcQSNB4hlyVWZZblXBBg7LdCJP2M44pHazc70qzPljEmUUezKaFkTEMaSO9
         ASdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5Ru1pUr7RiA4h1nPvPG4KS1xAEIbA3h93Cum6uaNuCI=;
        b=MhdpURW07oNASMwDHiYc3LmgJDpPm2CVa3VtN67uMqtnfcK297C6BqhHMk9Bd82UWM
         84MZrYkBRbPAk1ftwzr7uc0M1lKqm/crAEYSZVNfdQ8AjU1eyBNXVivpYXF+4/Hq8ir+
         0hur+HVW10EcJyuMtVxdzZzquXJFAaibEeDT6tfnYXSSNq0tVYtb4kkR5bkuL3pucvIO
         /vG2fEt1y+isxkHwtxmBgSNZ9wZso7ht4jSkAbRffbXX3onYAvlBe1TKab5CVYUDN6Iv
         tIE0wBOZI6mIZzD851nt25o8ZIxu0IdqS3dxJOAw39SCa/xJ8wqUkJAAMR6m36YU6Ex9
         frSQ==
X-Gm-Message-State: APjAAAWIt5IYL3Djc2kS4goDUsVDoCZp8A9AY+T8+ZJOvO4UQRQcjvrI
        6SbIzN5G/yNjnzMKBmpQxrY=
X-Google-Smtp-Source: APXvYqxmOrdnSeyZq4MqHtZoPK/f63j7RGwXu+20jBu84dZUJyuO0MmIlc+VMTzwqbo4IUKPlyINKw==
X-Received: by 2002:a1c:2311:: with SMTP id j17mr643660wmj.79.1572332097567;
        Mon, 28 Oct 2019 23:54:57 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f17:6e00:25ab:765c:1552:bc80? (p200300EA8F176E0025AB765C1552BC80.dip0.t-ipconnect.de. [2003:ea:8f17:6e00:25ab:765c:1552:bc80])
        by smtp.googlemail.com with ESMTPSA id h17sm1849484wme.6.2019.10.28.23.54.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Oct 2019 23:54:57 -0700 (PDT)
Subject: Re: [PATCH net-next 3/4] net: phy: marvell: add downshift support for
 M88E1111
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chris Healy <Chris.Healy@zii.aero>
References: <4ae7d05a-4d1d-024f-ebdf-c92798f1a770@gmail.com>
 <7c5be98d-6b75-68fe-c642-568943c5c4b6@gmail.com>
 <20191028200952.GH17625@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <16d203e3-9a42-38df-a5a7-3b9106e90b9d@gmail.com>
Date:   Tue, 29 Oct 2019 07:54:38 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191028200952.GH17625@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.10.2019 21:09, Andrew Lunn wrote:
> On Mon, Oct 28, 2019 at 08:53:25PM +0100, Heiner Kallweit wrote:
>> This patch adds downshift support for M88E1111. This PHY version uses
>> another register for downshift configuration, reading downshift status
>> is possible via the same register as for other PHY versions.
> 
> Hi Heiner
> 
Hi Andrew,

> I think this method is also valid for the 88E1145.
> 
I had a look at the Marvell DSDT and indeed 88E114X has same downshift
support as 88E1111 (what's called MAD_PHY_DOWNSHIFT_TYPE1 in the DSDT).
So I will submit a follow-up patch to add downshift support for 88E1145.

>   Andrew
> 
Heiner
