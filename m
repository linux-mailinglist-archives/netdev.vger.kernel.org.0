Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D05437EBF
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 21:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234119AbhJVTlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 15:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233926AbhJVTlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 15:41:05 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB99DC061764;
        Fri, 22 Oct 2021 12:38:47 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id u6so3477351ple.2;
        Fri, 22 Oct 2021 12:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GZCUVRdlGz5w64scpwW1qRIwHRq4zFtCZuM+xqeebBQ=;
        b=hZ+HYle2YZzqBTgOVO5MxddMNEJji9Ufx1jwtK5X/1CtQzyU48JVJgVzxdD6wXzCeU
         xa/5b0IfZulerMDhBecZKTv6TkISh5YlqiXg9xk5Yn8z9a2ge7dsMoaHerGZQeg1PpEa
         z62hM5UszWb7TulKnxGXvVNAuFQIe+pLlY4Fm/+BJ4YzwRCG0YNAbd/J6ayvjEqtBFMT
         83umv2PB0vPlal3DEsqw8SF6hzXHTPliMu9Ql49zklm2LzCvnuCnp+32hSalA9HTPvO8
         FE5zYi4nAw2tryWck5XCz9KqVt6NCox80hapRkT2X+ZXosakM/PPF66CKIekelnHgt0m
         K2Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GZCUVRdlGz5w64scpwW1qRIwHRq4zFtCZuM+xqeebBQ=;
        b=Lco1gD6XqfLK8NL286USIk7m4JKA43NXKlhWI0QOhubUBAOw3LV8AQF0O2dM/M/fuq
         V5CpRPLNhTkInCtTHujrKQEoKDV/hdluDsuOfeyY8XQ+J85cS1LcfEEDdouaMR06Teoz
         V3RAJHfteEJtllZaG3YGsgkhi32KLFsVINN8mH1buhVEl7FpJ8PlvJ6Thq5T94eaKx+9
         6+P+MtCBkFM8KWfMaExVC8APgJ5PLOTE0ui5/wEHCfsv8pBiMyzC4zCiIjr3KWKPL4iq
         jae66oH2SQ1uGOqgtwy7DoEQIrh6UuBu19YmpGFBTygnNtXggnKb/GYLpadlBbNoWlup
         S2ew==
X-Gm-Message-State: AOAM531IFBic+iNH/VWBDOV5agZbWDvfR2LSRDlSUsik63up/PlQO4jS
        Tht7kPjJp3tpm3MuKv4c4gI6rBYElhc=
X-Google-Smtp-Source: ABdhPJw+/2FLK1F69Yl0+ofWGavBusDIyEsyTcD1i6WJCtZJjg3RKyNC/MRq94CTRsLVeCgnkkUFDQ==
X-Received: by 2002:a17:90a:f0d8:: with SMTP id fa24mr10428610pjb.113.1634931526887;
        Fri, 22 Oct 2021 12:38:46 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id m4sm2802552pjl.11.2021.10.22.12.38.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 12:38:46 -0700 (PDT)
Subject: Re: [PATCH net-next 3/3] net: bcmgenet: Add support for 7712 16nm
 internal EPHY
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:BROADCOM GENET ETHERNET DRIVER" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20211022161703.3360330-1-f.fainelli@gmail.com>
 <20211022161703.3360330-4-f.fainelli@gmail.com> <YXMS23QSf55r8vBT@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2da4e5f6-63d8-73d6-7dbd-e3e541f91ac5@gmail.com>
Date:   Fri, 22 Oct 2021 12:38:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YXMS23QSf55r8vBT@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew,

On 10/22/21 12:36 PM, Andrew Lunn wrote:
> On Fri, Oct 22, 2021 at 09:17:03AM -0700, Florian Fainelli wrote:
>> The 16nm internal EPHY that is present in 7712 is actually a 16nm
>> Gigabit PHY which has been forced to operate in 10/100 mode.
> 
> Hi Florian
> 
> Will genphy_read_abilities() detect it as a 1G PHY? Does bcmgenet.c
> need to call phy_set_max_speed() to stop it advertising 1G?

That is not necessary, the capabilities have been adjusted accordingly,
the PHY only advertises 10/100 and not above.
-- 
Florian
