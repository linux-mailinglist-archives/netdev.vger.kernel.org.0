Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBAD1C8D31
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 16:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgEGOAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 10:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgEGOAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 10:00:34 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1266AC05BD43;
        Thu,  7 May 2020 07:00:34 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id h9so6550796wrt.0;
        Thu, 07 May 2020 07:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=h1WpxjPdyCBE7KAla9iO5P4bZZoKPEKo563S8bN0HCI=;
        b=sBk6kKvAGS4In8Q8py/eXSV9EjvovXYsypizSjw5hvFDJpLj2W5MJDyZ2qq95Wbeb1
         4SDHjPtRiHmzqNGUbcc2Efjf3F2eelcZelnsPLA/wiaUJqwvMX/nYFXQOgGYUVljOcLr
         bSR5574lbhRAnScqLpRTqeGtRQd0KpJSdzUjJtHsz1llWx51lGgphJVM+VifTrobHSjn
         3+EDncYp1Ifba+WYMcpBpNqSL23Sfx0zu2mIOmdcFhioO2AAal2NY2VMjTbEDEtUDZja
         aha/k1rZ/crR/Blxkp/QSstjUzfMj9f7BMYt+oIBYs4HPNN19ZMb3+Fx9y3FvM863nJC
         TDrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=h1WpxjPdyCBE7KAla9iO5P4bZZoKPEKo563S8bN0HCI=;
        b=chTWUXx7cQ0GP0YBGAB5r9b7Y+jWnb5IGkSRYSYd4YpSnOd+oihXijI/G1IcBAD1vJ
         /wm3fCOHylX7DiZYUB/rgb+ErE30cbq/pWfvhGYdWrUU6qsuDpgkyD9Cq8rGieZsdc32
         deH8S3umKhKGJKReIX/o6VaQmvtz8eLzmaQtgkJR6cysX2WRc1ujGRg4p2q9izkFb4jV
         KnEl66n25EIr8ciWiUvZPu5pH9qCvwPTsmrr+4p05hBHUBMTSmT/lEce8w/3/9Ekc7Jt
         /A2VEhKSUphMwcOhTI03SvOCEv77KjoGSknuCqreIgOqzB5gSES0EWu4Kyntn02ocrGb
         6CXA==
X-Gm-Message-State: AGi0Pua8h9Qwwz0OcTUGONYtDAHr8hlbpC66hzxEiMVgKS6uefc0eoZp
        uZjcKqBeEmeFqAo7lnJhIyuyIwCtvyS4wJB66tI=
X-Google-Smtp-Source: APiQypL1Kp/ABv534LtfGV8dmXs8pCbQlD4SIU85WagRPFd7hgdlZNSjkg4/6551ILrUP3UGRzwNGQlRBBAKhbdnNPE=
X-Received: by 2002:adf:e910:: with SMTP id f16mr15150333wrm.176.1588860032651;
 Thu, 07 May 2020 07:00:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ+HfNidbgwtLinLQohwocUmoYyRcAG454ggGkCbseQPSA1cpw@mail.gmail.com>
 <877dxnkggf.fsf@toke.dk>
In-Reply-To: <877dxnkggf.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 7 May 2020 16:00:21 +0200
Message-ID: <CAJ+HfNhvzZ4JKLRS5=esxCd7o39-OCuDSmdkxCuxR9Y6g5DC0A@mail.gmail.com>
Subject: Re: XDP bpf_tail_call_redirect(): yea or nay?
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 May 2020 at 15:44, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.=
com> wrote:
>
> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>
> > Before I start hacking on this, I might as well check with the XDP
> > folks if this considered a crappy idea or not. :-)
> >
> > The XDP redirect flow for a packet is typical a dance of
> > bpf_redirect_map() that updates the bpf_redirect_info structure with
> > maps type/items, which is then followed by an xdp_do_redirect(). That
> > function takes an action based on the bpf_redirect_info content.
> >
> > I'd like to get rid of the xdp_do_redirect() call, and the
> > bpf_redirect_info (per-cpu) lookup. The idea is to introduce a new
> > (oh-no!) XDP action, say, XDP_CONSUMED and a built-in helper with
> > tail-call semantics.
> >
> > Something across the lines of:
> >
> > --8<--
> >
> > struct {
> >         __uint(type, BPF_MAP_TYPE_XSKMAP);
> >         __uint(max_entries, MAX_SOCKS);
> >         __uint(key_size, sizeof(int));
> >         __uint(value_size, sizeof(int));
> > } xsks_map SEC(".maps");
> >
> > SEC("xdp1")
> > int xdp_prog1(struct xdp_md *ctx)
> > {
> >         bpf_tail_call_redirect(ctx, &xsks_map, 0);
> >         // Redirect the packet to an AF_XDP socket at entry 0 of the
> >         // map.
> >         //
> >         // After a successful call, ctx is said to be
> >         // consumed. XDP_CONSUMED will be returned by the program.
> >         // Note that if the call is not successful, the buffer is
> >         // still valid.
> >         //
> >         // XDP_CONSUMED in the driver means that the driver should not
> >         // issue an xdp_do_direct() call, but only xdp_flush().
> >         //
> >         // The verifier need to be taught that XDP_CONSUMED can only
> >         // be returned "indirectly", meaning a bpf_tail_call_XXX()
> >         // call. An explicit "return XDP_CONSUMED" should be
> >         // rejected. Can that be implemented?
> >         return XDP_PASS; // or any other valid action.
> > }
> >
> > -->8--
> >
> > The bpf_tail_call_redirect() would work with all redirectable maps.
> >
> > Thoughts? Tomatoes? Pitchforks?
>
> The above answers the 'what'. Might be easier to evaluate if you also
> included the 'why'? :)
>

Ah! Sorry! Performance, performance, performance. Getting rid of a
bunch of calls/instructions per packet, which helps my (AF_XDP) case.
This would be faster than the regular REDIRECT path. Today, in
bpf_redirect_map(), instead of actually performing the action, we
populate the bpf_redirect_info structure, just to look up the action
again in xdp_do_redirect().

I'm pretty certain this would be a gain for AF_XDP (quite easy to do a
quick hack, and measure). It would also shave off the same amount of
instructions for "vanilla" XDP_REDIRECT cases. The bigger issue; Is
this new semantic something people would be comfortable being added to
XDP.


Cheers,
Bj=C3=B6rn
