Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E166F61B6
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 23:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbfKIWPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 17:15:45 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:40337 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbfKIWPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 17:15:45 -0500
Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
        (Authenticated sender: pshelar@ovn.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id D8183200004;
        Sat,  9 Nov 2019 22:15:41 +0000 (UTC)
Received: by mail-vs1-f52.google.com with SMTP id a143so6279671vsd.9;
        Sat, 09 Nov 2019 14:15:41 -0800 (PST)
X-Gm-Message-State: APjAAAXKbZpuq3e2j0IJQN7Wu1WwvATCCTTPHL0z7D5PRsxSpAppJYwo
        gh6s5H8Sr9jV5PLgwQqCs5kiIQWAsHagww5k4Ds=
X-Google-Smtp-Source: APXvYqyc90bexO8eRldc5FZhDnhfdSc1UeYFztZ5ppCtTzb2OHwiFcUK7tRNSe0JQSzTQ8Da/zzopewstGJFU+j+7BE=
X-Received: by 2002:a05:6102:2417:: with SMTP id j23mr13329005vsi.93.1573337740380;
 Sat, 09 Nov 2019 14:15:40 -0800 (PST)
MIME-Version: 1.0
References: <20191108210714.12426-1-aconole@redhat.com>
In-Reply-To: <20191108210714.12426-1-aconole@redhat.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Sat, 9 Nov 2019 14:15:31 -0800
X-Gmail-Original-Message-ID: <CAOrHB_B1ueESwUQSkb7BuFGCCyKKqognoWbukTHo2jTajNca6w@mail.gmail.com>
Message-ID: <CAOrHB_B1ueESwUQSkb7BuFGCCyKKqognoWbukTHo2jTajNca6w@mail.gmail.com>
Subject: Re: [PATCH net 1/2] openvswitch: support asymmetric conntrack
To:     Aaron Conole <aconole@redhat.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, ovs dev <dev@openvswitch.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 8, 2019 at 1:07 PM Aaron Conole <aconole@redhat.com> wrote:
>
> The openvswitch module shares a common conntrack and NAT infrastructure
> exposed via netfilter.  It's possible that a packet needs both SNAT and
> DNAT manipulation, due to e.g. tuple collision.  Netfilter can support
> this because it runs through the NAT table twice - once on ingress and
> again after egress.  The openvswitch module doesn't have such capability.
>
> Like netfilter hook infrastructure, we should run through NAT twice to
> keep the symmetry.
>
> Fixes: 05752523e565 ("openvswitch: Interface with NAT.")
> Signed-off-by: Aaron Conole <aconole@redhat.com>

The patch looks ok. But I am not able apply it. can you fix the encoding.
