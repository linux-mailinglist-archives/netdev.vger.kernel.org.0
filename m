Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBE9F26AC
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 05:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733124AbfKGEpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 23:45:03 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:37707 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733035AbfKGEpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 23:45:03 -0500
Received: by mail-yb1-f193.google.com with SMTP id e13so481320ybh.4;
        Wed, 06 Nov 2019 20:45:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iJhzGnu0ImDPOaNbn03CyYLCDVtrE0HHQ6fA/Qe4tlU=;
        b=Qa93JpTX3X1QsPLuK3o1gH4MrOWHyTW9B43I8/jzUgnbzLddAYAwP5lg4CzJcFDGST
         NoGVo+JDzEcR4qSrCqo5G5pj1er8MN1aN5LsRJTqi2xrRuJrp2SDhFFx3xMlAt769Myh
         50RJCw0TAFM/7vDsAuRXRIyZmbzibyCCrpYuxy/JoYnAV914gGxA7KvNo29VNsI56pV7
         +ismONlHUjOxnj1laC1slM3UZL863xX6x0Ki8cweNeur6BsOsRHqNBmUR9YAZoTyhmxD
         p/CIOmv+52VD9m3IlKuxJBcT5k4zzjrG9b+M+5SRO3gw4+JQSHu+0uBuC96Uj/QCsehj
         3+7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iJhzGnu0ImDPOaNbn03CyYLCDVtrE0HHQ6fA/Qe4tlU=;
        b=TH/Ab7gbnxrzh30Kl38OhbKZJGqcjeSYnQqQal3CtTJqe2RX7sLFW8Mlcj2G9RU9bp
         Hi43b5e7/FOTfxu4TOoaDOjg+Uwsf3p9s6FZUGh2igAf/3pt70hk/RoXKx698FQPWa8P
         pYMgaWzK3XsxLuOFjtnCrUHjvpbf6gAMdptu9X4Hkz00rqnLgXQVmC5BhbRVocr7ckVX
         ijKrM4l/436nNB2M63GQPndSefx+xKlST4v5eEWiKjVXq3HzI1MGTJdba0JoihWbtJ9T
         zlqH8sKBhmTDLssqz8NV8xOHVHPGHPQtV7UtQx0w85qiURGivYrswBIo+xRWiVxvnetg
         ySMg==
X-Gm-Message-State: APjAAAUNPw5CpvUMh2ZcKVCM8JjLEso1y/dKYWmYg0CMWE6sWYM6FAZ6
        5qd3AYjR4BbSSEIoQjj1kA6t3nTt4UxRj2QnpQ==
X-Google-Smtp-Source: APXvYqx3llFeZAmPtYMN67UeE1PwxeheJx4YWooNG3jJdjHYk2tPRDW7WxUaoinbDonEYcPu9I5aERjhH+u6hPTnDlE=
X-Received: by 2002:a25:145:: with SMTP id 66mr1559693ybb.180.1573101901916;
 Wed, 06 Nov 2019 20:45:01 -0800 (PST)
MIME-Version: 1.0
References: <20191107005153.31541-1-danieltimlee@gmail.com>
 <20191107005153.31541-3-danieltimlee@gmail.com> <CAEf4BzZpBqPAKy1fKUQYSm3Wxez29EuBYqu_n2SayCfDt_ziUg@mail.gmail.com>
In-Reply-To: <CAEf4BzZpBqPAKy1fKUQYSm3Wxez29EuBYqu_n2SayCfDt_ziUg@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Thu, 7 Nov 2019 13:44:48 +0900
Message-ID: <CAEKGpzi5qz14TWm4ZSmk8zWcw_z2f9iM+dW10Tu6evJg60aa_g@mail.gmail.com>
Subject: Re: [PATCH,bpf-next v2 2/2] samples: bpf: update map definition to
 new syntax BTF-defined map
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 11:53 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Nov 6, 2019 at 4:52 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > Since, the new syntax of BTF-defined map has been introduced,
> > the syntax for using maps under samples directory are mixed up.
> > For example, some are already using the new syntax, and some are using
> > existing syntax by calling them as 'legacy'.
> >
> > As stated at commit abd29c931459 ("libbpf: allow specifying map
> > definitions using BTF"), the BTF-defined map has more compatablility
> > with extending supported map definition features.
> >
> > The commit doesn't replace all of the map to new BTF-defined map,
> > because some of the samples still use bpf_load instead of libbpf, which
> > can't properly create BTF-defined map.
> >
> > This will only updates the samples which uses libbpf API for loading bpf
> > program. (ex. bpf_prog_load_xattr)
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
> > Changes in v2:
> >  - stick to __type() instead of __uint({key,value}_size) where possible
> >
> >  samples/bpf/sockex1_kern.c          |  12 ++--
> >  samples/bpf/sockex2_kern.c          |  12 ++--
> >  samples/bpf/xdp1_kern.c             |  12 ++--
> >  samples/bpf/xdp2_kern.c             |  12 ++--
> >  samples/bpf/xdp_adjust_tail_kern.c  |  12 ++--
> >  samples/bpf/xdp_fwd_kern.c          |  13 ++--
> >  samples/bpf/xdp_redirect_cpu_kern.c | 108 ++++++++++++++--------------
> >  samples/bpf/xdp_redirect_kern.c     |  24 +++----
> >  samples/bpf/xdp_redirect_map_kern.c |  24 +++----
> >  samples/bpf/xdp_router_ipv4_kern.c  |  64 ++++++++---------
> >  samples/bpf/xdp_rxq_info_kern.c     |  37 +++++-----
> >  samples/bpf/xdp_tx_iptunnel_kern.c  |  26 +++----
> >  12 files changed, 178 insertions(+), 178 deletions(-)
>
> Heh, 1-to-1 insertions/deletions, no excuse to use old syntax ;)
>
> Thanks for completing conversion!
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
>
> [...]

Thank you for your time and effort for the review.

Thanks,
Daniel
