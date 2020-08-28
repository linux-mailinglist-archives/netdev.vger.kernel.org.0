Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9060F256257
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 23:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbgH1VFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 17:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgH1VFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 17:05:45 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A2A5C061264;
        Fri, 28 Aug 2020 14:05:44 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id p37so1018247pgl.3;
        Fri, 28 Aug 2020 14:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5ane8DBc+f3r1w7tC8dfBuPl+fS6X/x6Y++VRwRzwLQ=;
        b=MsL7kGa1JiTOPBkJ2PoXKt3Fr0+C/uzb9XgehxuRwK7TkBMMoeYquf8/R4btCU+W6/
         u4BhD+TJOyVEAF0sEEGAfZ0riANm/clvP3zjEp+ZvsdVir4lQPTuJxOHYgdtPkEDC0Pt
         5H/ArWQK/IhY3gXjFB5VHqvLUxcPkVhAlQXbNHPGIcMD0NiTJJlV450VIC24CLgYspuK
         Y7BrPgYCcP7Fv1FRKqVi0tAee6xJiXJD6T24fLKiVTjNetC4Dc7bwD2iZG4ePxY+aMZ+
         bGjINg5PRRtwJBDGH7ACw5kuGsRRN6RuQlrVQgvnIJmJPpPA+H/0VnfUl2/h9tx4sr9K
         k1jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5ane8DBc+f3r1w7tC8dfBuPl+fS6X/x6Y++VRwRzwLQ=;
        b=e6/xwDnL0Kj3UO/BHsh8NvTx/4YKrX/LtRAPVL5pnNC+uolM6UpO7v9NRxRlO/TfmQ
         Xsu6MfKPUavyz24La0GKPhTtGRixWcQZHZMy8WOJFCG6xyp/f+ZO/VITNOrU5qamzYe7
         494koFSKThaMGEGowzR0GLbbp/PkOfB7MO+C6nXPDFpwkTBqEk84GNrOZzVEQQWIJ3+R
         MWYnBRHIsSzQC9m43Tb5lFtuAb6poWZfkXaidcMGsyRM/tS8ozIBKSKy8M5pZkb1Y/rP
         JBZBiD2wpVys5KM5klcmsGI9C5ttD0mhDVIITRmX7i9NYOyysRZ243tqwxmtsC5a/IK+
         DIAw==
X-Gm-Message-State: AOAM532X/JVMxoxfYQBwqkX7W+AmQ2bNNN6FqV+ZtthWDQSlbS2Hd0ce
        qn/HZNPGMv4kSWeJNaKCJxxXYfsamS10GAtaE+BRyF9ALlo=
X-Google-Smtp-Source: ABdhPJzuCr+aNitJffvBCNOF3MiA7pUa312fVi1VhewBnSyhEjpIVPDYBB9N7lJJzeuTL2wOJNm5hINQn/RWXrooM10=
X-Received: by 2002:aa7:96cf:: with SMTP id h15mr692046pfq.294.1598648743207;
 Fri, 28 Aug 2020 14:05:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200828070752.54444-1-xie.he.0141@gmail.com> <m3pn7b6opa.fsf@t19.piap.pl>
In-Reply-To: <m3pn7b6opa.fsf@t19.piap.pl>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 28 Aug 2020 14:05:32 -0700
Message-ID: <CAJht_EOk2_L-77KDDEJTcfqhw48X0ZMA2PKdLG4+LXHAAtNtsw@mail.gmail.com>
Subject: Re: [PATCH net] drivers/net/wan/hdlc_cisco: Add hard_header_len
To:     =?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 28, 2020 at 3:37 AM Krzysztof Ha=C5=82asa <khalasa@piap.pl> wro=
te:
>
> OTOH hdlc_setup_dev() initializes hard_header_len to 16,
> but in this case I guess 4 bytes are better.
>
> Acked-by: Krzysztof Halasa <khc@pm.waw.pl>

Thank you, Krzysztof!

Actually I'm thinking about changing the default value of 16 in hdlc.c to 0=
.

I think a driver should always keep its hard_header_len consistent
with its header_ops functions. If a driver doesn't have header_ops,
its hard_header_len should be set to 0. This makes the driver able to
be correctly used with AF_PACKET sockets.

In net/packet/af_packet.c, in the function packet_snd, for
AF_PACKET/DGRAM sockets, it would reserve a headroom of
hard_header_len for the skb, and call dev_hard_header (which calls the
header_ops->create function) to fill in the headroom, but for
AF_PACKET/RAW sockets, it would not reserve the headroom of
hard_header_len, and will check (in function dev_validate_header)
whether the user has provided the header of length hard_header_len. So
I think hard_header_len should be kept consistent with header_ops to
make the driver able to work correctly with af_packet.c.

If the driver really needs to use additional header space outside of
the header_ops->create function, it should request that header space
in dev->needed_headroom instead of hard_header_len. This avoids the
complex header processing in af_packet.c but still gets the header
space reserved.

Currently for the 6 HDLC protocol drivers, hdlc_ppp sets
hard_header_len and the value is consistent with its header_ops,
hdlc_raw_eth sets both hard_header_len and header_ops correctly with
the ether_setup function, hdlc_x25 has been previously changed by me
to set hard_header_len to 0 because it doesn't have header_ops, and
this patch would make hdlc_cisco set its hard_header_len to the value
consistent with its header_ops. This leaves us hdlc_raw and hdlc_fr. I
see that both of these 2 drivers don't set hard_header_len when
attaching the protocol, so they will use the default value of 16. But
because both of these drivers don't have header_ops, I think their
hard_header_len should be set to 0. So I think maybe it's better to
change the default value in hdlc.c to 0 and let them take the default
value of 0.

What do you think?

Thanks!

Xie He
