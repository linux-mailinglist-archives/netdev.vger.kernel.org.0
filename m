Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448A93609AA
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 14:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbhDOMos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 08:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbhDOMor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 08:44:47 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A38C061574
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 05:44:23 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id w186so7868581wmg.3
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 05:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=V8GSsxBnqQoo40VJ4UWzwLekusr1w/KeqY7pgNwrgC8=;
        b=EvFFj32pbqHKGpGi8PnGHfcnNovqt3tiypMmcV23t2x5SggJAzSosNjlpMNQQvmpTC
         rSBKobp7VDE3jAwyJgLqI4IFPTIEtgZftPPsGxd3tU6gRO1pkxSTO5hiT7JFV/iJik2J
         GSRaxBhRZtwnske7SKk4csfxU54D4OIiZElKZG49CrihyKNXZ39PtFVNVINEND3j6A3H
         xN9Z8vle+miXewC8z61TTgAAX4tUheplty24QeiCoO3GkW32ixyBpVN4a/5kHxMpb7TT
         5N63EJ7OjIF5uOSNelz2W3/XY1j5Q6Y64c6yuZzw2RZJUwDRSVA624M7ljBf3/piPayp
         xK0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V8GSsxBnqQoo40VJ4UWzwLekusr1w/KeqY7pgNwrgC8=;
        b=h7iCJqzk2ChGN+l1Qf0Xxfi79wR3pkih5ZEZdvjZOj4H1I57sz8N30zvG1nzVevzuy
         zVxUfTIDrwk0EyVI226rMyI9gCpBoNbwV9v4nBNJAY0rXFTbHyVK2zgnuYbQK6ZUEEBf
         UgMIbMbmUJwYUNSwFbZIPx7u5FsC3J15DxadtSA+DWOIQ/wI2tNf8NfHtEnT4kVbHcXT
         EvmFjKJT7oQ1nqLK1JyXjrT2kaCrZffENICS7S7TeB8xz3rDeZCNGynDhRwWoh5zBx81
         q5EkbcSDmwev4gWPEtgcmlRUZdMZEF/k/5HFbK53rYx0d+XrSkvWQNvXh3xwxnoQVM9Q
         /adA==
X-Gm-Message-State: AOAM532Zc3xG4BOg2WTNLFYxiV41pEathxvsgYkrYWYwy7kJESW0nHPC
        a5JUIKslLZvkmuW64bAfUb3EoneinaqrIw==
X-Google-Smtp-Source: ABdhPJzVck9u4puoiXhVyJszIRSeC1B52zBGkdTpZAe3Xb0l+q8MQC286UhpaUhoViyxIemNcceakw==
X-Received: by 2002:a7b:c098:: with SMTP id r24mr2970111wmh.77.1618490662379;
        Thu, 15 Apr 2021 05:44:22 -0700 (PDT)
Received: from [192.168.1.122] (cpc159425-cmbg20-2-0-cust403.5-4.cable.virginm.net. [86.7.189.148])
        by smtp.gmail.com with ESMTPSA id k16sm2968132wro.11.2021.04.15.05.44.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 05:44:21 -0700 (PDT)
Subject: Re: Panic in sfc module on boot since 5.10
To:     Trevor Hemsley <themsley@voiceflex.com>
References: <c510abba-3e99-6d7e-64ad-572d55d73695@voiceflex.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>
Message-ID: <5ba94d4f-65ae-befc-d977-cbad64fa984f@gmail.com>
Date:   Thu, 15 Apr 2021 13:44:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <c510abba-3e99-6d7e-64ad-572d55d73695@voiceflex.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/04/2021 10:03, Trevor Hemsley wrote:
> Hi,
> 
> I run Fedora 32 and since kernels in the 5.10 series I have been unable to boot without getting a panic in the sfc module. I tried on 5.11.12 tonight and the crash still occurs. I have tried reporting this via Fedora channels but the silence has been deafening
Seems Red Hat couldn't even be bothered to forward it to us :sigh:

> and I suspect this is an upstream issue anyway.
You could try building an upstream kernel and driver, and attempting to
 reproduce the issue there.  That would remove some of the unknowns.

> BUG: kernel NULL pointer dereference, address: 0000000000000104

> RIP: 0010:efx_farch_ev_process+0x3d2/0x910 [sfc]
> Code: c0 02 39 f0 76 34 c1 fe 02 41 03 b6 28 07 00 00 83 e1 03 49 8b 84 f6 d0 00 00 00 48 8b 94 c8 80 09 00 00 b0 01 00 00 00 31 c9 <f0> 8f b1 8a 04 81 00 00 05 c0 0f 05 37 03 00 00 48 8d 74 24 20 4c
Hmm, I think this is actually <f0> 0f b1 8a 04 01 00 00 85...
 which decodes as lock cmpxchg %ecx,0x104(%rdx)
With other transcription errors fixed, the key sequence appears to be
    mov $0x1,%eax
    xor %ecx,%ecx
    lock cmpxchg %ecx,0x104(%rdx)
So we're saying "if (rdx[0x104] == 1) rdx[0x104] = 0", only atomically.
I'd *guess* this is the atomic_cmpxchg() in efx_farch_handle_tx_flush_done()
 (though it'd be nice to have your sfc.ko, with debugging symbols, to
 check for certain).
Which in turn tells us that tx_queue is NULL; this is suspicious
 because the relevant commits
    a81dcd85a7c1 ("sfc: assign TXQs without gaps")
    12804793b17c ("sfc: decouple TXQ type from label")
 happened at about the right time to cause this regression.
So now I have to go off and figure out exactly what the semantics
 of this TX flush done event's 'subdata' field are... looks like it
 probably corresponds to tx_queue->queue from
 efx_farch_flush_tx_queue().
Unfortunately, there is no simple lookup to convert from qid to
 tx_queue, because we just allocate queues as-needed in
 efx_set_channels() and don't store the reverse mapping (everything
 else works by label rather than queue, so doesn't need it).
I think the right fix is probably just to have
 efx_farch_handle_tx_flush_done() (and presumably also
 efx_farch_handle_rx_flush_done()) iterate over all queues (or at
 least all queues on the channel that received the event; but
 possibly the events might always be delivered to channel 0 rather
 than necessarily the channel that owns the queue) and perform the
 handling on any queue whose qid matches.
I will followup with a patch, hopefully some time next week if I can
 find a 6122F to test with.

> Just prior to the crash I get a pair of messages that don't look particularly right but I get these on 5.9.16 too and that survives.
> 
> [    9.027961] sfc 0000:0b:00.0 enp11s0f0np0: MC command 0x2a inlen 16 failed rc=-22 (raw=0) arg=0
> [    9.029895] sfc 0000:0b:00.1 enp11s0f1np1: MC command 0x2a inlen 16 failed rc=-22 (raw=0) arg=0

0x2a is MC_CMD_SET_LINK, which gets called in a variety of situations
 like MTU change, link advertising change (e.g. ethtool -s), and SFP+
 module hotplug.  An -EINVAL failure typically means we've asked for
 some combination of link modes that is unsupported or nonsensical; to
 investigate this further you could try with the mcdi_logging_default=1
 module parameter, which will log all MC commands and responses at
 KERN_INFO — these can then be decoded by reference to mcdi_pcol.h.
In any case this seems to be unrelated to the above issue.

-ed
