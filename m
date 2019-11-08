Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA8D1F4ECD
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 15:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbfKHO5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 09:57:45 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44675 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbfKHO5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 09:57:45 -0500
Received: by mail-pl1-f193.google.com with SMTP id az9so3346584plb.11;
        Fri, 08 Nov 2019 06:57:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vK/JxxtUoPpEjhiq8CjL8ld2OAvwz69+P9YIG3BmDRc=;
        b=Juts835bX1lHxKXQOeGXPivssuxgivvjL8BNMr2UIK5PWJJcxxMtfxXAkvzVhTdbHZ
         Zrfiqa3IqV4WKgfnXiU0XcIw9KiyHDZWGGyXyDi2eiUm4e0k5qTKVdtdI9oP5mYzZ26d
         u8ph00/tnL+0Le6QRT6TXkEhKcJoncu9F8oodJh1PXa2xic2VIBxQJWIxEiqcrjqpde4
         CrgDjIKBo9LllUUSBlhicgQbq2fKsMkjchi7kSmQIQ8+6qCqXVUlkwt3uPkn+8XWTpxe
         FI3OpKRQz2SLfxvA3S5eSInrJhPTRIT5QkW89triZx6tH0YNCnl0gn7CpS12N2zgGBQm
         l34A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vK/JxxtUoPpEjhiq8CjL8ld2OAvwz69+P9YIG3BmDRc=;
        b=RakM67S7qGPqsDnm2LP9e9y925tbPZJ5IqGfN/MSZgYuNAibCWroGuKhJHjEwkkNTZ
         V8EVDCAdof+X/cH2zkb2nL1Y+hQQYFiSnMT4gfIy/wOzZ9s+Ad99CvAHVx55MJC8uFaA
         xAS0DDX3oNTqV78KdgKx6dMXEI2ujJzFA5SHmn/lgrqWp6l70Y2ZC28Ss9m7EUYrvPSG
         bt1qGd4dQuxJN4fwAake59VaEpScRr1ogx371NX2cpxTZuPhE0PGetbcBD7c2iNjchIB
         sJi6+T2/jaxFeIYIgEhaL+aBO09Jm4xhcljqw62Z8NCPkQVGWo609+4HKVKyG0WHeBeJ
         F3aA==
X-Gm-Message-State: APjAAAWVMC1RgPDjNLcpfNrdyvMLgyxF/2RPkAIajawJorvUANdGVDJp
        jdrxbRlaAIYoaEiLVAr5YR0=
X-Google-Smtp-Source: APXvYqxS7yTW36iTyDWAVosPlasJDxfJ/NHDVAH2tdz41VKuOkWTlSbH3piGbgWb6Rdz3HR5b1xN0A==
X-Received: by 2002:a17:902:b215:: with SMTP id t21mr8318993plr.332.1573225064474;
        Fri, 08 Nov 2019 06:57:44 -0800 (PST)
Received: from gmail.com (c-76-21-95-192.hsd1.ca.comcast.net. [76.21.95.192])
        by smtp.gmail.com with ESMTPSA id o15sm4467580pgf.2.2019.11.08.06.57.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Nov 2019 06:57:43 -0800 (PST)
Date:   Fri, 8 Nov 2019 06:57:38 -0800
From:   William Tu <u9012063@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 0/5] Extend libbpf to support shared umems and
 Rx|Tx-only sockets
Message-ID: <20191108145738.GC36440@gmail.com>
References: <1573148860-30254-1-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573148860-30254-1-git-send-email-magnus.karlsson@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 07, 2019 at 06:47:35PM +0100, Magnus Karlsson wrote:
> This patch set extends libbpf and the xdpsock sample program to
> demonstrate the shared umem mode (XDP_SHARED_UMEM) as well as Rx-only
> and Tx-only sockets. This in order for users to have an example to use
> as a blue print and also so that these modes will be exercised more
> frequently.
> 
> Note that the user needs to supply an XDP program with the
> XDP_SHARED_UMEM mode that distributes the packets over the sockets
> according to some policy. There is an example supplied with the
> xdpsock program, but there is no default one in libbpf similarly to
> when XDP_SHARED_UMEM is not used. The reason for this is that I felt
> that supplying one that would work for all users in this mode is
> futile. There are just tons of ways to distribute packets, so whatever
> I come up with and build into libbpf would be wrong in most cases.
> 
Hi Magnus,

Thanks for the patch.
I look at the sample code and it's sharing a umem among multiple queues in
the same netdev. Is it possible to shared one umem across multiple netdevs?

For example in OVS, one might create multiple tap/veth devices (using skb-mode
or native-mode). And I want to save memory by having just one shared umem for
these devices.

Thanks
--William

> This patch has been applied against commit 30ee348c1267 ("Merge branch 'bpf-libbpf-fixes'")
> 
> Structure of the patch set:
> 
> Patch 1: Adds shared umem support to libbpf
> Patch 2: Shared umem support and example XPD program added to xdpsock sample
> Patch 3: Adds Rx-only and Tx-only support to libbpf
> Patch 4: Uses Rx-only sockets for rxdrop and Tx-only sockets for txpush in
>          the xdpsock sample
> Patch 5: Add documentation entries for these two features
> 
> Thanks: Magnus
> 
> Magnus Karlsson (5):
>   libbpf: support XDP_SHARED_UMEM with external XDP program
>   samples/bpf: add XDP_SHARED_UMEM support to xdpsock
>   libbpf: allow for creating Rx or Tx only AF_XDP sockets
>   samples/bpf: use Rx-only and Tx-only sockets in xdpsock
>   xsk: extend documentation for Rx|Tx-only sockets and shared umems
> 
>  Documentation/networking/af_xdp.rst |  28 +++++--
>  samples/bpf/Makefile                |   1 +
>  samples/bpf/xdpsock.h               |  11 +++
>  samples/bpf/xdpsock_kern.c          |  24 ++++++
>  samples/bpf/xdpsock_user.c          | 158 ++++++++++++++++++++++++++----------
>  tools/lib/bpf/xsk.c                 |  32 +++++---
>  6 files changed, 195 insertions(+), 59 deletions(-)
>  create mode 100644 samples/bpf/xdpsock.h
>  create mode 100644 samples/bpf/xdpsock_kern.c
> 
> --
> 2.7.4
