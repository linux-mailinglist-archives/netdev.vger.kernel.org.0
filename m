Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76FC7100A44
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 18:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfKRRav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 12:30:51 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:33439 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbfKRRav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 12:30:51 -0500
Received: by mail-yb1-f196.google.com with SMTP id i15so7521145ybq.0
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 09:30:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VHVvLV5KD/aqHK/KND/CA8mxpHO78BscA84GOop0DLI=;
        b=I7U3CERg1KS70r1brqmXYt2zD0lhcA1UrqbEZsXDw4o/CriDJ/5g8MClwrTMuR6aam
         c4LeJo0xBi/O8qqQLoi2bO8SX2NxfZpaJYHEbpNdw20ohP518xHej60/4WBt6ad5BLGu
         zVaGs3s6x+Cxu+/lV2lOpKvc1brwTdHqYiTuFslTO2HOE3DxjQBWABv7lfJbtj7hzkUA
         9s0WmEskUmLi3T3llhjUJeCUbfy44K0K1K0o4vEudMfcfzD7j6vn8wZZbBRIVWMHnrka
         Qh+V5uO3oQu1uvDuReYYKg/F+LjGjCgtB7QIx72/B4uN0Jfv9e+qEDNHhcwKphNm0FHS
         h0Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VHVvLV5KD/aqHK/KND/CA8mxpHO78BscA84GOop0DLI=;
        b=AmPNuvoHrEcbCeI0KZTFj89AYJ59fP0TA9UNCRzktV89/GkqH89ssoE6tVtObZTnmw
         8ltiwTlU5PpBwdzW3hgvdeCf/ouwOWrKrJaMSTq0+7gZmylv4XQjlcynEzto6tWk48oX
         aweWDscH8fYUFesXegLy6R7Zhn43ho/Bag28TZ+/hep8ZVuL9bopYL8fc8WNfQsR1yhT
         kOi98hx03Y2A35xJUjnOW8Di+kF+grwdPPqaohBdb1khwLVh0nq3od+6oLiK60rrs+vq
         IZnE0Q+uwpCJrQdCTsQWYpiwUaja8B2m2t9RPZ6JM0nr1MzybZzhyM/O5B2rahq0K139
         cbpg==
X-Gm-Message-State: APjAAAWHQs1bifrv9k498l1jZn+zttTGpbrcywkVqVV2DEqaPXBtDr5q
        zx3bgKLWZhpkAGKnETE2v+K2pOg+
X-Google-Smtp-Source: APXvYqxcssXFQxQLkI2ugKEJ7JxpZ0SRxYI13h67Vf2kx9tMBs7SekmebYqKXcO5uwKnSNAVfJU2zA==
X-Received: by 2002:a25:df85:: with SMTP id w127mr23900482ybg.375.1574098249491;
        Mon, 18 Nov 2019 09:30:49 -0800 (PST)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id j67sm7941521ywf.71.2019.11.18.09.30.48
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2019 09:30:48 -0800 (PST)
Received: by mail-yb1-f181.google.com with SMTP id q18so7501011ybq.6
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 09:30:48 -0800 (PST)
X-Received: by 2002:a5b:a86:: with SMTP id h6mr23993315ybq.139.1574098247618;
 Mon, 18 Nov 2019 09:30:47 -0800 (PST)
MIME-Version: 1.0
References: <cover.1573872263.git.martin.varghese@nokia.com> <24ec93937d65fa2afc636a2887c78ae48736a649.1573872264.git.martin.varghese@nokia.com>
In-Reply-To: <24ec93937d65fa2afc636a2887c78ae48736a649.1573872264.git.martin.varghese@nokia.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 18 Nov 2019 12:30:11 -0500
X-Gmail-Original-Message-ID: <CA+FuTSeHsZnHMUiZmHugCT=83g6EA8OJVWd9VdV-LqbA94xVqQ@mail.gmail.com>
Message-ID: <CA+FuTSeHsZnHMUiZmHugCT=83g6EA8OJVWd9VdV-LqbA94xVqQ@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 2/2] Special handling for IP & MPLS.
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, corbet@lwn.net,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 16, 2019 at 12:45 AM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> From: Martin Varghese <martin.varghese@nokia.com>
>
> Special handling is needed in bareudp module for IP & MPLS as they support
> more than one ethertypes.
>
> MPLS has 2 ethertypes. 0x8847 for MPLS unicast and 0x8848 for MPLS multicast.
> While decapsulating MPLS packet from UDP packet the tunnel destination IP
> address is checked to determine the ethertype. The ethertype of the packet
> will be set to 0x8848 if the  tunnel destination IP address is a multicast
> IP address. The ethertype of the packet will be set to 0x8847 if the
> tunnel destination IP address is a unicast IP address.
>
> IP has 2 ethertypes.0x0800 for IPV4 and 0x86dd for IPv6. The version field
> of the IP header tunnelled will be checked to determine the ethertype.

If using ipv6 dual stack, it might make more sense to use extended
mode with the ipv6 device instead of the ipv4 device.

Also, the term extended mode is not self describing. Dual stack as
term would be, but is not relevant to MPLS. Maybe "dual_proto"?

> diff --git a/Documentation/networking/bareudp.rst b/Documentation/networking/bareudp.rst
> index 2828521..1f01dfd 100644
> --- a/Documentation/networking/bareudp.rst
> +++ b/Documentation/networking/bareudp.rst
> @@ -12,6 +12,15 @@ The Bareudp tunnel module provides a generic L3 encapsulation tunnelling
>  support for tunnelling different L3 protocols like MPLS, IP, NSH etc. inside
>  a UDP tunnel.
>
> +Special Handling
> +----------------
> +The bareudp device supports special handling for MPLS & IP as they can have
> +multiple ethertypes.
> +MPLS procotcol can have ethertypes ETH_P_MPLS_UC  (unicast) & ETH_P_MPLS_MC (multicast).
> +IP proctocol can have ethertypes ETH_P_IP (v4) & ETH_P_IPV6 (v6).

proctocol -> protocol
