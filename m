Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65DC6ED254
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 07:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbfKCGre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 01:47:34 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:34993 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfKCGre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 01:47:34 -0500
X-Originating-IP: 209.85.221.176
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
        (Authenticated sender: pshelar@ovn.org)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 762EF240005
        for <netdev@vger.kernel.org>; Sun,  3 Nov 2019 06:47:32 +0000 (UTC)
Received: by mail-vk1-f176.google.com with SMTP id t184so54235vka.1
        for <netdev@vger.kernel.org>; Sat, 02 Nov 2019 23:47:32 -0700 (PDT)
X-Gm-Message-State: APjAAAXKAPVX3DeCGC/MNuqPZIR+opx+1mfrJfkluBWE2+YmZNpPAnSl
        Ldkl1aGmmJE/S7wE08bByW6gsIydHVr3hw7gQAc=
X-Google-Smtp-Source: APXvYqz74dF2g18eWEpiPUz4844jZf+iaf4fSA69g1QIHXdtEwK1FKktNjpluErUEe802AItRZUklrxilIy55FIjp8M=
X-Received: by 2002:a1f:5ed0:: with SMTP id s199mr8339124vkb.17.1572763651061;
 Sat, 02 Nov 2019 23:47:31 -0700 (PDT)
MIME-Version: 1.0
References: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com> <1572618234-6904-5-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1572618234-6904-5-git-send-email-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Sat, 2 Nov 2019 23:47:20 -0700
X-Gmail-Original-Message-ID: <CAOrHB_APMOVTooR0JEXDLZSFM31rFyY+pOzq6oq-2x1rSshjFA@mail.gmail.com>
Message-ID: <CAOrHB_APMOVTooR0JEXDLZSFM31rFyY+pOzq6oq-2x1rSshjFA@mail.gmail.com>
Subject: Re: [PATCH net-next v6 04/10] net: openvswitch: optimize flow mask
 cache hash collision
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
> Port the codes to linux upstream and with little changes.
>
> Pravin B Shelar, says:
> | In case hash collision on mask cache, OVS does extra flow
> | lookup. Following patch avoid it.
>
> Link: https://github.com/openvswitch/ovs/commit/0e6efbe2712da03522532dc5e84806a96f6a0dd1
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> Tested-by: Greg Rose <gvrose8192@gmail.com>
> ---
Signed-off-by: Pravin B Shelar <pshelar@ovn.org>
