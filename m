Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7120BED252
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 07:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbfKCGrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 01:47:22 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:46895 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfKCGrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 01:47:21 -0500
X-Originating-IP: 209.85.217.45
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
        (Authenticated sender: pshelar@ovn.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 4D262C0004
        for <netdev@vger.kernel.org>; Sun,  3 Nov 2019 06:47:20 +0000 (UTC)
Received: by mail-vs1-f45.google.com with SMTP id a143so8998913vsd.9
        for <netdev@vger.kernel.org>; Sat, 02 Nov 2019 23:47:20 -0700 (PDT)
X-Gm-Message-State: APjAAAX3SvvfdtvHd/0AmbEERgb7GCu0SPxbo4PT+eIS4402zl61TjV2
        J/9hmK89ZiBH9RVDYDhkfnvImYdM86/Y3fb9+yM=
X-Google-Smtp-Source: APXvYqz86JXZZ1BMOTVGZX/ucGlOuZS0ujhGTaU+a0Rx1Jd9bkw4CxM5NaNoNCyss1n4ard9114rbiKCRae7E1rtnDI=
X-Received: by 2002:a67:ec8f:: with SMTP id h15mr9739550vsp.66.1572763639213;
 Sat, 02 Nov 2019 23:47:19 -0700 (PDT)
MIME-Version: 1.0
References: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com> <1572618234-6904-3-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1572618234-6904-3-git-send-email-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Sat, 2 Nov 2019 23:47:08 -0700
X-Gmail-Original-Message-ID: <CAOrHB_BxG4bef-G6vSBNAuheyT+=Y=pw_WQ=+dKz65SvpU_-Zg@mail.gmail.com>
Message-ID: <CAOrHB_BxG4bef-G6vSBNAuheyT+=Y=pw_WQ=+dKz65SvpU_-Zg@mail.gmail.com>
Subject: Re: [PATCH net-next v6 02/10] net: openvswitch: convert mask list in
 mask array
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
> | mask caches index of mask in mask_list. On packet recv OVS
> | need to traverse mask-list to get cached mask. Therefore array
> | is better for retrieving cached mask. This also allows better
> | cache replacement algorithm by directly checking mask's existence.
>
> Link: https://github.com/openvswitch/ovs/commit/d49fc3ff53c65e4eca9cabd52ac63396746a7ef5
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> Tested-by: Greg Rose <gvrose8192@gmail.com>
> Acked-by: William Tu <u9012063@gmail.com>
> ---
Signed-off-by: Pravin B Shelar <pshelar@ovn.org>
