Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFFD29CB76
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 22:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505516AbgJ0VrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 17:47:12 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34827 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505415AbgJ0VrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 17:47:11 -0400
Received: by mail-pl1-f196.google.com with SMTP id 1so1474585ple.2;
        Tue, 27 Oct 2020 14:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PId/GI+hcXXbOu/LnsogZk5VN2ylDcfCg4OFOAWpEzo=;
        b=ldQowFXC8eFlwbBWNZO8AaaAXZBPr/tw1b+AcXbHJGyMoBX9NU3XMcBd2ueEoFM2rK
         zr8MGMtyruN3tBuM8KEDrxfbIN5hUV3sPKK3SyWlCytZsWgQzz2reAKivkR7RR4BkL/c
         ECZIr+lArPNwejnZu9t29Jg0Vcvk7cKQ3V+5OrZggZLiiANpuT5Ek4xiWgzLxig2du6p
         29BSptkRxr3FsJEMyL8vGN6f74qeWXFkRvu0VXUX2DEgx6Ed40g+9sfjZazWkAMdgCjk
         0auIlDLlrg3ctP4c7f/6V4Kf/EZzmTZkpodE2UC6y6OFQmjyKk7WaVVNS7a3kRLGpdCN
         8mEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PId/GI+hcXXbOu/LnsogZk5VN2ylDcfCg4OFOAWpEzo=;
        b=doAoOc6g8ASwZrhry/ZyNSQH2Paq0QgFf+uzD1JrypRlJPkThSzRkQ4HJDGpb8Zmgi
         zAUSlejfzQbgVBWp6SZqLHlkwyHb/fJRwuEG6mbQoqEX751rZe32VScACDOeciuR/ues
         /7s+9C+SbqmfCzl5lR9OqhDY0KaUTkX7+kibQ+/6cG67N7pZwDMh2hHYjziSLRd+PNLh
         ZMMgNUMkTGHVjhxJyhU70L4oB8E4x2RrYqN+qKePqTJ3lFZ52QFbUWnHXloXHBK712yb
         FqlGGrhRRi2koo/lPySTc6Emf4/whe95+ZBdySUfcgO9Si+Recataq4qTw0sHB2G4eeB
         NZOg==
X-Gm-Message-State: AOAM530kuwYaigtuSyz8X31khY9oBJoGia/H5uThaPGqKPNLY4qQFVJP
        kOs2wg15+PN0jqptl7paiRMFjS8SnQxz3gyoNcY=
X-Google-Smtp-Source: ABdhPJzyEnkhCIuOYYYmydQS3da60vOXkxDj2b/6bADjGohkd3CibmjUzhihjGOWR04Ff5zgPcDkN+bCN3wDVG7Ec9E=
X-Received: by 2002:a17:902:ee53:b029:d6:ff1:d569 with SMTP id
 19-20020a170902ee53b02900d60ff1d569mr3578907plo.23.1603835230698; Tue, 27 Oct
 2020 14:47:10 -0700 (PDT)
MIME-Version: 1.0
References: <20201026213040.3889546-1-arnd@kernel.org> <20201027035558.16864-1-xie.he.0141@gmail.com>
 <CAJht_EPSs6W-r6kpWUNQDPzCjL-+_8mqq2JBoY=qhsQREgn92g@mail.gmail.com> <CAK8P3a3JTg5Mi2XC9AEC+YwH552M_TXDY4BaULZz5WmEb3woRQ@mail.gmail.com>
In-Reply-To: <CAK8P3a3JTg5Mi2XC9AEC+YwH552M_TXDY4BaULZz5WmEb3woRQ@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Tue, 27 Oct 2020 14:46:59 -0700
Message-ID: <CAJht_EPoXR9K3WoY5iNDNhzMgqtd=iS=mQsMQKHiGh7xRrYwHA@mail.gmail.com>
Subject: Re: [PATCH net-next 01/11] atm: horizon: shut up clang null pointer
 arithmetic warning
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Chas Williams <3chas3@gmail.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-atm-general@lists.sourceforge.net,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 6:24 AM Arnd Bergmann <arnd@kernel.org> wrote:
>
> Ah, of course. I had looked up the types but mixed up the memmap
> and HDW definitions, but then got confused trying to understand the
> logic in wr_mem() that operates on bytes but expands them into
> multiples of 4.

I think wr_mem() doesn't try to expand the address into multiples of
4. The address is multiplied by "sizeof(HDW)", which is 1. So the
address is not expanded.

I think this driver uses 0-based pointers not as byte-addresses to
access the host memory, but as (32-bit) word-addresses to access the
special hardware address space.

So using pointers in this case is confusing because it makes people
incorrectly consider they are used to access the host memory. It'd be
better that we just use integers.

> I've modified it as below now, will resend along with the other patches
> if you think this makes sense.
>
>         Arnd
>
> --- a/drivers/atm/horizon.c
> +++ b/drivers/atm/horizon.c
> @@ -1815,7 +1815,7 @@ static int hrz_init(hrz_dev *dev)
>
>    int buff_count;
>
> -  HDW * mem;
> +  uintptr_t offset;
>
>    cell_buf * tx_desc;
>    cell_buf * rx_desc;
> @@ -1841,8 +1841,8 @@ static int hrz_init(hrz_dev *dev)
>
>    printk (" clearing memory");
>
> -  for (mem = (HDW *) memmap; mem < (HDW *) (memmap + 1); ++mem)
> -    wr_mem (dev, mem, 0);
> +  for (offset = 0; offset < sizeof(struct MEMMAP); offset++)
> +    wr_mem (dev, (HDW *)offset, 0);
>
>    printk (" tx channels");

This looks good to me. Thanks!
