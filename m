Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC9D128A95
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 18:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfLURZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 12:25:42 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:48525 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbfLURZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 12:25:42 -0500
X-Originating-IP: 209.85.222.42
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
        (Authenticated sender: pshelar@ovn.org)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 67116240005
        for <netdev@vger.kernel.org>; Sat, 21 Dec 2019 17:25:40 +0000 (UTC)
Received: by mail-ua1-f42.google.com with SMTP id o42so4350255uad.10
        for <netdev@vger.kernel.org>; Sat, 21 Dec 2019 09:25:40 -0800 (PST)
X-Gm-Message-State: APjAAAVFQbzSPRccyYJdEHeDB4heXXtBzdsqgkTZM4DrfGD1RJAweQ6t
        wuYy7/oLYbF6ZjCJ9gGX7pTaD6LRrAZ1xJoeN48=
X-Google-Smtp-Source: APXvYqyN0SRMfv2AlVGVdwicHhiVDb0vtU5ZcJEofms1R7zckQVY6CgR2xqdMoqm/Wyi9gssxzVwcZ3xJCx3qDnNk4U=
X-Received: by 2002:ab0:2006:: with SMTP id v6mr12525449uak.22.1576949138967;
 Sat, 21 Dec 2019 09:25:38 -0800 (PST)
MIME-Version: 1.0
References: <cover.1576896417.git.martin.varghese@nokia.com> <5dbc2dbc222ff778861ef08b4e0a68a49a7afeb1.1576896417.git.martin.varghese@nokia.com>
In-Reply-To: <5dbc2dbc222ff778861ef08b4e0a68a49a7afeb1.1576896417.git.martin.varghese@nokia.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Sat, 21 Dec 2019 09:25:28 -0800
X-Gmail-Original-Message-ID: <CAOrHB_CpxF5zaaVdsf9wrLmNjaFbEzf8tacUio4SZGJ84nxNCQ@mail.gmail.com>
Message-ID: <CAOrHB_CpxF5zaaVdsf9wrLmNjaFbEzf8tacUio4SZGJ84nxNCQ@mail.gmail.com>
Subject: Re: [PATCH net-next v5 1/3] net: skb_mpls_push() modified to allow
 MPLS header push at start of packet.
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

On Fri, Dec 20, 2019 at 7:21 PM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> From: Martin Varghese <martin.varghese@nokia.com>
>
> The existing skb_mpls_push() implementation always inserts mpls header
> after the mac header. L2 VPN use cases requires MPLS header to be
> inserted before the ethernet header as the ethernet packet gets tunnelled
> inside MPLS header in those cases.
>
> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> ---
> Changes in v2:
>     - Fixed comments section of skb_mpls_push().
>     - Added skb_reset_mac_len() in skb_mpls_push(). The mac len changes
>       when MPLS header in inserted at the start of the packet.
>
>  net/core/skbuff.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
Acked-by: Pravin B Shelar <pshelar@ovn.org>

Thanks.
