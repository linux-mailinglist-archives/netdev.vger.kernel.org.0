Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A778109837
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 05:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbfKZEHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 23:07:40 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:44195 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbfKZEHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 23:07:40 -0500
Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
        (Authenticated sender: pshelar@ovn.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 04D18200004;
        Tue, 26 Nov 2019 04:07:37 +0000 (UTC)
Received: by mail-vk1-f178.google.com with SMTP id r4so4074934vkf.9;
        Mon, 25 Nov 2019 20:07:37 -0800 (PST)
X-Gm-Message-State: APjAAAVB2KBWMbt/LPzTJMPimJ/RdWEbkYxHm7rbCBc3BqnUM0Q5cYxu
        LzkLw7UtiLuUH55YY0R4CQsVT2HRp1O4T0yEy4Y=
X-Google-Smtp-Source: APXvYqzuS+vDFQHOO8Q1FRBhRtJDY/6XqplwokxvnEnzOX7PtBBwwhPUCj3DsKZJp38Tr5/S9Ad7jwEATHBUVs4GNtc=
X-Received: by 2002:ac5:c2c3:: with SMTP id i3mr19830904vkk.17.1574741256480;
 Mon, 25 Nov 2019 20:07:36 -0800 (PST)
MIME-Version: 1.0
References: <20191108210714.12426-1-aconole@redhat.com> <CAOrHB_B1ueESwUQSkb7BuFGCCyKKqognoWbukTHo2jTajNca6w@mail.gmail.com>
 <f7twobwyl53.fsf@dhcp-25.97.bos.redhat.com> <f7t7e3o9d9r.fsf@dhcp-25.97.bos.redhat.com>
In-Reply-To: <f7t7e3o9d9r.fsf@dhcp-25.97.bos.redhat.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Mon, 25 Nov 2019 20:07:25 -0800
X-Gmail-Original-Message-ID: <CAOrHB_BHKASZ9i5LA678Cqh3F8QtDy4Wv6_8eTSCXaJTx4HaVw@mail.gmail.com>
Message-ID: <CAOrHB_BHKASZ9i5LA678Cqh3F8QtDy4Wv6_8eTSCXaJTx4HaVw@mail.gmail.com>
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

Downloading from patchwork is working for me. Its strange other
patches in my mailbox does not has this issue.

Thanks.

On Mon, Nov 25, 2019 at 7:39 AM Aaron Conole <aconole@redhat.com> wrote:
>
> Aaron Conole <aconole@redhat.com> writes:
>
> > Pravin Shelar <pshelar@ovn.org> writes:
> >
> >> On Fri, Nov 8, 2019 at 1:07 PM Aaron Conole <aconole@redhat.com> wrote:
> >>>
> >>> The openvswitch module shares a common conntrack and NAT infrastructure
> >>> exposed via netfilter.  It's possible that a packet needs both SNAT and
> >>> DNAT manipulation, due to e.g. tuple collision.  Netfilter can support
> >>> this because it runs through the NAT table twice - once on ingress and
> >>> again after egress.  The openvswitch module doesn't have such capability.
> >>>
> >>> Like netfilter hook infrastructure, we should run through NAT twice to
> >>> keep the symmetry.
> >>>
> >>> Fixes: 05752523e565 ("openvswitch: Interface with NAT.")
> >>> Signed-off-by: Aaron Conole <aconole@redhat.com>
> >>
> >> The patch looks ok. But I am not able apply it. can you fix the encoding.
> >
> > Hrrm.  I didn't make any special changes (just used git send-email).  I
> > will look at spinning a second patch.
>
> Pravin,
>
> I tried the following:
>
>   10:36:59 aconole@dhcp-25 {(312434617cb1...)} ~/git/linux$ curl http://patchwork.ozlabs.org/patch/1192219/mbox/ > test.patch
>     % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
>                                    Dload  Upload   Total   Spent    Left  Speed
>   100  4827  100  4827    0     0   8824      0 --:--:-- --:--:-- --:--:--  8808
>   10:37:21 aconole@dhcp-25 {(312434617cb1...)} ~/git/linux$ git am test.patch
>   Applying: openvswitch: support asymmetric conntrack
>   10:37:24 aconole@dhcp-25 {(f759cc2b7323...)} ~/git/linux$
>
>
> Can you check your mailer settings?  The patchwork mbox worked fine, and
> I was able to apply from my own mbox as well.
>
> -Aaron
>
