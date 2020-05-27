Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2A61E472A
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 17:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbgE0PTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 11:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgE0PTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 11:19:23 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B903EC05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 08:19:22 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id d24so20517085eds.11
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 08:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qyRAjSPjbWDmo3C3qGE8/sza5iW0uqSRk6eXoOrx70g=;
        b=lAlwwh6FRT34NKn7tJHvpcdulNIc/uQJKNQz3O5ULBb3nOvRKtybtf/oXiKSbccmPf
         mukFj5Wwb10F1Su9CCUcCj/ga5R4A+gcW9oHL0Hz6oqqJpdKYds/n4ddeFuNeOd8nj16
         D21yqVx2ZIAGjeb5aY7TsahNLdK9aGI1fGjB5Q6p0LBI2oc22nhchhB6Zz3KgDQoZoMW
         3xhhzYVPtJEgMO7fQwboMjyglyHpRv+kHMTq8FZ9W3MkRDQ03JQBrjTy7N5yUHRANF0W
         Jyl3NLXz141iFME3n4pnHDB7pIhDyby4FYVT6tE7ite7P/ft1m05mBxMlMfhOyDr4+zx
         7chg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qyRAjSPjbWDmo3C3qGE8/sza5iW0uqSRk6eXoOrx70g=;
        b=VnYc2k/cY5Z3AD0nIg6w5tZkEw/V1yzMKQzNMANfuDux+OpaZ8iXJlVe007LOOPltA
         y11eYkNnFyLbLbiYGETe5hSyN1BfL+t0RX+Liaxrogwu22et6xBOVB1YCfAIx8otz0Kx
         oSIO/YdgpDpywptpv8oSdoftWRTcrkO5LVnQVajhlUXFDa7bovOnVnte1UC/tNhTKdJN
         O5ANPbxeYBU4g1C7K/YvCYqeaVsixb6Imx3yFSO+SuAzgSLxCQQj1yiZ2xgiESUAGrw5
         Ggemt5VPemIpx/iWKMAoGo9ebMpgfE8VC2oU2bYtfxHJQGHSYEWw8J5lynh/Gm+cPRwn
         3ibA==
X-Gm-Message-State: AOAM532dd/G5QuR2GfkPayUhBmTi116oKWEK2vyFIauixQAojhy6uMcZ
        20EpHAJ0iuUUAWy3VK8iFUmwpMgOL/iBKkYL6rn3bw==
X-Google-Smtp-Source: ABdhPJy/9WHlC2e5InLSewTE5rMKFux4Sbg3e0KjyM62fs/d9sHN23TN0WUCmG/D6uP32UoXMvZ/BXCOhMNo/NI1e+o=
X-Received: by 2002:a05:6402:2213:: with SMTP id cq19mr24512782edb.337.1590592761444;
 Wed, 27 May 2020 08:19:21 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1590512901.git.petrm@mellanox.com>
In-Reply-To: <cover.1590512901.git.petrm@mellanox.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 27 May 2020 18:19:10 +0300
Message-ID: <CA+h21hqUKN9+Staoff++CoMd7wAkYBnwHOcunzX4nOFuAK_XHg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 0/3] TC: Introduce qevents
To:     Petr Machata <petrm@mellanox.com>
Cc:     netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Petr,

On Tue, 26 May 2020 at 20:11, Petr Machata <petrm@mellanox.com> wrote:
>
> The Spectrum hardware allows execution of one of several actions as a
> result of queue management events: tail-dropping, early-dropping, marking a
> packet, or passing a configured latency threshold or buffer size. Such
> packets can be mirrored, trapped, or sampled.
>
> Modeling the action to be taken as simply a TC action is very attractive,
> but it is not obvious where to put these actions. At least with ECN marking
> one could imagine a tree of qdiscs and classifiers that effectively
> accomplishes this task, albeit in an impractically complex manner. But
> there is just no way to match on dropped-ness of a packet, let alone
> dropped-ness due to a particular reason.
>
> To allow configuring user-defined actions as a result of inner workings of
> a qdisc, this patch set introduces a concept of qevents. Those are attach
> points for TC blocks, where filters can be put that are executed as the
> packet hits well-defined points in the qdisc algorithms. The attached
> blocks can be shared, in a manner similar to clsact ingress and egress
> blocks, arbitrary classifiers with arbitrary actions can be put on them,
> etc.
>
> For example:
>
> # tc qdisc add dev eth0 root handle 1: \
>         red limit 500K avpkt 1K qevent early block 10
> # tc filter add block 10 \
>         matchall action mirred egress mirror dev eth1
>
> Patch #1 of this set introduces several helpers to allow easy and uniform
> addition of qevents to qdiscs. The following two patches, #2 and #3, then
> add two qevents to the RED qdisc: "early" qevent fires when a packet is
> early-dropped; "mark" qevent, when it is ECN-marked.
>
> This patch set does not deal with offloading. The idea there is that a
> driver will be able to figure out that a given block is used in qevent
> context by looking at binder type. A future patch-set will add a qdisc
> pointer to struct flow_block_offload, which a driver will be able to
> consult to glean the TC or other relevant attributes.
>
> Petr Machata (3):
>   net: sched: Introduce helpers for qevent blocks
>   net: sched: sch_red: Split init and change callbacks
>   net: sched: sch_red: Add qevents "early" and "mark"
>
>  include/net/flow_offload.h     |   2 +
>  include/net/pkt_cls.h          |  48 +++++++++++++++
>  include/uapi/linux/pkt_sched.h |   2 +
>  net/sched/cls_api.c            | 107 +++++++++++++++++++++++++++++++++
>  net/sched/sch_red.c            | 100 ++++++++++++++++++++++++++----
>  5 files changed, 247 insertions(+), 12 deletions(-)
>
> --
> 2.20.1
>

I only took a cursory glance at your patches. Can these "qevents" be
added to code outside of the packet scheduler, like to the bridge, for
example? Or can the bridge mark the packets somehow, and then any
generic qdisc be able to recognize this mark without specific code?
A very common use case which is currently not possible to implement is
to rate-limit flooded (broadcast, unknown unicast, unknown multicast)
traffic. Can your "qevents" be used to describe this, or must it be
described separately?

Thanks,
-Vladimir
