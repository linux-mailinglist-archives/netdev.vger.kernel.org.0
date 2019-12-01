Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E82E710E275
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 17:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbfLAQGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 11:06:01 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:32949 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbfLAQGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 11:06:00 -0500
Received: by mail-io1-f67.google.com with SMTP id j13so37547203ioe.0
        for <netdev@vger.kernel.org>; Sun, 01 Dec 2019 08:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=j6OtAq0I54jNaHod0R8HQTI4LJW0XcH5J+R1X6sKSRA=;
        b=bhgNkFESUQRMWsw8xUZV8D7RlcH+oEMjadwrENPwyI6GvslN3aAidWv6rSu4JRALOY
         24q/K85KlL5C9cipvvBbzEdztXZ5occ+5qFqDMW9UY2/oZ5yvX3pT1EFK5ZU6bRubkzI
         lvVfhDvAfIHe7qM7B4WeCfu8vIFCrbnuHjU9T/QAdporhZYGDk5EDX9OzFHDw6APKF/g
         qqxiJ7kQn1a46SdBFtNRIAR5s8l75MWjEnu5NCISD3rxBA+xjAwJrZjsACUf7cDzo5/p
         Kp+hiVXlX94mBpRmJiuPmHQMQ2nAKs+HJWbJgFH7AiiJgwAUoBcYh387QiWb2Y/FtuIm
         8/Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j6OtAq0I54jNaHod0R8HQTI4LJW0XcH5J+R1X6sKSRA=;
        b=tWrITmj2i+xS7FcAm6Fa1CM3VwLt0D+STwxJrMtlBMx1inI3Ru9o2y/IMbej8B+7Zb
         c0nxHlRWvprRXCQ1JFSWznVAxlAcudnayHNSJCFhaRMs1fUZHYYhNhnCmyKfFzwLOtNI
         /uXAzCwXlNGuPuxYlqlUfvvKRuTCxHbT/0XAIGrX+RwMf7hsN86pVnDcdOs0b5HoNa/+
         tWjul2T8U17YFhcnHVZLOk/HDddvf5NiVtYoXMSbD39PFLEJiDVg5lIPi6jtOmLXcpGJ
         jo6NBJNdkg8OIO8aCafFViiRqxS1idAXqMNeiCPPtvmasJ+pCOE8ZvgRBFr1r1MaOfed
         nstw==
X-Gm-Message-State: APjAAAV+JK1VW/yrxO1/eFmkcvYC4hMee6gFOsG9hs7YQdY9Vr6oUlnL
        dEQ4IzGytxlG9OldJDGhyuH1u+JR
X-Google-Smtp-Source: APXvYqyEY88oF6MGfnbE5z9++EAy2lPkryro0Y95uQe6MZhreck8GtwKf1AMUF0eZzoIRsV8Hx7bCQ==
X-Received: by 2002:a5d:8184:: with SMTP id u4mr49265110ion.155.1575216359885;
        Sun, 01 Dec 2019 08:05:59 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:fd6b:fde:b20f:61ed])
        by smtp.googlemail.com with ESMTPSA id d8sm7239168ioq.84.2019.12.01.08.05.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Dec 2019 08:05:58 -0800 (PST)
Subject: Re: Linux kernel - 5.4.0+ (net-next from 27.11.2019) routing/network
 performance
To:     =?UTF-8?Q?Pawe=c5=82_Staszewski?= <pstaszewski@itcare.pl>,
        netdev@vger.kernel.org
References: <81ad4acf-c9b4-b2e8-d6b1-7e1245bce8a5@itcare.pl>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <589d2715-80ae-0478-7e31-342060519320@gmail.com>
Date:   Sun, 1 Dec 2019 09:05:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <81ad4acf-c9b4-b2e8-d6b1-7e1245bce8a5@itcare.pl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/29/19 4:00 PM, Paweł Staszewski wrote:
> As always - each year i need to summarize network performance for
> routing applications like linux router on native Linux kernel (without
> xdp/dpdk/vpp etc) :)
> 

Do you keep past profiles? How does this profile (and traffic rates)
compare to older kernels - e.g., 5.0 or 4.19?


> HW setup:
> 
> Server (Supermicro SYS-1019P-WTR)
> 
> 1x Intel 6146
> 
> 2x Mellanox connect-x 5 (100G) (installed in two different x16 pcie
> gen3.1 slots)
> 
> 6x 8GB DDR4 2666 (it really matters cause 100G is about 12.5GB/s of
> memory bandwidth one direction)
> 
> 
> And here it is:
> 
> perf top at 72Gbit.s RX and 72Gbit/s TX (at same time)
> 
>    PerfTop:   91202 irqs/sec  kernel:99.7%  exact: 100.0% [4000Hz
> cycles:ppp],  (all, 24 CPUs)
> ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
> 
> 
>      7.56%  [kernel]       [k] __dev_queue_xmit
>      5.27%  [kernel]       [k] build_skb
>      4.41%  [kernel]       [k] rr_transmit
>      4.17%  [kernel]       [k] fib_table_lookup
>      3.83%  [kernel]       [k] mlx5e_skb_from_cqe_mpwrq_linear
>      3.30%  [kernel]       [k] mlx5e_sq_xmit
>      3.14%  [kernel]       [k] __netif_receive_skb_core
>      2.48%  [kernel]       [k] netif_skb_features
>      2.36%  [kernel]       [k] _raw_spin_trylock
>      2.27%  [kernel]       [k] dev_hard_start_xmit

