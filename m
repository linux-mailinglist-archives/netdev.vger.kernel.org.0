Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E355394DB4
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 20:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbhE2SoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 14:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhE2SoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 14:44:23 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BE4C061574
        for <netdev@vger.kernel.org>; Sat, 29 May 2021 11:42:46 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id qq22so1934653ejb.9
        for <netdev@vger.kernel.org>; Sat, 29 May 2021 11:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=YZoUx9cevNVY9B/GlNhUbyd5QxdXNNymTwSVMDdV/S4=;
        b=MxMnVlLdDpAVD0NNBejMDoxnNGA8swAkvIcWlzyLfZneuF0dWzmrxWasRSKt0vXxgE
         COfmHLjASHr0cBOVQUMl9Dgc/w9pyz7sIK2w1jt6GDllHRxJkgtbSnG/xr4a1zIcK30D
         Bp3ruquz10dzQ52o1cf7I70YRm6MTknH/Zy9jhkptZW7AqFAlDCdEdsMcIoVj9GObtg3
         9LvxEMr6oU7mT9349QdPa3DlryeoDUgKjvjmsIJAqrtWu8rja1Jt3eF3fHVK8c9buFTg
         tygPxZ3vKZZb9dpRtKEWGvWKV+wBa+vgiRlCMIEkKS/9dFBYCxNumaC5/yDl8dF3nMIB
         4DPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YZoUx9cevNVY9B/GlNhUbyd5QxdXNNymTwSVMDdV/S4=;
        b=FIqaiKHqUUzVpqYYf+FkH+JElL+aWeiejS8C9eFx9WA9jlNr4v/ui1RvLq7LMJGUDt
         Sg1GL4UYWVUzNsln8XNOl0/uv+b/SFPDD67C6rNumIVNjBqW0V5/jMXIDJ2iSO+jKFu3
         yuPgcvd2Pf3FRbKbelMI463KbepzgrmOdP6NMpEhDGydjSR7uQu+VRUpkOVHpz9gCuH7
         BSmjULUk8FZaGm5WzXXQSpwAJMe10QhWLgIqGuCGS5qOuCCw+QkcLQDOneHHwRqiblV3
         Ye8ialxA8+mrgnL2rt4Z6Eih51TQnYJkP6YpFwpYWwXauonBIBSX5qx+4z2CBhEefADv
         Vsow==
X-Gm-Message-State: AOAM532iXnV2gSon3vZDcE4lPLPl76bgHi56/oO0lKuAXTDrB8Hq6oxf
        aE/+OpDpF3OXmH2I0WEFRCrFjppfRSg=
X-Google-Smtp-Source: ABdhPJyFApHxKsuU5lnZG3m3g9PEg9oRuq4K97f1KvCFKr1xMHbW9ZRD0AnZ+iT7VhPzEESbyOnuOg==
X-Received: by 2002:a17:906:7842:: with SMTP id p2mr14640283ejm.487.1622313764933;
        Sat, 29 May 2021 11:42:44 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:24f0:58ef:1226:c09c? (p200300ea8f38460024f058ef1226c09c.dip0.t-ipconnect.de. [2003:ea:8f38:4600:24f0:58ef:1226:c09c])
        by smtp.googlemail.com with ESMTPSA id o64sm3399986eda.83.2021.05.29.11.42.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 May 2021 11:42:44 -0700 (PDT)
To:     Nikolai Zhubr <zhubr.2@gmail.com>, netdev@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>
References: <60B24AC2.9050505@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: Realtek 8139 problem on 486.
Message-ID: <ca333156-f839-9850-6e3d-696d7b725b09@gmail.com>
Date:   Sat, 29 May 2021 20:42:37 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <60B24AC2.9050505@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.05.2021 16:08, Nikolai Zhubr wrote:
> Hello all,
> 
> I'm observing a problem with Realtek 8139 cards on a couple of 486 boxes. The respective driver is 8139too. It starts operation successfully, obtains an ip address via dhcp, replies to pings steadily, but some subsequent communication fails apparently. At least, nfsroot is unusable (it gets stuck in "... not responding, still trying" forever), and also iperf3 -c xxx when run against a neighbour box on a lan prints 2-3 lines with some reasonable 7Mbit/s rate, then just prints 0s and subsequently throws a panic about output queue full or some such.
> 
> My kernel is 4.14.221 at the moment, but I can compile another if necessary.
> I've already tried the "#define RTL8139_DEBUG 3" and "8139TOO_PIO=y" and "#define RX_DMA_BURST 4" and "#define TX_DMA_BURST 4" (in case there is a PCI burst issue, as mentioned somewhere) and nothing changed whatsoever.
> 
> Some additional notes:
> - the problem is 100% reproducable;
> - replacing this 8139 card with some entirely different 8139-based card changes nothing;
> - if I replace this 8139 with a (just random) intel Pro/1000 card, everything seem to work fine;
> - if I insert this 8139 into some other 486 motherboard (with a different chipset), everything seem to work fine again;
> - etherboot and pxelinux work fine.
> 
> I'm willing to do some debugging but unfortunately I'm not anywhere familiar with this driver and network controllers in general, therefore I'm asking for some hints/advice first.
> 
This driver hasn't seen functional changes for ages. Any previous kernel
version that works fine so that you could bisect? It will be hard to
find any developer who has test hw, especially as your issue seems to be
system-dependent.
Please provide a full dmesg log, maybe it provides a hint.

You write: "reasonable 7Mbit/s rate"
So you operate the systems with a 10Mbit hub? Or any other reason why
you consider 7Mbps reasonable?

> 
> Thank you,
> 
> Regards,
> Nikolai
Heiner
