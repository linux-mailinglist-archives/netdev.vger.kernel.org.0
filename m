Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00CAE49BF4D
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 00:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234584AbiAYXDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 18:03:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234586AbiAYXCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 18:02:49 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A59C06173B;
        Tue, 25 Jan 2022 15:02:49 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id u11so20779936plh.13;
        Tue, 25 Jan 2022 15:02:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EBImikir9ryAT25BALwOBZaIdeZpyfkOerp8AGfow0Y=;
        b=nS/qs9KssIJBTLzoLDLJszdVUiXxpkn92Gj/mSrQkvnuM5mgW1SQgyG1o+8jAruIj7
         ECS09HKz/+dnA+KNFP2GgHqKwmKO2hCXnqNDrNrDNuKMBTs+5Z+l4C0tk/fZMCZnoZdr
         YhC3VN2lfAFgR/0mdLfFIUG4PJRoh7kFfMHP3pqhfdEsCUT78J5zjm1dWL8MFMZ8d0pX
         WuURUQf53/4jtwjRwdI9Dxw5Y8rZR7KHJRXKizykEq7xkNycQK5bwgeSMYMBj17IFW+r
         mblklustS3N81EEQYEu675+sO1LupmJjWR4M2HVHsEYGXegfUO32PGTktkreTBVB37VZ
         +OQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EBImikir9ryAT25BALwOBZaIdeZpyfkOerp8AGfow0Y=;
        b=okBwUwq6UTYsMQhAX2djnD4sxagRhUPIwoCkT0VIwEdcvYeTlD2gCJnj4Siz13NK06
         ikN9705PjjPrDXmaaQo/qytClKv4VNB3y2D52PviZqS4xAyWSzuNQRt5V8QQvKnjeIWy
         Z6+pbf1d1gRUwL0wmtWidM5eZUk7OW5F7OxS+o4W/746PSBudOJAnH1tjfz6PEiuxNoI
         Ed2Gv5ccH2HNOmpPFLnGGXdXnFpQqsmFObgFjWA0SDzghyu6IxD9hf+6WxCTGiVqrc1I
         XLKsU+X+rAiPMtX2CylA+1YZtf0OSyCtMAJ8yljYS+UL+9sakvB+8je+cinTtTSzleZw
         6a/g==
X-Gm-Message-State: AOAM532xm9DnCjwiERDDxWlvOIyKrtLILdU+CGmUNqUajIyuLcHhKXfN
        bFBjG5yLO0k+F7T+g0Bqt0q3J3Dboak4wq1tuoU=
X-Google-Smtp-Source: ABdhPJy5YQg3TdenuLu2bpBojTq87dI7qwnNcwo4fmhj3+xZGz079adASMz1cchAxmmJBkXWlv8d72PId6c8m90wEOk=
X-Received: by 2002:a17:90b:3b4c:: with SMTP id ot12mr5749610pjb.62.1643151768394;
 Tue, 25 Jan 2022 15:02:48 -0800 (PST)
MIME-Version: 1.0
References: <20220113070245.791577-1-imagedong@tencent.com>
 <87sftbobys.fsf@cloudflare.com> <20220125224524.fkodqvknsluihw74@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220125224524.fkodqvknsluihw74@kafai-mbp.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 25 Jan 2022 15:02:37 -0800
Message-ID: <CAADnVQKbYCCYjCMhEV7p1YzkAVSKvg-1VKfWVQYVL0TaESNxBQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Add document for 'dst_port' of 'struct bpf_sock'
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Menglong Dong <menglong8.dong@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
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

On Tue, Jan 25, 2022 at 2:45 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, Jan 25, 2022 at 08:24:27PM +0100, Jakub Sitnicki wrote:
> > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > index b0383d371b9a..891a182a749a 100644
> > > --- a/include/uapi/linux/bpf.h
> > > +++ b/include/uapi/linux/bpf.h
> > > @@ -5500,7 +5500,11 @@ struct bpf_sock {
> > >     __u32 src_ip4;
> > >     __u32 src_ip6[4];
> > >     __u32 src_port;         /* host byte order */
> > > -   __u32 dst_port;         /* network byte order */
> > > +   __u32 dst_port;         /* low 16-bits are in network byte order,
> > > +                            * and high 16-bits are filled by 0.
> > > +                            * So the real port in host byte order is
> > > +                            * bpf_ntohs((__u16)dst_port).
> > > +                            */
> > >     __u32 dst_ip4;
> > >     __u32 dst_ip6[4];
> > >     __u32 state;
> >
> > I'm probably missing something obvious, but is there anything stopping
> > us from splitting the field, so that dst_ports is 16-bit wide?
> >
> > I gave a quick check to the change below and it seems to pass verifier
> > checks and sock_field tests.
> >
> > IDK, just an idea. Didn't give it a deeper thought.
> >
> > --8<--
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 4a2f7041ebae..344d62ccafba 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -5574,7 +5574,8 @@ struct bpf_sock {
> >       __u32 src_ip4;
> >       __u32 src_ip6[4];
> >       __u32 src_port;         /* host byte order */
> > -     __u32 dst_port;         /* network byte order */
> > +     __u16 unused;
> > +     __u16 dst_port;         /* network byte order */
> This will break the existing bpf prog.

I think Jakub's idea is partially expressed:
+       case offsetof(struct bpf_sock, dst_port):
+               bpf_ctx_record_field_size(info, sizeof(__u16));
+               return bpf_ctx_narrow_access_ok(off, size, sizeof(__u16));

Either 'unused' needs to be after dst_port or
bpf_sock_is_valid_access() needs to allow offset at 'unused'
and at 'dst_port'.
And allow u32 access though the size is actually u16.
Then the existing bpf progs (without recompiling) should work?
