Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D58E0ED255
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 07:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbfKCGrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 01:47:40 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:39173 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfKCGrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 01:47:40 -0500
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
        (Authenticated sender: pshelar@ovn.org)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id A3253100004
        for <netdev@vger.kernel.org>; Sun,  3 Nov 2019 06:47:38 +0000 (UTC)
Received: by mail-vs1-f42.google.com with SMTP id y129so9005982vsc.6
        for <netdev@vger.kernel.org>; Sat, 02 Nov 2019 23:47:38 -0700 (PDT)
X-Gm-Message-State: APjAAAUm63da4Rhv2PcF/19S6wNR+ujjbzfVtRisVFE7G2MSFsk4ETw7
        JtxEt8m0bewTIBTA70XJx+E48LVtse1dUSFAf8o=
X-Google-Smtp-Source: APXvYqyl0jhd+5VwhJxGXX+Sykx62cFvqBOjUO5WKJ6Fz85/kS4FopLvIbE6/mk0ADhaCPtDTdynt+XBMLZp37RLwmw=
X-Received: by 2002:a67:5d47:: with SMTP id r68mr4466950vsb.103.1572763657501;
 Sat, 02 Nov 2019 23:47:37 -0700 (PDT)
MIME-Version: 1.0
References: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com> <1572618234-6904-7-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1572618234-6904-7-git-send-email-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Sat, 2 Nov 2019 23:47:26 -0700
X-Gmail-Original-Message-ID: <CAOrHB_CtsNjx2b6Oaj345AHSWGGNrGfuPZL6J_uCivGsvHNKQQ@mail.gmail.com>
Message-ID: <CAOrHB_CtsNjx2b6Oaj345AHSWGGNrGfuPZL6J_uCivGsvHNKQQ@mail.gmail.com>
Subject: Re: [PATCH net-next v6 06/10] net: openvswitch: simplify the flow_hash
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
> Simplify the code and remove the unnecessary BUILD_BUG_ON.
>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> Tested-by: Greg Rose <gvrose8192@gmail.com>
> Acked-by: William Tu <u9012063@gmail.com>
> ---
Acked-by: Pravin B Shelar <pshelar@ovn.org>
