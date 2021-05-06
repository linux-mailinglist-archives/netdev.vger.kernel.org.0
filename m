Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0945F375122
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 10:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233881AbhEFIzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 04:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233464AbhEFIzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 04:55:20 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D15C061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 01:54:22 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id 65-20020a9d03470000b02902808b4aec6dso4257624otv.6
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 01:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aleksander-es.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q4IHGEooq3P+sjgPfLgE2uimjvqOzdAedwdUmuZ41V8=;
        b=uJJTlMSh7CgDeLRxaWJ8I8PMnOxkDVU2RFx1QH1Xvf8aFDPZdpShEznsc8E50kHXma
         eC9IeTznEp+vZSPfrfo5RHOVZ4Tv7D1PurJXkO0maUUB+oA+BfQV9y1VBWwa/1Mr7KA6
         kIi/CRVtXaIjiuTr9PNgQBbjsYeeueE5KzhXllDGVEYKoEZvc7iNPtvTM9TZ+VykonJT
         MQdxlqmkO/nRNXglkAgkw3qczqAnDwfvPjZyxawOILCrOwPP54Wn1tM/i6Ior6QFJGhH
         eYse/vk1yEuhgFXJb+veFSY6Zv22aD5N1oK2EnX7MD9NrsCeRPpmF3soZ+fyLyofKKwy
         pG2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q4IHGEooq3P+sjgPfLgE2uimjvqOzdAedwdUmuZ41V8=;
        b=CGXIR0J885WwTgazDAR8oOoXn9qx9tzM43NqIII5RIWUyIlgioRQcDWQ6IeqELH9bZ
         D93sHR97WYzhQDtwp6WlV5Qy5oHcW1l326AqJyPngnbEJFzKC9eDmrO9LlREAINBtHkN
         ovjbd0ayLs5G6E1b4cwDT5E1xbJOJV9BwqDUVCqQsakenLXZz9c1iRzaFkBim3WpMveE
         eAX6yPcCjMEHe5+xGMQJmZbcYcA53e1UHTgDMBJOl7ScfSx4VY4YyUMZVx0TLTWidMS+
         KS+VZp15DdyuW73VfFzYnM/H0PV6X7xBeJwegMYANRsZZWqztpV7Oz38peStgB766w3k
         8Lww==
X-Gm-Message-State: AOAM533LSv2Yt3/oOe+if5Ru61ik1iDLprIID5qj3IC/N0AQcvseaQ5L
        Icgd+hfFEtdwMotl2JpIObn7pESaVabMtMadqoTDdg==
X-Google-Smtp-Source: ABdhPJyMzBmLsV7xvM80Kz3lnaTIUFkGGFrPTmL/AhZCqEZIIGjeeb6BxiiigwqQx3JIgmsfavOPMPgmSt4NrCy+anM=
X-Received: by 2002:a9d:10a:: with SMTP id 10mr2698527otu.188.1620291261869;
 Thu, 06 May 2021 01:54:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210420161310.16189-1-m.chetan.kumar@intel.com>
In-Reply-To: <20210420161310.16189-1-m.chetan.kumar@intel.com>
From:   Aleksander Morgado <aleksander@aleksander.es>
Date:   Thu, 6 May 2021 10:54:10 +0200
Message-ID: <CAAP7ucLwXqvc8sNpm8NtowFnKxcWKAwqwJEE89s9eME1YgCowQ@mail.gmail.com>
Subject: Re: [PATCH V2 00/16] net: iosm: PCIe Driver for Intel M.2 Modem
To:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
        krishna.c.sudi@intel.com, linuxwwan@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey,

On Tue, Apr 20, 2021 at 6:14 PM M Chetan Kumar <m.chetan.kumar@intel.com> wrote:
>
> The IOSM (IPC over Shared Memory) driver is a PCIe host driver implemented
> for linux or chrome platform for data exchange over PCIe interface between
> Host platform & Intel M.2 Modem. The driver exposes interface conforming to
> the MBIM protocol. Any front end application ( eg: Modem Manager) could
> easily manage the MBIM interface to enable data communication towards WWAN.
>
> Intel M.2 modem uses 2 BAR regions. The first region is dedicated to Doorbell
> register for IRQs and the second region is used as scratchpad area for book
> keeping modem execution stage details along with host system shared memory
> region context details. The upper edge of the driver exposes the control and
> data channels for user space application interaction. At lower edge these data
> and control channels are associated to pipes. The pipes are lowest level
> interfaces used over PCIe as a logical channel for message exchange. A single
> channel maps to UL and DL pipe and are initialized on device open.
>
> On UL path, driver copies application sent data to SKBs associate it with
> transfer descriptor and puts it on to ring buffer for DMA transfer. Once
> information has been updated in shared memory region, host gives a Doorbell
> to modem to perform DMA and modem uses MSI to communicate back to host.
> For receiving data in DL path, SKBs are pre-allocated during pipe open and
> transfer descriptors are given to modem for DMA transfer.
>
> The driver exposes two types of ports, namely "wwanctrl", a char device node
> which is used for MBIM control operation and "INMx",(x = 0,1,2..7) network
> interfaces for IP data communication.

Is there any plan to integrate this driver in the new "wwan" subsystem
so that the character device for MBIM control is exposed in the same
format (i.e. same name rules and such) as with the MHI driver?

-- 
Aleksander
https://aleksander.es
