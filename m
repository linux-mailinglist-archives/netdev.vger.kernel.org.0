Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15EA2754F9
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 11:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgIWJ5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 05:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbgIWJ5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 05:57:48 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6904DC0613CE
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 02:57:48 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id z22so26867555ejl.7
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 02:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5IRW0SMItHDhaS3u2lCvznRB0gRyx3WYvHHqGWqFwBs=;
        b=FbMEs/oCfsI+4GzvqP5SqO6bxVoovY2pCX9LQimkyuI2lG5EfH94hoMM6ELBHX1WZE
         ofsRMP9P/jTMsZeaNiYr6t6iSkLtNTwiCfuvY8+M48nHMrMmAc3Vc0VERoRfI5sk6DTW
         EuN9erJtDUInfBBpzPb6ef9kfQky53a0Bhbz/zrWthhMfGqcuvh8swUKcwBGeLv9ijcE
         ymTW1JjrD3mo2hOe0GRzFqkfcIG0rhDL+BjkguXYGw8JgUk/vj5Q60FSR47DSq89lxE7
         F9WpeEJ7Z5+WQumMFM7RLajPDbBpeCKiblzb3D5J7gIWhT+SDz/xlwcv1XXLPCFP20W5
         WFUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5IRW0SMItHDhaS3u2lCvznRB0gRyx3WYvHHqGWqFwBs=;
        b=YJAYXhLFJEDu8zfjMMJTRtFXQoi0FYXaz96vIY4SzQ5p9icSH9SBLX3hdoNDHqqiFH
         T6uxq9wjSmthx983vO9dTg9vepT9YKZ7PM183Np3c4WkIvP7rfWJDxVWRJ1O/2SlFexa
         r+BQOtr6wpd+Ux7ouwq6KBPE2hIoO8MucboX0uQhIKQyhVI58hC9+Jb2M+loR/a50asd
         cd9JJFuOkeWwrACdgkkD+GYOarZg4FFHVumxT+C7ia0OpWHq8pmYKlLXIMT4V6HoyXfr
         Lw8F48t102Kgblzrofs/A2YDYr03L8cHphwtj07TxxScmGO8kmKbPDHvJAvFwBcqfMGX
         f3Xw==
X-Gm-Message-State: AOAM533XRSJ7jOdk3seIKL0HAiTC3xJlP0iFsW/dnNgQBvHfcUwy/OGA
        xxKwrvLk/33E5fztV7Tjwhk7tlcgn04=
X-Google-Smtp-Source: ABdhPJxwJOKk9mDW4c/FZwWQQrE3baKdAMHiaRxktgSoFxFY4xeXdx/fnLH1ijE+CUkvjNlmN/0riA==
X-Received: by 2002:a17:906:7f06:: with SMTP id d6mr9192249ejr.553.1600855066820;
        Wed, 23 Sep 2020 02:57:46 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:c43a:de91:4527:c1ba? (p200300ea8f235700c43ade914527c1ba.dip0.t-ipconnect.de. [2003:ea:8f23:5700:c43a:de91:4527:c1ba])
        by smtp.googlemail.com with ESMTPSA id o92sm14081456edd.68.2020.09.23.02.57.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 02:57:46 -0700 (PDT)
Subject: Re: RTL8402 stops working after hibernate/resume
To:     Petr Tesarik <ptesarik@suse.cz>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        netdev@vger.kernel.org
References: <20200715102820.7207f2f8@ezekiel.suse.cz>
 <d742082e-42a1-d904-8a8f-4583944e88e1@gmail.com>
 <20200716105835.32852035@ezekiel.suse.cz>
 <e1c7a37f-d8d0-a773-925c-987b92f12694@gmail.com>
 <20200903104122.1e90e03c@ezekiel.suse.cz>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <7e6bbb75-d8db-280d-ac5b-86013af39071@gmail.com>
Date:   Wed, 23 Sep 2020 11:57:41 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200903104122.1e90e03c@ezekiel.suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.09.2020 10:41, Petr Tesarik wrote:
> Hi Heiner,
> 
> this issue was on the back-burner for some time, but I've got some
> interesting news now.
> 
> On Sat, 18 Jul 2020 14:07:50 +0200
> Heiner Kallweit <hkallweit1@gmail.com> wrote:
> 
>> [...]
>> Maybe the following gives us an idea:
>> Please do "ethtool -d <if>" after boot and after resume from suspend,
>> and check for differences.
> 
> The register dump did not reveal anything of interest - the only
> differences were in the physical addresses after a device reopen.
> 
> However, knowing that reloading the driver can fix the issue, I copied
> the initialization sequence from init_one() to rtl8169_resume() and
> gave it a try. That works!
> 
> Then I started removing the initialization calls one by one. This
> exercise left me with a call to rtl_init_rxcfg(), which simply sets the
> RxConfig register. In other words, these is the difference between
> 5.8.4 and my working version:
> 
> --- linux-orig/drivers/net/ethernet/realtek/r8169_main.c	2020-09-02 22:43:09.361951750 +0200
> +++ linux/drivers/net/ethernet/realtek/r8169_main.c	2020-09-03 10:36:23.915803703 +0200
> @@ -4925,6 +4925,9 @@
>  
>  	clk_prepare_enable(tp->clk);
>  
> +	if (tp->mac_version == RTL_GIGA_MAC_VER_37)
> +		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_DMA_BURST);
> +
>  	if (netif_running(tp->dev))
>  		__rtl8169_resume(tp);
>  
> This is quite surprising, at least when the device is managed by
> NetworkManager, because then it is closed on wakeup, and the open
> method should call rtl_init_rxcfg() anyway. So, it might be a timing
> issue, or incorrect order of register writes.
> 
Thanks for the analysis. If you manually bring down and up the
interface, do you see the same issue?
What is the value of RxConfig when entering the resume function?

> Since I have no idea why the above change fixes my issue, I'm hesitant
> to post it as a patch. It might break other people's systems...
> 
> Petr T
> 
Heiner
