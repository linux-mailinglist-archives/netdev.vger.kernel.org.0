Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6277D495054
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 15:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345872AbiATOgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 09:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238270AbiATOgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 09:36:35 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8610C061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 06:36:33 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id j23so24452218edp.5
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 06:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TEhICuZNaKujmqk/riwLT9nwyLOI8oZwCGRm5rhrtZ0=;
        b=Zygzblnrp8SvDn73wm14/6oLJXz/q/uYrZzzJ+pC4fJVKSXUYgrfwr4dL6smatgL3h
         wOiAWsQ0BkIB0KmcjShfHc7lncRd/Ui8U1UMHoLfd1MlhbkcG8uMNnSB562PlFAk4eZw
         ISWFm+XOTZpyEhpYCXIi31N6DJ9hGdTyVsTx6vhsH17xcOJVL/9U6Ut/i0i9F6gGrqF+
         m1TnNyj0pvK6qUv+BnnIgPPOh+xjZS0w7BpqE6AQ1skNUaB8UauR2eRoe4cTDMdfveyX
         9T1aXPvXY04G6YzAoadvgU2asdzLGHN4+r8ezHkS6e7sHsvLzUR9/8JwSvU8mulx5uCz
         qdLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TEhICuZNaKujmqk/riwLT9nwyLOI8oZwCGRm5rhrtZ0=;
        b=ZrJQ5Mi4hPzj8GqxGVN/4FVbCIkZ/4HB3CbbUYd1EUBQpgiEOe62NehAWcF1M6r/Bk
         tEFcMFVz9KrVfGxR8VMZhPabETPWVst0ageJt4hOU1bP3lsD8sueWcYfyDPTr8oiIqvg
         FeC/mAoySSKZut69Inmpksx3Oj7o4+taSY8K1vAxGAPeQQXvq/Pcv5I5Gku199noTkTk
         cbLaFS06qmYwUZJoHxXFegfG6ZEQoxcL1CqHD8xem+eqMH1bY0h5Xd2yh5ndmcdY5Plf
         HSpX06rSGtc/4bs9dz0cc8DihoTSXMrdSHrFRYx2XcrIGunxv5VaPjcW7fDa/VWJFMTK
         dT/Q==
X-Gm-Message-State: AOAM5302pGJJI8WLF2XeX6Zq8ycGSGM3JmncC4PyBG1NDpHYAQbPLOz+
        bp22t+TixvkgGaFBH+LINqs=
X-Google-Smtp-Source: ABdhPJyTfb38953NS8i9PfX4h/80vhUULpCq7U7vDlmGpwUtGj4sUrmq1IRjRZA/PFTTeJgSotlzVw==
X-Received: by 2002:a17:906:794f:: with SMTP id l15mr1104269ejo.328.1642689392359;
        Thu, 20 Jan 2022 06:36:32 -0800 (PST)
Received: from skbuf ([188.25.255.2])
        by smtp.gmail.com with ESMTPSA id s12sm1092355ejx.184.2022.01.20.06.36.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 06:36:31 -0800 (PST)
Date:   Thu, 20 Jan 2022 16:36:30 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        frank-w@public-files.de
Subject: Re: [PATCH net-next v4 00/11] net: dsa: realtek: MDIO interface and
 RTL8367S
Message-ID: <20220120143630.rimb2y74h2hxueg5@skbuf>
References: <20220105031515.29276-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105031515.29276-1-luizluca@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 12:15:04AM -0300, Luiz Angelo Daros de Luca wrote:
> The old realtek-smi driver was linking subdrivers into a single
> realtek-smi.ko After this series, each subdriver will be an independent
> module required by either realtek-smi (platform driver) or the new
> realtek-mdio (mdio driver). Both interface drivers (SMI or MDIO) are
> independent, and they might even work side-by-side, although it will be
> difficult to find such device. The subdriver can be individually
> selected but only at buildtime, saving some storage space for custom
> embedded systems.
> 
> Existing realtek-smi devices continue to work untouched during the
> tests. The realtek-smi was moved into a realtek subdirectory, but it
> normally does not break things.
> 
> I couldn't identify a fixed relation between port numbers (0..9) and
> external interfaces (0..2), and I'm not sure if it is fixed for each
> chip version or a device configuration. Until there is more info about
> it, there is a new port property "realtek,ext-int" that can inform the
> external interface.

Generally it isn't a good idea to put in the device tree things that you
don't understand. The reason being that you'd have to support those
device tree bindings even when you do understand those things. A device
tree blob has a separate lifetime compared to the kernel image, so a new
kernel image would have to support the device trees in circulation which
have this realtek,ext-int property.

Can you use a fixed relationship between the port number and the
external interface in the driver, until it is proven that this info
cannot be known statically or by reading some device configuration?

> The rtl8365mb might now handle multiple CPU ports and extint ports not
> used as CPU ports. RTL8367S has an SGMII external interface, but my test
> device (TP-Link Archer C5v4) uses only the second RGMII interface. We
> need a test device with more external ports to test these features.
> The driver still cannot handle SGMII ports.
> 
> The rtl8365mb was tested with a MDIO-connected RTL8367S (TP-Link Acher
> C5v4) and a SMI-connected RTL8365MB-VC switch (Asus RT-AC88U)
> 
> The rtl8366rb subdriver was not tested with this patch series, but it
> was only slightly touched. It would be nice to test it, especially in an
> MDIO-connected switch.
> 
> Best,
> 
> Luiz
> 
> Changelog:
> 
> v1-v2)
> - formatting fixes
> - dropped the rtl8365mb->rtl8367c rename
> - other suggestions
> 	
> v2-v3)
> * realtek-mdio.c:
>   - cleanup realtek-mdio.c (BUG_ON, comments and includes)   
>   - check devm_regmap_init return code
>   - removed realtek,rtl8366s string from realtek-mdio
> * realtek-smi.c:
>   - removed void* type cast
> * rtl8365mb.c:
>   - using macros to identify EXT interfaces
>   - rename some extra extport->extint cases
>   - allow extint as non cpu (not tested)
>   - allow multple cpu ports (not tested)
>   - dropped cpu info from struct rtl8365mb
> * dropped dt-bindings changes (dealing outside this series)
> * formatting issues fixed
> 
> v3-v4)
> * fix cover message numbering 0/13 -> 0/11
> * use static for realtek_mdio_read_reg
>   - Reported-by: kernel test robot <lkp@intel.com>
> * use dsa_switch_for_each_cpu_port
> * mention realtek_smi_{variant,ops} to realtek_{variant,ops}
>   in commit message
> 
> 
