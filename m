Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598F72316DF
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 02:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730836AbgG2AmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 20:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730507AbgG2AmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 20:42:17 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C550CC061794;
        Tue, 28 Jul 2020 17:42:17 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id w126so11836810pfw.8;
        Tue, 28 Jul 2020 17:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pQaiWRnOg2U3wniBNdLn9eHoMlUxqnrXd5V4+BRB/CY=;
        b=RpGU+Mei/engts5h8MouqvCWVDz34aRh2DPvpmniDB/n4eqpuuoA6/bwtKarGd3lWT
         HSSYkuuEhg3/JYeKhWkYEWB5Tn71LBUNKw9k5W4AHFZAapZPXYDEtkVXMF/6aeYOrWYx
         DokAermqnk4WkCTnfIfDnsWQaCi3peP9aLWNb0E4xzWHeeKjcMphsPAfbHpmJ2/RuOp2
         HDvUibZOENKu74R+gRgwt0XL8pUlh+GVrr8rve2AYqXtoNG420YNKj/fLlDJK23eEtVF
         Tjn/pV49kIy2PhDx51bCri7uZqEIDAIfKaKRzemC9JjNQIC4DFqwchzq53lx5UN79fxw
         CCDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pQaiWRnOg2U3wniBNdLn9eHoMlUxqnrXd5V4+BRB/CY=;
        b=NygP5tZ0bs7vCg0SK1byzM8DOnxn9mKXeLL/FDhg0NbqEj0/HwED3CLt9ad0rFDNn5
         SiMGBuA5/w88L0NK6QaKEkb/L4VS36ZkARajIrDY4T+7dHlj2w4X3gpJEFtft+cDZ6Ca
         mfiwuNnH04B9rxZIx53w57X3AfVLWp1VgeEnzN9U2AL0LoEDGlM4tc418eb/TUemuIIm
         JUO2/guAv1w0KGptBxVx5VwQLHvV44F9LbrHf5BI1jAXpIRqmQ26RfWILIp4BHuueajx
         Yg1cvTSL98Mmk2fAjywCUfRK3ARIiWbzPxhK5OByREr32mf//IROCTH3zrqSDP305qwt
         OOQQ==
X-Gm-Message-State: AOAM531Jhs7dyAVhbtSu0MADuZhREd0C5jU07oqGW+bCdHzzBCBiCQ3d
        o/pIy8aUHY6jzUPDj4rAARg=
X-Google-Smtp-Source: ABdhPJy3+gNRxf68LqN9TyA1VL3XQ71uc3syyud8ighvdATMLOr8IpjS/aIqVWwwKb2KHFGWL+aLNg==
X-Received: by 2002:a63:564e:: with SMTP id g14mr26522852pgm.326.1595983337353;
        Tue, 28 Jul 2020 17:42:17 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a2sm202775pgf.53.2020.07.28.17.42.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2020 17:42:16 -0700 (PDT)
Subject: Re: [net-next PATCH v7 0/6] ACPI support for dpaa2 MAC driver.
To:     David Miller <davem@davemloft.net>, calvin.johnson@oss.nxp.com
Cc:     rafael@kernel.org, lenb@kernel.org, Lorenzo.Pieralisi@arm.com,
        guohanjun@huawei.com, sudeep.holla@arm.com, ahs3@redhat.com,
        jeremy.linton@arm.com, linux@armlinux.org.uk, jon@solid-run.com,
        cristian.sovaiala@nxp.com, ioana.ciornei@nxp.com, andrew@lunn.ch,
        andy.shevchenko@gmail.com, madalin.bucur@oss.nxp.com,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        linux.cj@gmail.com, Paul.Yang@arm.com
References: <20200725142404.30634-1-calvin.johnson@oss.nxp.com>
 <20200728.173951.1166639369727479900.davem@davemloft.net>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c5691684-c666-7a6e-8442-b4b558df9c8b@gmail.com>
Date:   Tue, 28 Jul 2020 17:42:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200728.173951.1166639369727479900.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/2020 5:39 PM, David Miller wrote:
> From: Calvin Johnson <calvin.johnson@oss.nxp.com>
> Date: Sat, 25 Jul 2020 19:53:58 +0530
> 
>>  This patch series provides ACPI support for dpaa2 MAC driver.
>>  This also introduces ACPI mechanism to get PHYs registered on a
>>  MDIO bus and provide them to be connected to MAC.
>>
>>  Previous discussions on this patchset is available at:
>>  https://lore.kernel.org/linux-acpi/20200715090400.4733-1-calvin.johnson@oss.nxp.com/T/#t
>>
>>  Patch "net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver" depends on
>>  https://git.kernel.org/pub/scm/linux/kernel/git/lpieralisi/linux.git/commit/?h=acpi/for-next&id=c279c4cf5bcd3c55b4fb9709d9036cd1bfe3beb8
>>  Remaining patches are independent of the above patch and can be applied without
>>  any issues.
> 
> This really needs to be reviewed by phy/phylink people.

Oh it has been reviewed! We just have stalled for various reasons. There
is another email thread with the same subject which is still being
discussed:

https://lore.kernel.org/netdev/20200715090400.4733-1-calvin.johnson@oss.nxp.com/T/#t
-- 
Florian
