Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF609278B31
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 16:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbgIYOsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 10:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728888AbgIYOsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 10:48:02 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE8DC0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 07:48:02 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id i26so3954636ejb.12
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 07:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ElKTjAd4r0ALv/sZKmtwjIsj1xkk3YEDvQvg0RGLiIU=;
        b=M7n8oC2a/nBsDW9KN5wBuC8jKF1zyLYjsxkuZd1xBhhJU/1kcHPUpnylaRoGEWOEhW
         sKj4Im/uid0bE7l9Ez317BIqcng/es3zOPTWbOLoOtgZzmwkGkTRA1dDXLOIXroAZtl1
         V2B5+ArykgHRvYy6/zb73kabMP2nKWG9ij575lbRpeX8C5zM2mGnqau7wXp761kJ7sm6
         783zyRYbQbdW99dFRc8riomlqtihHKnVTwFYwhrEBPyCi4EWuWu7thWHJN/XwoECh+5b
         QUA82oFTkZx3/4I8PVT/iKBoGQtQiTyzeApPCH7jiBVRti0urYFFwhyXm/1Km8X1VG5R
         StYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ElKTjAd4r0ALv/sZKmtwjIsj1xkk3YEDvQvg0RGLiIU=;
        b=Q8wUtqUtvJfrSW9qy1ZyHGaiZUFcf8qdRJf7vWVyQNlcnyQ8FDi0F/K2160lIMc75B
         17XMhkqfAe8YeiVK87onS1L+ud5s3/rhz0PZDn1kIizXdWfd1D22ZWxmQdiO9fF/T6Y9
         fjALr91M2HqRFa0KOXMBkxzAdGqkdIyd8uoJ+M8R0VWgNdx/xF2fgXb3DOVfomnzTh3z
         Rp9GL19lCVYFSQvMMqR1zmQZpYQn2kUVy3OZznJp92rovKqtwU+z94aB7Wumxmm7i1+W
         Tb2DfutkbWj2FWDLfJIk+6bDSG8wFcA0GYLrdQVtmNYSK7PkjBWbibhDiQDQctzkTJsx
         sG4w==
X-Gm-Message-State: AOAM5304+J02cb5xspHykrpy/53d1wpAK5y/LCc9u8/6KvGZKEX33Ejt
        OAYoFD5fMsUB41Z6PeAdbLZUL6+/aAM=
X-Google-Smtp-Source: ABdhPJwJz1b2lzG9UEEabcaH6gV6IADN9a1KfJGQlr4EZjl9FWuSerGHbD2qKqpWvs0LJMyEUaWRJQ==
X-Received: by 2002:a17:907:2506:: with SMTP id y6mr2916693ejl.265.1601045280181;
        Fri, 25 Sep 2020 07:48:00 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:4d7a:f898:eecc:8621? (p200300ea8f2357004d7af898eecc8621.dip0.t-ipconnect.de. [2003:ea:8f23:5700:4d7a:f898:eecc:8621])
        by smtp.googlemail.com with ESMTPSA id r16sm2013709edc.57.2020.09.25.07.47.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 07:47:59 -0700 (PDT)
Subject: Re: RTL8402 stops working after hibernate/resume
To:     Petr Tesarik <ptesarik@suse.cz>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        netdev@vger.kernel.org
References: <20200715102820.7207f2f8@ezekiel.suse.cz>
 <d742082e-42a1-d904-8a8f-4583944e88e1@gmail.com>
 <20200716105835.32852035@ezekiel.suse.cz>
 <e1c7a37f-d8d0-a773-925c-987b92f12694@gmail.com>
 <20200903104122.1e90e03c@ezekiel.suse.cz>
 <7e6bbb75-d8db-280d-ac5b-86013af39071@gmail.com>
 <20200924211444.3ba3874b@ezekiel.suse.cz>
 <a10f658b-7fdf-2789-070a-83ad5549191a@gmail.com>
 <20200925093037.0fac65b7@ezekiel.suse.cz>
 <20200925105455.50d4d1cc@ezekiel.suse.cz>
 <aa997635-a5b5-75e3-8a30-a77acb2adf35@gmail.com>
 <20200925115241.3709caf6@ezekiel.suse.cz>
 <20200925145608.66a89e73@ezekiel.suse.cz>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <30969885-9611-06d8-d50a-577897fcab29@gmail.com>
Date:   Fri, 25 Sep 2020 16:47:54 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200925145608.66a89e73@ezekiel.suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.09.2020 14:56, Petr Tesarik wrote:
> On Fri, 25 Sep 2020 11:52:41 +0200
> Petr Tesarik <ptesarik@suse.cz> wrote:
> 
>> On Fri, 25 Sep 2020 11:44:09 +0200
>> Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>>> On 25.09.2020 10:54, Petr Tesarik wrote:  
>> [...]
>>>> Does it make sense to bisect the change that broke the driver for me, or should I rather dispose of this waste^Wlaptop in an environmentally friendly manner? I mean, would you eventually accept a workaround for a few machines with a broken BIOS?
>>>>     
>>> If the workaround is small and there's little chance to break other stuff: then usually yes.
>>> If you can spend the effort to bisect the issue, this would be appreciated.  
>>
>> OK, then I'm going to give it a try.
> 
> Done. The system freezes when this commit is applied:
> 
> commit 9f0b54cd167219266bd3864570ae8f4987b57520
> Author: Heiner Kallweit <hkallweit1@gmail.com>
> Date:   Wed Jun 17 22:55:40 2020 +0200
> 
>     r8169: move switching optional clock on/off to pll power functions
> 
This sounds weird. On your system tp->clk should be NULL, making
clk_prepare_enable() et al no-ops. Please check whether tp->clk
is NULL after the call to rtl_get_ether_clk().

    
>     Relevant chip clocks are disabled in rtl_pll_power_down(), therefore
>     move calling clk_disable_unprepare() there. Similar for enabling the
>     clock.
>     
>     Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> I cannot be sure this is related to the malfunction after resume reported earlier, but it again touches the suspend/resume path...
> 
> Anything else I should try?
> 
> Petr T
> 

