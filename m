Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1567221D8F
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 09:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgGPHpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 03:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgGPHpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 03:45:52 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97335C061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 00:45:52 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id t18so3500710otq.5
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 00:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FMoILK+X5jTaIbGVSG5H31GkdqNoSH0BcB+z3L+MzqQ=;
        b=oG2BtW3cPqqvgUdT/Lriv5qWlALNoa51/kOCxRZrz8Szrk86qyF/W7WR5InBNUXLvW
         4CYCg+6AXsaL8tRZUpqUMckGCOLWnI+ut4Jt72C63K8XQRaYOVmp5XKMqJ5a79yhOi3b
         aCnnF9vnJm7YwNSpNcFWqJWUR5sQfaP1jZRAz3tgoLKRKsbSQBKxq+DPtUwrnla6TVTK
         nDtzxSAasS1YSxBi6wnCMha9vG6h1UTYZEVoBnMqlcBJsNGMVwdQY5zmKa3nRSET/qK8
         MvBI0e7MkEidf6yPnRqpF01ai0P7QP4PASzxDYuvVdPndH3Y2OySH3okLmyM0e4G8bor
         H2iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FMoILK+X5jTaIbGVSG5H31GkdqNoSH0BcB+z3L+MzqQ=;
        b=R8ZFzCoV/3jFYLuJzzPxUYUgu7gDK6Uqjy6BMyIgROXAcHH9yTrqynU8eb/HrwlTk2
         ClWi49U9hWX6K1FjRgFSht4i7n1QLd+s3s2kqRb7ot5G7KomH/RcD3xGf0vBu2zhS0Z0
         wKqiPImDLBkCNgb4Kz/D/AtNbUmE1lH80TtVnOCztoyQlCO7VEu1jNMLGOEi/lTUByG7
         fs7KgbHTew8jEIu9gSQATAO2/E7YjSnKGzqY5Qd1QOJVdzuunTwzD8ddDjoAcreawcHg
         i4I8Atvpd8Vi7Fww76/ffHX2m3VZVgKLQoVQ/CQlnJ/VVid0kEwcUo2H0nfYte/iWQyZ
         1BuQ==
X-Gm-Message-State: AOAM531CZWQKK6G90L4O+3K9JiRSyMtezfi2k4RU7Jxuq7vu5Wc7vm2P
        7QX2Tm+LRk6ZL5f/cG/JgVIAZnV3kmGP21iVmZ0xXM9e
X-Google-Smtp-Source: ABdhPJyCW6/e9dB2/CwAUm2hVIu0MyYYpcRDrsJZSWB7uV4kCJqRERKY0Sp5SZsXr7Doz8vvhJEDu41BxJoE6YjBF6g=
X-Received: by 2002:a05:6830:1083:: with SMTP id y3mr3197967oto.59.1594885551928;
 Thu, 16 Jul 2020 00:45:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAD=hENcYJwkL-mjgJd5OZ0B4tHz2Q9kuqQ8iHid=9TWgyvR=+Q@mail.gmail.com>
 <773f-5f0ffd00-eb-de520b0@96800578>
In-Reply-To: <773f-5f0ffd00-eb-de520b0@96800578>
From:   Zhu Yanjun <zyjzyj2000@gmail.com>
Date:   Thu, 16 Jul 2020 15:45:40 +0800
Message-ID: <CAD=hENeCRuFOYwB5kSNrLGeWFBzAZooQF9F+bNhBEn95eJ7xCQ@mail.gmail.com>
Subject: Re: Bonding driver unexpected behaviour
To:     Riccardo Paolo Bestetti <pbl@bestov.io>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 3:08 PM Riccardo Paolo Bestetti <pbl@bestov.io> wrote:
>
> Hello Zhu Yanjun,
>
> On Thursday, July 16, 2020 05:41 CEST, Zhu Yanjun <zyjzyj2000@gmail.com> wrote:
>
> >
> > Please check this
> > https://developers.redhat.com/blog/2019/05/17/an-introduction-to-linux-virtual-interfaces-tunnels/#gre
> >
> > Perhaps gretap only forwards ip (with L2 header) packets.
>
> That does not seem to be the case.
> E.g.
> root@fo-exit:/home/user# tcpdump -i intra16
> tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
> listening on intra16, link-type EN10MB (Ethernet), capture size 262144 bytes
> 09:05:12.619206 IP 10.88.16.100 > 10.88.16.200: GREv0, length 46: ARP, Request who-has 10.42.42.200 tell 10.42.42.100, length 28
> 09:05:12.619278 IP 10.88.16.200 > 10.88.16.100: GREv0, length 46: ARP, Reply 10.42.42.200 is-at da:9d:34:64:cb:8d (oui Unknown), length 28
> 09:05:14.054026 IP 10.88.16.200 > 10.88.16.100: GREv0, length 46: ARP, Request who-has 10.42.42.100 tell 10.42.42.200, length 28
> 09:05:14.107143 IP 10.88.16.100 > 10.88.16.200: GREv0, length 46: ARP, Reply 10.42.42.100 is-at d6:49:e5:19:52:16 (oui Unknown), length 28

Interesting problem. You can use team to make tests.

Zhu Yanjun

> ^C
>
> >
> > Possibly "arp -s" could help to workaround this.
>
> Riccardo P. Bestetti
>
