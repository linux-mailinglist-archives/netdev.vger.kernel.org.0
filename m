Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFFEF3B3B4C
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 05:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233076AbhFYDto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 23:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbhFYDtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 23:49:41 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660B1C061574;
        Thu, 24 Jun 2021 20:47:20 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id j4so14002850lfc.8;
        Thu, 24 Jun 2021 20:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=toZAs9JPmAsiOSU1MchBEbcfF/e+3WBe3Mbk19M8Xak=;
        b=Ub0q0f9PXGDvdf0VIKmWYwY2N4zilskDEJxvFL47SQvZpC3JD1ZTftgRPCsB6Oo3ih
         fThaeKnMz+tqj4Ydo+Y6ttmF9aIYmZy1+AbrTY3cEfm4+8yl6zXrm9GYtWKcvh6HEfVj
         EnxpQBQH2YEDeG+5lwlDphfY8u7DNw7Ig0gwKIZzlmN0E1T/dxjvepB6+8w3SspLpQcG
         J1Caj7hkaGRWZtdnQjk2uhralBsuHdPRR1iu9bM1Wo9v8+c6Lbm3kFIrST6qszMUsdYf
         O1yB2GymzGCk60WSyMhn/N+dUTpD9BhGsaWP8geaRxAjAxo4VQ864yI0ZePjA87R9FZW
         1Iew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=toZAs9JPmAsiOSU1MchBEbcfF/e+3WBe3Mbk19M8Xak=;
        b=JjNwOWcbfSe9YfOUDFzQwk24KUyTs4qmf6sz3XgzJEgkpLaNzXF9P9/yAPH41vVho9
         ad6I5SJtyZON0cV0RTeJ5oJdx+I4kBa/l7W9mU4fx0aaME0cfsOVuY+XCDrOUpZn7E/4
         DcYJpO3UdBsIftALuYuWBM4slL8kdESn2YvClLofTNcX1QrCTQ0oZZEsJFLMnxZMl9fd
         4X96ECAwPY5DWkibTwXcfsbqQNQi1xbrPS9IivEkQCfxt8Ey/+14SI10Pa+zGdcGG8YS
         WwBnXL0u7Qwnfkkmp3L+nlfM5qLoMkuQRqPRSR3Ty45ksVoeskDmvrVcW+wOnKtmQud7
         CUCA==
X-Gm-Message-State: AOAM532ZecgyIdQHMyiVY/bICGe81EUqvfYbUickW2/jxN11N1ma+zyL
        cimlrppzBd2jk0QhcSsJ/dbiLPAXbP7+x3wLZho=
X-Google-Smtp-Source: ABdhPJyx6Gtk+UC67EnJ7OopVHNoNFLcsWqtJnP+/KpuoMIhDpX/gUZE9KGMKKlCD3eJFwmOiUje8R3L7t+ubZ+Kul4=
X-Received: by 2002:a05:6512:3293:: with SMTP id p19mr6568951lfe.214.1624592837649;
 Thu, 24 Jun 2021 20:47:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210623040918.8683-1-glin@suse.com> <CAADnVQLpN993VpnPkTUxXpBMZtS6+h4CVruH33zbw-BLWj41-A@mail.gmail.com>
 <20210623065744.igawwy424y2zy26t@amnesia>
In-Reply-To: <20210623065744.igawwy424y2zy26t@amnesia>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 24 Jun 2021 20:47:06 -0700
Message-ID: <CAADnVQK2uQ3MvwaRztMtcw8SJz1r213hxA+vM2dCtr6RfpZnSA@mail.gmail.com>
Subject: Re: [PATCH bpf] net/bpfilter: specify the log level for the kmsg message
To:     Dmitrii Banshchikov <me@ubique.spb.ru>
Cc:     Gary Lin <glin@suse.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Martin Loviska <mloviska@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 11:57 PM Dmitrii Banshchikov <me@ubique.spb.ru> wrote:
>
> On Tue, Jun 22, 2021 at 09:38:38PM -0700, Alexei Starovoitov wrote:
> > On Tue, Jun 22, 2021 at 9:09 PM Gary Lin <glin@suse.com> wrote:
> > >
> > > Per the kmsg document(*), if we don't specify the log level with a
> > > prefix "<N>" in the message string, the default log level will be
> > > applied to the message. Since the default level could be warning(4),
> > > this would make the log utility such as journalctl treat the message,
> > > "Started bpfilter", as a warning. To avoid confusion, this commit adds
> > > the prefix "<5>" to make the message always a notice.
> > >
> > > (*) https://www.kernel.org/doc/Documentation/ABI/testing/dev-kmsg
> > >
> > > Fixes: 36c4357c63f3 ("net: bpfilter: print umh messages to /dev/kmsg")
> > > Reported-by: Martin Loviska <mloviska@suse.com>
> > > Signed-off-by: Gary Lin <glin@suse.com>
> > > ---
> > >  net/bpfilter/main.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/net/bpfilter/main.c b/net/bpfilter/main.c
> > > index 05e1cfc1e5cd..291a92546246 100644
> > > --- a/net/bpfilter/main.c
> > > +++ b/net/bpfilter/main.c
> > > @@ -57,7 +57,7 @@ int main(void)
> > >  {
> > >         debug_f = fopen("/dev/kmsg", "w");
> > >         setvbuf(debug_f, 0, _IOLBF, 0);
> > > -       fprintf(debug_f, "Started bpfilter\n");
> > > +       fprintf(debug_f, "<5>Started bpfilter\n");
> > >         loop();
> > >         fclose(debug_f);
> > >         return 0;
> >
> > Adding Dmitrii who is redesigning the whole bpfilter.
>
> Thanks. The same logic already exists in the bpfilter v1 patchset
> - [1].
>
> 1. https://lore.kernel.org/bpf/c72bac57-84a0-ac4c-8bd8-08758715118e@fb.com/T/#mb36e20c4e5e4a70746bd50a109b1630687990214

Dmitrii,

what do you prefer we should do with this patch then?
