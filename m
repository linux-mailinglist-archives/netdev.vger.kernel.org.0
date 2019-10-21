Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98F9ADF3F4
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 19:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbfJUROt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 13:14:49 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36422 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbfJUROs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 13:14:48 -0400
Received: by mail-qk1-f196.google.com with SMTP id y189so13374283qkc.3
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 10:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8ex54VGnFSDW0tDRO0nJdtnH/+uhFytZQsBPaAkGVVs=;
        b=s45e/B/w+i7O2DyLj6GH+9P1HATaxznqp+GGL6chH3k6aNbIqXxK2ElHFxspMW0hAC
         wvQ7FeNm5LUeDbsuAJWKCBha9MbkJnaos7Ki3TmUM74l6S3rzyWgcSYVM3WBVn1xVOGG
         bYKBus9HFhd3sFt4k57V7aZH1ifJNwYA7k3NXLtKHJbsD4DTqh7FUkOX5wuF9c3Dp6cQ
         Ip7r25V9h6yECprHJ4npkd7QHbc4HDKNaVeI2ahkVt6bB+RsD+ZXlYtLzSLn7EROuXFP
         kUUa8Zlv5/wwJEUqyqdCTaGrruGrQyKa7gCy88LiJV+zRyIT1mxKul5hj036BbuLPavi
         sVbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8ex54VGnFSDW0tDRO0nJdtnH/+uhFytZQsBPaAkGVVs=;
        b=P9v/V/vGfaiQFAFH+HPtQ3yIK0C33DVZlz6NryeUGWqEq4dnf/XBe+b6x4GawHEPwx
         gFelFTcKUOVJ7Z6UuDC+liUC1sYiZWvc0kU11HPTYa0tlG+mj0a43C8WNKoYM+eJprCZ
         q2KZrcBBCjxbfL1tfUY7o3GTBTGa+NL937FvGkIhXOtrMSdxQxxhpFfhvFAgcsRaoIxM
         NxrmDdGTOTezmn9bicaYM/VzjxXsbSCAN+9K3ChKgXI2vas9CrW1MZBRrdQP+LcOp2WM
         OXGlaDavxdDMfseOqfL9l39fnp4Z5lZROcM0ASA/DgLS+I9a5SMyat4U2DQnqzlgZDX/
         yIBg==
X-Gm-Message-State: APjAAAVmOezDFEAk/9ICbafwz6skQDVmlfoWMrHW0gPGqN7r3MvcTrmF
        L1L7+J7RoCebC24hho3srLV4QdU42c3a8o3LX8M=
X-Google-Smtp-Source: APXvYqzdRtcIpPKO4MqYX50xK22H0wXaC8OaXOZb0e7e0L3+jiXSYUiSox6eV/5sCf5ceSG71WaI/qqkmKgyQ7Izoa0=
X-Received: by 2002:a37:4b4f:: with SMTP id y76mr23166319qka.147.1571678087387;
 Mon, 21 Oct 2019 10:14:47 -0700 (PDT)
MIME-Version: 1.0
References: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Mon, 21 Oct 2019 10:14:06 -0700
Message-ID: <CALDO+SZib59P3qmQNWGNjKnrn_+DsFnu+QoPE0gfqRLVRpDk+Q@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH net-next v4 00/10] optimize openvswitch flow
 looking up
To:     xiangxia.m.yue@gmail.com
Cc:     Greg Rose <gvrose8192@gmail.com>, pravin shelar <pshelar@ovn.org>,
        "<dev@openvswitch.org>" <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 5:50 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> This series patch optimize openvswitch for performance or simplify
> codes.
>
> Patch 1, 2, 4: Port Pravin B Shelar patches to
> linux upstream with little changes.

btw, should we keep Pravin as the author of the above three patches?

Regards,
William

>
> Patch 5, 6, 7: Optimize the flow looking up and
> simplify the flow hash.
>
> Patch 8, 9: are bugfix.
>
> The performance test is on Intel Xeon E5-2630 v4.
> The test topology is show as below:
>
> +-----------------------------------+
> |   +---------------------------+   |
> |   | eth0   ovs-switch    eth1 |   | Host0
> |   +---------------------------+   |
> +-----------------------------------+
>       ^                       |
>       |                       |
>       |                       |
>       |                       |
>       |                       v
> +-----+----+             +----+-----+
> | netperf  | Host1       | netserver| Host2
> +----------+             +----------+
>
> We use netperf send the 64B packets, and insert 255+ flow-mask:
> $ ovs-dpctl add-flow ovs-switch "in_port(1),eth(dst=00:01:00:00:00:00/ff:ff:ff:ff:ff:01),eth_type(0x0800),ipv4(frag=no)" 2
> ...
> $ ovs-dpctl add-flow ovs-switch "in_port(1),eth(dst=00:ff:00:00:00:00/ff:ff:ff:ff:ff:ff),eth_type(0x0800),ipv4(frag=no)" 2
> $
> $ netperf -t UDP_STREAM -H 2.2.2.200 -l 40 -- -m 18
>
> * Without series patch, throughput 8.28Mbps
> * With series patch, throughput 46.05Mbps
>
> v3->v4:
> access ma->count with READ_ONCE/WRITE_ONCE API. More information,
> see patch 5 comments.
>
> v2->v3:
> update ma point when realloc mask_array in patch 5.
>
> v1->v2:
> use kfree_rcu instead of call_rcu
>
> Tonghao Zhang (10):
>   net: openvswitch: add flow-mask cache for performance
>   net: openvswitch: convert mask list in mask array
>   net: openvswitch: shrink the mask array if necessary
>   net: openvswitch: optimize flow mask cache hash collision
>   net: openvswitch: optimize flow-mask looking up
>   net: openvswitch: simplify the flow_hash
>   net: openvswitch: add likely in flow_lookup
>   net: openvswitch: fix possible memleak on destroy flow-table
>   net: openvswitch: don't unlock mutex when changing the user_features
>     fails
>   net: openvswitch: simplify the ovs_dp_cmd_new
>
>  net/openvswitch/datapath.c   |  65 +++++----
>  net/openvswitch/flow.h       |   1 -
>  net/openvswitch/flow_table.c | 316 +++++++++++++++++++++++++++++++++++++------
>  net/openvswitch/flow_table.h |  19 ++-
>  4 files changed, 329 insertions(+), 72 deletions(-)
>
> --
> 1.8.3.1
>
> _______________________________________________
> dev mailing list
> dev@openvswitch.org
> https://mail.openvswitch.org/mailman/listinfo/ovs-dev
