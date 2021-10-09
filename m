Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56CF2427C12
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 18:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhJIQou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 12:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhJIQot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 12:44:49 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69B3C061570;
        Sat,  9 Oct 2021 09:42:52 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id a25so32631447edx.8;
        Sat, 09 Oct 2021 09:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oC3W0L4nbj+Es3qnEJSnPIpp2bogBOkZdrry4xHeY8Y=;
        b=hbfKNn7sYURhUZT0/cn/Y5MI5W30HAzpz+g/ZdDeyc3fLP7UgvcB8X800okGHUOSEb
         qArJoFO58daWe3xe9XhgXSbo1274tYU7URbayX4mKAuow2RANl9nkZ8aX1Zxz7/rU2AW
         wpZIUekchUR4dePvshcMnwWSYcioGwjWE8SFfzT39QupeMvMkmLilAco8hoV2P8m/1Oc
         YNpacH967Vji89pQkbHlgbp1iArI49xCGCaTVzoTPLEEW71pr0C0D3ozCH7grr8VkBeP
         vBQmB7748J+9vAKI9hDZgnLLYaNeWRSRUxAhNyzngnRPrdhZHrwxs47FVFFJ+9hUDeba
         s0sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oC3W0L4nbj+Es3qnEJSnPIpp2bogBOkZdrry4xHeY8Y=;
        b=njE0atsCv8KMc4UyCdDpEmhzYrMvgLHIMpJz4JUxXji/d0i5pv96g6VhdZIhIfkhqt
         0yjkqH5B2ODW8Ggf7RTMuO3ZQn6LA+iW+ft08cLen1LxgVn8Zzy+xOuMPFDAAg9/ZLx2
         bzycSJVmfBETGSavJIaT2TD0FnDFS3XQm/ZrWP/is03jNdWOHWHYkMtpkuB2i0SDRD9o
         iy9bSdLiZ8M77s4sEF3acXtK5yEosn7lOCew7IX9/DVEyuWNq6h3PsEpqRpbpmwnDMUJ
         bjTwvR64TpONXLRejnpsUG8A2uYqMquNnovH7ywkXYMH/y20T8tPtz+Y0fH3U0UvjgcY
         8uMQ==
X-Gm-Message-State: AOAM530/GNyGCsPAR7tGgeasTSXftxbtVh+P3Ul1Z+QRrNGRi8TVz0Ah
        Cy9Z4skRrjbClMsw5Z3G2Rg=
X-Google-Smtp-Source: ABdhPJysCc2OxyudNqo7dV0pCLF+VuQvNPKj5bnrtzr3FBJNjovVxLB4M+c/ptbAwICZCNlIdLDhoA==
X-Received: by 2002:a50:da8f:: with SMTP id q15mr25805243edj.139.1633797771213;
        Sat, 09 Oct 2021 09:42:51 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id g2sm1424437edq.81.2021.10.09.09.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 09:42:50 -0700 (PDT)
Date:   Sat, 9 Oct 2021 19:42:49 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: procfs: add seq_puts() statement for
 dev_mcast
Message-ID: <20211009164249.euf7dfpccr6kz7a3@skbuf>
References: <20210816085757.28166-1-yajun.deng@linux.dev>
 <20211009163511.vayjvtn3rrteglsu@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211009163511.vayjvtn3rrteglsu@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 09, 2021 at 07:35:11PM +0300, Vladimir Oltean wrote:
> On Mon, Aug 16, 2021 at 04:57:57PM +0800, Yajun Deng wrote:
> > Add seq_puts() statement for dev_mcast, make it more readable.
> > As also, keep vertical alignment for {dev, ptype, dev_mcast} that
> > under /proc/net.
> > 
> > Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> > ---
> 
> FYI, this program got broken by this commit (reverting it restores
> functionality):
> 
> root@debian:~# ifstat
> ifstat: /proc/net/dev: unsupported format.
> 
> Confusingly enough, the "ifstat" provided by Debian is not from iproute2:
> https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/tree/misc/ifstat.c
> but rather a similarly named program:
> https://packages.debian.org/source/bullseye/ifstat
> https://github.com/matttbe/ifstat
> 
> I haven't studied how this program parses /proc/net/dev, but here's how
> the kernel's output changed:

Ah, it scrapes the text for "Inter-|":
https://github.com/matttbe/ifstat/blob/main/drivers.c#L825

> 
> Doesn't work:
> 
> root@debian:~# cat /proc/net/dev
> Interface|                            Receive                                       |                                 Transmit
>          |            bytes      packets errs   drop fifo frame compressed multicast|            bytes      packets errs   drop fifo colls carrier compressed
>        lo:            97400         1204    0      0    0     0          0         0            97400         1204    0      0    0     0       0          0
>     bond0:                0            0    0      0    0     0          0         0                0            0    0      0    0     0       0          0
>      sit0:                0            0    0      0    0     0          0         0                0            0    0      0    0     0       0          0
>      eno2:          5002206         6651    0      0    0     0          0         0        105518642      1465023    0      0    0     0       0          0
>      swp0:           134531         2448    0      0    0     0          0         0         99599598      1464381    0      0    0     0       0          0
>      swp1:                0            0    0      0    0     0          0         0                0            0    0      0    0     0       0          0
>      swp2:          4867675         4203    0      0    0     0          0         0            58134          631    0      0    0     0       0          0
>     sw0p0:                0            0    0      0    0     0          0         0                0            0    0      0    0     0       0          0
>     sw0p1:           124739         2448    0   1422    0     0          0         0         93741184      1464369    0      0    0     0       0          0
>     sw0p2:                0            0    0      0    0     0          0         0                0            0    0      0    0     0       0          0
>     sw2p0:          4850863         4203    0      0    0     0          0         0            54722          619    0      0    0     0       0          0
>     sw2p1:                0            0    0      0    0     0          0         0                0            0    0      0    0     0       0          0
>     sw2p2:                0            0    0      0    0     0          0         0                0            0    0      0    0     0       0          0
>     sw2p3:                0            0    0      0    0     0          0         0                0            0    0      0    0     0       0          0
>       br0:            10508          212    0    212    0     0          0       212         61369558       958857    0      0    0     0       0          0
> 
> Works:
> 
> root@debian:~# cat /proc/net/dev
> Inter-|   Receive                                                |  Transmit
>  face |bytes    packets errs drop fifo frame compressed multicast|bytes    packets errs drop fifo colls carrier compressed
>     lo:   13160     164    0    0    0     0          0         0    13160     164    0    0    0     0       0          0
>  bond0:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
>   sit0:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
>   eno2:   30824     268    0    0    0     0          0         0     3332      37    0    0    0     0       0          0
>   swp0:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
>   swp1:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
>   swp2:   30824     268    0    0    0     0          0         0     2428      27    0    0    0     0       0          0
>  sw0p0:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
>  sw0p1:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
>  sw0p2:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
>  sw2p0:   29752     268    0    0    0     0          0         0     1564      17    0    0    0     0       0          0
>  sw2p1:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
>  sw2p2:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
>  sw2p3:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
