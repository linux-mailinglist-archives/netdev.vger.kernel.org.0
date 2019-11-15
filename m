Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEB50FE87E
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 00:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbfKOXNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 18:13:23 -0500
Received: from mail-yw1-f49.google.com ([209.85.161.49]:34676 "EHLO
        mail-yw1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbfKOXNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 18:13:22 -0500
Received: by mail-yw1-f49.google.com with SMTP id y18so3691005ywk.1
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 15:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mXm/gzBPFwdi3AvkVmmSsWFLVbsAUPHv3WjzhLg9pl0=;
        b=ORuEkA+A+MB/LMR5MwGAlDRbEJ+4idg+tRiiI89UoZ2MCjnt8d8mn/mt7cvItUk8jv
         VtWwPZwPAaK2sTnOgTlcA2e9yH+GeYD6Akjz7x1+zlnmo3kJfdeQ40TPxlyA2L/71nP/
         BxFVg6aIxwuWLVU5IJfeIotSgXxFn2sVwrUD2g5iNmoOYmyJruAM26ifljOHlEYyupEj
         k5sG4vEidN9cZK07eE8FTjFsSs/AnUQeGeHfR5oNWlXTekchlTwDFEm+kIngmKL6l0Bl
         b3DiOvwn86+nQ1SGoSz9vmCDiCLe6hjT7UuPiGJVtvGSx789uw/P21dN7kBOn08DlAZx
         /spg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mXm/gzBPFwdi3AvkVmmSsWFLVbsAUPHv3WjzhLg9pl0=;
        b=WxrImmR8mevW4YREwn8R5vPmVao5ycx/uEir0kDbXvHEVEqY6S3Chna3+EFzeQ/8Z2
         iixL4kt2SK+DOSKDqCJ70GBemM2wofYwBeHYk3aUf4vAU0wxHc7CIRq2vCx/VMtkYBSz
         e49r1vaImDAumSsl4ziP7GNVRd8QCz6gS3do0k3661GfZWpQUMc6YX1Pe3MBpR9TZ5oD
         5yx1/pu7B6GILB5yKjMzPqPGz+9kYs4DsZxHSf3TWdYK4VylbmGFcgqBmLMliOG1qfoP
         9KLRdpWM7ylxxGwOJwc+ZgPjNDI6zMJ2T7tIjbsXTk7k6XDV2ZxHwDp96okpvUHvQGfU
         V16g==
X-Gm-Message-State: APjAAAWn7/zvyYtqLyCX2wJQOcmfKtnwsJLcvwDujJiSRkVIRjOZAMb2
        aaGEV10wHeTDYUTxtyjrMqIPty9o
X-Google-Smtp-Source: APXvYqxkdEmkRFakosyvErw4o+d6iN3Kf3PnnwAUIBcUJzyYUe2UuD9v1WdvM9Ox2htmp7hyOabG2g==
X-Received: by 2002:a81:51c4:: with SMTP id f187mr11435660ywb.409.1573859600707;
        Fri, 15 Nov 2019 15:13:20 -0800 (PST)
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com. [209.85.219.169])
        by smtp.gmail.com with ESMTPSA id k84sm2832980ywk.51.2019.11.15.15.13.19
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2019 15:13:20 -0800 (PST)
Received: by mail-yb1-f169.google.com with SMTP id q7so4712145ybk.4
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 15:13:19 -0800 (PST)
X-Received: by 2002:a25:2c0f:: with SMTP id s15mr14702054ybs.337.1573859599166;
 Fri, 15 Nov 2019 15:13:19 -0800 (PST)
MIME-Version: 1.0
References: <CA+FuTSfTMuKv8s0zdS6YzLC14bNdPQxi2mu7ak6e_sS+qyyrFg@mail.gmail.com>
 <5dcf24ddc492e_66d2acadef865b4b2@john-XPS-13-9370.notmuch>
In-Reply-To: <5dcf24ddc492e_66d2acadef865b4b2@john-XPS-13-9370.notmuch>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 15 Nov 2019 18:12:42 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdaAawmZ2N8nfDDKu3XLpXBbMtcCT0q4FntDD2gn8ASUw@mail.gmail.com>
Message-ID: <CA+FuTSdaAawmZ2N8nfDDKu3XLpXBbMtcCT0q4FntDD2gn8ASUw@mail.gmail.com>
Subject: Re: combining sockmap + ktls
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > For this workload, more interesting is sk_msg directly to icept
> > egress, anyway. This works without ktls. Support for ktls is added in
> > commit d3b18ad31f93 ("tls: add bpf support to sk_msg handling"). The
> > relevant callback function tls_sw_sendpage_locked was not immediately
> > used and subsequently removed in commit cc1dbdfed023 ("Revert
> > "net/tls: remove unused function tls_sw_sendpage_locked""). It appears
> > to work once reverting that change, plus registering the function
>
> I don't fully understand this. Are you saying a BPF_SK_MSG_VERDICT
> program attach to a ktls socket is not being called? Or packets are
> being dropped or ...? Or that the program doesn't work even with
> just KTLS and no bpf involved.

Not the verdict program. The setup is as follows:

  client --> icept.1 -- (optionally ktls) --> icept.2 --> server

I'm trying to redirect on send from the client directly into the send
side of the ktls socket, to avoid waking up the icept.1 process
completely. The ktls enabled socket has no BPF programs associated.

>
> >
> >         @@ -859,6 +861,7 @@ static int __init tls_register(void)
> >
> >                 tls_sw_proto_ops = inet_stream_ops;
> >                 tls_sw_proto_ops.splice_read = tls_sw_splice_read;
> >         +       tls_sw_proto_ops.sendpage_locked   = tls_sw_sendpage_locked,
> >
> > and additionally allowing MSG_NO_SHARED_FRAGS:
> >
> >          int tls_sw_sendpage_locked(struct sock *sk, struct page *page,
> >                                     int offset, size_t size, int flags)
> >          {
> >                if (flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL |
> >         -                     MSG_SENDPAGE_NOTLAST | MSG_SENDPAGE_NOPOLICY))
> >         +                     MSG_SENDPAGE_NOTLAST |
> > MSG_SENDPAGE_NOPOLICY | MSG_NO_SHARED_FRAGS))
> >                          return -ENOTSUPP;
> >
>
> If you had added MSG_NO_SHARED_FRAGS to the existing tls_sw_sendpage
> would that have been sufficient?

No, the stack trace I observed is

  tcp_bpf_sendmsg_redir
    tcp_bpf_push_locked
      tcp_bpf_push
        kernel_sendpage_locked
          sock->ops->sendpage_locked

which never tries tls_sw_sendpage. Perhaps the relevant part is the
following in tcp_bpf_push?

                if (has_tx_ulp) {
                        flags |= MSG_SENDPAGE_NOPOLICY;
                        ret = kernel_sendpage_locked(sk,
                                                     page, off, size, flags);
                } else {
                        ret = do_tcp_sendpages(sk, page, off, size, flags);
                }

> > and not registering parser+verdict programs on the destination socket.
> > Note that without ktls this mode also works with such programs
> > attached.
>
> Right ingress + ktls is known to be broken at the moment. Also I have
> plans to cleanup ingress side at some point. The current model is a
> bit clumsy IMO. The workqueue adds latency spikes on the 99+
> percentiles. At this point it makes the ingress side similar to the
> egress side without a workqueue and with verdict+parser done in a
> single program.

Good to know thanks. Then I won't spend too much time on this.

> >
> > Lastly, sockmap splicing from icept ingress to egress (no sk_msg) also
> > stops working when I enable ktls on the egress socket. I'm taking a
> > look at that next. But this email is long enough already ;)
>
> Yes this is a known bug I've got a set of patches to address this.

Same thing. Good to know I'm not crazy :)

> I've
> been trying to get to it for awhile now and just resolved a few other
> things on my side so plan to do this Monday/Tuesday next week.

To be clear, I don't mean to pressure at all. Was just running through
a variety of points in the option space. The sk_msg  plus redirect to
egress of a ktls-enabled socket is the variant I'm most interested in.

Do let me know if there's anything I can help out with. Thanks for
your quick answer!
