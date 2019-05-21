Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 928C925007
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 15:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbfEUNX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 09:23:26 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:44514 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728006AbfEUNX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 09:23:26 -0400
Received: by mail-qk1-f193.google.com with SMTP id w25so10973215qkj.11
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 06:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KBDJLPZk/tlNjyKsasnuF8ZkxJ37zHjz9CBGzBVukHM=;
        b=TpkXgsgonXCMjoJcO65Q3CE8uyIsQHzLq6yG/+/DFhai8Wd1JQHrGOPVTIyrOZe0IB
         RZaQenxeuk4K+08StwLfmdHQKS9DX6ViC9vPXc/KdywLw7IuZu3NccAv6ViX7euKawuF
         oBoiMyavJwrt2AUHSH5R5Ug6kzBLfAIhTdx4WUjllhmxstqCH+C8GwcQ8B4EJI2tgisr
         lSE0441O4TcOZyCLj0AdtZJD3rA1r2M82mqbgjZ3SN0vDdlCI41mTGbjgbeZKSddsknc
         rhjRcl6ahw+P68mdrQnqBaTyZ1kCmdlR77xZRvdVJokZJ0Y9Vybl7ipM/yPNlFwMGGrd
         YYlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KBDJLPZk/tlNjyKsasnuF8ZkxJ37zHjz9CBGzBVukHM=;
        b=nktRJ6u6wNbDqjYTH4+xqIY2EYE44R9nz7CrMLsWlzt3wAIPe4V5NZWmXVhjjUJ+1w
         /qrthZSJQJO7nXYgQ0pxlVtM+nV/+rcLR77MSwHAeax/a9zJMWr7jOsbnxRo1vwSXFjQ
         V1Ny+VNvLrftkX4s3VC9IRz5A0K1XWKOhvWYmmdxyhS72L1QKU/ezACEeLbz5kLTnjTI
         82rIOPhy9UtDclul7i7YBslJJwIurQzhIPsGDWaAKH9+pg3GOLSVOsxmkjDi0wfDwpJD
         5BN8RcNCgaeoqXtMmWF3bVbUUfJtP3VzD1Mj5bVYHXMxAh3qmw+b+PFjUCpMY72/62+M
         fhCg==
X-Gm-Message-State: APjAAAWD/UyXisjtg2CXlnis2081fo2vHyi9FQXW8QjTcTSqtuQ/NOLY
        qbEdHYFAc5ugXVmA+6pTb8r3Clv0FAKVH8kJKOQ=
X-Google-Smtp-Source: APXvYqxdC1MZY2nqL36/rke7AUuhsPtbhBnudyawqLyN+3rLSEINKyxPvpIS3WxiBVhrOBFj2OJzLq9fCwQ5wiF0MWk=
X-Received: by 2002:a05:620a:133c:: with SMTP id p28mr62362347qkj.165.1558445005547;
 Tue, 21 May 2019 06:23:25 -0700 (PDT)
MIME-Version: 1.0
References: <ba3ef670-a8ff-abfd-5e86-9b14af626112@infradead.org>
In-Reply-To: <ba3ef670-a8ff-abfd-5e86-9b14af626112@infradead.org>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 21 May 2019 15:23:13 +0200
Message-ID: <CAJ+HfNjAjCsQViE=t-M6s-d2yN86YYg8c0iO+BVXB9TW42LtuQ@mail.gmail.com>
Subject: Re: [PATCH] Documentation/networking: fix af_xdp.rst Sphinx warnings
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 May 2019 at 23:23, Randy Dunlap <rdunlap@infradead.org> wrote:
>
> From: Randy Dunlap <rdunlap@infradead.org>
>
> Fix Sphinx warnings in Documentation/networking/af_xdp.rst by
> adding indentation:
>
> Documentation/networking/af_xdp.rst:319: WARNING: Literal block expected;=
 none found.
> Documentation/networking/af_xdp.rst:326: WARNING: Literal block expected;=
 none found.
>
> Fixes: 0f4a9b7d4ecb ("xsk: add FAQ to facilitate for first time users")
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Magnus Karlsson <magnus.karlsson@intel.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  Documentation/networking/af_xdp.rst |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> --- lnx-52-rc1.orig/Documentation/networking/af_xdp.rst
> +++ lnx-52-rc1/Documentation/networking/af_xdp.rst
> @@ -316,16 +316,16 @@ A: When a netdev of a physical NIC is in
>     all the traffic, you can force the netdev to only have 1 queue, queue
>     id 0, and then bind to queue 0. You can use ethtool to do this::
>
> -   sudo ethtool -L <interface> combined 1
> +     sudo ethtool -L <interface> combined 1
>
>     If you want to only see part of the traffic, you can program the
>     NIC through ethtool to filter out your traffic to a single queue id
>     that you can bind your XDP socket to. Here is one example in which
>     UDP traffic to and from port 4242 are sent to queue 2::
>
> -   sudo ethtool -N <interface> rx-flow-hash udp4 fn
> -   sudo ethtool -N <interface> flow-type udp4 src-port 4242 dst-port \
> -   4242 action 2
> +     sudo ethtool -N <interface> rx-flow-hash udp4 fn
> +     sudo ethtool -N <interface> flow-type udp4 src-port 4242 dst-port \
> +     4242 action 2
>
>     A number of other ways are possible all up to the capabilitites of
>     the NIC you have.
>
>

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
