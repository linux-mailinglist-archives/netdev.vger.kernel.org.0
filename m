Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E44C12FCED
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 20:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbgACTSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 14:18:40 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:44271 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728380AbgACTSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 14:18:40 -0500
Received: by mail-qv1-f65.google.com with SMTP id n8so16599230qvg.11;
        Fri, 03 Jan 2020 11:18:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yu1PQeV86PC8O/FDOg5jNn1X99e7ZatzvafUBFhxrGM=;
        b=syVCeyMMTbrbspjyaBc7Dz7ShCs5rmTzYqukMmvk98MeX16ciBpHJkK2yEyYUYKIBU
         p9UImKs3V9W/BrutfHdaei3r9XOYb0ymSvRfQQy7I6QnKO1Rb4BcX1c2SZPHineKkL2d
         U1LiOhzkw53PnWqIydlVUNtqlU2A4Wnvz7yqfPMN5b+/OCzv7cZw9QTL7hMx6A9pcXrT
         8Vcht+A7XQnP90H8xRyUp8ptIC5IRK65zH9nJ7n434QHGyYWURDlp0pH5EtBLERPWp1m
         k4lgSg9Vg2ns98kmdDz30c1Z9LJJEEoqJ80ekT03h/mtviP7KGW50s17A/SVLrTRt/iC
         xVQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yu1PQeV86PC8O/FDOg5jNn1X99e7ZatzvafUBFhxrGM=;
        b=TP4ld3HSJmufDEsKr4+wWbCsilyTbBBIsTv/yrrBZcBA3zth7tgG44c78i/mo1gtf7
         MzYreQHmbJrQvJmIvKfvAEsxzgHJYgQc2uyl9lsH0S+izpSVSe9G40DD8i8OK3GW/+ju
         CZEjwK+87avrLkN4SuK3OqLhD7UO0NiGQw9/jNOjSs6UIWU/4mC4SNaiuEPeD4yvZjed
         MoNLvdtSLihvXYhaa3qSmpJp3q3Av8vTtwnfp/yjwIH56gdy3GjnVtOyDDvSelHX1G6F
         fLOnl2ad7CSAnS/WPjgc9CvgzpEaDY1rTw8cDENJ6hTQm5d5AQzIWdasgk/+an8K45m0
         qdYg==
X-Gm-Message-State: APjAAAXNI073VGLgl1pPakzfConXGXiMBeGMPvm0GShdiI2wi/eoJIPy
        XynB+fmNx9YjoT3Bo3YnXMKsSxk6iMTYm0FYEeM=
X-Google-Smtp-Source: APXvYqxwbLcBHd9eGb/ikZ0DYoOyo3nhlhVq+UHTumSxAcsa74RtbTOjuV0k6MX3hbODEG9EIML0P/qcQNXpW922r6g=
X-Received: by 2002:a05:6214:923:: with SMTP id dk3mr66651024qvb.96.1578079119506;
 Fri, 03 Jan 2020 11:18:39 -0800 (PST)
MIME-Version: 1.0
References: <1578031353-27654-1-git-send-email-lirongqing@baidu.com> <20200103082712.GF12930@netronome.com>
In-Reply-To: <20200103082712.GF12930@netronome.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Fri, 3 Jan 2020 11:18:28 -0800
Message-ID: <CAPhsuW6z+jh0xofi8FCA0uvTJ5jSL_ZGpwPu1Eg566XeJ03pZA@mail.gmail.com>
Subject: Re: [PATCH][bpf-next] bpf: change bpf_skb_generic_push type as void
To:     Simon Horman <simon.horman@netronome.com>
Cc:     Li RongQing <lirongqing@baidu.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 3, 2020 at 12:27 AM Simon Horman <simon.horman@netronome.com> wrote:
>
> On Fri, Jan 03, 2020 at 02:02:33PM +0800, Li RongQing wrote:
> > bpf_skb_generic_push always returns 0, not need to check
> > its return, so change its type as void
> >
> > Signed-off-by: Li RongQing <lirongqing@baidu.com>
>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>
Acked-by: Song Liu <songliubraving@fb.com>

>
> > ---
> >  net/core/filter.c | 30 ++++++++++--------------------
> >  1 file changed, 10 insertions(+), 20 deletions(-)
> >
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 42fd17c48c5f..1cbac34a4e11 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
>
> ...
>
> > @@ -5144,7 +5134,7 @@ BPF_CALL_3(bpf_lwt_seg6_adjust_srh, struct sk_buff *, skb, u32, offset,
> >               if (unlikely(ret < 0))
> >                       return ret;
> >
> > -             ret = bpf_skb_net_hdr_push(skb, offset, len);
> > +             bpf_skb_net_hdr_push(skb, offset, len);
>
> There is a check for (ret < 0) just below this if block.
> That is ok becuase in order to get to here (ret < 0) must
> be true as per the check a few lines above.
>
> So I think this is ok although the asymmetry with the else arm
> of this if statement is not ideal IMHO.

Agreed with this concern. But I cannot think of any free solution. I guess we
will just live with assumption that skb_cow_head() never return >0.

Thanks,
Song
