Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E52A90ABC
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 00:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbfHPWIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 18:08:37 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39037 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727702AbfHPWIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 18:08:37 -0400
Received: by mail-pg1-f193.google.com with SMTP id u17so3584308pgi.6;
        Fri, 16 Aug 2019 15:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KKHGsWwp9VQGZcOx7JBLufoPQpmlvuaisJXdz3bX3gw=;
        b=Jkn31o+e4uQs0EahqmLm4mV9g5QBx1EYv1mbcibd+F/GdP9lJd8/8vekR9wgoOWvJ5
         x3ATYW/MYGpSQuBefNcbX+kAydxew3EHg7CxfjPYRO5NqiQBDF4Fvx9hqIXpui6ElocS
         Sx5nzzY6wHuVzhbjcdYBuzMM1O1Lr2YOTTE/r2E7HP20VEYIlNKPN6m16DPLNxU2kIiG
         K12WZhdMfsPH6vC9yO+4nTutG6nlPUs4cdoWWymMErpx0nClt1u5HaIGy6//oiuqYzdS
         GIy+jMr6KVmwqNOtnYo40wrQ55bHhKTeL3pSIuHejPa78lvJ7akJNbeU4LJA6zsmIpPP
         dJ9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KKHGsWwp9VQGZcOx7JBLufoPQpmlvuaisJXdz3bX3gw=;
        b=F/bCY40jnDVf+JpumO/Ss8T3GxqbiaGVr7cp5Sxaa5eS2SysAKJir70dknRkz4l544
         WIzmjqp6l7SlRwDlgKGzYmY76dwQ5ihrGOKeNG0Iog7AErAemQHfClzMLgbgxxCixNF7
         DaS8pqJ9ZlagomxIA7ks7TjnWl3QSaRDnXc7B7kS5f2SOS5mxqzZ+WQdtKcEt4Y+m6Gx
         uFgr9NiH5LYqmljb5ymZ7lTipYGusi+HD4j5Ynb1LoKHV+pPVnrYze1YD4zgvXv7v+rq
         PTY5gVP/fYM4PpleysqltI6GPoEs1dh7vhsUCRsbcZLPq57TKqo/AFt6yf9BNNMOxiOT
         pLRw==
X-Gm-Message-State: APjAAAWmTNbBdkKQ4yoGl2uk+nWIxTqBW1CmXbMfmuTzXu50bIP58r+Y
        DHCHPaLO/jTFBhirMqsBQVM=
X-Google-Smtp-Source: APXvYqymvxATJjozxNnA+Dw9NWhkSe4BnTdAZZrbxbYUQCtUtiUnBvAU1D9uKS3/fYajOFmjn5YUCg==
X-Received: by 2002:a62:1d8f:: with SMTP id d137mr13178397pfd.207.1565993316106;
        Fri, 16 Aug 2019 15:08:36 -0700 (PDT)
Received: from [169.254.4.234] ([2620:10d:c090:200::3:e378])
        by smtp.gmail.com with ESMTPSA id a10sm9020626pfl.159.2019.08.16.15.08.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 15:08:35 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@gmail.com>
Cc:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        maciej.fijalkowski@intel.com, tom.herbert@intel.com
Subject: Re: [Intel-wired-lan] [PATCH bpf-next 0/5] Add support for SKIP_BPF
 flag for AF_XDP sockets
Date:   Fri, 16 Aug 2019 15:08:34 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <331CAEDB-776A-4928-93EF-F45F1339848F@gmail.com>
In-Reply-To: <CAJ+HfNj=devuEky3VwbibA-j+o=bKi4Gg=MeHsuuDGAKc9p2Vw@mail.gmail.com>
References: <1565840783-8269-1-git-send-email-sridhar.samudrala@intel.com>
 <bebfb097-5357-91d8-ebc7-2f8ede392ad7@intel.com>
 <cc3a09eb-bcb8-a6e1-7175-77bddaf10c11@intel.com>
 <CAJ+HfNj=devuEky3VwbibA-j+o=bKi4Gg=MeHsuuDGAKc9p2Vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16 Aug 2019, at 6:32, Björn Töpel wrote:

> On Thu, 15 Aug 2019 at 18:46, Samudrala, Sridhar
> <sridhar.samudrala@intel.com> wrote:
>>
>> On 8/15/2019 5:51 AM, Björn Töpel wrote:
>>> On 2019-08-15 05:46, Sridhar Samudrala wrote:
>>>> This patch series introduces XDP_SKIP_BPF flag that can be 
>>>> specified
>>>> during the bind() call of an AF_XDP socket to skip calling the BPF
>>>> program in the receive path and pass the buffer directly to the 
>>>> socket.
>>>>
>>>> When a single AF_XDP socket is associated with a queue and a HW
>>>> filter is used to redirect the packets and the app is interested in
>>>> receiving all the packets on that queue, we don't need an 
>>>> additional
>>>> BPF program to do further filtering or lookup/redirect to a socket.
>>>>
>>>> Here are some performance numbers collected on
>>>>    - 2 socket 28 core Intel(R) Xeon(R) Platinum 8180 CPU @ 2.50GHz
>>>>    - Intel 40Gb Ethernet NIC (i40e)
>>>>
>>>> All tests use 2 cores and the results are in Mpps.
>>>>
>>>> turbo on (default)
>>>> ---------------------------------------------
>>>>                        no-skip-bpf    skip-bpf
>>>> ---------------------------------------------
>>>> rxdrop zerocopy           21.9         38.5
>>>> l2fwd  zerocopy           17.0         20.5
>>>> rxdrop copy               11.1         13.3
>>>> l2fwd  copy                1.9          2.0
>>>>
>>>> no turbo :  echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
>>>> ---------------------------------------------
>>>>                        no-skip-bpf    skip-bpf
>>>> ---------------------------------------------
>>>> rxdrop zerocopy           15.4         29.0
>>>> l2fwd  zerocopy           11.8         18.2
>>>> rxdrop copy                8.2         10.5
>>>> l2fwd  copy                1.7          1.7
>>>> ---------------------------------------------
>>>>
>>>
>>> This work is somewhat similar to the XDP_ATTACH work [1]. Avoiding 
>>> the
>>> retpoline in the XDP program call is a nice performance boost! I 
>>> like
>>> the numbers! :-) I also like the idea of adding a flag that just 
>>> does
>>> what most AF_XDP Rx users want -- just getting all packets of a
>>> certain queue into the XDP sockets.
>>>
>>> In addition to Toke's mail, I have some more concerns with the 
>>> series:
>>>
>>> * AFAIU the SKIP_BPF only works for zero-copy enabled sockets. IMO, 
>>> it
>>>    should work for all modes (including XDP_SKB).
>>
>> This patch enables SKIP_BPF for AF_XDP sockets where an XDP program 
>> is
>> attached at driver level (both zerocopy and copy modes)
>> I tried a quick hack to see the perf benefit with generic XDP mode, 
>> but
>> i didn't see any significant improvement in performance in that
>> scenario. so i didn't include that mode.
>>
>>>
>>> * In order to work, a user still needs an XDP program running. 
>>> That's
>>>    clunky. I'd like the behavior that if no XDP program is attached,
>>>    and the option is set, the packets for a that queue end up in the
>>>    socket. If there's an XDP program attached, the program has
>>>    precedence.
>>
>> I think this would require more changes in the drivers to take XDP
>> datapath even when there is no XDP program loaded.
>>
>
> Today, from a driver perspective, to enable XDP you pass a struct
> bpf_prog pointer via the ndo_bpf. The program get executed in
> BPF_PROG_RUN (via bpf_prog_run_xdp) from include/linux/filter.h.
>
> I think it's possible to achieve what you're doing w/o *any* driver
> modification. Pass a special, invalid, pointer to the driver (say
> (void *)0x1 or smth more elegant), which has a special handling in
> BPF_RUN_PROG e.g. setting a per-cpu state and return XDP_REDIRECT. The
> per-cpu state is picked up in xdp_do_redirect and xdp_flush.
>
> An approach like this would be general, and apply to all modes
> automatically.
>
> Thoughts?

All the default program does is check that the map entry contains a xsk,
and call bpf_redirect_map().  So this is pretty much the same as above,
without any special case handling.

Why would this be so expensive?  Is the JIT compilation time being 
counted?
-- 
Jonathan

>
>>>
>>> * It requires changes in all drivers. Not nice, and scales badly. 
>>> Try
>>>    making it generic (xdp_do_redirect/xdp_flush), so it Just Works 
>>> for
>>>    all XDP capable drivers.
>>
>> I tried to make this as generic as possible and make the changes to 
>> the
>> driver very minimal, but could not find a way to avoid any changes at
>> all to the driver. xdp_do_direct() gets called based after the call 
>> to
>> bpf_prog_run_xdp() in the drivers.
>>
>>>
>>> Thanks for working on this!
>>>
>>>
>>> Björn
>>>
>>> [1]
>>> https://lore.kernel.org/netdev/20181207114431.18038-1-bjorn.topel@gmail.com/
>>>
>>>
>>>
>>>> Sridhar Samudrala (5):
>>>>    xsk: Convert bool 'zc' field in struct xdp_umem to a u32 bitmap
>>>>    xsk: Introduce XDP_SKIP_BPF bind option
>>>>    i40e: Enable XDP_SKIP_BPF option for AF_XDP sockets
>>>>    ixgbe: Enable XDP_SKIP_BPF option for AF_XDP sockets
>>>>    xdpsock_user: Add skip_bpf option
>>>>
>>>>   drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 22 +++++++++-
>>>>   drivers/net/ethernet/intel/i40e/i40e_xsk.c    |  6 +++
>>>>   drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 20 ++++++++-
>>>>   drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 16 ++++++-
>>>>   include/net/xdp_sock.h                        | 21 ++++++++-
>>>>   include/uapi/linux/if_xdp.h                   |  1 +
>>>>   include/uapi/linux/xdp_diag.h                 |  1 +
>>>>   net/xdp/xdp_umem.c                            |  9 ++--
>>>>   net/xdp/xsk.c                                 | 43 
>>>> ++++++++++++++++---
>>>>   net/xdp/xsk_diag.c                            |  5 ++-
>>>>   samples/bpf/xdpsock_user.c                    |  8 ++++
>>>>   11 files changed, 135 insertions(+), 17 deletions(-)
>>>>
>> _______________________________________________
>> Intel-wired-lan mailing list
>> Intel-wired-lan@osuosl.org
>> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
