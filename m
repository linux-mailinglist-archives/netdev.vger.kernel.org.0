Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1331CC4DC
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 00:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbgEIWEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 18:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgEIWEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 18:04:07 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008D7C061A0C;
        Sat,  9 May 2020 15:04:06 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id f6so2616629pgm.1;
        Sat, 09 May 2020 15:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vO45rBzZP4qUYAWgoBky++9H1SklKJ9deQfkRumUR9E=;
        b=O0aejT9n9lWNzQ84KsiOjKdl0XezkuotcorNzy23hjxOQSHP7Cnsz7huf1y49juoGZ
         NQgEh89BmCfwgaAbh81YYwmHHQAQU4IKbjJ+idanpEpaWGySieubEYLuB8awUNCzgUgj
         wmVCVCCYZxjO/msPpKY/TLgb5IfgUcOQzgYpdek5cNnI+XbzhrHl9xTYepRdkbF4IX8I
         0Ss8gPgnTsrRELU5YEkCTrUuk2Kw94M19uOjtaVdHwUcJ1JRt6iGLYx0is6C3+PhDTJR
         MzBcyjz7b4fFtr+Cqr8qJY96MFUXBKUcIFWg3EFtwIN5ymhvx3/lHu53WDVUPyaxR7Yj
         efCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vO45rBzZP4qUYAWgoBky++9H1SklKJ9deQfkRumUR9E=;
        b=cBuvEU61vOiOiR05gPgjYh6yQ+pjnL7nP88SU49xx+/9Dyou32dl7/QQEQw26H5n6+
         X2r0GTAgx4BO8NPljdqf5NEV6JCBtJ4Q0TPyyLV4NyiYUUpfdfy2I78AW+BsYQT1YiL/
         UT+JIfOMTMc+cthdM/HfDCywwmgWFHGI4OFdCULsQxiVAGLrba4RchhOS0zfUC5W5yWg
         n8yDRmq/xUl2A9rLUlMoMmFb5kjD6wyem33L+cUY6k0v5JNpN7N/uRol5oZAhyc7Mkpq
         6QSHZqevXjD5QBB1LkqQnVfVLDdRNh8/SGHNOHTpO/YPBvZ7wJgfa5QkmIZk/vFNJjTn
         iTRg==
X-Gm-Message-State: AGi0PubzE4ul0YqnzKmiHH/l8SBZ9YpNvtaDWeOLCiIu+hMjUWf8SlBz
        028Tsy+wjfh8KUM0Az87+Xk=
X-Google-Smtp-Source: APiQypJwPAL8GEOL7Ni5ovhZVrk3VmVmieCEJOLH26UkAdgiAiK+lGtjPOQPa79DdEXH6T+lLuOj9g==
X-Received: by 2002:aa7:9d90:: with SMTP id f16mr9891947pfq.48.1589061846362;
        Sat, 09 May 2020 15:04:06 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id e4sm4459145pge.45.2020.05.09.15.04.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 May 2020 15:04:05 -0700 (PDT)
Subject: Re: [PATCH] net: freescale: select CONFIG_FIXED_PHY where needed
To:     Arnd Bergmann <arnd@arndb.de>, Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Timur Tabi <timur@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
References: <20200509120505.109218-1-arnd@arndb.de>
 <20200509132427.3d2979d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAK8P3a0figw8FHGp2KqW6XdfbWLu_ZXp3hyuPVoPwpum6XeJ_Q@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <bce24dff-5287-76e2-ba85-8d31d7e673f8@gmail.com>
Date:   Sat, 9 May 2020 15:04:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a0figw8FHGp2KqW6XdfbWLu_ZXp3hyuPVoPwpum6XeJ_Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/9/2020 2:48 PM, Arnd Bergmann wrote:
> On Sat, May 9, 2020 at 10:24 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Sat,  9 May 2020 14:04:52 +0200 Arnd Bergmann wrote:
>>> I ran into a randconfig build failure with CONFIG_FIXED_PHY=m
>>> and CONFIG_GIANFAR=y:
>>>
>>> x86_64-linux-ld: drivers/net/ethernet/freescale/gianfar.o:(.rodata+0x418): undefined reference to `fixed_phy_change_carrier'
>>>
>>> It seems the same thing can happen with dpaa and ucc_geth, so change
>>> all three to do an explicit 'select FIXED_PHY'.
>>>
>>> The fixed-phy driver actually has an alternative stub function that
>>> theoretically allows building network drivers when fixed-phy is
>>> disabled, but I don't see how that would help here, as the drivers
>>> presumably would not work then.
>>>
>>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>>
>>> +     select FIXED_PHY
>>
>> I think FIXED_PHY needs to be optional, depends on what the board has
>> connected to the MAC it may not be needed, right PHY folks? We probably
>> need the
>>
>>     depends on FIXED_PHY || !FIXED_PHY
> 
> Unfortunately that does not work because it causes a circular dependency:
> 
> drivers/net/phy/Kconfig:415:error: recursive dependency detected!
> drivers/net/phy/Kconfig:415: symbol FIXED_PHY depends on PHYLIB
> drivers/net/phy/Kconfig:250: symbol PHYLIB is selected by FSL_PQ_MDIO
> drivers/net/ethernet/freescale/Kconfig:60: symbol FSL_PQ_MDIO is
> selected by UCC_GETH
> drivers/net/ethernet/freescale/Kconfig:75: symbol UCC_GETH depends on FIXED_PHY
> 
> I now checked what other drivers use the fixed-phy interface, and found
> that all others do select FIXED_PHY except for these three, and they
> are also the only ones using fixed_phy_change_carrier().
> 
> The fixed-phy driver is fairly small, so it probably won't harm too much
> to use the select, but maybe I missed another option.

select FIXED_PHY appears the correct choice here we could think about
providing stubs if that is deemed useful, but in general these drivers
do tend to have a functional dependency on the fixed PHY and MDIO bus
subsystems.

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
