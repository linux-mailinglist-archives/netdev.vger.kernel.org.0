Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACCED23010A
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 07:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgG1FB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 01:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbgG1FBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 01:01:53 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA08C0619D2;
        Mon, 27 Jul 2020 22:01:53 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id x69so17601070qkb.1;
        Mon, 27 Jul 2020 22:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9GiJFplLkrVe2P2djDina8SpQbLhusk7z/UDvkWFSzw=;
        b=H38VJRXTVFmMsWtckzdw49EBWCoL8eRWZNWhzhvKMupOD7NZsOxI4yB3/HLCcxiBvT
         D6iDhK1wXiyMRNVdVx7gO5AwiQ+zBrv93qMVbb1IPLzm8gOh7py4SSw8rTMSZ2cHW8wX
         ryv3pQLsB1ljUVM/haYwTCWBXHEZclJBzfv+RwvA1IuKfOVpSZdnxxK8ytAGuxguLhtS
         5J5bAW/PjBhAY0gw6bxbnRI+lM6KwIu8EeD6P7MPtFxBClgy+ulQp98a8+AekNBJ3zRT
         M9JZyV2YeVMQlu31rv3TGN4PVGM9/IkpZQ5+j7bNCyNhm6NDt7Mt/bJ2s8IICuQbZQU2
         QHnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9GiJFplLkrVe2P2djDina8SpQbLhusk7z/UDvkWFSzw=;
        b=A2E2U+yRxcl4civ3RtNs1snb9gfdWbNaQ860XoOX4o/J/6Ap5S/DA+D8BWPR5LFaWT
         puME8t44NBG4IrIYkRrOZ0jMUh9Lk7SYdcmM7L+xNv+eZM/jiMyJmkLnYoYcGthMQf8H
         fIbixYML7htk92IXJzrbGaepxVtDzCQHsuXciVDSz+ER8Q6ZePOK2hWK1Jar57KhbhDE
         8qj0ez8kmaopYbV/ELuG7zdzsqNKwGFxE6y0hUWUk9/gM6ABXHI2VCP7UEX2jUxXRQbv
         04WFAEyIX8bhsB+KgPAHjaJWMDpV1HblP+LZHQIo5tSk9b+n1U5UchxwPts9p7H8yFRQ
         ztqA==
X-Gm-Message-State: AOAM533LrtCnFdve4sFM2AwgspBhBj5M6NbkqxYh92+6e3bVCGlyYSyr
        y39KzakTvdM0FSvWGX494t1q6si02qNU0cPp8rqC8g==
X-Google-Smtp-Source: ABdhPJwhYpurrebIDrB9Ym/cZeix2EE0A9z8I8H1cpLXDDVplNsGzT/MrgqVKHwMMT+3tH2S0+eBt5pJAH/cNQ/URIM=
X-Received: by 2002:a37:afc3:: with SMTP id y186mr7074210qke.36.1595912512905;
 Mon, 27 Jul 2020 22:01:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200727233431.4103-1-bimmy.pujari@intel.com>
In-Reply-To: <20200727233431.4103-1-bimmy.pujari@intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 27 Jul 2020 22:01:41 -0700
Message-ID: <CAEf4BzYMaU14=5bzzasAANJW7w2pNxHZOMDwsDF_btVWvf9ADA@mail.gmail.com>
Subject: Re: [PATCH] bpf: Add bpf_ktime_get_real_ns
To:     bimmy.pujari@intel.com
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        mchehab@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, maze@google.com,
        ashkan.nikravesh@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 4:35 PM <bimmy.pujari@intel.com> wrote:
>
> From: Ashkan Nikravesh <ashkan.nikravesh@intel.com>
>
> The existing bpf helper functions to get timestamp return the time
> elapsed since system boot. This timestamp is not particularly useful
> where epoch timestamp is required or more than one server is involved
> and time sync is required. Instead, you want to use CLOCK_REALTIME,
> which provides epoch timestamp.
> Hence add bfp_ktime_get_real_ns() based around CLOCK_REALTIME.
>

This doesn't seem like a good idea. With time-since-boot it's very
easy to translate timestamp into a real time on the host. Having
get_real_ns() variant might just encourage people to assume precise
wall-clock timestamps that can be compared between within or even
across different hosts. REALCLOCK can jump around, you can get
duplicate timestamps, timestamps can go back in time, etc. It's just
not a good way to measure time.

Also, you mention the need for time sync. It's an extremely hard thing
to have synchronized time between two different physical hosts, as
anyone that has dealt with distributed systems will attest. Having
this helper will just create a dangerous illusion that it is possible
and will just cause more problems down the road for people.

> Signed-off-by: Ashkan Nikravesh <ashkan.nikravesh@intel.com>
> Signed-off-by: Bimmy Pujari <bimmy.pujari@intel.com>
> ---
>  drivers/media/rc/bpf-lirc.c    |  2 ++
>  include/linux/bpf.h            |  1 +
>  include/uapi/linux/bpf.h       |  7 +++++++
>  kernel/bpf/core.c              |  1 +
>  kernel/bpf/helpers.c           | 14 ++++++++++++++
>  kernel/trace/bpf_trace.c       |  2 ++
>  tools/include/uapi/linux/bpf.h |  7 +++++++
>  7 files changed, 34 insertions(+)

[...]
