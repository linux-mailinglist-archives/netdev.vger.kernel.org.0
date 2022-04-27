Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE6E511235
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 09:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358709AbiD0HTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 03:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358768AbiD0HTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 03:19:01 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2981F18382
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 00:15:35 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id d5so1161242wrb.6
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 00:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fXZXEpIVMPXhXH04Yni5aGscWoHRA0fCF9kz5WmJ7uw=;
        b=sDBAsClbz/WMOLI2obaCI1aCr2rWGYlhh6lwFaMjoYj4ZS3i97wfb5syfYyy5CWOIJ
         fw6qKaX1koK56+3Y17m1gyhaafClvAhHTOrw0IfZKJBrwUTFpiD3K9VtuwfvTfCIU4vH
         a4j8rGrPuqMXiYTV45t1WQT3BUpDxkhDyyQAQB78HPQCDR1WBW75Rpt0ZOG6h7Zn55oP
         AyAU93EPd7GODj7O853aBbUEcDrRbOHLLp2jfZ+L3SLAnYbApqRwHW/UW3lnnoBuhOoO
         YmOqEmZrxvsH4n/Xj01Aj/DczqW5wdBmNy5Tzj78ho6RsbK1OmQLIn6U1qI6lpVOZlKO
         1PDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fXZXEpIVMPXhXH04Yni5aGscWoHRA0fCF9kz5WmJ7uw=;
        b=iH7rHSFy+nT+dmnzIX1kA634A0EHQjUX77m7Y25X/NOK6jgsD5jfJp92F8dkeVt7jt
         wEPmiVUdujTgDWXZzZhA7LLT6yArF2qYuTtlDFAFTcMAD0uON0MeG1O1DyekNLwOhkxG
         2Q5AHIHGeyZdXImPDBVuMrsPgTVTAN2LWFB1iRtT8N6e0YDb77e7IrKgnVRBMnvdBH4s
         aU1RXl/Rc0Nk5WDSC5pw+h2f15iSi4ZUFaZ1/uE0txkcHbtQbeKfsmbDn9COMo8mZK2a
         Hd8x8rxlCKu33QH2Semr4MHF5AMO9RWDx8x3A9lLcq7TuBteJtcGzFwBgDXWgxti8dAQ
         ze7Q==
X-Gm-Message-State: AOAM531bfQjLGzExDoJCKqGicdCa0m2NZGBMNmFbjYyLC1P4FHnEztKZ
        +sfN/cQPo3qaNWw4HRLlZRgX4Q==
X-Google-Smtp-Source: ABdhPJwgrg7QM+qaMP3/o/7TAnWFNAPJ55jjzdV8Ty4/msgbadPuGapryoWKWURMrX106PpqsRIa2g==
X-Received: by 2002:a5d:6988:0:b0:20a:dff5:54c with SMTP id g8-20020a5d6988000000b0020adff5054cmr8260916wru.55.1651043733925;
        Wed, 27 Apr 2022 00:15:33 -0700 (PDT)
Received: from [192.168.17.225] (bzq-82-81-222-124.cablep.bezeqint.net. [82.81.222.124])
        by smtp.gmail.com with ESMTPSA id az30-20020a05600c601e00b0038ebd950caesm937148wmb.30.2022.04.27.00.15.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 00:15:33 -0700 (PDT)
Message-ID: <f9769cbd-6c1e-0fee-d643-9b764fe98c61@solid-run.com>
Date:   Wed, 27 Apr 2022 10:15:31 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2 3/3] ARM: dts: imx6qdl-sr-som: update phy configuration
 for som revision 1.9
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, alvaro.karsz@solid-run.com,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>
References: <20220410104626.11517-1-josua@solid-run.com>
 <20220419102709.26432-1-josua@solid-run.com>
 <20220419102709.26432-4-josua@solid-run.com> <YmFNpLLLDzBNPqGf@lunn.ch>
 <YmFWFzYz/iV4t2cW@shell.armlinux.org.uk> <YmFcfhzOmi1GwTvS@lunn.ch>
 <YmFoKm0UvrSgD7kp@shell.armlinux.org.uk>
From:   Josua Mayer <josua@solid-run.com>
In-Reply-To: <YmFoKm0UvrSgD7kp@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

Am 21.04.22 um 17:20 schrieb Russell King (Oracle):
> On Thu, Apr 21, 2022 at 03:30:38PM +0200, Andrew Lunn wrote:
>>> The only other ways around this that I can see would be to have some
>>> way to flag in DT that the PHYs are "optional" - if they're not found
>>> while probing the hardware, then don't whinge about them. Or have
>>> u-boot discover which address the PHY is located, and update the DT
>>> blob passed to the kernel to disable the PHY addresses that aren't
>>> present. Or edit the DT to update the node name and reg property. Or
>>> something along those lines.
>> uboot sounds like the best option. I don't know if we currently
>> support the status property for PHYs. Maybe the .dtsi file should have
>> them all status = "disabled"; and uboot can flip the populated ones to
>> "okay". Or maybe the other way around to handle older bootloaders.
> ... which would immediately regress the networking on all SolidRun iMX6
> platforms when booting "new" DT with existing u-boot, so clearly that
> isn't a possible solution.

So to summarize - you don't want to see a third phy spamming the console 
with probe errors ...

I think a combination of the suggestions would be doable:
- Add the new phy to dt, with status disabled
- keep the existing phys unchanged
- after probing in u-boot, disable the two old entries, and enable the 
new one

It is not very convenient since that means changes to u-boot are necessary,
but it can be done - and won't break existing users only updating Linux.

sincerely
Josua Mayer

