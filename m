Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789CB446FC2
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 19:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234219AbhKFSMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 14:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbhKFSMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 14:12:36 -0400
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C878CC061570;
        Sat,  6 Nov 2021 11:09:54 -0700 (PDT)
Received: by mail-ua1-x929.google.com with SMTP id l43so23350974uad.4;
        Sat, 06 Nov 2021 11:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U7pF4Zemk61+ZsARRk/stGHq2vqpNGqmv8TLGd6IkSs=;
        b=VqZkV0EYEAJBMSrC3fG4S5Eg2zf9KAkc5sgwGjX+ZLMIC+Xxxk4UTofnF/FDdk7Uzy
         Ggy9uZlo9Flno8osXd2myTPCjGm/UXG3pJOMvTNBD2aNsK7LsPvRxCH4qaewkaUwIf/A
         74GLMmNwDBNE0fbn+cRxjjVTY7Dxb+55tuJph7PL28hM3oeeQviwNrtSFUPou0pO/poU
         zXF80hVNY6Re2dLxZXEqo3TwSyi1U9bDoBsu3ImWYapSPVBMPo6hdctdFFvgSlksgnqO
         iaqQTOQLdrQtgeBe9s5WxkHx8ud4Gbz5EfmjEgGaM7Nn22fJWNLTo2sQee9qtiTUccg5
         Abcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U7pF4Zemk61+ZsARRk/stGHq2vqpNGqmv8TLGd6IkSs=;
        b=OqhnOFd64JqPj4If781kKlHycup54qPcdSb3hNBxXQg4f+5ZeMZtJ8XpMr30Hv6I+1
         +CmPN4yUQ1Nf3XKGFpsWosyqmnLhMjA20ktGSkdg48QBFAk0YvzJsGVwKHav8aVm3oj7
         sIw2N8+Xg/NgziCk4oMrB1UOOvopnT69xBrVBswt7b482K2pMch9D+ebCxA9BshwsI66
         Jhh0rFxGo5x3FQwDJ6pfj089cSPUl8ZczXGPfCIb5mJGeaD7WtjK4bJcv+uxCi9qz+PG
         BK2ien/dVWYMc5ccreg4Vs5oDWBtvCbpjqhlJmJdIh0tsNsaw0zw2ePp4cSeLz0fWDxy
         pNGw==
X-Gm-Message-State: AOAM531sN6qGxyM4IbUlis59xxQQ0oGmdec46x+PFGDGfIGUz/7LpLeO
        AgXoABLtp2+R1A4cgsATHIAkEp3p+gOhWbCfgEc=
X-Google-Smtp-Source: ABdhPJx2mOL9Q1qy1+IlmlkLastGKPO4t+8iLvXYhL4pzqxvf9kruU2L0UHG9NvrDlNWz5paV7RLitTB7fdBcg602o8=
X-Received: by 2002:a05:6102:3e81:: with SMTP id m1mr82989874vsv.44.1636222194012;
 Sat, 06 Nov 2021 11:09:54 -0700 (PDT)
MIME-Version: 1.0
References: <20211101035635.26999-1-ricardo.martinez@linux.intel.com>
In-Reply-To: <20211101035635.26999-1-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sat, 6 Nov 2021 21:10:57 +0300
Message-ID: <CAHNKnsSW15BXq7WXmyG7SrrNA+Rqp_bKVneVNrpegJvDrh688Q@mail.gmail.com>
Subject: Re: [PATCH v2 00/14] net: wwan: t7xx: PCIe driver for MediaTek M.2 modem
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        mika.westerberg@linux.intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        suresh.nagaraj@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Ricardo,

On Mon, Nov 1, 2021 at 6:57 AM Ricardo Martinez
<ricardo.martinez@linux.intel.com> wrote:
> t7xx is the PCIe host device driver for Intel 5G 5000 M.2 solution which
> is based on MediaTek's T700 modem to provide WWAN connectivity.
> The driver uses the WWAN framework infrastructure to create the following
> control ports and network interfaces:
> * /dev/wwan0mbim0 - Interface conforming to the MBIM protocol.
>   Applications like libmbim [1] or Modem Manager [2] from v1.16 onwards
>   with [3][4] can use it to enable data communication towards WWAN.
> * /dev/wwan0at0 - Interface that supports AT commands.
> * wwan0 - Primary network interface for IP traffic.
>
> The main blocks in t7xx driver are:
> * PCIe layer - Implements probe, removal, and power management callbacks.
> * Port-proxy - Provides a common interface to interact with different types
>   of ports such as WWAN ports.
> * Modem control & status monitor - Implements the entry point for modem
>   initialization, reset and exit, as well as exception handling.
> * CLDMA (Control Layer DMA) - Manages the HW used by the port layer to send
>   control messages to the modem using MediaTek's CCCI (Cross-Core
>   Communication Interface) protocol.
> * DPMAIF (Data Plane Modem AP Interface) - Controls the HW that provides
>   uplink and downlink queues for the data path. The data exchange takes
>   place using circular buffers to share data buffer addresses and metadata
>   to describe the packets.
> * MHCCIF (Modem Host Cross-Core Interface) - Provides interrupt channels
>   for bidirectional event notification such as handshake, exception, PM and
>   port enumeration.
>
> The compilation of the t7xx driver is enabled by the CONFIG_MTK_T7XX config
> option which depends on CONFIG_WWAN.
> This driver was originally developed by MediaTek. Intel adapted t7xx to
> the WWAN framework, optimized and refactored the driver source in close
> collaboration with MediaTek. This will enable getting the t7xx driver on
> Approved Vendor List for interested OEM's and ODM's productization plans
> with Intel 5G 5000 M.2 solution.

Nice work! The driver generally looks good for me. But at the same
time the driver looks a bit raw, needs some style and functionality
improvements, and a lot of cleanup. Please find general thoughts below
and per-patch comments.

A one nitpick that is common for the entire series. Please consider
using a common prefix for all driver function names (e.g. t7xx_) to
make them more specific. This should improve the code readability.
Thus, any reader will know for sure that the called functions belong
to the driver, and not to a generic kernel API. E.g. use the
t7xx_cldma_hw_init() name for the  CLDMA initialization function
instead of the too generic cldma_hw_init() name, etc.

Interestingly, that you are using the common 't7xx_' prefix for all
driver file names. This is Ok, but it does not add to the specifics as
all driver files are already located in a common directory with the
specific name. But function names at the same time lack a common
prefix.

Another common drawback is that the driver should break as soon as two
modems are connected simultaneously. This should happen due to the use
of multiple _global_ variables that keeps pointers to a modem runtime
state. Out of curiosity, did you test the driver with two or more
modems connected simultaneously?

Next, the driver entirely lacks the multibyte field endians handling.
Looks like it will be unable to run on a big-endians CPU. To fix this,
it is needed to find all the structures that are passed to the modem
and replace the multibyte fields of types u16/u32 with __le16/__le32.
Then examine all the field accesses and use
cpu_to_le{16,32}()/le{16,32}_to_cpu() to update/read field contents.
As soon as you change the types to __le16/__le32, sparse (a static
analyzing utility) will warn you about every unsafe field access. Just
build your kernel with make C=1.

Ricardo, please consider submitting at the next iteration a patch
series with the driver that will be cleaned from debug stuff and
questionable optimizations. Just a bare minimum functional: AT/MBIM
control ports and network interface for data communications. This will
cut the code in half. What will greatly facilitate the reviewing
process. And then extend the driver functionality with follow up
patches.

--
Sergey
