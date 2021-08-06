Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2D23E3208
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 01:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244689AbhHFXJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 19:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbhHFXJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 19:09:28 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A56C0613CF;
        Fri,  6 Aug 2021 16:09:10 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id x192so18043863ybe.0;
        Fri, 06 Aug 2021 16:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ll/x/yovExn13R1zVLxrcsB3UtcNbp32T83iw2cAJZQ=;
        b=MuvbfZY8OUQ+az8fF18cSfNjnzbax/xy3T11/P/nOv8cCOyw+LPYkXxF6fxqTsHiNJ
         +I98mpP0kQPNxu3+moWa6wy6pVtj2w9+XK2OC3JfL9bYoxqaZKBR+qfzIKOg5mnzCDGn
         SmbBkK232ohJYF/ymGK88de8lOAfQZVb4tQ2C+FosB6uCqCL8mbLoBNrKLSIG4AdvMUF
         eGXK4JlTOvy7P7jiOf4kZFeFDiW80UQH0m+olzfOU4R5iC7Sh1tzeApkhv6/gwcddbI9
         j4UvCgd+NJ/jqPUqR4OEQN+PBNZjdi/5BinkRzWDaQZ+uBlEbmATWmoDms37MJ0eoLPD
         59WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ll/x/yovExn13R1zVLxrcsB3UtcNbp32T83iw2cAJZQ=;
        b=R1o8ZB6qKrcj48T4+4cjhockowto6TZkp6l12TWxRrJqgdawS3RayRBrYDV0ZiUQ6v
         n3VJB5lysS/5aTW210XBtpSutVdHxVcKfSoBh3Odt8cWUr5BC3s7iMiWjAc7ZZ+lwyet
         AVgXDqE3dSEpEV2QFLWnKKtbIUWt6NiGYPdnrHkZsv8r3ucWTeDhFvFVpRFPRbARRHPv
         dIfxAQHPJiAn7k4rxCCQANH1h1fIQUEZ5vDzWyC47EU3AY7CxevNUpMPqDTrWiGbLpzy
         Zu80sYOniy7mBO3XxGWTb5ja8gTKaHFLT5Z/RWeFz344BphxkMITmEMGysNAToQc17T5
         mmrg==
X-Gm-Message-State: AOAM531eHBTP5McoSFmkMnfy8YQQoL3kuPPgMmWjE0xTM1lOQpgz+abl
        k9m9ACzGXEPwFlxAChl8Vx0abiZpa07gbfC5aZE=
X-Google-Smtp-Source: ABdhPJw3gE82NFLhS+dAW0wUmyKqtI5N9N/1cYIDs+4SRDz5lquPP8xam6ayb2Af+Ikumb9+SdN8hpWttGOXgRv+TpY=
X-Received: by 2002:a25:1455:: with SMTP id 82mr15941456ybu.403.1628291350206;
 Fri, 06 Aug 2021 16:09:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210803171006.13915-1-kishen.maloor@intel.com> <20210803171006.13915-3-kishen.maloor@intel.com>
In-Reply-To: <20210803171006.13915-3-kishen.maloor@intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 6 Aug 2021 16:08:59 -0700
Message-ID: <CAEf4BzY7kiXhLJktZg5aa2BU9yxZ1qzb925XO1mPW=qnu3qwgw@mail.gmail.com>
Subject: Re: [RFC bpf-next 2/5] libbpf: SO_TXTIME support in AF_XDP
To:     Kishen Maloor <kishen.maloor@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 3, 2021 at 10:10 AM Kishen Maloor <kishen.maloor@intel.com> wrote:
>
> This change adds userspace support for SO_TXTIME in AF_XDP
> to include a specific TXTIME (aka "Launch Time")
> with XDP frames issued from userspace XDP applications.
>
> The userspace API has been expanded with two helper functons:
>
> - int xsk_socket__enable_so_txtime(struct xsk_socket *xsk, bool enable)
>    Sets the SO_TXTIME option on the AF_XDP socket (using setsockopt()).
>
> - void xsk_umem__set_md_txtime(void *umem_area, __u64 chunkAddr,
>                                __s64 txtime)
>    Packages the application supplied TXTIME into struct xdp_user_tx_metadata:
>    struct xdp_user_tx_metadata {
>         __u64 timestamp;
>         __u32 md_valid;
>         __u32 btf_id;
>    };
>    and stores it in the XDP metadata area, which precedes the XDP frame.
>
> Signed-off-by: Kishen Maloor <kishen.maloor@intel.com>
> ---

Same comments as in [0] regarding the AF_XDP APIs in libbpf.

  [0] https://lore.kernel.org/bpf/CAEf4BzZ44wc-+r6o7vthddt5BoePdg0cQn83g8qkyPMAca4vvA@mail.gmail.com/

>  tools/include/uapi/linux/if_xdp.h     |  2 ++
>  tools/include/uapi/linux/xdp_md_std.h | 14 ++++++++++++++
>  tools/lib/bpf/xsk.h                   | 27 ++++++++++++++++++++++++++-
>  3 files changed, 42 insertions(+), 1 deletion(-)
>  create mode 100644 tools/include/uapi/linux/xdp_md_std.h
>

[...]
