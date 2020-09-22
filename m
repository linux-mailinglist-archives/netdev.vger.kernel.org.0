Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7758273EF7
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 11:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbgIVJxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 05:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgIVJxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 05:53:47 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213D0C061755;
        Tue, 22 Sep 2020 02:53:47 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id c2so13574987ljj.12;
        Tue, 22 Sep 2020 02:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+i7aBMoF6jV+rGnPKiYKPNmoc8geU7C4VPgWDVerolU=;
        b=LitoGsUWcZ9QgkrF4+ZYNUL7eTogmiXT/i0lNCBMAROw0jOBbmza9EhQDack8OlEs8
         CVK0uRy2bTFtmn1vXRFaD7flCqK5cbpBRmehnQOO0fa4pAYDt6AXhDuoOI4YQnUI5KSZ
         ZMpkYkjFJ45EnP47g1FEad6oH7K4OeW9SYMTbh/qBDX2YWywmFKhsWKmWFL9Qd4B6UB+
         flxrHj0QQ2oPjSJyUyWKR14qB1BE+y0QH2NH+6S3go3hbFRtYz3cY6D8i8k1xNg12YnN
         HvMze7oFLcyExP+pG32JsyeI/l9C/Q1iNb7+Bt51XL32a6vVZLbuDcWLFr3t4laRvWSA
         Ig5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=+i7aBMoF6jV+rGnPKiYKPNmoc8geU7C4VPgWDVerolU=;
        b=dULkrwX+ZXHVfoPCaCKaMAD0BcM0Jnrnbf4qnEIbC8M+agy8ZkEGDBIbMa6zY9Q5lZ
         44XVrJqnIoAne7QEuJY3Vi8cZ2w0pIqtSNmxD75w4ihEGtYQ/t7lKBp11IlV1ZGxhsQ/
         wK+iCuUPW9URg0JaDVWgzzMFoAy7UvN9NGdLUwBOke9PClrhsxpj/ysQX9mlOvRlhHUf
         MCxpQnW24vpG8cKFc1VN8H04akv2pybbf7WKfH940pe4tO7vkhQPwFcUA5q1y2NOxhMR
         FfT+VvsOLiheQP6b0V4UhdTMd5KSgbHvWZ3pg/+zU03rCBmBnzco+FA5OUwoe7UMdUef
         dZmg==
X-Gm-Message-State: AOAM530qxlbvHZBKj7Bfb9ZtI4f3w8wDqeQiad3P1GuSjsZhtUXZMXUC
        +ofqe58p02BpPCIvhioMTCd0j5kXZhHs+A==
X-Google-Smtp-Source: ABdhPJx9ANFk/Po7zdPjbuZB+cQsG9ryqzW4eACSlsLoTXtfZut5FzEHhjpvnqWEzOwyRoEcZNoQXw==
X-Received: by 2002:a2e:a202:: with SMTP id h2mr1348967ljm.282.1600768425408;
        Tue, 22 Sep 2020 02:53:45 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:426e:8bbe:c99d:2ede:2a50:6604? ([2a00:1fa0:426e:8bbe:c99d:2ede:2a50:6604])
        by smtp.gmail.com with ESMTPSA id r13sm3349330lfe.114.2020.09.22.02.53.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 02:53:44 -0700 (PDT)
Subject: Re: [PATCH net] Revert "ravb: Fixed to be able to unload modules"
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20200922072931.2148-1-geert+renesas@glider.be>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <32351a6c-07ea-2a5c-0edd-4ef92dc38002@gmail.com>
Date:   Tue, 22 Sep 2020 12:53:37 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200922072931.2148-1-geert+renesas@glider.be>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.09.2020 10:29, Geert Uytterhoeven wrote:

> This reverts commit 1838d6c62f57836639bd3d83e7855e0ee4f6defc.
> 
> This commit moved the ravb_mdio_init() call (and thus the
> of_mdiobus_register() call) from the ravb_probe() to the ravb_open()
> call.  This causes a regression during system resume (s2idle/s2ram), as
> new PHY devices cannot be bound while suspended.
> 
> During boot, the Micrel PHY is detected like this:
> 
>      Micrel KSZ9031 Gigabit PHY e6800000.ethernet-ffffffff:00: attached PHY driver [Micrel KSZ9031 Gigabit PHY] (mii_bus:phy_addr=e6800000.ethernet-ffffffff:00, irq=228)
>      ravb e6800000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off
> 
> During system suspend, (A) defer_all_probes is set to true, and (B)
> usermodehelper_disabled is set to UMH_DISABLED, to avoid drivers being
> probed while suspended.
> 
>    A. If CONFIG_MODULES=n, phy_device_register() calling device_add()
>       merely adds the device, but does not probe it yet, as
>       really_probe() returns early due to defer_all_probes being set:
> 
>         dpm_resume+0x128/0x4f8
> 	 device_resume+0xcc/0x1b0
> 	   dpm_run_callback+0x74/0x340
> 	     ravb_resume+0x190/0x1b8
> 	       ravb_open+0x84/0x770
> 		 of_mdiobus_register+0x1e0/0x468
> 		   of_mdiobus_register_phy+0x1b8/0x250
> 		     of_mdiobus_phy_device_register+0x178/0x1e8
> 		       phy_device_register+0x114/0x1b8
> 			 device_add+0x3d4/0x798
> 			   bus_probe_device+0x98/0xa0
> 			     device_initial_probe+0x10/0x18
> 			       __device_attach+0xe4/0x140
> 				 bus_for_each_drv+0x64/0xc8
> 				   __device_attach_driver+0xb8/0xe0
> 				     driver_probe_device.part.11+0xc4/0xd8
> 				       really_probe+0x32c/0x3b8
> 
>       Later, phy_attach_direct() notices no PHY driver has been bound,
>       and falls back to the Generic PHY, leading to degraded operation:
> 
>         Generic PHY e6800000.ethernet-ffffffff:00: attached PHY driver [Generic PHY] (mii_bus:phy_addr=e6800000.ethernet-ffffffff:00, irq=POLL)
>         ravb e6800000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off
> 
>    B. If CONFIG_MODULES=y, request_module() returns early with -EBUSY due
>       to UMH_DISABLED, and MDIO initialization fails completely:
> 
>         mdio_bus e6800000.ethernet-ffffffff:00: error -16 loading PHY driver module for ID 0x00221622
>         ravb e6800000.ethernet eth0: failed to initialize MDIO
>         PM: dpm_run_callback(): ravb_resume+0x0/0x1b8 returns -16
>         PM: Device e6800000.ethernet failed to resume: error -16
> 
>       Ignoring -EBUSY in phy_request_driver_module(), like was done for
>       -ENOENT in commit 21e194425abd65b5 ("net: phy: fix issue with loading
>       PHY driver w/o initramfs"), would makes it fall back to the Generic
>       PHY, like in the CONFIG_MODULES=n case.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: stable@vger.kernel.org

Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

> ---
> Commit 1838d6c62f578366 ("ravb: Fixed to be able to unload modules") was
> already backported to stable v4.4, v4.9, v4.14, v4.19, v5.4, and v5.8),
> and thus needs to be reverted there, too.

    Ugh!
    Sorry for not noticing the issue with the original patch... :-/

MBR, Sergei
