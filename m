Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6CD7F25AE
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 04:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732937AbfKGDBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 22:01:37 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:60847 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727665AbfKGDBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 22:01:37 -0500
X-Originating-IP: 209.85.217.41
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
        (Authenticated sender: pshelar@ovn.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 751C1C0004
        for <netdev@vger.kernel.org>; Thu,  7 Nov 2019 03:01:35 +0000 (UTC)
Received: by mail-vs1-f41.google.com with SMTP id u6so311546vsp.4
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 19:01:35 -0800 (PST)
X-Gm-Message-State: APjAAAVKRJBQ9fcECabiEqePBDB9Sh6mdbEteDk2QiHNdplIWxUWp8ZN
        Y1HBoyHjUVuhTJzDCiQek7nXpI9U5f6PQAGWr0s=
X-Google-Smtp-Source: APXvYqz0YWo6MGfr1VtOCnv4tyHkKF8gYszaCmTvTA/KiplIzklxqSlwtQcAgrkn3S+45CNAvzsd3NGhBtXOv5uqiYk=
X-Received: by 2002:a67:5d47:: with SMTP id r68mr1086050vsb.103.1573095693948;
 Wed, 06 Nov 2019 19:01:33 -0800 (PST)
MIME-Version: 1.0
References: <1573058068-7073-1-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1573058068-7073-1-git-send-email-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Wed, 6 Nov 2019 19:01:25 -0800
X-Gmail-Original-Message-ID: <CAOrHB_DCsC9Gnk5hd-JcDF_FMmLPFnZ9TUw_3sJ9Y3+ziPNC+A@mail.gmail.com>
Message-ID: <CAOrHB_DCsC9Gnk5hd-JcDF_FMmLPFnZ9TUw_3sJ9Y3+ziPNC+A@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: openvswitch: select vport upcall portid directly
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     ee07b291@gmail.com,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 6, 2019 at 8:34 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> The commit 69c51582ff786 ("dpif-netlink: don't allocate per
> thread netlink sockets"), in Open vSwitch ovs-vswitchd, has
> changed the number of allocated sockets to just one per port
> by moving the socket array from a per handler structure to
> a per datapath one. In the kernel datapath, a vport will have
> only one socket in most case, if so select it directly in
> fast-path.
>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Acked-by: Pravin B Shelar <pshelar@ovn.org>

Thanks.
