Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25556E79C2
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 21:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbfJ1UMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 16:12:38 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37992 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbfJ1UMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 16:12:38 -0400
Received: by mail-wm1-f67.google.com with SMTP id 22so252978wms.3
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 13:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Jps7p+7emVos88H/xl9wAvfrJF2VcfG9jOAx3iDsxr8=;
        b=CfI/1k9IvYr/2+4QlDQvaESE+Kkz7qFow6SmpoSAZDqQ6Q6kJB4spAwzK4e+7WKTIF
         T9pE9MQyHn1byXzhvUb4lCykj13t1SyEzM2KD9P4heBud5EJtxjRya6/mySt9wYwM7eu
         NdfE7PZ2BMXC/ZWU6GUQhnIc4VBdGSRRVXCGhdOuRvB4uolQCPYr01huCDfYWgGocBsK
         MtA3RzZtGx+sFYToqAHpwUJNy/xcpXec7ExHo9B8YIpVg9nP/O2kWlTRg1VJAEUAWG8w
         JMz8RddKQUXL/ISqpYHIGX1sw+vt39bfYbZWqiToro64YjHlYkeMWS87ehpAE77MEI2+
         ArMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Jps7p+7emVos88H/xl9wAvfrJF2VcfG9jOAx3iDsxr8=;
        b=RiN44tmWNQj6E2g0x1JgF/LHgGzU+MIJFoTPn7ebZvygJrCdvH4TAytko3FOyRajrh
         dhm2+j+CLMiu61b4J+ml2F4xEIdBaKcQ0KDKtn88CkB1XP6eelBK3wh3iCiK//0SnJ3J
         vtW4EnAnWFbXEpKOVWHt5/MZUSqfC8aE/0QPBVLvjKeT3Sg5eujXR1LVMsEDJuIPXLm0
         ghrYN1xSFHyMBkZ4rLCQY/yduCTxbz1nL7kpxOA0r9RvZ9GTkdF1J7NaRfAAhl8qfDvA
         fm16nav733A193Lxg32NEnJyI17Ilfw1JpBaNEdTzVMrZz5eaSrhP+bWgzgBmcYS7FOW
         aaiA==
X-Gm-Message-State: APjAAAUvL3llN4T/IpAob9PuMNJzx8yaFlgRE7WyCFNH3FfYvmgoEgtC
        BUlEQWIzYklRODW5Mqe51PU=
X-Google-Smtp-Source: APXvYqyaIisgQY39onQa+j/yqCLXowsHRpFmbKJbLSUA6O9VZkmyMGUf59vPuFp6Sh7EeXuaKo+0XQ==
X-Received: by 2002:a05:600c:1009:: with SMTP id c9mr922284wmc.6.1572293556028;
        Mon, 28 Oct 2019 13:12:36 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f17:6e00:9578:29b8:2cd4:8cd8? (p200300EA8F176E00957829B82CD48CD8.dip0.t-ipconnect.de. [2003:ea:8f17:6e00:9578:29b8:2cd4:8cd8])
        by smtp.googlemail.com with ESMTPSA id t4sm564368wmi.39.2019.10.28.13.12.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Oct 2019 13:12:35 -0700 (PDT)
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
Message-ID: <05887c69-f2e5-b8a0-e8a0-60e1279dcb1b@gmail.com>
Date:   Mon, 28 Oct 2019 21:12:27 +0100
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
for this one I don't have the datasheet, therefore I didn't
consider it. Then we can add downshift support for 88E1145
in a follow-up patch, similar to patch 4.

>   Andrew
> 
Heiner
