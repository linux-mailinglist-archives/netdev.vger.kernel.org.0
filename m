Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 958BD11EFD5
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 02:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfLNB76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 20:59:58 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:37390 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfLNB75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 20:59:57 -0500
Received: by mail-pj1-f67.google.com with SMTP id ep17so479384pjb.4;
        Fri, 13 Dec 2019 17:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LxNQ93N0kzZYFokT7bl3z1w7v0WAye//I7zpGer0E8s=;
        b=VxYFXFAmZAHGDCOJ3wSwm/jC1vdG/ArsWrqdALacCEtvdbE5xdIaTmueBXmX1vgMVx
         y4VYLmEQfnWBqF/1WPnWeh+fdojnsAJqfmUzj2w6nvy2L7D/PSpVMkSuFvq4Kz5jvYWO
         HtWqpkpuSCw6OMVCgUCSkEsAizj8X+4nk7FztPs1VuEWjRpjVDljQ0CPbBP1QJHLq5H9
         Cf4f8C21yL/+M8Q3Q+xXFMtGpSjG58ROda3OlO8Vg+UQL3zRLjP8Ki2wfP0MVQHDvXk/
         POlu/nYRKW/FXhDqy9tjPTfR9/3jN+efcf30crcBPXTiGGAVG7UO5tRyhB+7bDj1V1Xm
         vfxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LxNQ93N0kzZYFokT7bl3z1w7v0WAye//I7zpGer0E8s=;
        b=KcWOzSA+W1Qyeu/XNigahAeS7xhxgMajAhkZdHNsWi97oGof58guatXVj3ddJl4EpM
         O7h0CWV4BSOBP64A5S0eQF8IRz2H7wdwHABQeSIORF4zmuxdH+LZCPfLqbxpTyEm7QZg
         ZZMPBlgqSHFuZXOlFj62yglmamHGmk5NtrmORXiBHGqNQa4aNen+/atYRbMBSv1FtDuf
         f6BLhtXU3YQ238D00t3PicjxmBWHdXhuxEwfhkrQdtyGwZYrm3DucJZQMd606dAZnp+I
         mhSWe6iKW4JBlXC0LJJMr6R7RQGZG7XsAev48KrdZKXt5mGFlUJ6dLBkQXvMD7uqygTy
         hKpw==
X-Gm-Message-State: APjAAAWv1R8ROAmdg2wDtT5O6/i8XSIZzLPDPr44b4zVrAvc47iskxom
        8Oqz+SY6oMRD6FK5Zm+5sVpis0aG
X-Google-Smtp-Source: APXvYqzTgdBq2WJRmx15b0V06YvyK3H4fOGH1sDPHA+p2USbqoxw30H1cKx95Gp+1FzolDAH1SUg8g==
X-Received: by 2002:a17:90a:9c1:: with SMTP id 59mr3044962pjo.65.1576288795960;
        Fri, 13 Dec 2019 17:59:55 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id j14sm12152148pgs.57.2019.12.13.17.59.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2019 17:59:55 -0800 (PST)
Subject: Re: [PATCH bpf-next 09/13] bpf: Add BPF_FUNC_jiffies
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, kernel-team@fb.com,
        netdev@vger.kernel.org
References: <20191214004737.1652076-1-kafai@fb.com>
 <20191214004758.1653342-1-kafai@fb.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b321412c-1b42-45a9-4dc6-cc268b55cd0d@gmail.com>
Date:   Fri, 13 Dec 2019 17:59:54 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191214004758.1653342-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/13/19 4:47 PM, Martin KaFai Lau wrote:
> This patch adds a helper to handle jiffies.  Some of the
> tcp_sock's timing is stored in jiffies.  Although things
> could be deduced by CONFIG_HZ, having an easy way to get
> jiffies will make the later bpf-tcp-cc implementation easier.
> 

...

> +
> +BPF_CALL_2(bpf_jiffies, u64, in, u64, flags)
> +{
> +	if (!flags)
> +		return get_jiffies_64();
> +
> +	if (flags & BPF_F_NS_TO_JIFFIES) {
> +		return nsecs_to_jiffies(in);
> +	} else if (flags & BPF_F_JIFFIES_TO_NS) {
> +		if (!in)
> +			in = get_jiffies_64();
> +		return jiffies_to_nsecs(in);
> +	}
> +
> +	return 0;
> +}

This looks a bit convoluted :)

Note that we could possibly change net/ipv4/tcp_cubic.c to no longer use jiffies at all.

We have in tp->tcp_mstamp an accurate timestamp (in usec) that can be converted to ms.


Have you thought of finding a way to not duplicate the code for cubic and dctcp, maybe
by including a template ?

Maintaining two copies means that future changes need more maintenance work.
