Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A88A918251F
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 23:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387404AbgCKWky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 18:40:54 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:47026 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729956AbgCKWky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 18:40:54 -0400
Received: by mail-pg1-f196.google.com with SMTP id y30so1969924pga.13;
        Wed, 11 Mar 2020 15:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=9SRTk6Qjjk1tP01EZ8totvHB8j0f9Ncy1D8Goqn/0Y4=;
        b=m9xOawrqvlJHFzsBp6vzwIzlaeE/ayvB8eHf6iDbhwErGvNLbDqj2OmmFgSNi9ceB4
         72HT+gHZL95NE7E9KZS/QygKbWdK+Js5hLbZtQmV/8OiK5x/YlnyoWwvU/JK4W4yrrkZ
         rIHulPL/meujfaqlej+fj4dIdeLVs0QEw/snHuwkIscDMXn8kudxQf0kqarqd2vuqSzw
         lRsUDARxs5ENKq8GEkH7FEWf7tHdkxGMTILoiDhHr8phgtusLFgqFv0GXXl2Ay+3htCo
         McW8/iouPDg86ebQCwfO6flhktLwjNA5EnE1H9OWd+V7aIy507N+0w02Wf6pI+m1y/RP
         SXBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=9SRTk6Qjjk1tP01EZ8totvHB8j0f9Ncy1D8Goqn/0Y4=;
        b=auU7oKe1pB7IWN9xlqny0Qy8qQyfMpG9Geugr+FtJ6G9msqLbaI1kJ7B4VmfaT5ES3
         9/YyXUcI1HL1T4f9KliFyYKndl1xzwqnkp+8/TLYlCPIONcIX3/GzbPEcEvpz8R2Mg7Q
         OlurUNehRwdYOrIOtnXHK1Aept1RpuVeJhNtYayorDkA9JcrzQtwDZT95KmUBKzoYEZ/
         BzySbBPnMQD0PDd/cEo0QG62AHdpEXIOABHS4IWQ0xV4xXDknVVAnBbkHapYkEv+bGLz
         ATrYVO2dMxihSzIDuJ8EOQt1zpKeCXCDA67SSNGjcrynuog/iS3+k2oQPlMtIk/XsnXH
         mfCQ==
X-Gm-Message-State: ANhLgQ2jO76X5doUQZaMcR5NWQSOFh3X51sSs3yl8rpbu6FJMfGi7v1X
        nUcaE+JFTGZrRXxFn17oTekGbI8Y
X-Google-Smtp-Source: ADFU+vvpHWFqeJUKUlvQTkEOJHFRg8TclUxUyMK06u67ywTIf7wefljUep7uXke4/z51voptdbSxDQ==
X-Received: by 2002:aa7:8f36:: with SMTP id y22mr5064328pfr.162.1583966451153;
        Wed, 11 Mar 2020 15:40:51 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id n5sm170747pfq.35.2020.03.11.15.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 15:40:50 -0700 (PDT)
Date:   Wed, 11 Mar 2020 15:40:43 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Lorenz Bauer <lmb@cloudflare.com>, kernel-team@cloudflare.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <5e6968eb5c09c_20552ab9153405b419@john-XPS-13-9370.notmuch>
In-Reply-To: <87y2s7xayn.fsf@cloudflare.com>
References: <20200310174711.7490-1-lmb@cloudflare.com>
 <87y2s7xayn.fsf@cloudflare.com>
Subject: Re: [PATCH 0/5] Return fds from privileged sockhash/sockmap lookup
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Tue, Mar 10, 2020 at 06:47 PM CET, Lorenz Bauer wrote:
> > We want to use sockhash and sockmap to build the control plane for
> > our upcoming BPF socket dispatch work. We realised that it's
> > difficult to resize or otherwise rebuild these maps if needed,
> > because there is no way to get at their contents. This patch set
> > allows a privileged user to retrieve fds from these map types,
> > which removes this obstacle.
> 
> Since it takes just a few lines of code to get an FD for a sock:
> 
> 	fd = get_unused_fd_flags(O_CLOEXEC);
> 	if (unlikely(fd < 0))
> 		return fd;
>         fd_install(fd, get_file(sk->sk_socket->file));
> 
> ... I can't help but wonder where's the catch?
> 
> IOW, why wasn't this needed so far?
> How does Cilium avoid resizing & rebuilding sockmaps?

I build a map at init time and pin it for the lifetime of the daemon.
If we overrun the sockmap we can always fall back to the normal case
so there has never been a reason to resize.

I guess being able to change the map size at runtime would be a nice
to have but we don't do this with any other maps, e.g. connection
tracking, load balancing, etc. We expect good-sizing upfront. 

@Lorenz, Would it be possible to provide some more details where a
resize would be used? I guess if the map is nearly full you could
rebuild a bigger one and migrate? One thing I explored at one point
is to just create a new map and use multiple maps in the datapath
but that required extra lookups and for hashing might not be ideal.

> 
> Just asking out of curiosity.
> 
> [...]


