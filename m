Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86572C4CA1
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 02:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731984AbgKZBaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 20:30:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730646AbgKZBaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 20:30:10 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A23C061A52;
        Wed, 25 Nov 2020 17:30:09 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id e8so166687pfh.2;
        Wed, 25 Nov 2020 17:30:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7Wvzm+8lvRf1crH0kVSlHEeSP3AC7RZpdjWMOjFrfc0=;
        b=VlJmQqw5CyQNDdKTuVy5mY/62KO26UDN3VEAWM4bxt6Znu3rF9zL4LNjPsxbngin3P
         hLGxGWTsffQVJ9ntVX0zEXnKibMhzR2hq3cJ1Z0k0pjVmvQiF1I162+DiEiTHYtny6ak
         vFdFVzApOHp6ZGeq8iqccWSKeqAtJuSicn3JHUNfK1UEium9lEja/KkNwjkvKaExV66d
         GkmcdbvLNK2obo1qGR0h841zuoJfkszlMZzD9t3H1WdmBIOuLp8EGZtRgJoAMdr1kadl
         Ew+83OjlAIc44R7zygQYFxHTEk8TNR35RnRmu1aAyavUeJMiG+K4aVdtuOSRERQcnkUG
         yIqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7Wvzm+8lvRf1crH0kVSlHEeSP3AC7RZpdjWMOjFrfc0=;
        b=Q+YXMjXNbpvUmd12NufHFBBeO7vT1vgnoKammODQcwoId3beUd8ZG9SHQqvVFckoOr
         SpT0lHGiMsjd/FIbXjQPhF+4G/eLV4evhZ+0ZthStpT2l5waTp3jWeAfkxWcw05OMnt+
         IO5nXUSbrr5eS/Ao6csedaISd0UjS3O8/Pf8Sk323+YQ/6BsrnNGFU3qOU7/2xYqgbdV
         oPZrAptg5qHpVJazoWtd1wEU7m/YojMNmISc6akBhx8svUwVi3onk0PFBicDC1kP8xXI
         f0rFT1bEvVTVflrDnJSrSnB+qFBC95krBEB2YwFF8ybr+p3hwNiaan5eNx7c9p9cCl4j
         6CcA==
X-Gm-Message-State: AOAM533hLWg1ukYOKmcCjek54hE5Uh4T40LvaY0BKyi2PlVp6tJHT9XJ
        Vk7vNY7mddZT1Gy3BscmK+k=
X-Google-Smtp-Source: ABdhPJyR+uFeZik0HiCiPSUOWc3H9MqR3H9gbS1PAPs7A4YB/Q0hnX1H8IFas8y38DP6gwPKZhqS3Q==
X-Received: by 2002:a17:90a:be0a:: with SMTP id a10mr731610pjs.15.1606354209452;
        Wed, 25 Nov 2020 17:30:09 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s26sm2989081pgv.93.2020.11.25.17.30.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2020 17:30:08 -0800 (PST)
Subject: Re: [RFC 0/4] net: l2switch: Provide support for L2 switch on i.MX28
 SoC
To:     Andrew Lunn <andrew@lunn.ch>, Lukasz Majewski <lukma@denx.de>
Cc:     Peng Fan <peng.fan@nxp.com>, Fugang Duan <fugang.duan@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>, stefan.agner@toradex.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        krzk@kernel.org, "David S . Miller" <davem@davemloft.net>,
        NXP Linux Team <linux-imx@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-arm-kernel@lists.infradead.org
References: <20201125232459.378-1-lukma@denx.de>
 <20201126000049.GL2073444@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c717666c-8357-60a2-7c66-5d9e9f18d250@gmail.com>
Date:   Wed, 25 Nov 2020 17:30:04 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201126000049.GL2073444@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/25/2020 4:00 PM, Andrew Lunn wrote:
> On Thu, Nov 26, 2020 at 12:24:55AM +0100, Lukasz Majewski wrote:
>> This is the first attempt to add support for L2 switch available on some NXP
>> devices - i.e. iMX287 or VF610. This patch set uses common FEC and DSA code.
> 
> Interesting. I need to take another look at the Vybrid manual. Last
> time i looked, i was more thinking of a pure switchdev driver, not a
> DSA driver. So i'm not sure this is the correct architecture. But has
> been a while since i looked at the datasheet.

Agreed the block diagram shows one DMA for each "switch port" which
definitively fits more within the switchdev model than the DSA model
that re-purposes an existing Ethernet MAC controller as-is and bolts on
an integrated or external switch IC.
-- 
Florian
