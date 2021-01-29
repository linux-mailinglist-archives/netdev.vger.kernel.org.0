Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED2E530824D
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 01:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhA2ARP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 19:17:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbhA2ARO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 19:17:14 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67723C061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 16:16:32 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id e2so6431727lfj.13
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 16:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CgP0TYdI0ta/Oh0nw7OGuwH+lTt0JhcN816ZEg3bZhU=;
        b=Bs7gzxzlO+sgP+o7LrDAjbxLNxKTd3HBvWfwRx5vkHEeGCNAnnwh0bV3Pq1IqW0xl7
         ijFPa6RE4VfbWtj+x/51XhUadDDQHTFQCIJcBa06HrzoewtnSmOwkGiS+0kBEikK6TB6
         3PFft61bX9CdZdKODFDU5LdweNLVxYRSFdGBZiNqrcUDUsVjzA8tHmp/XignKSev+xMp
         QehwaLXLGjs1XgNlSiYK1kgShoZYUZojEoUbCbvrsTpSu0pTkhyPHMUwKpqgsHqQsUau
         kYQklKOANRULXN4PkEKGJwJvYWri+t5CejeOMz1O74PGLPPmMKHQfs4amTZ9hO/bYB0b
         Dosw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CgP0TYdI0ta/Oh0nw7OGuwH+lTt0JhcN816ZEg3bZhU=;
        b=APUezkzR4ItqQSqxhH6F9y5jC7tsjAl08eglY3GdAT+ZYDcUrcp9ulWXQqcH9SdCbj
         EED6zFsORXCc0t+O4TB5JmzbX8EVeAPOd3Ld+yjIvRqCHf++Aw2UQR2kA85qmVwJvtYO
         syrllrpdx6wL9sBaJdj22gJ4qZGfS63hXggWF5xr1yURObAgduTyaVH9BMEVF1IKNsCU
         Yt+0z3brazaGRz8SwuSpLG08YCw/dxWzKtbmnqwmldNl7YGT5EUxUFX0nqHxyX5sJQve
         3mgAGSyBE2nhKDYr0odSVB8BwYlnG1bo0Brj3eisLzHkyE1Wcg1atDCVV6KBECGyEC+6
         y50A==
X-Gm-Message-State: AOAM533c6mdU54lKo+vi1Ti5PwXk/aiIWKEZBywvxTIF79diWbrbVdUK
        9MLlC9fPxmnVsaYmJlmdhHA0FIrUt8BBEYuDK4Y=
X-Google-Smtp-Source: ABdhPJxhCvmjNwoR6zezAej4wyYS6Fop0binKk3ePIfYv9cOzaYPzIh0ssDKopm5CtFMW8pZJZLaGIZqRsh+SkInslg=
X-Received: by 2002:a19:6d07:: with SMTP id i7mr819777lfc.75.1611879390909;
 Thu, 28 Jan 2021 16:16:30 -0800 (PST)
MIME-Version: 1.0
References: <20210129001210.344438-1-hari@netflix.com>
In-Reply-To: <20210129001210.344438-1-hari@netflix.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 28 Jan 2021 16:16:19 -0800
Message-ID: <CAADnVQJE+nVoCsCxQDdy9SgdMRhrWePzRF__vrZSN2-wBFc+0g@mail.gmail.com>
Subject: Re: [PATCH] net: tracepoint: exposing sk_family in all tcp:tracepoints
To:     Hariharan Ananthakrishnan <hari@netflix.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Brendan Gregg <bgregg@netflix.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 4:12 PM Hariharan Ananthakrishnan
<hari@netflix.com> wrote:
>
> Similar to sock:inet_sock_set_state tracepoint, expose sk_family to
> distinguish AF_INET and AF_INET6 families.
>
> The following tcp tracepoints are updated:
> tcp:tcp_destroy_sock
> tcp:tcp_rcv_space_adjust
> tcp:tcp_retransmit_skb
> tcp:tcp_send_reset
> tcp:tcp_receive_reset
> tcp:tcp_retransmit_synack
> tcp:tcp_probe
>
> Signed-off-by: Hariharan Ananthakrishnan <hari@netflix.com>
> Signed-off-by: Brendan Gregg <bgregg@netflix.com>
> ---
>  include/trace/events/tcp.h | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
>
> diff --git a/include/trace/events/tcp.h b/include/trace/events/tcp.h
> index cf97f6339acb..a319d2f86cd9 100644
> --- a/include/trace/events/tcp.h
> +++ b/include/trace/events/tcp.h
> @@ -59,6 +59,7 @@ DECLARE_EVENT_CLASS(tcp_event_sk_skb,
>                 __field(int, state)
>                 __field(__u16, sport)
>                 __field(__u16, dport)
> +               __field(__u16, family)
>                 __array(__u8, saddr, 4)
>                 __array(__u8, daddr, 4)
>                 __array(__u8, saddr_v6, 16)

raw tracepoint can access all sk and skb fields already.
Why do you need this?
