Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7100ED25A
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 07:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbfKCGsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 01:48:07 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:50315 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfKCGsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 01:48:06 -0500
X-Originating-IP: 209.85.222.46
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
        (Authenticated sender: pshelar@ovn.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 54A20C0004
        for <netdev@vger.kernel.org>; Sun,  3 Nov 2019 06:48:05 +0000 (UTC)
Received: by mail-ua1-f46.google.com with SMTP id o9so2317284uat.8
        for <netdev@vger.kernel.org>; Sat, 02 Nov 2019 23:48:05 -0700 (PDT)
X-Gm-Message-State: APjAAAWqhIBSyhC6mgGWnE8+DNde9TJJTP88DfTEesdzU5ETZ/UW7I87
        5/ZzXCCrfOtWY8TdmFvKjhBWMx+MyYLoIc4yHfg=
X-Google-Smtp-Source: APXvYqx9oKy1vi1hA6XYiZgtTT/QfO3W4olTr0kDML1moak6Eo8TY2apek1OIq33O/l3FzSw/NhqlbEYxPj+ohMt/Hw=
X-Received: by 2002:ab0:20ad:: with SMTP id y13mr3277827ual.70.1572763684239;
 Sat, 02 Nov 2019 23:48:04 -0700 (PDT)
MIME-Version: 1.0
References: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com> <1572618234-6904-11-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1572618234-6904-11-git-send-email-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Sat, 2 Nov 2019 23:47:53 -0700
X-Gmail-Original-Message-ID: <CAOrHB_AxNSkvZ7vUmp5V-OVf2k0VGWxwVfm_NmZjgqNnSy70Lw@mail.gmail.com>
Message-ID: <CAOrHB_AxNSkvZ7vUmp5V-OVf2k0VGWxwVfm_NmZjgqNnSy70Lw@mail.gmail.com>
Subject: Re: [PATCH net-next v6 10/10] net: openvswitch: simplify the ovs_dp_cmd_new
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
> use the specified functions to init resource.
>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> Tested-by: Greg Rose <gvrose8192@gmail.com>
Acked-by: Pravin B Shelar <pshelar@ovn.org>
