Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1B8CED257
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 07:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbfKCGrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 01:47:52 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:57921 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfKCGrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 01:47:52 -0500
X-Originating-IP: 209.85.221.171
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
        (Authenticated sender: pshelar@ovn.org)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id A987B1C0004
        for <netdev@vger.kernel.org>; Sun,  3 Nov 2019 06:47:50 +0000 (UTC)
Received: by mail-vk1-f171.google.com with SMTP id o198so3090184vko.11
        for <netdev@vger.kernel.org>; Sat, 02 Nov 2019 23:47:50 -0700 (PDT)
X-Gm-Message-State: APjAAAUfQsmV9zU1hNWAL+qZ4i0h2Slcz7hBmy7nls+z2R4zegxch3zh
        QdR+2fwTJnXTvqjQ410XfURoibwA35cdrt+qPW8=
X-Google-Smtp-Source: APXvYqwMoOCXFnjYZYjiKFkEnwS4gdZp3oiO64rF5eNL1QfmVkSCzzBNs/j8dkQcZt9ksUanePhGG4WRYV/TONrlslU=
X-Received: by 2002:a1f:2155:: with SMTP id h82mr9223492vkh.18.1572763669534;
 Sat, 02 Nov 2019 23:47:49 -0700 (PDT)
MIME-Version: 1.0
References: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com> <1572618234-6904-8-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1572618234-6904-8-git-send-email-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Sat, 2 Nov 2019 23:47:38 -0700
X-Gmail-Original-Message-ID: <CAOrHB_CC2a+-7QO=TQGjyLQ31qemmdTWq6d6SYVg9RiKhexMfQ@mail.gmail.com>
Message-ID: <CAOrHB_CC2a+-7QO=TQGjyLQ31qemmdTWq6d6SYVg9RiKhexMfQ@mail.gmail.com>
Subject: Re: [PATCH net-next v6 07/10] net: openvswitch: add likely in flow_lookup
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Greg Rose <gvrose8192@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 1, 2019 at 7:24 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> The most case *index < ma->max, and flow-mask is not NULL.
> We add un/likely for performance.
>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> Tested-by: Greg Rose <gvrose8192@gmail.com>
> Acked-by: William Tu <u9012063@gmail.com>
> ---
Acked-by: Pravin B Shelar <pshelar@ovn.org>
