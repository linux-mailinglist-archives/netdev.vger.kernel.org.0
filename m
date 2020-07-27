Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4148522E52B
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 07:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgG0FT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 01:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgG0FT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 01:19:57 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9EEC0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 22:19:56 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id s9so8293827lfs.4
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 22:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pesu-pes-edu.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ozt9OYkcD6AjbMEqO1NrB1cTbEGxVehRnBtW5ShPGTE=;
        b=N+phtonw/dLSV8xFacy0xHc1wofpvI9z3iQxJQwYwoEXtwfSpEPSi1hVNut4CuuvW1
         tanKnHYJGp/zyWkmdRyClrxB5CGH6z9xpKgkuxzTJXXwJrUbarnS4POKJaxuECOuWYUV
         uYFbWVBoP1grcT0vbngIsGoi9q6ukeITNW4mBpFW2za6vClqsSRwvtXr2TXr4RtaeOg5
         ObpwnkCcJO1mvVGlsxSsGTOfw1i5zrdqGzOnaZzKjB9MXRn7Y4M8NfLExIZfcWRiqP8Q
         EsMyHuOoeU3hvws/PJX+CcFfGH7bV+1ZTtF3cwkaBMdoiMVtAIgnkxDNar79iUtG+ADU
         fR6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ozt9OYkcD6AjbMEqO1NrB1cTbEGxVehRnBtW5ShPGTE=;
        b=mfQZnTLjtBITiJrOLiKbCga1sPiPmtmp6S01bB7/Uh8S0XPPdwmlytqpWVtTMkiUdO
         pfzpK79xKXggHcEF/5fsQjwgwAAGaaa99jSfDMOKfCkwjALDja0ixbUGU2fBkQ6LgHL+
         KyM1fX45Jgzy8Mh8kO5G19GPTGT8g8MUY3/S4KPK2qadxg4IIYFVfvUC547WphfB+WWM
         aXbg5eyuGYl9tNoDRYBdFQYNz0JS2lQ/Csmrev0XPLlDa8VHPzlcr7UsxZbnuPhn245l
         cUDDQZxyn6qUbTURsbHPbL/cBXxBGVAhPe4WAIpHgW52wrCafVk3dtCC+a2O1RbHu6je
         QbXQ==
X-Gm-Message-State: AOAM532BrsIl+hhZIDVAVzZpoGXpwi5rn2jUn4UiRldLlHankjNTxb3+
        h9/cQHF37hhNdSpSFMBWJJKg5YeNKKZfq94SxmcI6Q==
X-Google-Smtp-Source: ABdhPJztlE0965bqCYFX7suGiujXvJJ3ywyoZaR6TB+veUzG5oUH+5xrRYioBMIf1tP3Ihlkzp5YBmatVk9njhY+7vw=
X-Received: by 2002:ac2:4144:: with SMTP id c4mr10880776lfi.118.1595827194783;
 Sun, 26 Jul 2020 22:19:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200726030855.q6dfjekazfzl5usw@pesu.pes.edu> <CAM_iQpUFL7VdCKSgUa6N3pg7ijjZRu6-6UAs2oNosM-EzgXbaQ@mail.gmail.com>
 <CAAhDqq28h9_ji=ANttUyx2Q1Md=bZD3-JVCwQRW06W7aikPN0A@mail.gmail.com> <CAM_iQpX+iw+5AALriNZLfx5P-LV_ratiwhMRiHXmuLE2z81aaw@mail.gmail.com>
In-Reply-To: <CAM_iQpX+iw+5AALriNZLfx5P-LV_ratiwhMRiHXmuLE2z81aaw@mail.gmail.com>
From:   B K Karthik <bkkarthik@pesu.pes.edu>
Date:   Mon, 27 Jul 2020 10:49:43 +0530
Message-ID: <CAAhDqq3kf-XPB5nEEr76YOT=DifuCWM4HagB9R7brs1TaDbzZw@mail.gmail.com>
Subject: Re: [PATCH v2] net: ipv6: fix use-after-free Read in __xfrm6_tunnel_spi_lookup
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel-mentees@lists.linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 1:37 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Sat, Jul 25, 2020 at 11:12 PM B K Karthik <bkkarthik@pesu.pes.edu> wrote:
> >
> > On Sun, Jul 26, 2020 at 11:05 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > On Sat, Jul 25, 2020 at 8:09 PM B K Karthik <bkkarthik@pesu.pes.edu> wrote:
> > > > @@ -103,10 +103,10 @@ static int __xfrm6_tunnel_spi_check(struct net *net, u32 spi)
> > > >  {
> > > >         struct xfrm6_tunnel_net *xfrm6_tn = xfrm6_tunnel_pernet(net);
> > > >         struct xfrm6_tunnel_spi *x6spi;
> > > > -       int index = xfrm6_tunnel_spi_hash_byspi(spi);
> > > > +       int index = xfrm6_tunnel_spi_hash_byaddr((const xfrm_address_t *)spi);
> > > >
> > > >         hlist_for_each_entry(x6spi,
> > > > -                            &xfrm6_tn->spi_byspi[index],
> > > > +                            &xfrm6_tn->spi_byaddr[index],
> > > >                              list_byspi) {
> > > >                 if (x6spi->spi == spi)
> > >
> > > How did you convince yourself this is correct? This lookup is still
> > > using spi. :)
> >
> > I'm sorry, but my intention behind writing this patch was not to fix
> > the UAF, but to fix a slab-out-of-bound.
>
> Odd, your $subject is clearly UAF, so is the stack trace in your changelog.
> :)
>
>
> > If required, I can definitely change the subject line and resend the
> > patch, but I figured this was correct for
> > https://syzkaller.appspot.com/bug?id=058d05f470583ab2843b1d6785fa8d0658ef66ae
> > . since that particular report did not have a reproducer,
> > Dmitry Vyukov <dvyukov@google.com> suggested that I test this patch on
> > other reports for xfrm/spi .
>
> You have to change it to avoid misleading.

I will do that once somebody tells me this patch is reasonable to
avoid wasting people's time.
>
> >
> > Forgive me if this was the wrong way to send a patch for that
> > particular report, but I guessed since the reproducer did not trigger
> > the crash
> > for UAF, I would leave the subject line as 'fix UAF' :)
> >
> > xfrm6_spi_hash_by_hash seemed more convincing because I had to prevent
> > a slab-out-of-bounds because it uses ipv6_addr_hash.
> > It would be of great help if you could help me understand how this was
> > able to fix a UAF.
>
> Sure, you just avoid a pointer deref, which of course can fix the UAF,
> but I still don't think it is correct in any aspect.

I saw a function call being made to tomoyo_check_acl(). the next thing
happening is a kfree().
Also, spi_hash_byspi just returns spi % XFRM6_TUNNEL_SPI_BYSPI_HSIZE .

I'm a mentee, hence I would say my knowledge is very limited, please
let me know if I am making a horrible mistake somewhere,
but return (__force u32)(a->s6_addr32[0] ^ a->s6_addr32[1] ^
a->s6_addr32[2] ^ a->s6_addr32[3]); seems like a better because
as David S. Miller <davem@davemloft.net> said "It is doing a XOR on
all bits of an IPv6 address, it is doing more bit shifting which the
existing hash was ignoring" .

Please help me understand this better if I am going wrong.

>
> Even if it is a OOB, you still have to explain why it happened. Once
> again, I can't see how it could happen either.
>
> >
> > >
> > > More importantly, can you explain how UAF happens? Apparently
> > > the syzbot stack traces you quote make no sense at all. I also
> > > looked at other similar reports, none of them makes sense to me.
> >
> > Forgive me, but I do not understand what you mean by the stack traces
> > (this or other similar reports) "make no sense".
>
> Because the stack trace in your changelog clearly shows it is allocated
> in tomoyo_init_log(), which is a buffer in struct tomoyo_query, but
> none of xfrm paths uses it. Or do you see anything otherwise?

Aren't there indirect inet calls and netfilter hooks? I'm sorry I do
not see anything otherwise.
Please help me understand.

thanks,

karthik
