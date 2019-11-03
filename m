Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01CD4ED251
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 07:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfKCGrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 01:47:17 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:41595 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfKCGrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 01:47:16 -0500
X-Originating-IP: 209.85.217.46
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
        (Authenticated sender: pshelar@ovn.org)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 9F5321BF203
        for <netdev@vger.kernel.org>; Sun,  3 Nov 2019 06:47:14 +0000 (UTC)
Received: by mail-vs1-f46.google.com with SMTP id b16so2848491vso.10
        for <netdev@vger.kernel.org>; Sat, 02 Nov 2019 23:47:14 -0700 (PDT)
X-Gm-Message-State: APjAAAUajM0rgxwioJdvH7Sqii9HS0BaelgMtCO24Y7oPQ30n/rzNg/C
        r9ooIDCndlcsW0whAMNwLD81keOoSNo9AteVpLM=
X-Google-Smtp-Source: APXvYqwTEniSy0kKE6RcARSy9LRqldD9uXH5PWcNd1KdRAuGwEDfLszHHmC5d/i8O+SL4/Zcr9R2y7QCjnu8k2lXIJQ=
X-Received: by 2002:a05:6102:2436:: with SMTP id l22mr9491830vsi.93.1572763632867;
 Sat, 02 Nov 2019 23:47:12 -0700 (PDT)
MIME-Version: 1.0
References: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com> <1572618234-6904-2-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1572618234-6904-2-git-send-email-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Sat, 2 Nov 2019 23:47:01 -0700
X-Gmail-Original-Message-ID: <CAOrHB_CSmYfGA9Gp7ttLFc5B3EGuegYFr9b_5pO_W=Aog5+DiQ@mail.gmail.com>
Message-ID: <CAOrHB_CSmYfGA9Gp7ttLFc5B3EGuegYFr9b_5pO_W=Aog5+DiQ@mail.gmail.com>
Subject: Re: [PATCH net-next v6 01/10] net: openvswitch: add flow-mask cache
 for performance
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
> The idea of this optimization comes from a patch which
> is committed in 2014, openvswitch community. The author
> is Pravin B Shelar. In order to get high performance, I
> implement it again. Later patches will use it.
>
> Pravin B Shelar, says:
> | On every packet OVS needs to lookup flow-table with every
> | mask until it finds a match. The packet flow-key is first
> | masked with mask in the list and then the masked key is
> | looked up in flow-table. Therefore number of masks can
> | affect packet processing performance.
>
> Link: https://github.com/openvswitch/ovs/commit/5604935e4e1cbc16611d2d97f50b717aa31e8ec5
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> Tested-by: Greg Rose <gvrose8192@gmail.com>
> Acked-by: William Tu <u9012063@gmail.com>
> ---
Signed-off-by: Pravin B Shelar <pshelar@ovn.org>
