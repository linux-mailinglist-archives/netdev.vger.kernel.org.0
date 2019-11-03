Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 349FEED259
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 07:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfKCGsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 01:48:02 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:55355 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfKCGsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 01:48:02 -0500
X-Originating-IP: 209.85.217.54
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
        (Authenticated sender: pshelar@ovn.org)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id C9FACE0004
        for <netdev@vger.kernel.org>; Sun,  3 Nov 2019 06:48:00 +0000 (UTC)
Received: by mail-vs1-f54.google.com with SMTP id k1so9048330vsm.0
        for <netdev@vger.kernel.org>; Sat, 02 Nov 2019 23:48:00 -0700 (PDT)
X-Gm-Message-State: APjAAAUJl1ddbr+DEUr4QSf5zZp3gNKMFV3h3KVIi/ACs8KawhR2BBAc
        PZHp9pt8sUkY46SakQ7TpJ88fMsRMYQXQTn0G/k=
X-Google-Smtp-Source: APXvYqxCf6CJ+Hywsp7KjmlFO6VZUY/kCoDNp29RlUCo55VbWFwsrtVqLhiJTITmJMuBe6KXJTERusdtBCsQF8IosD0=
X-Received: by 2002:a67:2804:: with SMTP id o4mr9989084vso.47.1572763679749;
 Sat, 02 Nov 2019 23:47:59 -0700 (PDT)
MIME-Version: 1.0
References: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com> <1572618234-6904-10-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1572618234-6904-10-git-send-email-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Sat, 2 Nov 2019 23:47:48 -0700
X-Gmail-Original-Message-ID: <CAOrHB_DrR9RqER_t_xCehFUQZZmyit02Qf2NorN3c7Pb8m5fMQ@mail.gmail.com>
Message-ID: <CAOrHB_DrR9RqER_t_xCehFUQZZmyit02Qf2NorN3c7Pb8m5fMQ@mail.gmail.com>
Subject: Re: [PATCH net-next v6 09/10] net: openvswitch: don't unlock mutex
 when changing the user_features fails
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Greg Rose <gvrose8192@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>, Paul Blakey <paulb@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 1, 2019 at 7:24 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> Unlocking of a not locked mutex is not allowed.
> Other kernel thread may be in critical section while
> we unlock it because of setting user_feature fail.
>
> Fixes: 95a7233c4 ("net: openvswitch: Set OvS recirc_id from tc chain index")
> Cc: Paul Blakey <paulb@mellanox.com>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> Tested-by: Greg Rose <gvrose8192@gmail.com>
> Acked-by: William Tu <u9012063@gmail.com>
> ---
Acked-by: Pravin B Shelar <pshelar@ovn.org>
