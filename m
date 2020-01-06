Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9F2E131B81
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 23:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgAFWcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 17:32:10 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46927 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbgAFWcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 17:32:09 -0500
Received: by mail-pg1-f196.google.com with SMTP id z124so27487567pgb.13;
        Mon, 06 Jan 2020 14:32:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VJV1jqLximhJfLgI93Z8Y+rrciBYU6tl19IHqJuODkY=;
        b=lPmeJiNYSquC6XJHaAWPTiJ64X7L5REj51lg0G2qjq6SNtQDSQKq0k7Xs32A/0/6Td
         vNxNeJUD5LcVdv6pJB3e/+pz8/LG1CT/wxzwGIsWks2zF9pa+tG6RV34GoKqy2eTA8jW
         BfHUFqrGA+eO6Hb/YCVXX5N7VpSu+xE7IYEIR27Vr9LzRzHFCVelvdmybWs0+JhZmItc
         T1nYS98tUwVxm3GV2U7BS5tKW6guPODmnl0t3CI7D/sqI7PX2J6w8PITN9jcpzRPBpC+
         TW52iRslJ2XBc4Nvrf3gEe0cqqwYGNCpRuI2LMSyo7SPNDWUlxsqlfjZGctX13iTAaYK
         PztQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VJV1jqLximhJfLgI93Z8Y+rrciBYU6tl19IHqJuODkY=;
        b=TwEfs7MFRYMs1nE0fgJ7Qr/4Ybn+W/4vKjgR8V9A2Kt+g/tsrbIWZmvQzFwCIoXIHb
         rnqI8Y10dbyxCWgUClZ2y/PPx9nOCGjqIbYws5BZQbgzIu41pGMEcmOp/vmX8beWTok9
         UZf1u0BOVScXmxCoPcf3CGALy+0mz+QKP2VlG+AyopE7tDxc45V3AYfA7CFryN043zKM
         k5lR3kDT+Yn+6wqtAmgaOiRrfaXBKmQ7Owh6qMb6frc17BN50ssrXkNAjpPBWk7Spq13
         cNK9ahiBna2sECT8QjM0fFYh5/TVsVkm7gaWZTCIdiQLIOmwIZ8Gk3cFRFkj+Una/zO8
         2vQw==
X-Gm-Message-State: APjAAAXtkBU/jQzbtDI/FCdzVe3bk39kVPXvJKcHlNT7KL46wz3kDRkx
        uUdn3NZ/XElEx6a/ngLrI4Y=
X-Google-Smtp-Source: APXvYqzB1KGfF4oler8gb3ZsrESDiqXu4a0nZXz4KtkS4M0kKrCHg6iL3PBDGStOMSc2CblMrXGg5A==
X-Received: by 2002:aa7:86ce:: with SMTP id h14mr33759904pfo.31.1578349929077;
        Mon, 06 Jan 2020 14:32:09 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:200::1:2bf6])
        by smtp.gmail.com with ESMTPSA id j20sm67018596pfe.168.2020.01.06.14.32.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jan 2020 14:32:08 -0800 (PST)
Date:   Mon, 6 Jan 2020 14:32:07 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Simon Horman <simon.horman@netronome.com>,
        Li RongQing <lirongqing@baidu.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH][bpf-next] bpf: change bpf_skb_generic_push type as void
Message-ID: <20200106223206.uxq6isyk7pjruxx3@ast-mbp>
References: <1578031353-27654-1-git-send-email-lirongqing@baidu.com>
 <20200103082712.GF12930@netronome.com>
 <CAPhsuW6z+jh0xofi8FCA0uvTJ5jSL_ZGpwPu1Eg566XeJ03pZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW6z+jh0xofi8FCA0uvTJ5jSL_ZGpwPu1Eg566XeJ03pZA@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 03, 2020 at 11:18:28AM -0800, Song Liu wrote:
> On Fri, Jan 3, 2020 at 12:27 AM Simon Horman <simon.horman@netronome.com> wrote:
> >
> > On Fri, Jan 03, 2020 at 02:02:33PM +0800, Li RongQing wrote:
> > > bpf_skb_generic_push always returns 0, not need to check
> > > its return, so change its type as void
> > >
> > > Signed-off-by: Li RongQing <lirongqing@baidu.com>
> >
> > Reviewed-by: Simon Horman <simon.horman@netronome.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> 
> >
> > > ---
> > >  net/core/filter.c | 30 ++++++++++--------------------
> > >  1 file changed, 10 insertions(+), 20 deletions(-)
> > >
> > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > index 42fd17c48c5f..1cbac34a4e11 100644
> > > --- a/net/core/filter.c
> > > +++ b/net/core/filter.c
> >
> > ...
> >
> > > @@ -5144,7 +5134,7 @@ BPF_CALL_3(bpf_lwt_seg6_adjust_srh, struct sk_buff *, skb, u32, offset,
> > >               if (unlikely(ret < 0))
> > >                       return ret;
> > >
> > > -             ret = bpf_skb_net_hdr_push(skb, offset, len);
> > > +             bpf_skb_net_hdr_push(skb, offset, len);
> >
> > There is a check for (ret < 0) just below this if block.
> > That is ok becuase in order to get to here (ret < 0) must
> > be true as per the check a few lines above.
> >
> > So I think this is ok although the asymmetry with the else arm
> > of this if statement is not ideal IMHO.
> 
> Agreed with this concern. But I cannot think of any free solution. I guess we
> will just live with assumption that skb_cow_head() never return >0.

I don't think this patch is worth doing.
I can imagine bpf_skb_generic_push() handling some errors in the future.
compiler can do this optimization job instead.
