Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD16011EFFB
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 03:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbfLNC0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 21:26:22 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39293 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbfLNC0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 21:26:22 -0500
Received: by mail-pl1-f195.google.com with SMTP id z3so466962plk.6;
        Fri, 13 Dec 2019 18:26:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wo9r4rSE7tkatlXALGiUFKiH8mcBRFI+jPzXnhl2cfA=;
        b=pYWqPS+yIkKuHiEwb6zXocjPm7l36BEcZ78c/NDVU1+swy4023cBPnHRiWpQfja72N
         j3RzbMdu1FWpdjFJt+ZeUlQiFZbgpOOu3vsqIzkbuyi+xzv1liUC23PYXel+Qf8MNpJr
         7eF2GFd47dCvNviHfI7f9Korl3gxM4Htm/rqIH1q+WL8sNl/jtDXSG3SYLr3Spml6d5d
         zBfvjiHER6GopAc7Cjxvkx7HZ8klvIp8fylrFsHSvCgJFpia06kXYdD6Sm3E3pNChkbb
         slWaNEOXIv6kGjyxQCdlyKwKVDNo2xmR8dh4rSOqK+xLaRcsDIEU2RqNwGd2qqv1oSW0
         Ex1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wo9r4rSE7tkatlXALGiUFKiH8mcBRFI+jPzXnhl2cfA=;
        b=cidnFo1qpkL2mU4em1iG155kIq+qkZKrQORiQB2W+pnlX1dI9rlvjlnDAWYnOhgMUB
         d4vnz1dwBsE1OLHv02hbTtGRCzwTH7e7M0+QGM61Lgnk/9rCXbadg0S5A25cxPf8oXSV
         eKi6JgTP8YBrlCHpllKK8IYMBY7D2TrQ9gC20bmIsbhrSelCvqFvgIKHXbBfaT7IDNCs
         VNm7Q9Uh5E6Z+flpOFtzvm2+rIg9LG6tHc8CNVb16KngcuhFHNy7Utk/E0xvQ9q0iem0
         AoKcgojIaodzWgV5KPEKvzr5lAL8edxo98IUmQoCr0Gxa3lO3/whVsuS6q9mpQLBmeHd
         RlsA==
X-Gm-Message-State: APjAAAU5MJSpkOjqJ2sAyk6yUrDHKbx6pRUJMBQHaLJRSUqES0c0+HiM
        iZPKIrNNOuy5aDRlNW6g8AQwkkky
X-Google-Smtp-Source: APXvYqwb2NNfitr3h1l3OCGbxsq+7rCO9SoUjygkxl5kMpKAC26eJJNMyB3J11KWm1dF8n09f1hcJg==
X-Received: by 2002:a17:90a:374f:: with SMTP id u73mr3214261pjb.22.1576290381190;
        Fri, 13 Dec 2019 18:26:21 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id a26sm13343187pfo.5.2019.12.13.18.26.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2019 18:26:20 -0800 (PST)
Subject: Re: [PATCH bpf-next 00/13] Introduce BPF STRUCT_OPS
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, kernel-team@fb.com,
        netdev@vger.kernel.org
References: <20191214004737.1652076-1-kafai@fb.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <3928131b-2c70-759a-c12b-e7258942e189@gmail.com>
Date:   Fri, 13 Dec 2019 18:26:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191214004737.1652076-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/13/19 4:47 PM, Martin KaFai Lau wrote:
> This series introduces BPF STRUCT_OPS.  It is an infra to allow
> implementing some specific kernel's function pointers in BPF.
> The first use case included in this series is to implement
> TCP congestion control algorithm in BPF  (i.e. implement
> struct tcp_congestion_ops in BPF).
> 
> There has been attempt to move the TCP CC to the user space
> (e.g. CCP in TCP).   The common arguments are faster turn around,
> get away from long-tail kernel versions in production...etc,
> which are legit points.
> 
> BPF has been the continuous effort to join both kernel and
> userspace upsides together (e.g. XDP to gain the performance
> advantage without bypassing the kernel).  The recent BPF
> advancements (in particular BTF-aware verifier, BPF trampoline,
> BPF CO-RE...) made implementing kernel struct ops (e.g. tcp cc)
> possible in BPF.
> 
> The idea is to allow implementing tcp_congestion_ops in bpf.
> It allows a faster turnaround for testing algorithm in the
> production while leveraging the existing (and continue growing) BPF
> feature/framework instead of building one specifically for
> userspace TCP CC.
>

This is awesome work Martin !

