Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA8B1E90CB
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 21:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfJ2U3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 16:29:47 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:37247 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfJ2U3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 16:29:47 -0400
X-Originating-IP: 209.85.217.42
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
        (Authenticated sender: pshelar@ovn.org)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 3866A20005
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 20:29:44 +0000 (UTC)
Received: by mail-vs1-f42.google.com with SMTP id a143so124530vsd.9
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 13:29:44 -0700 (PDT)
X-Gm-Message-State: APjAAAXsD2ttD78bl5srAf5/w1jbEVJ46773rn016xuGfFOs4rZtHDH/
        SkK2FZvmN69dLy1MxRr1i01xk/kJOLtapGiMi9U=
X-Google-Smtp-Source: APXvYqzZIiOJbycYkOvbwBtOmbiI5n5KLtwEIOSb5CXPCCgFAhZWKTRdR4lGeIguGip43hQLLY3Lg4DJfyniwoY8wBU=
X-Received: by 2002:a05:6102:2436:: with SMTP id l22mr2838013vsi.93.1572380983946;
 Tue, 29 Oct 2019 13:29:43 -0700 (PDT)
MIME-Version: 1.0
References: <1572242037-7041-1-git-send-email-martinvarghesenokia@gmail.com>
In-Reply-To: <1572242037-7041-1-git-send-email-martinvarghesenokia@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Tue, 29 Oct 2019 13:29:33 -0700
X-Gmail-Original-Message-ID: <CAOrHB_DuRj2vKonQQ4nGUd5ZeEPQXboK_1Yk8SUC14VGF2z9LQ@mail.gmail.com>
Message-ID: <CAOrHB_DuRj2vKonQQ4nGUd5ZeEPQXboK_1Yk8SUC14VGF2z9LQ@mail.gmail.com>
Subject: Re: [PATCH v3 net-next] Change in Openvswitch to support MPLS label
 depth of 3 in ingress direction
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, scott.drennan@nokia.com,
        Jiri Benc <jbenc@redhat.com>,
        "Varghese, Martin (Nokia - IN/Bangalore)" <martin.varghese@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 27, 2019 at 10:54 PM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> From: Martin Varghese <martin.varghese@nokia.com>
>
> The openvswitch was supporting a MPLS label depth of 1 in the ingress
> direction though the userspace OVS supports a max depth of 3 labels.
> This change enables openvswitch module to support a max depth of
> 3 labels in the ingress.
>
> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>

Acked-by: Pravin B Shelar <pshelar@ovn.org>
