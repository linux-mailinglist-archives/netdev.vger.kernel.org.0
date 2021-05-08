Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B9C3772B6
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 17:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbhEHPqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 11:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhEHPqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 11:46:23 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5278C061574;
        Sat,  8 May 2021 08:45:21 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id fa21-20020a17090af0d5b0290157eb6b590fso7219866pjb.5;
        Sat, 08 May 2021 08:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EyGIO+zb9FI2/JqagPe/JEsAThaV4XnNGT1Na66oGes=;
        b=BwwAgEd4Bol14g0pvsBZDRQ8VPvHWsegSDmxMFJTvNoy/Ahgkp1UZ6Zj+Gxojl6wVy
         /JTPHPtW8NHoTkTIfBJEz+Weu6Ffu4mJp+DthVDRd3DKxjCr9EroqNG9y3MEp4tTwNbt
         VS2QIBh9YLExU6L6uwlLMbhMd3ypyXu7rHrSs1i7UKoPFzpScs6fHxg0Fz75e9E3Kyka
         p21KHyRf21IEJpjQW+CThUZ56xGNwcf5qMav45XJPLgL2BoRSYBIEFcdhWT7DvU0R/UU
         ZpL+wFKCFdWekfE2sCVRyyOkKhzsNYe4p+evBL3KRBkRcIUak1f9VfzzoVxHOLbFE3Fi
         XDkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EyGIO+zb9FI2/JqagPe/JEsAThaV4XnNGT1Na66oGes=;
        b=pKBeeDVlWxwBFpJ9C+uVcNGot8xloGqHuYXzzTIlv53MfiD9aXyg9XSawu27zMI7iA
         qrOZB8dpSmT6pLCnlENgV4aM2cchcrySuiYVvk0uqi2JkoCQw8P1MaWf6jjc4UVixqpe
         i4ctifDtTT32GECac0EBMg4L6Z1FmtRVuL2d3MlN/nFzwhuEovOr1pJEBphV7m1OzR0f
         z1Wvk/jqoti3bZ0XN8nMmWybDgbFP7xZEd+4nmK9A0NifXg8bKwb9lh75wO+Q8ahbZr7
         LI+kq05Yba7q9X4llNvHxOmJf0xZRUE7BBgR9Q02OXq6ldgJznYFR1vQGx21yCO9rptN
         5s4A==
X-Gm-Message-State: AOAM533wuCZs2NzjK8RQ94doE3yn2Nbp8UqQoxjEy1DMvcJs8cxKCZ0d
        ArcTUuOiGfdktRGvx0ATU52repPi+YM=
X-Google-Smtp-Source: ABdhPJwmEgE/d3pwWy/OTpkj4vTw5G2ogFBpWeV1KlJF+259iWr/NFagWAiWszfmf4Dqqh20CAFCYw==
X-Received: by 2002:a17:902:104:b029:ec:9fa6:c08 with SMTP id 4-20020a1709020104b02900ec9fa60c08mr15878036plb.10.1620488720940;
        Sat, 08 May 2021 08:45:20 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id u21sm7029024pfm.89.2021.05.08.08.45.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 May 2021 08:45:20 -0700 (PDT)
Subject: Re: [RFC PATCH net-next v4 28/28] net: phy: add qca8k driver for
 qca8k switch internal PHY
To:     Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <20210508002920.19945-28-ansuelsmth@gmail.com>
 <20210508043535.18520-1-dqfext@gmail.com>
 <YJZ2bE8j+nqnCEp8@Ansuel-xps.localdomain>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d778eae8-07da-dafd-3dac-29ea68ac4b17@gmail.com>
Date:   Sat, 8 May 2021 08:45:13 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YJZ2bE8j+nqnCEp8@Ansuel-xps.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/8/2021 4:30 AM, Ansuel Smith wrote:
> On Sat, May 08, 2021 at 12:35:35PM +0800, DENG Qingfang wrote:
>> On Sat, May 08, 2021 at 02:29:18AM +0200, Ansuel Smith wrote:
>>> Add initial support for qca8k internal PHYs. The internal PHYs requires
>>> special mmd and debug values to be set based on the switch revision
>>> passwd using the dev_flags. Supports output of idle, receive and eee_wake
>>> errors stats.
>>> Some debug values sets can't be translated as the documentation lacks any
>>> reference about them.
>>
>> I think this can be merged into at803x.c, as they have almost the same
>> registers, and some features such as interrupt handler and cable test
>> can be reused.
>>
> 
> Wouldn't this be a little bit confusing? But actually yes... interrupt
> handler and cable test have the same regs. My main concern is about the
> phy_dev flags and the dbg regs that I think are different and would
> create some confusion. If this It's not a proble, sure I can rework this
> a put in the at803x.c phy driver.

Consistency is key, and having all of your PHY eggs in the same PHY
driver basket is easier for maintenance and generalizing features.
drivers/net/phy/broadcom.c contains PHY entries for integrated PHY
switches, too (5395, 53125). As far as phydev::dev_flags, you can skip
interpreting those unless you match the QCA8K PHY driver entry/probe.
-- 
Florian
