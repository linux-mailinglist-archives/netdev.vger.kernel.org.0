Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF3E01395B0
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 17:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbgAMQVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 11:21:48 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:34809 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbgAMQVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 11:21:48 -0500
Received: by mail-yw1-f65.google.com with SMTP id b186so6466921ywc.1
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 08:21:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ocz6CpUCL2zzgRFmpnyljHkGYdMTYLDTU0/fEUgYlro=;
        b=D286ww8hOq9YikFRNsoCtY7kYY1NUJD6U3cuf59C31P3BgSBf3Ficmd8Wz89l4Eiqi
         mgHWCC2ThCqLECHKZdLUPXyneIbdtuOnRxT3O6jfdse6DFJrAmGPPUmBr+522iydlLMJ
         j4Z4JLJ4il4vai4OfwOWsjI4JNaEgL/y0yOI5nGy8IrIuc+odna3pU75uP2d3GN56NhH
         tw26whkgr0uRUdFB+E1y3c2gbfcB40LurAmIrbwLpJyWsyioN80BfJvmEOuqH6qAq6uS
         zmJEAAfeRKhJ/1cYBNR5V+uXD5S2p3YANgfuIUW5hHzVvF0Scuj4p6gwkUK9VDwZcoxu
         rJLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ocz6CpUCL2zzgRFmpnyljHkGYdMTYLDTU0/fEUgYlro=;
        b=d31a7qYTzwZM2RT+r2ymwHygSfLpPo3mXTGtO9rMGPNGGUSrjUO9nJVmXk/P6zyj6Q
         Rwy6wudXXtfr4kQ7w/cRKFVPMf6NE7mkpwEUVWrDIuE7i6SfZs/Jd03GSKUph2qwmfQv
         74AB5RlyZNYoXBf54HgjTz+vRaDRBXdnf3aJSMZP5tcYb2YTy6rKrTLEW4YsfJvAsXyj
         nrMyAbXCo/Djl2mw0vBJARbMF28VoxFGS1792ODEUR7aOBWlDTMdd8DebqIZc0eD0fD+
         6oS0E2BujmKB4PQSLBErtanibM5o4K5BbCEpORFL7ETSIPifesRpg5+eTXa20BiKuYqM
         Y4xA==
X-Gm-Message-State: APjAAAVkHjy3jD6JFDdmZzTkChwmHxsnhzwk9Cnc+crvbJL6wDKLKBt9
        Svvnhogb90s4oZZr3+jbPSrswzJF
X-Google-Smtp-Source: APXvYqxeFC5qibQAubLplnWuFy0elMQMTVaNia6M6l8tNJ+4rsl72CNSxxd/fo7dF+jyjvQ0HhM0XA==
X-Received: by 2002:a81:5151:: with SMTP id f78mr9617625ywb.221.1578932506380;
        Mon, 13 Jan 2020 08:21:46 -0800 (PST)
Received: from mail-yw1-f54.google.com (mail-yw1-f54.google.com. [209.85.161.54])
        by smtp.gmail.com with ESMTPSA id n142sm5313598ywd.26.2020.01.13.08.21.44
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jan 2020 08:21:44 -0800 (PST)
Received: by mail-yw1-f54.google.com with SMTP id l22so6464380ywc.8
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 08:21:44 -0800 (PST)
X-Received: by 2002:a25:ced4:: with SMTP id x203mr9648025ybe.419.1578932503829;
 Mon, 13 Jan 2020 08:21:43 -0800 (PST)
MIME-Version: 1.0
References: <20191218133458.14533-1-steffen.klassert@secunet.com>
 <20191218133458.14533-4-steffen.klassert@secunet.com> <CA+FuTScnux23Gj1WTEXHmZkiFG3RQsgmSz19TOWdWByM4Rd15Q@mail.gmail.com>
 <20191219082246.GS8621@gauss3.secunet.de> <CA+FuTScKcwyh7rZdDNQsujndrA+ZnYMmtA7Uh7-ji+RM+t6-hQ@mail.gmail.com>
 <20200113085128.GH8621@gauss3.secunet.de>
In-Reply-To: <20200113085128.GH8621@gauss3.secunet.de>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 13 Jan 2020 11:21:07 -0500
X-Gmail-Original-Message-ID: <CA+FuTSc3sOuPsQ3sJSCudCwZky4FcGF5CopejURmGZUSjXEn3Q@mail.gmail.com>
Message-ID: <CA+FuTSc3sOuPsQ3sJSCudCwZky4FcGF5CopejURmGZUSjXEn3Q@mail.gmail.com>
Subject: Re: [PATCH net-next 3/4] net: Support GRO/GSO fraglist chaining.
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 13, 2020 at 3:51 AM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> On Thu, Dec 19, 2019 at 11:28:34AM -0500, Willem de Bruijn wrote:
> > On Thu, Dec 19, 2019 at 3:22 AM Steffen Klassert
> > <steffen.klassert@secunet.com> wrote:
> > >
> > > I tried to find the subset of __copy_skb_header() that is needed to copy.
> > > Some fields of nskb are still valid, and some (csum related) fields
> > > should not be copied from skb to nskb.
> >
> > Duplicating that code is kind of fragile wrt new fields being added to
> > skbs later (such as the recent skb_ext example).
> >
> > Perhaps we can split __copy_skb_header further and call the
> > inner part directly.
>
> I thought already about that, but __copy_skb_header does a
> memcpy over all the header fields. If we split this, we
> would need change the memcpy to direct assignments.

Okay, if any of those fields should not be overwritten in this case,
then that's not an option. That memcpy is probably a lot more
efficient than all the direct assignments.

> Maybe we can be conservative here and do a full
> __copy_skb_header for now. The initial version
> does not necessarily need to be the most performant
> version. We could try to identify the correct subset
> of header fields later then.

We should probably aim for the right set from the start. If you think
this set is it, let's keep it.

Could you add an explicit comment that this is a subset of
__copy_skb_header. That might help remind us of this partial duplicate
whenever updating that function.

> > > I had to set ip_summed to CHECKSUM_UNNECESSARY on GRO to
> > > make sure the noone touches the checksum of the head
> > > skb. Otherise netfilter etc. tries to touch the csum.
> > >
> > > Before chaining I make sure that ip_summed and csum_level is
> > > the same for all chained skbs and here I restore the original
> > > value from nskb.
> >
> > This is safe because the skb_gro_checksum_validate will have validated
> > already on CHECKSUM_PARTIAL? What happens if there is decap or encap
> > in the path? We cannot revert to CHECKSUM_PARTIAL after that, I
> > imagine.
>
> Yes, the checksum is validated with skb_gro_checksum_validate. If the
> packets are UDP encapsulated, they are segmented before decapsulation.
> Original values are already restored. If an additional encapsulation
> happens, the encap checksum will be calculated after segmentation.
> Original values are restored before that.

I was wondering more about additional other encapsulation protocols.

From a quick read, it seems like csum_level is associated only with
CHECKSUM_UNNECESSARY.

What if a device returns CHECKSUM_COMPLETE for packets with a tunnel
that is decapsulated before forwarding. Say, just VLAN. That gets
untagged in __netif_receive_skb_core with skb_vlan_untag calling
skb_pull_rcsum. After segmentation the ip_summed is restored, with
skb->csum still containing the unmodified csum that includes the VLAN
tag?

>
> >
> > Either way, would you mind briefly documenting the checksum behavior
> > in the commit message? It's not trivial and I doubt I'll recall the
> > details in six months.
>
> Yes, can do this.
>
> > Really about patch 4: that squashed in a lot of non-trivial scaffolding
> > from previous patch 'UDP: enable GRO by default'. Does it make sense
> > to keep that in a separate patch? That should be a noop, which we can
> > verify. And it makes patch 4 easier to reason about on its own, too.
>
> Patch 4 is not that big, so not sure it that makes really sense.
> But I can split out a preparation patch if that is preferred.

Thanks. If it's not too complex. I do think that it will help make the
non-obvious functional change stand out from the larger noop code
refactor. But perhaps it's indeed nitpicking. Leave as is if you
prefer, for sure.

> Anyway, I likely do another RFC version because we are already
> late in the development cycle.

The feature is now disabled by default, so it could definitely go in
late in the cycle and allow us to find and fix bugs during
stabilization. Up to you, obviously!
