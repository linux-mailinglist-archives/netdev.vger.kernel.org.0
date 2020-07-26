Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF1622E1EF
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 20:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgGZSSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 14:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgGZSSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 14:18:05 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5D3C0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 11:18:05 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id l23so13372108qkk.0
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 11:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uNfkCa3abx8Y+Foq/q1fkMndz87/txVSbN63T/tJ+Fw=;
        b=VGE2Z9RfvRWVzXu9UaLb8tBrgv5HwwUR/wx46PUc6h6Z/J0qPdt7WC5TpRKs8WEtRi
         XkBHfSrMqKUVOM8Av+8BvXboiOQT6ZCELviuTruQw/8dtamcgLBgV7emLVm7/hEkP85H
         jv4cVQYdArGFElYKGNo7+6+ylxlpjIYndrHjAXtZ7A+wSEoUnaTPQkiIiSpR/I56Cz5e
         fLmXumN4yFbM0hniZ5bYD+1fD8hKGc+tZ4bLc/kwQnEbjAT104E8ZCCXybuX2CqA7VSr
         5I9gbDfndkU/LTrTM06q1Rx0BZyItdTq4gQ3zbFILykLX+L1aGipbzKXn0xB9iUmAUSn
         xkGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uNfkCa3abx8Y+Foq/q1fkMndz87/txVSbN63T/tJ+Fw=;
        b=M06fyGtLS6em8hmhdlA+phZEgRgMC2bbPQjUgKGgMBISSw2s0vOzk9/pjBv9CWaj/j
         XdIi3b8/MMZuGrFD8vkghuAaHlZ7aYV19sJMPgIqJTzueF5Gy9Wq89KUyVYirwnl6kHP
         QXhDx3ZwnUZtzTqI0A/jZj9lLBUSTB4qROlTWwGeXC2uv7mZqMOtT5N7VZpLWX3YkgVf
         drWMStFz9t58a/0ugB9ir03YYTMN1l2J9C7rTyXs6uGLr7ebA+Xweg99WuWTiyfKHAIM
         bkZptac2dTmq2an55RmozmrSE0exH7hFckzIQpfjM+rD3SIqLHtNvKkWVwNCQlfy+inq
         jL0w==
X-Gm-Message-State: AOAM5339qMbUfkpffW1XsfQpbIOsQPe9dl/kKgFmOU+VJ6h0euldMc3C
        ydy9x9070Xpf1RqrRjRvKQ4+xmrNbyZvGLnNEPc=
X-Google-Smtp-Source: ABdhPJwsHCaTFPQvDKyYA/ORNbNdI7DDoZ0WnGdtnip3KUfWRGGWqpPPo81Xw9SI+8p2B8JbzTGCx8LUmex6C8tfEl8=
X-Received: by 2002:a37:910:: with SMTP id 16mr17410968qkj.466.1595787484579;
 Sun, 26 Jul 2020 11:18:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAEjGaqfhr=1RMavYUAyG0qMyQe44CQbuet04LWSC8YRM8FMpKA@mail.gmail.com>
 <CA+FuTSfpadw+ea-=pL0pMXxujzjoLW+d9yH2+GQo0jOJv=Zo4Q@mail.gmail.com>
In-Reply-To: <CA+FuTSfpadw+ea-=pL0pMXxujzjoLW+d9yH2+GQo0jOJv=Zo4Q@mail.gmail.com>
From:   Han <keepsimple@gmail.com>
Date:   Sun, 26 Jul 2020 11:17:53 -0700
Message-ID: <CAEjGaqdo_6watKcGi1WUmrHiB9F=1+i+8LcxBXOMZvLneiEh7A@mail.gmail.com>
Subject: Re: question about using UDP GSO in Linux kernel 4.19
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 26, 2020 at 6:42 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Sat, Jul 25, 2020 at 7:08 PM Han <keepsimple@gmail.com> wrote:
> >
> > My apologies if this is not the right place to ask this question.
> >
> > I'm trying to use UDP GSO to improve the throughput. My testing shows
> > that UDP GSO works with the local server (i.e. loopback interface) but
> > fails with a remote server (in WLAN, via wlan0 interface).
> >
> > My question is: do I need to explicitly enable UDP GSO for wlan0
> > interface? If yes, how do I do it? I searched online but could not
> > find a good answer.  I looked at "ethtool" but not clear which option
> > to use:
> >
> > $ ethtool  --show-offload wlan0 | grep -i generic-segment
> > generic-segmentation-offload: off [requested on]
>
> Which wireless driver does your device use. Does it have tx checksum offload?

It seems to be "brcmfmac" :

$ readlink /sys/class/net/wlan0/device/driver
../../../../../../../../bus/sdio/drivers/brcmfmac

I think tx checksum offload is off, and I couldn't turn it on. Does
"[fixed]" mean it cannot be changed?

$ ethtool  --show-offload wlan0 | grep -i sum
rx-checksumming: off [fixed]
tx-checksumming: off
        tx-checksum-ipv4: off [fixed]
        tx-checksum-ip-generic: off [fixed]
        tx-checksum-ipv6: off [fixed]
        tx-checksum-fcoe-crc: off [fixed]
        tx-checksum-sctp: off [fixed]
tx-gre-csum-segmentation: off [fixed]
tx-udp_tnl-csum-segmentation: off [fixed]
esp-tx-csum-hw-offload: off [fixed]

Tried this but didn't work:

$ sudo ethtool --offload wlan0 tx on
Cannot change tx-checksumming
Could not change any device features

$ sudo ethtool -K wlan0 tx-checksum-ipv4 on
Could not change any device features

> That is a hard requirement. In udp_send_skb:
>
>                 if (skb->ip_summed != CHECKSUM_PARTIAL || is_udplite ||
>                     dst_xfrm(skb_dst(skb))) {
>                         kfree_skb(skb);
>                         return -EIO;
>                 }
>
> > $ ethtool  --show-offload wlan0 | grep -i udp-segment
> > tx-udp-segmentation: off [fixed]
>
> This is hardware segmentation offload. It is not required.
