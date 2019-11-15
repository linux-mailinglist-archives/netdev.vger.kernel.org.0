Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5820FD6C0
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 08:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfKOHJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 02:09:27 -0500
Received: from mslow2.mail.gandi.net ([217.70.178.242]:39686 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbfKOHJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 02:09:27 -0500
X-Greylist: delayed 1563 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Nov 2019 02:09:26 EST
Received: from relay12.mail.gandi.net (unknown [217.70.178.232])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id 533663B621A
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 06:36:01 +0000 (UTC)
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
        (Authenticated sender: pshelar@ovn.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id CD54E200007
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 06:36:00 +0000 (UTC)
Received: by mail-vs1-f50.google.com with SMTP id x21so5656487vsp.6
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 22:36:00 -0800 (PST)
X-Gm-Message-State: APjAAAXs+phjmMRNtAwXWY/AhikWw7vvqkRz0/FdwskFh5iF+bNDHNiB
        QSqPvcOrR9pdpjGeMcFm9vGO1Ox9aF4uXKXv6cI=
X-Google-Smtp-Source: APXvYqxR6doQX12+rkroxBMUFSFGC+P74BCkHojpyGcyF2bZf5OCQF1d8vBBtRClzjCF0MR1H2rxhlZLUe1cep4Fo0A=
X-Received: by 2002:a67:6e05:: with SMTP id j5mr8703881vsc.66.1573799759479;
 Thu, 14 Nov 2019 22:35:59 -0800 (PST)
MIME-Version: 1.0
References: <1573746668-6920-1-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1573746668-6920-1-git-send-email-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Thu, 14 Nov 2019 22:35:50 -0800
X-Gmail-Original-Message-ID: <CAOrHB_ABoBYR5yMCOBUGkb=JvzO2oBKZNoX1mpVBUfQWrC1pgQ@mail.gmail.com>
Message-ID: <CAOrHB_ABoBYR5yMCOBUGkb=JvzO2oBKZNoX1mpVBUfQWrC1pgQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: openvswitch: don't call pad_packet if not necessary
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Greg Rose <gvrose8192@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>, Joe Stringer <joe@ovn.org>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 7:51 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> The nla_put_u16/nla_put_u32 makes sure that
> *attrlen is align. The call tree is that:
>
> nla_put_u16/nla_put_u32
>   -> nla_put            attrlen = sizeof(u16) or sizeof(u32)
>   -> __nla_put          attrlen
>   -> __nla_reserve      attrlen
>   -> skb_put(skb, nla_total_size(attrlen))
>
> nla_total_size returns the total length of attribute
> including padding.
>
> Cc: Joe Stringer <joe@ovn.org>
> Cc: William Tu <u9012063@gmail.com>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---

Acked-by: Pravin B Shelar <pshelar@ovn.org>
