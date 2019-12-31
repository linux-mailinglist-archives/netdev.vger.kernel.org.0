Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 438A312DBD3
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 21:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfLaUk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 15:40:28 -0500
Received: from mail-yb1-f174.google.com ([209.85.219.174]:37724 "EHLO
        mail-yb1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbfLaUk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Dec 2019 15:40:28 -0500
Received: by mail-yb1-f174.google.com with SMTP id x14so15704719ybr.4
        for <netdev@vger.kernel.org>; Tue, 31 Dec 2019 12:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vPVykdiJdzzySCWm4kRUzAkmOvS4XDvXHxKP1UePK0w=;
        b=G94yZvG/OdttI9xyOyQuJ/6VKKerfxOE7BceaTRmW05PcQDyjUI0oGpDtl2A5SPlpd
         YHNS5WWnqCxkO0lmEOgc1YITEYUuG4Qi4kstRu24aWzBiBQTzhLuO/VRK6Ik/UNJCLmt
         uLaWyE+3k60N+0xSOAjrM03yrx85gxQss5worijaImY5+U2kpLTqknkaoj17jzBLjMLy
         PqDlfb6nyhZbqdrie6ucVPNxb9+NIzYcB/Sl3RdpccnmW1S2IIsZSNAS1NzrbMaX+dyN
         fUbrNouNISKSWDV1Ua/grWFhdVxUgjXIzUAN+mVeS/s9OqQCh3wTKoO9P9L5Xzg+APLt
         wBzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vPVykdiJdzzySCWm4kRUzAkmOvS4XDvXHxKP1UePK0w=;
        b=Agn54KjSZil4nPftsrbQDMqrBszrxsk0GQm12osQVXQ2Wxvh1mysQDBPyl1SZYjiAN
         lzRWfgw11d4FtIP/9rTrWZ/hH1ETYsxd+gmwP+292Yzo7Bo0z7yKzJTgH1GdMvVBF06J
         Yk2kmB+UUxWT3ORJUnBRdZZpXaBy0cIfHPQ6t77JSuV8PnPwTkXJu0yv4JEJNk+6yREc
         kbpbrOrYUl8qa8gYA1ScRqRULlv0cQBkjri8L4D+2ms349QpX+7+bd5bJ+GWXmUQrAsj
         O9GvmS8es3WGKJ6ZwiLWfcPNDEz6xJesiydb4kqU4K73hxwWCHGmzGJFAMtOF0asvnZb
         5byA==
X-Gm-Message-State: APjAAAUZ6G5/qksr0RUFEyCAMufyLlYM3vy5gIeKodEbPJpFWlmq4nJa
        paWuH2CnPW/Mj7471QMr+YLKWKfWP1nJ8xibCxk=
X-Google-Smtp-Source: APXvYqxlwR1Zay3m/H6sj7gghlqRA1NUK2hhJ69SrTwbFG/IWXfZPNgFIcX1pb18nrsQBXh/MTShgTcuzhG4u7zm0no=
X-Received: by 2002:a25:cf49:: with SMTP id f70mr56390237ybg.11.1577824827407;
 Tue, 31 Dec 2019 12:40:27 -0800 (PST)
MIME-Version: 1.0
References: <CAMDZJNVLEEzAwCHZG_8D+CdWQRDRiTeL1N2zj1wQ0jh3vS67rA@mail.gmail.com>
In-Reply-To: <CAMDZJNVLEEzAwCHZG_8D+CdWQRDRiTeL1N2zj1wQ0jh3vS67rA@mail.gmail.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Tue, 31 Dec 2019 22:40:16 +0200
Message-ID: <CAJ3xEMiqf9-EP0CCAEhhnU3PnvdWpqSR8VbJa=2JFPiHAQwVcw@mail.gmail.com>
Subject: Re: mlx5e question about PF fwd packets to PF
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Saeed Mahameed <saeedm@dev.mellanox.co.il>,
        Roi Dayan <roid@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 31, 2019 at 10:39 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:

> In one case, we want forward the packets from one PF to otter PF in eswitchdev mode.

Did you want to say from one uplink to the other uplink? -- this is
not supported.

What we do support is the following (I think you do it by now):

PF0.uplink --> esw --> PF0.VFx --> hairpin --> PF1.VFy --> esw --> PF1.uplink

Hairpin is an offload for SW gateway, SW gateway is an **application** that runs
over two NIC ports -- we allow them to be virtual NIC ports  -- PF0.VFx/PF1.VFy

since e-switch != (SW) gateway --> eswitch offload != (SW) gateway offload

note that steering rules ## (wise)

PF0.uplink --> T1 --> PF0.VFx --> T2 --> PF1.VFy --> T3 --> PF1.uplink

since you use instantiate eswitch on the system, T(ype)1 and T(ype)3 rules
are ones that differentiate packets that belong to this GW. But, T(ype)2 rules,
can be just "fwd everything" -- TC wise, you can even mask out the ethertype,
just a tc/flower rules that fwd everything from ingress PF0.VFx vNIC
to egress  PF1.VFy vNIC.

Further, you can also you this match-all (but with flower..) rule for
the PF1.VFy --> PF1.uplink
part of the chain since you know that everything that originates in
this VF should go to the uplink.

Hence the claim here is that if PF0.uplink --> hairpin --> PF1.uplink
would have been
supported and the system had N steering rules, with what is currently
supported you
need N+2 rules -- N rules + one T2 rule and one T3 rule
