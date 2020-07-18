Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459FA2247C2
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 03:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgGRBdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 21:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgGRBdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 21:33:01 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D46C0619D2
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 18:33:01 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id z13so12923173wrw.5
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 18:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sndDpxk0CDrQy2Y8/mWEX8kXRRbVGl5vOizMlAIUSRU=;
        b=Okkv3g7wJscJ14hpNYAYqTYawIHuCeJPGOl0O+AHLUAQbvz0idmFK5Ao7Zmhj/7kFW
         tdASzK4e6QeGzZE4iNM4prKonUVlpb6v8HltTIT2NGiMDWwJnHqPmWJds7esfGFXR2No
         gd0BBID+9JPC5jgjkYvoVYMPJGZlCyh9k96K62EAipFKmBpeEo8O7M2x7n8ubcmakZGu
         CgAJVUebn2MhxSwB8yVjiQHosyI2p+WRT0MiZT4HfuWGQYy6rzePoAm4Sxw85zl1Epy4
         ltnF7q9hGDjUew7E5BqowBAezyo6CXNjwxH9quB5+6zTyYko1wrf7qPBXxIUq80pEc+m
         WWKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sndDpxk0CDrQy2Y8/mWEX8kXRRbVGl5vOizMlAIUSRU=;
        b=Ov8Y3RXcbN0ubYtNc6OEKczjWmy5hi7y0OBMYrjjeEkBWTcyBymY/SjaArD5CuE2Em
         UEEk+kg6f6Q56iDBnykOYimSPUX+LoKuhkBLv8iM9KtXA6pqaitAwZtxKkSKo4yIvrh6
         GhufQzXoATtn9IfQjF1VOod1PhnOe0zHTPRbn/7tQAQuet7jzvKjNf1PM1sSZnkCKTcD
         UmYYj8Z8nlxMZfNgObG7U6JRgtyFmN0GPvZ/qUT0LE+RXGtsI6hLVYd+ZFhiOjudhOm1
         WQ6bns2ZwmH3yHAv5/jN3EshH+kDq7B67leTXb6/txpW8yr7ojF2AYu3EjOKYsHZM5I2
         9WLg==
X-Gm-Message-State: AOAM5319vTdItQndc55Z/SrdowfyYlD/aIytJcBomqSjZLhBoKFmV9nK
        tLnu/ovWzDjgUDjuCiCZLp9xW0ge2IDmxkGwmIU=
X-Google-Smtp-Source: ABdhPJzo2EW5UCTE3S29w3xsqgu0yXzcaJ+iAdZ9jIAt15DFRQRM+uYA60NN3qUXY/0dcYbt/4R4P3GaN6HAsJ3HQYU=
X-Received: by 2002:adf:f083:: with SMTP id n3mr12733252wro.297.1595035979665;
 Fri, 17 Jul 2020 18:32:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAPGpzNf5oRy7Vuesi2Y_aVj_B66ZUsQRKk+yQAF9g8TbASj=3Q@mail.gmail.com>
 <CA+FuTSeR-M56yJbYNeE4j4+4kQ6Mi4P2DrxQAdoFSkvoWKHxJw@mail.gmail.com>
In-Reply-To: <CA+FuTSeR-M56yJbYNeE4j4+4kQ6Mi4P2DrxQAdoFSkvoWKHxJw@mail.gmail.com>
From:   Matt Sandy <mooseboys@gmail.com>
Date:   Fri, 17 Jul 2020 18:32:48 -0700
Message-ID: <CAPGpzNeBjZ273mkCNskhFuju=MOuqRBn+C2Cyw25as+g3WhgUQ@mail.gmail.com>
Subject: Re: Unexpected PACKET_TX_TIMESTAMP Messages
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Got it, thanks! This makes a lot more sense. tl;dr: it's metadata
about the corresponding SOL_SOCKET/SO_TIMESTAMPING cmsg. It also looks
like passing OPT_ID as a socket option should auto-increment the
ee_data field on send. This was the first message sent on the socket
though so I'd expect zero anyway.

On Fri, Jul 17, 2020 at 3:51 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Fri, Jul 17, 2020 at 1:52 PM Matt Sandy <mooseboys@gmail.com> wrote:
> >
> > I've been playing around with raw sockets and timestamps, but seem to
> > be getting strange timestamp data back on the errqueue. Specifically,
> > if I am creating a socket(AF_PACKET, SOCK_RAW, htons(ETH_P_IP)) and
> > requesting SO_TIMESTAMPING_NEW with options 0x4DF. I am not modifying
> > the flags with control messages.
> >
> > On both send and receive, I get the expected
> > SOL_SOCKET/SO_TIMESTAMPING_NEW cmsg (in errqueue on send, in the
> > message itself on receive), and it contains what appears to be valid
> > timestamps in the ts[0] field. On send, however, I receive an
> > additional cmsg with level = SOL_PACKET/PACKET_TX_TIMESTAMP, whose
> > content is just the fixed value `char[16] { 42, 0, 0, 0, 4, <zeros>
> > }`.
> >
> > Any ideas why I'd be getting the SOL_PACKET message on transmit, and
> > why its payload is clearly not a valid timestamp? In case it matters,
> > this is on an Intel I210 nic using the igb driver.
>
> This is not a char[16], but a struct sock_extended_err.
>
> The first four bytes correspond to __u32 ee_errno, where 42 is ENOMSG.
> The fifth byte is __u8 ee_origin, where 4 corresponds to
> SO_EE_ORIGIN_TIMESTAMPING.
>
> This is metadata stored along with the skb by __skb_complete_tx_timestamp.
> This helps demultiplex timestamps received from the error queue from
> other messages.
>
> Additionally, in the case of timestamps it may include additional
> associated information:
>
>         serr->ee.ee_info = tstype;
>         serr->opt_stats = opt_stats;
>         serr->header.h4.iif = skb->dev ? skb->dev->ifindex : 0;
>         if (sk->sk_tsflags & SOF_TIMESTAMPING_OPT_ID) {
>                 serr->ee.ee_data = skb_shinfo(skb)->tskey;
>                 if (sk->sk_protocol == IPPROTO_TCP &&
>                     sk->sk_type == SOCK_STREAM)
>                         serr->ee.ee_data -= sk->sk_tskey;
>         }
>
> The fact that the field after ee_origin is zero means that this is a
> timestamp captured at device transmit (SCM_TSTAMP_SND), for instance.
>
> The csmg_level and type themselves are chosen on recv errqueue in
> packet_recvmsg:
>
>         if (flags & MSG_ERRQUEUE) {
>                 err = sock_recv_errqueue(sk, msg, len,
>                                          SOL_PACKET, PACKET_TX_TIMESTAMP);
>                 goto out;
>         }
