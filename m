Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D78D4C371
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 00:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730578AbfFSWOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 18:14:36 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36622 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfFSWOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 18:14:36 -0400
Received: by mail-wm1-f65.google.com with SMTP id u8so1085416wmm.1
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 15:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=C7dXNMpZ/PnE4ssC+RMhi/ByfdDT7v9LJrTngPMmeJ8=;
        b=B/fnEbMsE3Ds9+Q2fV5/qbvCjNQJVsOftx6bYIyzB+lzw1gW8sxEWJCXU2fesaJ1Gk
         75J4MPFU3KItER5B1ElPtPwSKSVFiiirJrvldRPEOk5cVUj4gN1KTsMDj4jIDJJCOs5k
         KrgX4vIxUBv2s7dEhCHGK7Cy5hjtDcHMLmX5FLgeAALGUlCppGvrQA5dyVgXZtc1DBnK
         FoTFqeFoJpH/UGbhMB+Lk6ntOEyPmbgsfT+M5UOObDx9CbEdk+uQprqagAYJJ1BOLdTi
         3wsIutn8INIe9RtrM/TA+JmcfLH7hlRFjoxVWcFNlXE1du5GYq6G1ZoEnUN+w6IxAxYN
         9WIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C7dXNMpZ/PnE4ssC+RMhi/ByfdDT7v9LJrTngPMmeJ8=;
        b=O+XRCAOucVQFDCw8xuhGS31QgzcIhhZRfXDpUZQjz0iDkLnxxD0UT4fua/WN4hHSOh
         n06A2TqcDj56LWuOMelvyDCXliprSZe+UwIb35D0yhAfpCYK18ui8WjH5gRoLMZcuCWM
         3nHXmSugHZ7NgpnP0bzbBOM3dewuXRWscBZwKOwVEWrCJmDKnDgqpVl2UO3uGuTI4D/E
         PRcOqVIqSz7PI9enZIlwYDEfyXQWC/k9iQDq5vKBDr58XA18l2lvGawfxZVeBm7hMULU
         1FrZuN6T14v3o+qTjDRFzr7t/uR4LbSvB8J5dQDIY8FFmP90z/zHsRzjSTkVMATIK1F7
         aUzw==
X-Gm-Message-State: APjAAAXaMsCD+fqAU8NqKHJoW/7LhKy2cGBvrR1VuN5Fs6+4nF+fZNak
        J+PiNUnJMzm6vIZHCoFxVSs=
X-Google-Smtp-Source: APXvYqwXS8p7Zh2/WDeBjYAlQ1bqhluCfp/i82D0ywQjNRtG7ZSkUAXYX/qMFIkTCIK+h5MUG7q6Hg==
X-Received: by 2002:a7b:c775:: with SMTP id x21mr9865822wmk.9.1560982473963;
        Wed, 19 Jun 2019 15:14:33 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:e495:2e7:a162:327f? (p200300EA8BF3BD00E49502E7A162327F.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:e495:2e7:a162:327f])
        by smtp.googlemail.com with ESMTPSA id v67sm3546464wme.24.2019.06.19.15.14.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 15:14:33 -0700 (PDT)
Subject: Re: network unstable on odroid-c1/meson8b.
To:     Aymeric <mulx@aplu.fr>, netdev@vger.kernel.org
Cc:     "linux-amlogic@lists.infradead.org" 
        <linux-amlogic@lists.infradead.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
References: <ff9a72bf-7eeb-542b-6292-dd70abdc4e79@aplu.fr>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <0df100ad-b331-43db-10a5-3257bd09938d@gmail.com>
Date:   Thu, 20 Jun 2019 00:14:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <ff9a72bf-7eeb-542b-6292-dd70abdc4e79@aplu.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.06.2019 22:18, Aymeric wrote:
> Hello all,
> 
> I've an ODROID-C1 board (a meson8b/S805) and I've some network
> unstablity with current mainline kernel; as time of writting, tested
> 5.0.y, 5.1.y, 5.2-rc4 and didn't try with any others versions.
> 
> After a few talks on linux-amlogic mailing list, I've been pointed here
> to find and, hoppefully, fix the issue.
> The whole thread on linux-amlogic is available here: [¹]
> 
> A short summary:
> 1. With Kernel 3.10.something made by Hardkernel (the one from the board
> vendor), the network link is working at 1 gigabit and stay at 1 gigabit.
> 2. With Kernel 5.0.y, 5.1.y, mainline, the network link goes from up to
> down every few seconds at 1 gigabit (making the board unusable) but is
> working fine when forced at 100Mb (using ethtool command).
> 3. The ethernet cable is not the cause of the issue (see #4).
> 4. After a few more check, I was able to narrow the problem. It's only
> present when the board is connected to my "internet box" (a Livebox
> 3/Sagemcom) but not with a "stupid" d-link switch (both have gigabit
> capability).
> 5. With the help from Martin on linux-amlogic I've tried to disable EEE
> in the dtb but it didn't change anything.
> 6. An extract of the dmesg output grepping ethernet and meson is here
> when the issue is occuring: [²].
> 
Kernel 3.10 didn't have a dedicated RTL8211F PHY driver yet, therefore
I assume the genphy driver was used. Do you have a line with
"attached PHY driver" in dmesg output of the vendor kernel?

The dedicated PHY driver takes care of the tx delay, if the genphy
driver is used we have to rely on what uboot configured.
But if we indeed had an issue with a misconfigured delay, I think
the connection shouldn't be fine with just another link partner.
Just to have it tested you could make rtl8211f_config_init() in
drivers/net/phy/realtek.c a no-op (in current kernels).

And you could compare at least the basic PHY registers 0x00 - 0x30
with both kernel versions, e.g. with phytool.

> 
> And the last comment from Martin and why I'm sending a mail here:
> - the Amlogic SoCs use a DesignWare MAC (Ethernet controller, the driver
> is called stmmac) with a Relatek RTL8211F Ethernet PHY.
> - there's little Amlogic specific registers involved: they mostly
> control the PHY interface (enabling RMII or RGMII) and the clocks so
> it's very likely that someone on the netdev list has an idea how to
> debug this because a large part of the Ethernet setup is not Amlogic SoC
> specific
> 
> So if you've got any idea to fix this issue.. :)
> 
> Thanks in advance,
> 
> Aymeric.
> 
Heiner
> 
> [¹]:
> http://lists.infradead.org/pipermail/linux-amlogic/2019-June/012341.html
> [²]:
> https://paste.aplu.fr/?b5eb6df48a9c95b6#sqHk8xhWGwRfagWNpL+u7mIsPGWVWFn2d7xBqika8Kc=
> 
> 
> 

