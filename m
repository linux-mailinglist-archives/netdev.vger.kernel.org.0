Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1B39956E0
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 07:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbfHTFuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 01:50:40 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:34325 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbfHTFuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 01:50:40 -0400
X-Originating-IP: 209.85.217.46
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
        (Authenticated sender: pshelar@ovn.org)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id E72C31BF203
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 05:50:38 +0000 (UTC)
Received: by mail-vs1-f46.google.com with SMTP id i128so2771837vsc.7
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 22:50:38 -0700 (PDT)
X-Gm-Message-State: APjAAAV7kFr7Oakn5aghkeULuFZxV8zEUnslXx9bXTaMMSw3T3p2Vs4O
        o07tlP86It/U82vx/li/SsW/2N8JYu2GVnI7Z2I=
X-Google-Smtp-Source: APXvYqwxldzn3mrsFAufSiifpL3zrnD4isr5plw2lIR0WwN0cOrXVyF1fjBJzUFBMOQdfpKu4OOFoDz6MuD1V+6G0iE=
X-Received: by 2002:a67:f98c:: with SMTP id b12mr16130215vsq.47.1566280237734;
 Mon, 19 Aug 2019 22:50:37 -0700 (PDT)
MIME-Version: 1.0
References: <1566144059-8247-1-git-send-email-paulb@mellanox.com>
In-Reply-To: <1566144059-8247-1-git-send-email-paulb@mellanox.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Mon, 19 Aug 2019 22:52:27 -0700
X-Gmail-Original-Message-ID: <CAOrHB_Ca3W1tTi58kQJ30ujNuKYuWOQCXs-Fj=Uy+hKigNxVkg@mail.gmail.com>
Message-ID: <CAOrHB_Ca3W1tTi58kQJ30ujNuKYuWOQCXs-Fj=Uy+hKigNxVkg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: openvswitch: Set OvS recirc_id from tc chain
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Justin Pettit <jpettit@nicira.com>,
        Simon Horman <simon.horman@netronome.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 18, 2019 at 9:01 AM Paul Blakey <paulb@mellanox.com> wrote:
>
> What do you guys say about the following diff on top of the last one?
> Use static key, and also have OVS_DP_CMD_SET command probe/enable the feature.
>
> This will allow userspace to probe the feature, and selectivly enable it via the
> OVS_DP_CMD_SET command.
>

This approach looks good to me.

Thanks.
