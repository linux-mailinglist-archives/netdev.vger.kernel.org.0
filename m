Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9664945F5
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 04:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358255AbiATDHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 22:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiATDHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 22:07:17 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A46C061574;
        Wed, 19 Jan 2022 19:07:15 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id c24so20196161edy.4;
        Wed, 19 Jan 2022 19:07:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6AciR2AKfyPUvmQqqeZADltLycshLQ4pZRWrBxQwNds=;
        b=au9z0HdVBZBLq5GfMsCVAczVs4JxTYHuhw8YWbzU3jXlJyCU6DL0bwgPzEtW8Q8pMO
         w2QzOztChaWzGqqbCBStS3qGn94DQneWOlOTDG1rf8+JZ9spA8lXCOidJkdOepG+cHEr
         /J0j1QXW9Ez241MyXdzdKzKCUecaofMtnlFj3posuMFpcDABBbEC2r0wkXW836j8KsDz
         Jf2plTDfzee+VKHPwUt+gw0i/RuaN+WQqbP+akYY7AYCDR67q51uOuNr7q19WHiQHu3X
         FzocVx7JtVwd3smRGeMxDwSbO1r79iQuhiJ1Jgw7q1e8Bdig/ilWPj1V22s9btrBfWBd
         uNhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6AciR2AKfyPUvmQqqeZADltLycshLQ4pZRWrBxQwNds=;
        b=zc76t+ayH30k4aoEfSxZcgqlEDPE3jSd+MwH+cJ6X+Vr8tGHC1OHqEu+i9r8jLYIiw
         oJIFtvkpUwCYPgf9Wk5d2/Z8jPoRRq+evz72IhxQcqlSx6bJUoeRlo7UsZ5kh/GnzEuG
         hvt5OnCaeHcP+9/Aa6eitKWRP/PgfieEoD22Rha3va18vT/r8sEZp4lay2FFleI9+LgM
         9HjMkj3XD65xWsrcxyxwnFIKm+v8HwuIKiA2lTibgNr614bRrxFQb4JMy1d/rAeE4m7F
         v7Ml8T9y/nmD5czybV2ufg55A7Ake/I9SEoZKo/z0D6bB6DJkTquNpQbD4tQ2WBGEOl8
         JT7g==
X-Gm-Message-State: AOAM533EaQRQL9P2rbjZ/bV5JUUvDVoDPkftGsGwYyTbz15SpfAZK+og
        kYtJm4tSNNuCafgr27lfSLfyvLO0VnY+1fBM210=
X-Google-Smtp-Source: ABdhPJwpcONPGuyA1L71cypckx0JcsiD/9+/f7BbFH1VxA84gPzARHiLqRySG4Pii6TEGarWECZLjL+KX0QAFxGFPMg=
X-Received: by 2002:a05:6402:34c9:: with SMTP id w9mr34197425edc.403.1642648009169;
 Wed, 19 Jan 2022 19:06:49 -0800 (PST)
MIME-Version: 1.0
References: <20220113070245.791577-1-imagedong@tencent.com> <CAADnVQKNCqUzPJAjSHMFr-Ewwtv5Cs3UCQpthaKDTd+YNRWqqg@mail.gmail.com>
In-Reply-To: <CAADnVQKNCqUzPJAjSHMFr-Ewwtv5Cs3UCQpthaKDTd+YNRWqqg@mail.gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Thu, 20 Jan 2022 11:02:27 +0800
Message-ID: <CADxym3bJZrcGHKH8=kKBkxh848dijAZ56n0fm_DvEh6Bbnrezg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Add document for 'dst_port' of 'struct bpf_sock'
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mengen Sun <mengensun@tencent.com>, flyingpeng@tencent.com,
        mungerjiang@tencent.com, Menglong Dong <imagedong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On Thu, Jan 20, 2022 at 6:03 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
[...]
>
> Looks like
>  __sk_buff->remote_port
>  bpf_sock_ops->remote_port
>  sk_msg_md->remote_port
> are doing the right thing,
> but bpf_sock->dst_port is not correct?
>
> I think it's better to fix it,
> but probably need to consolidate it with
> convert_ctx_accesses() that deals with narrow access.
> I suspect reading u8 from three flavors of 'remote_port'
> won't be correct.

What's the meaning of 'narrow access'? Do you mean to
make 'remote_port' u16? Or 'remote_port' should be made
accessible with u8? In fact, '*((u16 *)&skops->remote_port + 1)'
won't work, as it only is accessible with u32.

I can simply make 'dst_port' endianness right with what
'remote_port' do.

Thanks!
Menglong Dong


> 'dst_port' works with a narrow load, but gets endianness wrong.
