Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA5513C2BE7
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 02:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbhGJAC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 20:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhGJAC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 20:02:56 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3540C0613DD;
        Fri,  9 Jul 2021 17:00:11 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id g16so4402858wrw.5;
        Fri, 09 Jul 2021 17:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/ToKfqB2/LE0FMUQeT/1EAFVR7oxlBlN4PscNIzCfaU=;
        b=daG/HfFK2oWjLnpy9YHGjcTnAL03AuRVzSjZ5lkxgxPDIuCg9mTXi+HILZyqNGaYTT
         FVa1AZjq2VE5quseDtr+uCK7YzSAa1/BPavXBiqDhq5FOgwb5P7lYnb3foB4a++NgWif
         w7NuV5XnamRzzqXaT8MoDuVaE39QvRcEu3//Be4MfUp3iap+7fxX03mwWPdGrg0s+NP0
         22Qqtp7M00kdtWt2ZEMGoANG7J/TTXYowwaR2PylvROOnz9k99mVBhjTGJFbhyAvweIG
         Quh/rBrLJ2x4oPos5VjwnCjyMc/n7y8kBCsCjCxX9UJZr5yrrwPRv6RTOVtvctNs95cl
         RiGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/ToKfqB2/LE0FMUQeT/1EAFVR7oxlBlN4PscNIzCfaU=;
        b=iQcWCDfdBMKQX4GiI6aRyjCyg2WqGXRpC7SN27JKOh7jX0Q7HpJvVGrabF1XINCoyL
         pfNgoDjN9oFylu0B5AG1ePrw5DNupapBcT2fnZoujS/7u0RzbvziBCg64KW/fCJXip47
         r/aiR72I9hNlZWvgYYbt07STvJALswjP04LMP9OP0XVHoTEzpqp8kVgInhBhl5krzwa+
         uGtazik2cO9OJmh2/JP6KNrzrx++9/0gVIdIaWvKrGGAT+kw5PBIpQ64iTcLGJpIokPc
         3efG1WOMd11014TqdPM3O4IKL7Quxx7l3X2Sle5tF/Jd366cE54rXqwa/vDyDtaAundS
         0seQ==
X-Gm-Message-State: AOAM532clvAwkGY06i3L+aS/cQycuw7qq8snMUDZMQD0XiUiyNCHQSly
        LI67hFOQJMtC4ZWtk8pNTNc=
X-Google-Smtp-Source: ABdhPJwJdjSswdq4zx8yU0EK8XUlpCZvJZlzDV3UbYcbR9awq9OauyBi4+IFHVSLkjTsH+Y0+E1q/w==
X-Received: by 2002:a5d:67cd:: with SMTP id n13mr44263664wrw.201.1625875210170;
        Fri, 09 Jul 2021 17:00:10 -0700 (PDT)
Received: from [192.168.2.202] (pd9e5a098.dip0.t-ipconnect.de. [217.229.160.152])
        by smtp.gmail.com with ESMTPSA id f82sm12060499wmf.25.2021.07.09.17.00.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jul 2021 17:00:09 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] mwifiex: pcie: add reset_d3cold quirk for Surface
 gen4+ devices
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
Cc:     =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
References: <20210709161251.g4cvq3l4fnh4ve4r@pali>
 <d9158206-8ebe-c857-7533-47155a6464e1@gmail.com>
 <20210709173013.vkavxrtz767vrmej@pali>
 <89a60b06-b22d-2ea8-d164-b74e4c92c914@gmail.com>
 <20210709184443.fxcbc77te6ptypar@pali>
 <251bd696-9029-ec5a-8b0c-da78a0c8b2eb@gmail.com>
 <20210709194401.7lto67x6oij23uc5@pali>
 <4e35bfc1-c38d-7198-dedf-a1f2ec28c788@gmail.com>
 <20210709212505.mmqxdplmxbemqzlo@pali>
 <bfbb3b4d-07f7-1b97-54f0-21eba4766798@gmail.com>
 <20210709225433.axpzdsfbyvieahvr@pali>
From:   Maximilian Luz <luzmaximilian@gmail.com>
Message-ID: <89c9d1b8-c204-d028-9f2c-80d580dabb8b@gmail.com>
Date:   Sat, 10 Jul 2021 02:00:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210709225433.axpzdsfbyvieahvr@pali>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/10/21 12:54 AM, Pali Rohár wrote:

[...]

>> Also not sure if this is just my bias, but it feels like the Surface
>> line always had more problems with that driver (and firmware) than
>> others.
> 
> Ehm, really? I see reports also from non-Surface users about bad quality
> of these 88W[89]xxx cards and repeating firmware issues. I have bad
> personal experience with 88W8997 SDIO firmware and lot of times I get
> advice about ex-Marvell/NXP wifi cards "do not touch and run away
> quickly".

Yeah, then I'm probably biased since I'm mostly dealing with Surface
stuff.

> I think that more people if they get mPCIe/M.2 wifi card in laptop which
> does not work, they just replace it with some working one. And not
> spending infinite time in trying to fix it... So this may explain why
> there are more Surface users with these issues...

That might be an explanation. If it wouldn't need a heat-gun to open it
up, I'd probably have done that at some point in the past (there were
times when WiFi at my Uni was pretty much unusable with this device...
and I'm still not sure what fixed that or even if it's fixed completely).

>> I'm honestly a bit surprised that MS stuck with them for this
>> long (they decided to go with Intel for 7th gen devices). AFAICT they
>> initially chose Marvell due to connected standby support, so maybe that
>> causes issue for us and others simply aren't using that feature? Just
>> guessing though.
> 
> In my opinion that "Connected Standby" is just MS marketing term.

I can only really repeat what I've been told: Apparently when they
started designing those devices, the only option with "Connected
standby" (or probably rather that feature set that MS wanted) was,
unfortunately for us, Marvell.

> 88W[89]xxx chips using full-mac firmware and drivers [*]. Full-mac lot
> of times causing more issues than soft-mac solution. Moreover this
> Marvell firmware implements also other "application" layers in firmware
> which OS drivers can use, e.g. there is fully working "wpa-supplicant"
> replacement and also AP part. Maybe windows drivers are using it and it
> cause less problems? Duno. mwifiex uses only "low level" commands and
> WPA state machine is implemented in userspace wpa-supplicant daemon.
> 
> [*] - Small note: There are also soft-mac firmwares and drivers but
> apparently Marvell has never finished linux driver and firmware was not
> released to public...
> 
> And there is also Laird Connectivity which offers their own proprietary
> linux kernel drivers with their own firmware for these 88W[89]xxx chips.
> Last time I checked it they released some parts of driver on github.
> Maybe somebody could contact Laird or check if their driver can be
> replaced by mwifiex? Or just replacing ex-Marvell/NXP firmware by their?
> But I'm not sure if they have something for 88W8897.

Interesting, I was not aware of this. IIRC we've been experimenting with
the mwlwifi driver (which that lrdmwl driver seems to be based on?), but
couldn't get that to work with the firmware we have. IIRC it also didn't
work with the Windows firmware (which seems to be significantly
different from the one we have for Linux and seems to use or be modeled
after some special Windows WiFi driver interface).
