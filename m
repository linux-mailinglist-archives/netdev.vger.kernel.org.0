Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24EE3494FFA
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 15:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345339AbiATOSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 09:18:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241665AbiATOSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 09:18:48 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB42C061574;
        Thu, 20 Jan 2022 06:18:47 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id u18so15158985edt.6;
        Thu, 20 Jan 2022 06:18:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5Mz7q27SpmqwUwrWubZERoD29g9GOGLu3/nEjxPpvm0=;
        b=SdIhwJpqnrz2CkSu6coIK2i4m5KnCwxmovYSmkdcVGSKrwrYAeEuTnNzC8kEHkOXe2
         O4PQa3sQ10oXWVfL3OLv+HqYpDBCS/8toQkBmyczn9/aIEbwvEKWQ75dSl2qKDolXoGM
         TUHYBIDh2xCNXuFKYxn0+ea8iRagGoY3+zSSwYEjKdK658iOgvlWJoRFNrnvD4odKo72
         MzZaQ8pHDgWyU6whXEnxyb+pGrMFbEVmZtH8U1GGRI7NWfNhTUFWKrXgLcFRDleXAwTW
         atVQ4o937bi/fvI1i1XW6Jp0hOFcmjA1jHv4GlxGbfadMcCyPyHfZLy0jwt6sJkbLVEu
         d6Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5Mz7q27SpmqwUwrWubZERoD29g9GOGLu3/nEjxPpvm0=;
        b=CIsv5d2MeS2HxA11Bed4YENS7P2BXUuY029zhIruYBBdIEE1JZA+bCHQxaypduR9pP
         EKYYwn3H8hBnh767aPNJiYeYU0IgWqxhclN54rcnORDNV47cnpU4L2JcojAp4LTewRbu
         Gn1XnB3VWrgJ6ifyEjGnYUd08RBVKVvhIAadadDkDz4jiAhzsy+lHzVTVYsoEC5lV+4K
         MXgKMrm9AUr6/avfNEA13fbl8Tj4XAEaeWvyzGQgUGyGUoWVvM9bP594DdEjrl7BKvbU
         IpyzQhx8qM9BvlZagcY5kU2lz1r4EvoalFiyRYhTY6JG/XOS6BfFp1hrDd4rM8guxp64
         wksA==
X-Gm-Message-State: AOAM532iY3CmXEcTRyc0dwrRcW121x0E2FI4i9/vZlJbfZpQA0yPRHG1
        xo/cp4KDfk8yjfxVGRn57qDqR8syOP4dCJwp7Dg=
X-Google-Smtp-Source: ABdhPJwayU+fl3YGpI2/h8qTPctxrKdBGSOcDYWTwiwZgm9jycbZA0cqokuzX4dHOwuaEppTSS9h3psKbqwwxvwXXR0=
X-Received: by 2002:a17:907:2d9e:: with SMTP id gt30mr29598539ejc.704.1642688326394;
 Thu, 20 Jan 2022 06:18:46 -0800 (PST)
MIME-Version: 1.0
References: <20220113070245.791577-1-imagedong@tencent.com>
 <CAADnVQKNCqUzPJAjSHMFr-Ewwtv5Cs3UCQpthaKDTd+YNRWqqg@mail.gmail.com>
 <CADxym3bJZrcGHKH8=kKBkxh848dijAZ56n0fm_DvEh6Bbnrezg@mail.gmail.com> <20220120041754.scj3hsrxmwckl7pd@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220120041754.scj3hsrxmwckl7pd@ast-mbp.dhcp.thefacebook.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Thu, 20 Jan 2022 22:14:14 +0800
Message-ID: <CADxym3b-Q6LyjKqTFcrssK9dVJ8hL6QkMb0MzLyn64r4LS=xtw@mail.gmail.com>
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

On Thu, Jan 20, 2022 at 12:17 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Jan 20, 2022 at 11:02:27AM +0800, Menglong Dong wrote:
> > Hello!
> >
> > On Thu, Jan 20, 2022 at 6:03 AM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > [...]
> > >
> > > Looks like
> > >  __sk_buff->remote_port
> > >  bpf_sock_ops->remote_port
> > >  sk_msg_md->remote_port
> > > are doing the right thing,
> > > but bpf_sock->dst_port is not correct?
> > >
> > > I think it's better to fix it,
> > > but probably need to consolidate it with
> > > convert_ctx_accesses() that deals with narrow access.
> > > I suspect reading u8 from three flavors of 'remote_port'
> > > won't be correct.
> >
> > What's the meaning of 'narrow access'? Do you mean to
> > make 'remote_port' u16? Or 'remote_port' should be made
> > accessible with u8? In fact, '*((u16 *)&skops->remote_port + 1)'
> > won't work, as it only is accessible with u32.
>
> u8 access to remote_port won't pass the verifier,
> but u8 access to dst_port will.
> Though it will return incorrect data.
> See how convert_ctx_accesses() handles narrow loads.
> I think we need to generalize it for different endian fields.

Yeah, I understand narrower load in convert_ctx_accesses()
now. Seems u8 access to dst_port can't pass the verifier too,
which can be seen form bpf_sock_is_valid_access():

$    switch (off) {
$    case offsetof(struct bpf_sock, state):
$    case offsetof(struct bpf_sock, family):
$    case offsetof(struct bpf_sock, type):
$    case offsetof(struct bpf_sock, protocol):
$    case offsetof(struct bpf_sock, dst_port):  // u8 access is not allowed
$    case offsetof(struct bpf_sock, src_port):
$    case offsetof(struct bpf_sock, rx_queue_mapping):
$    case bpf_ctx_range(struct bpf_sock, src_ip4):
$    case bpf_ctx_range_till(struct bpf_sock, src_ip6[0], src_ip6[3]):
$    case bpf_ctx_range(struct bpf_sock, dst_ip4):
$    case bpf_ctx_range_till(struct bpf_sock, dst_ip6[0], dst_ip6[3]):
$        bpf_ctx_record_field_size(info, size_default);
$        return bpf_ctx_narrow_access_ok(off, size, size_default);
$    }

I'm still not sure what should we do now. Should we make all
remote_port and dst_port narrower accessable and endianness
right? For example the remote_port in struct bpf_sock_ops:

--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8414,6 +8414,7 @@ static bool sock_ops_is_valid_access(int off, int size,
                                return false;
                        info->reg_type = PTR_TO_PACKET_END;
                        break;
+               case bpf_ctx_range(struct bpf_sock_ops, remote_port):
                case offsetof(struct bpf_sock_ops, skb_tcp_flags):
                        bpf_ctx_record_field_size(info, size_default);
                        return bpf_ctx_narrow_access_ok(off, size,

If remote_port/dst_port are made narrower accessable, the
result will be right. Therefore, *((u16*)&sk->remote_port) will
be the port with network byte order. And the port in host byte
order can be get with:
bpf_ntohs(*((u16*)&sk->remote_port))
or
bpf_htonl(sk->remote_port)

Thanks!
Menglong Dong
