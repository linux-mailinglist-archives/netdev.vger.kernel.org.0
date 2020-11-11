Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03E242AF49D
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 16:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbgKKPUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 10:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbgKKPUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 10:20:17 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D96C0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 07:20:17 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id c16so2670041wmd.2
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 07:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=trW0PU8LRxjGiECU/PwLhGvVpHiQmXP5OAAdCAOStYU=;
        b=DmN9k3DMxSS6Cgr73TNxa7WohQU4aM7nu/w0D+HoZwynKcQzTkrn5/Wa159gaqzEB0
         /ZuVKHbiZyv7YuZOPkHYdSCGZlZjEr3BeImGJGHS0Hvr2WBVzK+roYLKBr5kQhjR/UPG
         ZNdgSo/KK/+IWHaT/tb1W6Wp3SKSdg8SqoVcXHAHam2ODVt3LS7sqkn53XJwDhhS11zQ
         hfPBKsSymYkn5VM0DmARJuwv7WxMu3WVZb972aEoHvLIS4UiaYShOlgMPbYJFLEd3Rvf
         T4dY23qGY9yXOwnuNKMGrOJ0e5Wb8kesI1So4KBTbfF+YUEu63bczGELOiBfp+dZPBw5
         hQWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=trW0PU8LRxjGiECU/PwLhGvVpHiQmXP5OAAdCAOStYU=;
        b=fkn9/2ZPfVQWNXJx00RU2yTV8FwCFPUQl8pVJ+qk5feOuim7f6JKPVy3421ZIHXSpp
         He9k2Ruu7FUtBl/JoRoFdDPd/CiEApxblJy0pm53RdLgX8c5/4uwsWnaLH7MexkTt5M/
         53INGVfYNSXW3M1mDYhZmrSIK8hUYIbS8LK3/qMD2nvs0BQ9vMM0gNUlab1oFj8vC7Wu
         8L/sTA62UsFhHMK/l8hIGkRFgBBQnW3Po06fzuMUzY0H5lP5QPhgTlqUC37vjPf/D95+
         hNTOiJdS/FUScBTwrljJXhbrDvOrgLEyWYwNomA6f/y13TJboz/MVVSadyeO3/S57mAt
         Yl1A==
X-Gm-Message-State: AOAM530KwUGniPwxogc7iFU2KKlImhUCC0i1xREzfPdgumRiyYN4bmDD
        5J6vgkL5zX2316tT3FFbykA=
X-Google-Smtp-Source: ABdhPJxNBl55aKjC6n+4o3OWXPhJUgJLFbQmtMqK+b3O9DCnXvoSH+YyI/KYsm/2dfY448JgqhWv/w==
X-Received: by 2002:a1c:1d82:: with SMTP id d124mr4908354wmd.12.1605108015989;
        Wed, 11 Nov 2020 07:20:15 -0800 (PST)
Received: from [192.168.8.114] ([37.167.154.104])
        by smtp.gmail.com with ESMTPSA id p4sm2911749wrm.51.2020.11.11.07.20.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2020 07:20:15 -0800 (PST)
Subject: Re: Fwd: net: fec: rx descriptor ring out of order
To:     Kegl Rohit <keglrohit@gmail.com>, netdev@vger.kernel.org,
        Andy Duan <fugang.duan@nxp.com>
References: <CAMeyCbh8vSCnr-9-odi0kg3E8BGCiETOL-jJ650qYQdsY0wxeA@mail.gmail.com>
 <CAMeyCbjuj2Q2riK2yzKXRfCa_mKToqe0uPXKxrjd6zJQWaXxog@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <3f069322-f22a-a2e8-1498-0a979e02b595@gmail.com>
Date:   Wed, 11 Nov 2020 16:20:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <CAMeyCbjuj2Q2riK2yzKXRfCa_mKToqe0uPXKxrjd6zJQWaXxog@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/11/20 3:27 PM, Kegl Rohit wrote:
> Hello!
> 
> We are using a imx6q platform.
> The fec interface is used to receive a continuous stream of custom /
> raw ethernet packets. The packet size is fixed ~132 bytes and they get
> sent every 250µs.
> 
> While testing I observed spontaneous packet delays from time to time.
> After digging down deeper I think that the fec peripheral does not
> update the rx descriptor status correctly.
> I modified the queue_rx function which is called by the NAPI poll
> function. "no packet N" is printed when the queue_rx function doesn't
> process any descriptor.
> Therefore the variable N counts continuous calls without ready
> descriptors. When the current descriptor is ready&processed and moved
> to the next entry, then N is cleared again.
> Additionally an error is printed if the current descriptor is empty
> but the next one is already ready. In case this error happens the
> current descriptor and the next 11 ones are dumped.
> "C"  ... current
> "E"  ... empty
> 
> [   57.436478 <    0.020005>] no packet 1!
> [   57.460850 <    0.024372>] no packet 1!
> [   57.461107 <    0.000257>] ring error, current empty but next is not empty
> [   57.461118 <    0.000011>] RX ahead
> [   57.461135 <    0.000017>] 129 C E 0x8840 0x2c743a40  132
> [   57.461146 <    0.000011>] 130     0x0840 0x2c744180  132
> [   57.461158 <    0.000012>] 131   E 0x8840 0x2c7448c0  132
> [   57.461170 <    0.000012>] 132   E 0x8840 0x2c745000  132
> [   57.461181 <    0.000011>] 133   E 0x8840 0x2c745740  132
> [   57.461192 <    0.000011>] 134   E 0x8840 0x2c745e80  132
> [   57.461204 <    0.000012>] 135   E 0x8880 0x2c7465c0  114
> [   57.461215 <    0.000011>] 136   E 0x8840 0x2c746d00  132
> [   57.461227 <    0.000012>] 137   E 0x8840 0x2c747440  132
> [   57.461239 <    0.000012>] 138   E 0x8840 0x2c748040  132
> [   57.461250 <    0.000011>] 139   E 0x8840 0x2c748780  132
> [   57.461262 <    0.000012>] 140   E 0x8840 0x2c748ec0  132
> [   57.461477 <    0.000008>] no packet 2!
> [   57.461506 <    0.000029>] ring error, current empty but next is not empty
> [   57.461537 <    0.000031>] RX ahead
> [   57.461550 <    0.000013>] 129 C E 0x8840 0x2c743a40  132
> [   57.461563 <    0.000013>] 130     0x0840 0x2c744180  132
> [   57.461577 <    0.000014>] 131     0x0840 0x2c7448c0  132
> [   57.461589 <    0.000012>] 132     0x0840 0x2c745000  132
> [   57.461601 <    0.000012>] 133   E 0x8840 0x2c745740  132
> [   57.461613 <    0.000012>] 134   E 0x8840 0x2c745e80  132
> [   57.461624 <    0.000011>] 135   E 0x8880 0x2c7465c0  114
> [   57.461635 <    0.000011>] 136   E 0x8840 0x2c746d00  132
> [   57.461645 <    0.000010>] 137   E 0x8840 0x2c747440  132
> [   57.461657 <    0.000012>] 138   E 0x8840 0x2c748040  132
> [   57.461668 <    0.000011>] 139   E 0x8840 0x2c748780  132
> [   57.461680 <    0.000012>] 140   E 0x8840 0x2c748ec0  132
> [   57.461894 <    0.000009>] no packet 3!
> [   57.461926 <    0.000032>] ring error, current empty but next is not empty
> [   57.461935 <    0.000009>] RX ahead
> [   57.461947 <    0.000012>] 129 C E 0x8840 0x2c743a40  132
> [   57.461959 <    0.000012>] 130     0x0840 0x2c744180  132
> [   57.461970 <    0.000011>] 131     0x0840 0x2c7448c0  132
> [   57.461982 <    0.000012>] 132     0x0840 0x2c745000  132
> [   57.461993 <    0.000011>] 133     0x0840 0x2c745740  132
> [   57.462005 <    0.000012>] 134   E 0x8840 0x2c745e80  132
> [   57.462017 <    0.000012>] 135   E 0x8880 0x2c7465c0  114
> [   57.462028 <    0.000011>] 136   E 0x8840 0x2c746d00  132
> [   57.462039 <    0.000011>] 137   E 0x8840 0x2c747440  132
> [   57.462051 <    0.000012>] 138   E 0x8840 0x2c748040  132
> [   57.462062 <    0.000011>] 139   E 0x8840 0x2c748780  132
> [   57.462075 <    0.000013>] 140   E 0x8840 0x2c748ec0  132
> [   57.462289 <    0.000009>] no packet 4!
> [   57.462316 <    0.000027>] ring error, current empty but next is not empty
> [   57.462326 <    0.000010>] RX ahead
> [   57.462339 <    0.000013>] 129 C E 0x8840 0x2c743a40  132
> [   57.462351 <    0.000012>] 130     0x0840 0x2c744180  132
> [   57.462362 <    0.000011>] 131     0x0840 0x2c7448c0  132
> [   57.462373 <    0.000011>] 132     0x0840 0x2c745000  132
> [   57.462384 <    0.000011>] 133     0x0840 0x2c745740  132
> [   57.462397 <    0.000013>] 134     0x0840 0x2c745e80  132
> [   57.462408 <    0.000011>] 135     0x0840 0x2c7465c0  132
> [   57.462421 <    0.000013>] 136   E 0x8840 0x2c746d00  132
> [   57.462431 <    0.000010>] 137   E 0x8840 0x2c747440  132
> [   57.462443 <    0.000012>] 138   E 0x8840 0x2c748040  132
> [   57.462454 <    0.000011>] 139   E 0x8840 0x2c748780  132
> [   57.462467 <    0.000013>] 140   E 0x8840 0x2c748ec0  132
> [   57.462697 <    0.000009>] no packet 5!
> [   57.462730 <    0.000033>] ring error, current empty but next is not empty
> [   57.462739 <    0.000009>] RX ahead
> [   57.462752 <    0.000013>] 129 C E 0x8840 0x2c743a40  132
> [   57.462763 <    0.000011>] 130     0x0840 0x2c744180  132
> [   57.462775 <    0.000012>] 131     0x0840 0x2c7448c0  132
> [   57.462787 <    0.000012>] 132     0x0840 0x2c745000  132
> [   57.462799 <    0.000012>] 133     0x0840 0x2c745740  132
> [   57.462809 <    0.000010>] 134     0x0840 0x2c745e80  132
> [   57.462820 <    0.000011>] 135     0x0840 0x2c7465c0  132
> [   57.462830 <    0.000010>] 136     0x0840 0x2c746d00  132
> [   57.462842 <    0.000012>] 137     0x0840 0x2c747440  132
> [   57.462853 <    0.000011>] 138   E 0x8840 0x2c748040  132
> [   57.462864 <    0.000011>] 139   E 0x8840 0x2c748780  132
> [   57.462877 <    0.000013>] 140   E 0x8840 0x2c748ec0  132
> [   57.463093 <    0.000009>] no packet 6!
> [   57.463120 <    0.000027>] RX ahead
> [   57.463133 <    0.000013>] 129 C   0x0840 0x2c743a40  132
> [   57.463144 <    0.000011>] 130     0x0840 0x2c744180  132
> [   57.463155 <    0.000011>] 131     0x0840 0x2c7448c0  132
> [   57.463166 <    0.000011>] 132     0x0840 0x2c745000  132
> [   57.463179 <    0.000013>] 133     0x0840 0x2c745740  132
> [   57.463190 <    0.000011>] 134     0x0840 0x2c745e80  132
> [   57.463201 <    0.000011>] 135     0x0840 0x2c7465c0  132
> [   57.463213 <    0.000012>] 136     0x0840 0x2c746d00  132
> [   57.463224 <    0.000011>] 137     0x0840 0x2c747440  132
> [   57.463235 <    0.000011>] 138     0x0840 0x2c748040  132
> [   57.463245 <    0.000010>] 139   E 0x8840 0x2c748780  132
> [   57.463256 <    0.000011>] 140   E 0x8840 0x2c748ec0  132
> [   57.463695 <    0.000244>] rx 12
> 
> As you can see, the described error is catched and the ring is dumped.
> 9 descriptors got ready before the current descriptor is ready.
> After that the current descriptor got ready and 12 packets were
> processed at once.
> I could also observe cases where the ring (512 entries) got full
> before the current descriptor was cleared.
> And also cases where the current and next descriptor were not ready.
> [   57.462752 <    0.000013>] 129 C E 0x8840 0x2c743a40  132
> [   57.462763 <    0.000011>] 130    E 0x0840 0x2c744180  132
> [   57.462775 <    0.000012>] 131     0x0840 0x2c7448c0  132
> 
> I am suspecting the errata:
> 
> ERR005783 ENET: ENET Status FIFO may overflow due to consecutive short frames
> Description:
> When the MAC receives shorter frames (size 64 bytes) at a rate
> exceeding the average line-rate
> burst traffic of 400 Mbps the DMA is able to absorb, the receiver
> might drop incoming frames
> before a Pause frame is issued.
> Projected Impact:
> No malfunction will result aside from the frame drops.
> Workarounds:
> The application might want to implement some flow control to ensure
> the line-rate burst traffic is
> below 400 Mbps if it only uses consecutive small frames with minimal
> (96 bit times) or short
> Inter-frame gap (IFG) time following large frames at such a high rate.
> The limit does not exist for
> frames of size larger than 800 bytes.
> Proposed Solution:
> No fix scheduled
> Linux BSP Status:
> Workaround possible but not implemented in the BSP, impacting
> functionality as described above.
> 
> Is the "ENET Status FIFO" some internal hardware FIFO or is it the
> descriptor ring.
> What would be the workaround when a "Workaround is possible"?
> 
> I could only think of skipping/dropping the descriptor when the
> current is still busy but the next one is ready.
> But it is not easily possible because the "stuck" descriptor gets
> ready after a huge delay.
> 
> Is this issue known already? Any suggestions?
> 
> 
> Thanks in advance
> 

It could help if you could provide your patch, or at least the kernel version and file (driver)
you are looking at :)

