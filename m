Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9B85FDBD
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 22:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbfGDUWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 16:22:14 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39320 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfGDUWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 16:22:14 -0400
Received: by mail-pg1-f194.google.com with SMTP id u17so2812870pgi.6;
        Thu, 04 Jul 2019 13:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rm2kV9yaZ6s1nLYzpiwzizy1cuY+K/0vfHusQEBtFDM=;
        b=ud9QTMzGJeG2Qyeabj4fzxOdJKu5mdumwhrsjky4yMQq7wJ8ByIxEuufzWyoErxa9s
         CkOmBNUXfzP1M3k5xwCoOLl/RzbUovzSX02GiCSbK88NhfWpMngxl2bmNKWibY+xT2Sh
         m8gVPDLWkxwsXJKuCzlaueqbknNi1UDbNwIEfy1iyUCGvXDdNdd+FkAvrHO+AFh4U70H
         t/seI8sDEtoBLp+hK4PBTksFrWlxwtY1gnt3Ctv1Wxj1gEoDTCwIDyAQ2gZh94sjQ9f9
         EkaRxv8FOhN18Qc0576Gdt5BgL2sr0CWnfyFEzUi5v/636CkUckFb1wZG1ZR0okS1L0u
         7yXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rm2kV9yaZ6s1nLYzpiwzizy1cuY+K/0vfHusQEBtFDM=;
        b=GnPT1nfbGQ42rhINXszZiZBz/HueuxDPmRObZGwPVm8vlp2AZp7Ov0ptXVYl1nVSFk
         HFAtvz8QOBWvcrNJo0nY5jr62OzXbufEYDgJNNcUS1OuzE86tHVI3rTRnJs7PI2n34lB
         X3KwL11DKvo4N+5zd+VQaQ9FkWZBQr6pLSMIyttBMLRVNz5jqTepDPcwlBVDA5cqHspR
         X2WX+XL35NH099ntjIdqquNi+VHK+E+VJqWNlaNwUQaSt2Nnayi3e2SQNOjtl1eSesoX
         tFIQJCO1IFAKAMj2XjzQFnVI283YS82BX1jT+NxrloDLJHvthwj9iiXz8FGEPQy6bOzv
         OHtg==
X-Gm-Message-State: APjAAAX5EBFCCmcfEPNs67doABeU1nWOcQdGMHqwHIJ8z5OgmHqt9S05
        QlDaY1WIORI8cHe+b9sWoyDUz2Y9
X-Google-Smtp-Source: APXvYqw0FmRzchp1flwHU/JMjvxUB4wW47+nJXzUYXeaqj2quvFrpT0ZePaI26WjQLdltIjpdSLz0Q==
X-Received: by 2002:a63:e1e:: with SMTP id d30mr350264pgl.100.1562271733235;
        Thu, 04 Jul 2019 13:22:13 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id f62sm9479672pfb.143.2019.07.04.13.22.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 13:22:12 -0700 (PDT)
Subject: Re: [PATCH v2 1/4] net: dsa: Change DT bindings for Vitesse VSC73xx
 switches
To:     Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190703171924.31801-1-paweldembicki@gmail.com>
 <20190703171924.31801-2-paweldembicki@gmail.com>
 <CACRpkdb5LonYLpbOHj=Oo8Z7XjVUWoO0CuhOokxfSoY_fRinPw@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <ae24004f-64c5-fb80-db59-8ad7ecddfd95@gmail.com>
Date:   Thu, 4 Jul 2019 13:22:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CACRpkdb5LonYLpbOHj=Oo8Z7XjVUWoO0CuhOokxfSoY_fRinPw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/4/2019 12:05 AM, Linus Walleij wrote:
> On Wed, Jul 3, 2019 at 7:21 PM Pawel Dembicki <paweldembicki@gmail.com> wrote:
> 
>> This commit introduce how to use vsc73xx platform driver.
>>
>> Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
> 
> Nice!
> 
>> +If Platform driver is used, the device tree node is an platform device so it
>> +must reside inside a platform bus device tree node.
> 
> I would write something like "when connected to a memory bus, and
> used in memory-mapped I/O mode, a platform device is used to represent
> the vsc73xx" so it is clear what is going on.

Agreed, with that fixed:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
