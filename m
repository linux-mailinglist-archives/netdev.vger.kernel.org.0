Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2DE51D98B
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 15:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441854AbiEFNrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 09:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240638AbiEFNrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 09:47:21 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE8D22BC9;
        Fri,  6 May 2022 06:43:38 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id p1so2810018uak.1;
        Fri, 06 May 2022 06:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HQhBIk9ZDxRam1pPGjEuYg3pQxnTdOv2YFzBqunrJeM=;
        b=SIZk9CuNLYUSGPut057biDMGfXxIcHV6hRVcr3IIy515N/Pk/Q1P5Zp4rg8sILC10G
         I4NSwKqUNAzg8OcPKdmu5rSpZmQiGvM4ASmxrHRQpdnnkLPVvrVgMlswxz98iMAMh5cu
         7GTp05gjAzlKR1U/CmSmTvosiP7m0PwRu9Atq8q6xBbnPN4386U9GZzpxB+XpiUUm2Ah
         e92NGAybkVI74xHUv1CrxMR4qxAa3kneG8oXARAR5dPliJ46ZbnCsI3VC4fMPe2BvxEt
         PfzzEFXfmxjlxU80ScTFA3alMzFNeFEZxbqtxW+2ZyqBN9D+w8nk1AvbdGTI5a/eRIRU
         NCzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HQhBIk9ZDxRam1pPGjEuYg3pQxnTdOv2YFzBqunrJeM=;
        b=gJUxPFWFcmCgopUT/v4agHjp/MkNUGmHecpvahvhoRR8zheHuTLZJsawaetj8cYSzQ
         5J31DhJWimieEvTN4nEaK1AP6BZfg8sRaj7wkPCqzMnllddcUcSPBkU5De96Bf70OSJl
         qMcXUHWKtBHJPScrFOTNZg1kloqmrFj26f1kfMZ7sBMKu18XtW4JYm4OwnVhHqfmPNS8
         cJXIt0jRbsPq+Us8s5gpPJ5+BG6T8Jv7XbTZyMdycktKhaPcTO2uFLF+K8abhXZbDLqk
         wBRksfC0N12J08Gcn9j+8ruCvOFlPbQVloQwpJqasazIGpMfGPBBfs4oEIneyxK57g/R
         +Vwg==
X-Gm-Message-State: AOAM532xmLq9IbaANHk/ED5vKHva/bohgtdbeawT7VCdmiBKJz+cd41j
        HN2gaQ4HyYFghmQ/MqX/+POEvkblcQTZJkioJf8=
X-Google-Smtp-Source: ABdhPJxHxTbUAd6UlMUr3ArGNnK2kJsC7Y5cjqHp6RfrlB61b2FCo6YJffPi8pDqH0arxqefD58Nn7h91me4o7om2pI=
X-Received: by 2002:ab0:407:0:b0:35f:ef75:81e8 with SMTP id
 7-20020ab00407000000b0035fef7581e8mr1023186uav.91.1651844617699; Fri, 06 May
 2022 06:43:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220506011616.1774805-1-ricardo.martinez@linux.intel.com>
In-Reply-To: <20220506011616.1774805-1-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Fri, 6 May 2022 16:43:26 +0300
Message-ID: <CAHNKnsTnqNrcnz9gx8uX0mMiq8V_Vt99AQPAom01Q=V50a2bFg@mail.gmail.com>
Subject: Re: [PATCH net-next v7 00/14] net: wwan: t7xx: PCIe driver for
 MediaTek M.2 modem
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        "Devegowda, Chandrashekar" <chandrashekar.devegowda@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        "Hanania, Amir" <amir.hanania@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Sharma, Dinesh" <dinesh.sharma@intel.com>,
        "Lee, Eliot" <eliot.lee@intel.com>,
        "Jarvinen, Ilpo Johannes" <ilpo.johannes.jarvinen@intel.com>,
        "Veleta, Moises" <moises.veleta@intel.com>,
        "Bossart, Pierre-louis" <pierre-louis.bossart@intel.com>,
        "Sethuraman, Muralidharan" <muralidharan.sethuraman@intel.com>,
        "Mishra, Soumya Prakash" <Soumya.Prakash.Mishra@intel.com>,
        "Kancharla, Sreehari" <sreehari.kancharla@intel.com>,
        "Sahu, Madhusmita" <madhusmita.sahu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Ricardo,

On Fri, May 6, 2022 at 4:16 AM Ricardo Martinez
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
> the WWAN framework, optimized and refactored the driver source code in close
> collaboration with MediaTek. This will enable getting the t7xx driver on the
> Approved Vendor List for interested OEM's and ODM's productization plans
> with Intel 5G 5000 M.2 solution.
>
> List of contributors:
> Amir Hanania <amir.hanania@intel.com>
> Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
> Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Dinesh Sharma <dinesh.sharma@intel.com>
> Eliot Lee <eliot.lee@intel.com>
> Haijun Liu <haijun.liu@mediatek.com>
> M Chetan Kumar <m.chetan.kumar@intel.com>
> Mika Westerberg <mika.westerberg@linux.intel.com>
> Moises Veleta <moises.veleta@intel.com>
> Pierre-louis Bossart <pierre-louis.bossart@intel.com>
> Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
> Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Madhusmita Sahu <madhusmita.sahu@intel.com>
> Muralidharan Sethuraman <muralidharan.sethuraman@intel.com>
> Soumya Prakash Mishra <Soumya.Prakash.Mishra@intel.com>
> Sreehari Kancharla <sreehari.kancharla@intel.com>
> Suresh Nagaraj <suresh.nagaraj@intel.com>
>
> [1] https://www.freedesktop.org/software/libmbim/
> [2] https://www.freedesktop.org/software/ModemManager/
> [3] https://gitlab.freedesktop.org/mobile-broadband/ModemManager/-/merge_requests/582
> [4] https://gitlab.freedesktop.org/mobile-broadband/ModemManager/-/merge_requests/523

Now the driver looks really nice. Good job!

-- 
Sergey
