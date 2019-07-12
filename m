Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDC5C662C3
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 02:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730596AbfGLAWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 20:22:09 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:35061 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728102AbfGLAWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 20:22:08 -0400
Received: by mail-qt1-f196.google.com with SMTP id d23so6407979qto.2;
        Thu, 11 Jul 2019 17:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/4+k8OBkWPl2wP9Mpj886E0SFBIDse14POqVOVVgzkg=;
        b=tN59z30f+lg/v89y4PZ/8rnECfXHofqbiSuoJxqTCXj4tF1s4jMkyscCyYzegIEa4/
         r1+0RZnxuXiif2blTLuplY2vy/82FJbOS80Foee/TlcOaPffxDRVUuOsmHxZpc1fblGd
         DuyeN/aXH8NAjJSF1vVNjKxyZHvj9LHrhuOrVTChmvTcrOFZ80uT5p5x8SB7tk/V5ePN
         Vp/RpFYIS4me8u4WUNWijXORxDKZLEkDorasmEg+KoFbAcNEtNT4P8327oYUitpOsqps
         7yy7VBTIyfI8GLNNaD5qXdwtn5jE1NV3XlgL6fWrw1T0Pe5DrGZ6HtcOZTIhA/W8ZdyD
         u/Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/4+k8OBkWPl2wP9Mpj886E0SFBIDse14POqVOVVgzkg=;
        b=Xc8/PZHG++N8NqZGjhOcu903Ce3YpbEkQ3u6ZXU1tSG5W3/go2ZEZTGEOtz9f3M3ib
         9p5B0KGoA06vJPEqtkHjFK1mdyzv6/YsPMcgicB/Y5lF4v5U++b4c7boIpVW7ZwrRqLc
         1SllfAiL38uhRvaPk4seYSbG5EAn6P6TnoT+i/yr2xqAqg9SQ10DCYrjSRurU90Fp0VO
         amhghvnziWII2VrSfUnZSl12/g3aw1A1tAeWxhkPrxXOh5fF/N/eKArOQJ7DfClS5Rd9
         QnwWMnMdjJTRSCcsN3qgcMtCdgRKCUuRs47ArLqtKHD7Rk+AKtWIERhi9T8PP2dj77jo
         5KEw==
X-Gm-Message-State: APjAAAUMx63EHnFIaR45hFTMFBKrRU9njf5jaNMZf2dIpn9fMJ8MsX8b
        wbGndyupqePFNva704yhV+eQZ9Uhabapl7vEvxI=
X-Google-Smtp-Source: APXvYqxRcNPW7o70Lv/0ta0iz/AgsAPC23tElXsi8v0Rjw3QFg66LYJNUS+dkJrYikGIOp6Tbd9q6mZyOtzcmRnLt9k=
X-Received: by 2002:a05:6214:1306:: with SMTP id a6mr4329977qvv.38.1562890927633;
 Thu, 11 Jul 2019 17:22:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190708163121.18477-1-krzesimir@kinvolk.io> <20190708163121.18477-9-krzesimir@kinvolk.io>
In-Reply-To: <20190708163121.18477-9-krzesimir@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 11 Jul 2019 17:21:56 -0700
Message-ID: <CAEf4BzZ23_m-L6vob6BKn24yphRQUBMceAHqkSU+8C8EovmVFA@mail.gmail.com>
Subject: Re: [bpf-next v3 08/12] tools headers: Sync struct bpf_perf_event_data
To:     Krzesimir Nowak <krzesimir@kinvolk.io>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Alban Crequy <alban@kinvolk.io>,
        =?UTF-8?Q?Iago_L=C3=B3pez_Galeiras?= <iago@kinvolk.io>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        xdp-newbies@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 8, 2019 at 3:42 PM Krzesimir Nowak <krzesimir@kinvolk.io> wrote:
>
> struct bpf_perf_event_data in kernel headers has the addr field, which
> is missing in the tools version of the struct. This will be important
> for the bpf prog test run implementation for perf events as it will
> expect data to be an instance of struct bpf_perf_event_data, so the
> size of the data needs to match sizeof(bpf_perf_event_data).
>
> Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/include/uapi/linux/bpf_perf_event.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/include/uapi/linux/bpf_perf_event.h b/tools/include/uapi/linux/bpf_perf_event.h
> index 8f95303f9d80..eb1b9d21250c 100644
> --- a/tools/include/uapi/linux/bpf_perf_event.h
> +++ b/tools/include/uapi/linux/bpf_perf_event.h
> @@ -13,6 +13,7 @@
>  struct bpf_perf_event_data {
>         bpf_user_pt_regs_t regs;
>         __u64 sample_period;
> +       __u64 addr;
>  };
>
>  #endif /* _UAPI__LINUX_BPF_PERF_EVENT_H__ */
> --
> 2.20.1
>
