Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 184D044EBB
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 23:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727532AbfFMVvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 17:51:16 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:36529 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfFMVvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 17:51:16 -0400
Received: by mail-ed1-f66.google.com with SMTP id k21so378021edq.3
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 14:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cbaS54IAV0LlCIms+BL5eZfVqdh6sasMzJFS+b9NyK0=;
        b=OVu/ehurx8UJ2wiHfFHP1G8OIDXsk0b1+r1CTn7Yo5BKbLWZS5uKYgOzrZ0MMcRid6
         JrKrfK6cZSsuZiXsHAtHe45exFLmjGXGUiQwJUvG1eE4dcnI92xiUa6gq1eUA04gLlL+
         hYu1+law5QWP8+5vejw4EmJApjZ+JiMvDJiyMW3zcdZEP9AZM2QXK7V5rGVyltTw7rQ+
         qB6UwecOfaVzG/hJg46MsglpkIIOibrjuAvSo0er2sV1xzoFqtzzdiLQA/zxrRnqMFbq
         k8x6KRzVu3P65+c1EuxFddQtr20qPZMIHgF3j4fZ67O2BriArv0Nbtt3nMn5KsfKI+DX
         /wzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cbaS54IAV0LlCIms+BL5eZfVqdh6sasMzJFS+b9NyK0=;
        b=n8EawAl1LpUa+GfDxMwjB/TWv1IenznKoWHIYM7s2+74lhzCCKl8/8U7vTSHy6pSn3
         dAU5ahlJ0ogzhKFhLbeR2a9A7c2zmr42WYv/IqAWLKGQhKB5BoPdMu+UaPlwOeM8cTmj
         UQilfsQchO79STQR59XvzMSvInvx0KYrowQ+gg3mCF5sU7QnogCsJyHqECsyXnxIsgyG
         HAaMVnHW/7fPyXGX1qgeNHhqLndB3wJsEeVjpVeqboPinlnIJaf9Ioum1DtrunJUI/9Z
         EPdQ9wt5dFjcYW0C6hNPLIJA8Pj2M4+ZTgE+Bxyv/6hP9n578APHAGd/zuHgrQsyV6Ng
         jXtg==
X-Gm-Message-State: APjAAAUkVUWIqFZ6B1+JuoNGpqMi/rjHskAD3evMsMNnPeJMpgeCr4sf
        WSVTeO5PaTHINIitTX4XwFN8VAhXbJXqyNZGvIeIiw==
X-Google-Smtp-Source: APXvYqyS53IKndEOeMS+KMgkKSHHQZ/P4oqV56ft8I1ioR8tUgxqFmwNpISSSnQa8yc43vMEvw8YRkdBaoFoP1SN65o=
X-Received: by 2002:a50:b224:: with SMTP id o33mr12759249edd.70.1560462674501;
 Thu, 13 Jun 2019 14:51:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190526153357.82293-1-fklassen@appneta.com> <20190526153357.82293-2-fklassen@appneta.com>
 <CAF=yD-KyJC0ErdyNRtiw5VPhQY+i__sDG5oh0LzWJ4RMYe1zCQ@mail.gmail.com> <D40775C9-AED4-4634-B3AF-78B2771516C7@appneta.com>
In-Reply-To: <D40775C9-AED4-4634-B3AF-78B2771516C7@appneta.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 13 Jun 2019 17:50:38 -0400
Message-ID: <CAF=yD-KN_yxKUkuGe55_OR0ywyxsHNq4Bg0koe6B+Kq5QQLgzQ@mail.gmail.com>
Subject: Re: [PATCH net v2 1/1] net/udp_gso: Allow TX timestamp with UDP GSO
To:     Fred Klassen <fklassen@appneta.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 4:58 PM Fred Klassen <fklassen@appneta.com> wrote:
>
> >> It also appears that other TX CMSG types cause similar issues, for
> >> example trying to set SOL_IP/IP_TOS.
> >
> > If correct we need to find the root cause. Without that, this is not
> > very informative. And likely the fix is not related, as that does not
> > involve tx_flags or tskey.
> >
> > What exact behavior do you observe: tx timestamp notifications go
> > missing when enabling IP_TOS?
>
> The IP_TOS observation was a false positive, so removing this comment for=
 v3.
>
> >>
> >> This patch preserves tx_flags for the first UDP GSO segment. This
> >> mirrors the stack's behaviour for IPv4 fragments.
> >
> > But deviates from the established behavior of other transport protocol =
TCP.
>
> Ack. Removing comment for v3. The noted IPv4 fragment behavior is from at=
 patch
> that is not been accepted yet.
>
> > I think it's a bit premature to resubmit as is while still discussing
> > the original patch.
> >
>
> Understood. Will wait for acceptance before submitting v3.
>
> >> --- a/net/ipv4/udp_offload.c
> >> +++ b/net/ipv4/udp_offload.c
> >> @@ -228,6 +228,10 @@ struct sk_buff *__udp_gso_segment(struct sk_buff =
*gso_skb,
> >>        seg =3D segs;
> >>        uh =3D udp_hdr(seg);
> >>
> >> +       /* preserve TX timestamp and zero-copy info for first segment =
*/
> >
> > As pointed out in v1, zerocopy flags are handled by protocol
> > independent skb_segment. It calls skb_zerocopy_clone.
> >
>
> Correcting in v3 to read =E2=80=A6
> "preserve TX timestamp flags and TS key for first segment=E2=80=9D.

Sounds good.

When resubmitting otherwise the same patch, please comment clearly why
this is the preferred solution (because in some ways it is not):

- Timestamping both first and last segmented is not feasible. Hardware
can only have one outstanding TS request at a time.

- Timestamping last segment may under report network latency of the
previous segments. Even though the doorbell is suppressed, the ring
producer counter has been incremented.

I have probably missed a few.

Timestamping the first segment has the downside that it may
underreport tx host network latency. It appears that we have to pick
one or the other. And possibly follow-up with a config flag to choose
behavior..
