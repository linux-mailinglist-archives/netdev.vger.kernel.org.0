Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47145F79C5
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 18:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfKKRWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 12:22:16 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39637 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbfKKRWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 12:22:15 -0500
Received: by mail-pf1-f193.google.com with SMTP id x28so11095756pfo.6;
        Mon, 11 Nov 2019 09:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Pr9jUK9hpR06BOxorbUjpb5j/ZN+oD1+Umx76qwU/ks=;
        b=uf1FoXh7fETXaGUhjBbp1T0r6CHwI2Dr0B3c5/VWEfLu3oqNHcFsc0fmItV0uJmq3P
         +D/IKTD0cd2b3I8MJ1DlfzK4aPwBPyOHrZoRijpaBRnHqhuNWF0uVTcptuQciwbSH3Hr
         VOqc+twXNgZBes7Pi5nsgp1m9EImrPDePgQukr8Fs/lg9zQR2UIvejFAdZOuihrh6Pi+
         zrcQYtmZZu/z1K9k/YKTSaHjmsXxAiBa/9VritC+iwiLspUivPd+paxlgcDSVNiOqJS/
         He4bJsqwkJaZrJU+Q9CODk/JDt93TlayEdZlQ+FyEmGgB1L7j4tZxyJv+lv4jjYxi7le
         4ruA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Pr9jUK9hpR06BOxorbUjpb5j/ZN+oD1+Umx76qwU/ks=;
        b=HhnPZm8bkqPvkYxroaa5dTV3pmDhcBUFGjso6marc7x+AQFY5Vybkwz/4HGZPbgijv
         DTUTRuRSb92UpjUPQpzXcs2RgBaBB6Ygky16FslXy4o7iqYyAVCMQIGQa+QkXzyrHsXp
         mvpJxuyLZTEzqRECPzfdDNcYfW4/5/s+dVfScu3ZJKBdZ0y1sCmueebFXU47xmfR/DAO
         taUipBu8K7oikvBrlcI5BPsLqKb39ZUjmRKVpL4QybBTLj5bO6fjL5K7jRwRzxC7XUFH
         +4lWPql8EKHxS74CyDn56uH99sthiuFwrJvec8a/R93LJsN1olqJILW3ASMjnSmndHpo
         +BgQ==
X-Gm-Message-State: APjAAAXez8KzHQ72dlTYYQPxAthuVqb4J8TtqkfRwLocitxRCMLFtQJO
        M9CbsTTM9DRQ5mWnaoKsfjQPYZjV
X-Google-Smtp-Source: APXvYqyfVniq/GPk0yH5+Occz+MRoBCdn4jwH3FWqvxY0j6sD3Ae+bwribzwRueZ1UFivRTL+8x6+w==
X-Received: by 2002:a63:3203:: with SMTP id y3mr29971550pgy.437.1573492933488;
        Mon, 11 Nov 2019 09:22:13 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id a34sm17956799pgl.56.2019.11.11.09.22.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 09:22:12 -0800 (PST)
Subject: Re: [PATCH] net: remove static inline from dev_put/dev_hold
To:     Tony Lu <tonylu@linux.alibaba.com>, davem@davemloft.net
Cc:     shemminger@osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191111140502.17541-1-tonylu@linux.alibaba.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c6230ad9-e859-4bee-dacb-4d7910a3f120@gmail.com>
Date:   Mon, 11 Nov 2019 09:21:58 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191111140502.17541-1-tonylu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/11/19 6:05 AM, Tony Lu wrote:
> This patch removes static inline from dev_put/dev_hold in order to help
> trace the pcpu_refcnt leak of net_device.
> 
> We have sufferred this kind of issue for several times during
> manipulating NIC between different net namespaces. It prints this
> log in dmesg:
> 
>   unregister_netdevice: waiting for eth0 to become free. Usage count = 1
> 
> However, it is hard to find out who called and leaked refcnt in time. It
> only left the crime scene but few evidence. Once leaked, it is not
> safe to fix it up on the running host. We can't trace dev_put/dev_hold
> directly, for the functions are inlined and used wildly amoung modules.
> And this issue is common, there are tens of patches fix net_device
> refcnt leak for various causes.
> 
> To trace the refcnt manipulating, this patch removes static inline from
> dev_put/dev_hold. We can use handy tools, such as eBPF with kprobe, to
> find out who holds but forgets to put refcnt. This will not be called
> frequently, so the overhead is limited.
>

This looks as a first step.

But I would rather get a full set of scripts/debugging features,
instead of something that most people can not use right now.

Please share the whole thing.

