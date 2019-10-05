Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEE18CC9D1
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 14:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbfJEMJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 08:09:52 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:38976 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727797AbfJEMJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 08:09:52 -0400
Received: by mail-ed1-f68.google.com with SMTP id a15so8336360edt.6
        for <netdev@vger.kernel.org>; Sat, 05 Oct 2019 05:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Jc5S1ISbrDzHepQ7EQ2u/uiCeecafH2ZBYZikQFhQBY=;
        b=x6s17tVYSjYp1zBtOi5DKIeLImNxwSdlvxY0kTnfF5RBTUg6FbLETYwudaqfcC4elQ
         /k8gC3Whhf1jy6gBUucy/Vai8Q2L3zLrvi1KtAUJkK+R+gkusfBT9/m8ZbFod/IjpEfQ
         HeUHqN+qn/nP5R8JLKBrb7LZuxqg+XGNleB/vvhoB1SCTTTK9Km39JcgtjJ9vN7uKJ15
         q/5Fq7LlDqzj7TD4lEyI1iTsLiahg1aNCXVguLncHcghiwhD4YdnzRF4KQ3CUItx5F0b
         BFljURS4hzecdU/uSPEMrei0XwTNXYfnC+a534vR5IS41j8EtvSot8JvOVTrA3/7bDXh
         u3Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Jc5S1ISbrDzHepQ7EQ2u/uiCeecafH2ZBYZikQFhQBY=;
        b=YSzJw0QHV1U0nTRGIgvzE7Tao2xoiemLmvK+re6ffsnRO6rIlCFFb2hIhVDaNY+Q/i
         2HeEaTrg18DIEr6LPboZ2oDjxsSiP+wLNDqx4w/0lEmGYNkAK+ylEdE7CK2nPvpH3SJr
         LKEGxDNLUwRaAMs9c1FO9YMPVVgqGVFMp1ByT9P1bXidnEEI3LlMoWMGfFjPPDYLI68l
         F1wtb0wsYxGeGroQ3KomavvryuBgNiYFiq2QUg31Iq6NI1aeHGBIFLbynk+qrNW0ph2P
         VYoaSOWi4HqSr/L4HCk8ricMPcUYMG8jQXnRZ042vpCZ+GsLv8Krc1ylIMXwZpnubrZV
         w85g==
X-Gm-Message-State: APjAAAXKGtPm5VZ+S6Rwwxhd3/HDTxMuh6rwsYUoXXMUcDE9oFdpvyI2
        SrMI9IgQrzH7SfBwsTubgKRanA==
X-Google-Smtp-Source: APXvYqwcSIqE7HuIDYNUNDZ+StlwELDTjAQJ7GvUQpc1eRdlwPJ78Yc3gRFMBDGpiSNsefyb5SoYhw==
X-Received: by 2002:a50:95c1:: with SMTP id x1mr19991742eda.180.1570277390395;
        Sat, 05 Oct 2019 05:09:50 -0700 (PDT)
Received: from netronome.com (penelope-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:c685:8ff:fe7c:9971])
        by smtp.gmail.com with ESMTPSA id d27sm996627ejc.37.2019.10.05.05.09.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 05 Oct 2019 05:09:49 -0700 (PDT)
Date:   Sat, 5 Oct 2019 14:09:48 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, davejwatson@fb.com,
        borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net
Subject: Re: [PATCH net-next 0/6] net/tls: add ctrl path tracing and
 statistics
Message-ID: <20191005120947.j3ths7o3fvqo435n@netronome.com>
References: <20191004231927.21134-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004231927.21134-1-jakub.kicinski@netronome.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 04, 2019 at 04:19:21PM -0700, Jakub Kicinski wrote:
> Hi!
> 
> This set adds trace events related to TLS offload and basic MIB stats
> for TLS.
> 
> First patch contains the TLS offload related trace points. Those are
> helpful in troubleshooting offload issues, especially around the
> resync paths.
> 
> Second patch adds a tracepoint to the fastpath of device offload,
> it's separated out in case there will be objections to adding
> fast path tracepoints. Again, it's quite useful for debugging
> offload issues.
> 
> Next four patches add MIB statistics. The statistics are implemented
> as per-cpu per-netns counters. Since there are currently no fast path
> statistics we could move to atomic variables. Per-CPU seem more common.
> 
> Most basic statistics are number of created and live sessions, broken
> out to offloaded and non-offloaded. Users seem to like those a lot.
> 
> Next there is a statistic for decryption errors. These are primarily
> useful for device offload debug, in normal deployments decryption
> errors should not be common.
> 
> Last but not least a counter for device RX resync.

FWIIW,

Reviewed-by: Simon Horman <simon.horman@netronome.com>

> 
> Jakub Kicinski (6):
>   net/tls: add tracing for device/offload events
>   net/tls: add device decrypted trace point
>   net/tls: add skeleton of MIB statistics
>   net/tls: add statistics for installed sessions
>   net/tls: add TlsDecryptError stat
>   net/tls: add TlsDeviceRxResync statistic
> 
>  Documentation/networking/tls.rst              |  30 +++
>  .../ethernet/netronome/nfp/nfp_net_common.c   |   3 +-
>  include/net/netns/mib.h                       |   3 +
>  include/net/snmp.h                            |   6 +
>  include/net/tls.h                             |  21 +-
>  include/uapi/linux/snmp.h                     |  17 ++
>  net/tls/Makefile                              |   4 +-
>  net/tls/tls_device.c                          |  36 +++-
>  net/tls/tls_main.c                            |  60 +++++-
>  net/tls/tls_proc.c                            |  47 ++++
>  net/tls/tls_sw.c                              |   5 +
>  net/tls/trace.c                               |  10 +
>  net/tls/trace.h                               | 202 ++++++++++++++++++
>  13 files changed, 429 insertions(+), 15 deletions(-)
>  create mode 100644 net/tls/tls_proc.c
>  create mode 100644 net/tls/trace.c
>  create mode 100644 net/tls/trace.h
> 
> -- 
> 2.21.0
> 
