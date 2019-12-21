Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C69C6128A96
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 18:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbfLURZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 12:25:47 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:46865 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbfLURZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 12:25:46 -0500
X-Originating-IP: 209.85.217.51
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
        (Authenticated sender: pshelar@ovn.org)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 1C4C5E0002
        for <netdev@vger.kernel.org>; Sat, 21 Dec 2019 17:25:44 +0000 (UTC)
Received: by mail-vs1-f51.google.com with SMTP id s16so6599300vsc.10
        for <netdev@vger.kernel.org>; Sat, 21 Dec 2019 09:25:44 -0800 (PST)
X-Gm-Message-State: APjAAAVhs6MFxV0I7GATVSswCcBf4zjYdt/y34h5vvRX87Yip5NPhgG3
        UlTFsZV+xkeqwGxBYGtppXjqWqk1lOzyxjtm+CM=
X-Google-Smtp-Source: APXvYqxpSeDOIF5i3rAhnDZZqkYCmBRyzVeAlsBjY11VV1LSdr+jeNn4rs1QUDFGu+op6wiAHGO5Ozkr4gcqpKE1/po=
X-Received: by 2002:a67:fe09:: with SMTP id l9mr11443055vsr.58.1576949143992;
 Sat, 21 Dec 2019 09:25:43 -0800 (PST)
MIME-Version: 1.0
References: <cover.1576896417.git.martin.varghese@nokia.com> <a934a03a66b3672acb09222055fe283991f93787.1576896417.git.martin.varghese@nokia.com>
In-Reply-To: <a934a03a66b3672acb09222055fe283991f93787.1576896417.git.martin.varghese@nokia.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Sat, 21 Dec 2019 09:25:33 -0800
X-Gmail-Original-Message-ID: <CAOrHB_CBOHq+9qsW3e5XKYc=ZohZy7Nisv=P+VirgRStaOku6w@mail.gmail.com>
Message-ID: <CAOrHB_CBOHq+9qsW3e5XKYc=ZohZy7Nisv=P+VirgRStaOku6w@mail.gmail.com>
Subject: Re: [PATCH net-next v5 2/3] net: Rephrased comments section of skb_mpls_pop()
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
> Rephrased comments section of skb_mpls_pop() to align it with
> comments section of skb_mpls_push().
>
> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>

Acked-by: Pravin B Shelar <pshelar@ovn.org>

Thanks.
