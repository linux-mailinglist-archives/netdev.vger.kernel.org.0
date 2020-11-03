Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3D92A3843
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 02:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgKCBPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 20:15:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbgKCBPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 20:15:46 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98787C0617A6;
        Mon,  2 Nov 2020 17:15:44 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id t14so12371126pgg.1;
        Mon, 02 Nov 2020 17:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xoqgQuozW5oeUPf4CYzqwAx5luKyVrcBIWtsSxo//oc=;
        b=UmCR742pXZ95PhnyDUM9lNeaGk+t71ddOr/Yx/dQFgpdWP0wYj9dGespx893SrJz3/
         CIElnPy0jWEkYXgKkwpsx6+Y2weY+wVr80Ar9IqlD33xYsdS22QYmufYnuPaz/31IJPL
         IkMO1Wt5mG9GJ1enacxJxaOmSrBQF/afxOq8rGVmIivqI0KQi7WJexA2oi0J4OknILex
         uJKUD3clFAZUyLrPuQJnTjJkIy59rt/HsPDyuSug1JWX6inzelNTdriD0RNQ1JBnEEiq
         32X96FFF9EhiEBINnmPqoIxWK8yDABWUkRUdNOpqWoDYmMLbH0ZlI91vUs/qwSBkPhuv
         aBsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xoqgQuozW5oeUPf4CYzqwAx5luKyVrcBIWtsSxo//oc=;
        b=SvyT9Tqy4OeIDO+aJX0cefqsrCscXrOdQBi7Tej/hswcpE9mx99UEzcyBfkWkk20Rw
         ahkqhh0LMsHrXWJCv4pljwduWTs7ynGXTRQfCyyBrfZwrLVJLhfIokUbd7p55d8G2K6N
         GYv90e+O5kRE1lsb4HfSGF/i2pIpBO+FCdOWefs7suZDBqS+E60PnGNWgy4JDrVJDguD
         iBBLTMcYGmByatajGlSlkNlddwB5g5Pbe3u5vW1pM4e9OYzeHeo15nlF118h250h2P1Q
         MBrlrQOkbnD+PZidciGL+r11yhIiEsrtSwROEaayqRycl3UlO3BJPBfMc8r71BagXgXF
         he7w==
X-Gm-Message-State: AOAM532WDzqH3aRicoECtIC1l0o6thmdbWyE+6679U9yzfXSIWnncg/H
        xVnUIpOr6XXjUdR/XUaVpoo=
X-Google-Smtp-Source: ABdhPJwouVsRBWLk0ddYKFjXwCr+PGhhQ2IcQFjcccYAm3gpVedigxELC15fWgkEEj98ZAyxRed+ng==
X-Received: by 2002:a17:90b:a05:: with SMTP id gg5mr985229pjb.214.1604366144028;
        Mon, 02 Nov 2020 17:15:44 -0800 (PST)
Received: from [10.230.28.234] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e2sm14004100pgd.27.2020.11.02.17.15.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 17:15:43 -0800 (PST)
Subject: Re: [PATCH 1/2] ethernet: igb: Support PHY BCM5461S
To:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     Jeffrey Townsend <jeffrey.townsend@bigswitch.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        John W Linville <linville@tuxdriver.com>
References: <20201102231307.13021-1-pmenzel@molgen.mpg.de>
 <20201102231307.13021-2-pmenzel@molgen.mpg.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <cdcaf9fa-4983-934f-0d9c-09588fe07901@gmail.com>
Date:   Mon, 2 Nov 2020 17:15:41 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201102231307.13021-2-pmenzel@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/2/2020 3:13 PM, Paul Menzel wrote:
> From: Jeffrey Townsend <jeffrey.townsend@bigswitch.com>
> 
> The BCM5461S PHY is used in switches.
> 
> The patch is taken from Open Network Linux, and it was added there as
> patch
> 
>     packages/base/any/kernels/3.16+deb8/patches/driver-support-intel-igb-bcm5461X-phy.patch
> 
> in ONL commit f32316c63c (Support the BCM54616 and BCM5461S.) [1]. Part
> of this commit was already upstreamed in Linux commit eeb0149660 (igb:
> support BCM54616 PHY) in 2017.
> 
> I applied the forward-ported
> 
>     packages/base/any/kernels/5.4-lts/patches/0002-driver-support-intel-igb-bcm5461S-phy.patch
> 
> added in ONL commit 5ace6bcdb3 (Add 5.4 LTS kernel build.) [2].
> 
> [1]: https://github.com/opencomputeproject/OpenNetworkLinux/commit/f32316c63ce3a64de125b7429115c6d45e942bd1
> [2]: https://github.com/opencomputeproject/OpenNetworkLinux/commit/5ace6bcdb37cb8065dcd1d4404b3dcb6424f6331
> 
> Cc: Jeffrey Townsend <jeffrey.townsend@bigswitch.com>
> Cc: John W Linville <linville@tuxdriver.com>
> Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
> ---

[snip]

> +
> +/**
> + *  igb_phy_init_script_5461s - Inits the BCM5461S PHY
> + *  @hw: pointer to the HW structure
> + *
> + *  Initializes a Broadcom Gigabit PHY.
> + **/
> +s32 igb_phy_init_script_5461s(struct e1000_hw *hw)
> +{
> +	u16 mii_reg_led = 0;
> +
> +	/* 1. Speed LED (Set the Link LED mode), Shadow 00010, 0x1C.bit2=1 */
> +	hw->phy.ops.write_reg(hw, 0x1C, 0x0800);
> +	hw->phy.ops.read_reg(hw, 0x1C, &mii_reg_led);
> +	mii_reg_led |= 0x0004;
> +	hw->phy.ops.write_reg(hw, 0x1C, mii_reg_led | 0x8000);
> +
> +	/* 2. Active LED (Set the Link LED mode), Shadow 01001, 0x1C.bit4=1, 0x10.bit5=0 */
> +	hw->phy.ops.write_reg(hw, 0x1C, 0x2400);
> +	hw->phy.ops.read_reg(hw, 0x1C, &mii_reg_led);
> +	mii_reg_led |= 0x0010;
> +	hw->phy.ops.write_reg(hw, 0x1C, mii_reg_led | 0x8000);
> +	hw->phy.ops.read_reg(hw, 0x10, &mii_reg_led);
> +	mii_reg_led &= 0xffdf;
> +	hw->phy.ops.write_reg(hw, 0x10, mii_reg_led);

Please try at least to re-use the definitions from
include/linux/brcmphy.h and add new ones where appropriate.

It is already painful enough to see that Intel does not use the PHY
library, there is no need to add insult to the injury by open coding all
of these register addresses and values.

Thanks
-- 
Florian
