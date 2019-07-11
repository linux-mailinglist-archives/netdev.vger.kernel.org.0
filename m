Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D47E660FD
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 23:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbfGKVHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 17:07:25 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:45143 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbfGKVHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 17:07:25 -0400
X-Originating-IP: 209.85.221.180
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
        (Authenticated sender: pshelar@ovn.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 5B0A3C0003
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 21:07:23 +0000 (UTC)
Received: by mail-vk1-f180.google.com with SMTP id u64so1666193vku.8
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 14:07:23 -0700 (PDT)
X-Gm-Message-State: APjAAAWlIRzSNHKrfpjJR98ZBCguQn7PUXMRjZwm/q10sFHCmBYfTG91
        awecZievbCQxp+zFSdObEKgFm4cofS/88tTv+F8=
X-Google-Smtp-Source: APXvYqyrD++iGsJ6DDVb5GYhCEEgptkIJ7wt+BH8LVJW5D1iQiIQye76toI6IGBBHw/FVWs6uKlqo9lP8Yq5RbNy8w8=
X-Received: by 2002:a1f:2909:: with SMTP id p9mr4778364vkp.23.1562879241907;
 Thu, 11 Jul 2019 14:07:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190705160809.5202-1-ap420073@gmail.com> <20190708.160804.2026506853635876959.davem@davemloft.net>
 <87bfb355-9ddf-c27b-c160-b3028a945a22@gmail.com> <b40f4a39-8de4-482c-2ee8-66adf5c606be@gmail.com>
In-Reply-To: <b40f4a39-8de4-482c-2ee8-66adf5c606be@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Thu, 11 Jul 2019 14:07:12 -0700
X-Gmail-Original-Message-ID: <CAOrHB_CLRYC_AFgDhzPGadXDob4hO1Q7Eorqm4bZjMJLV3cMBQ@mail.gmail.com>
Message-ID: <CAOrHB_CLRYC_AFgDhzPGadXDob4hO1Q7Eorqm4bZjMJLV3cMBQ@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH net-next] net: openvswitch: do not update
 max_headroom if new headroom is equal to old headroom
To:     Gregory Rose <gvrose8192@gmail.com>
Cc:     David Miller <davem@davemloft.net>, ap420073@gmail.com,
        ovs dev <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I was bit busy for last couple of days. I will finish review by EOD today.

Thanks,
Pravin.

On Mon, Jul 8, 2019 at 4:22 PM Gregory Rose <gvrose8192@gmail.com> wrote:
>
>
>
> On 7/8/2019 4:18 PM, Gregory Rose wrote:
> > On 7/8/2019 4:08 PM, David Miller wrote:
> >> From: Taehee Yoo <ap420073@gmail.com>
> >> Date: Sat,  6 Jul 2019 01:08:09 +0900
> >>
> >>> When a vport is deleted, the maximum headroom size would be changed.
> >>> If the vport which has the largest headroom is deleted,
> >>> the new max_headroom would be set.
> >>> But, if the new headroom size is equal to the old headroom size,
> >>> updating routine is unnecessary.
> >>>
> >>> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> >> I'm not so sure about the logic here and I'd therefore like an OVS
> >> expert
> >> to review this.
> >
> > I'll review and test it and get back.  Pravin may have input as well.
> >
>
> Err, adding Pravin.
>
> - Greg
>
> > Thanks,
> >
> > - Greg
> >
> >> Thanks.
> >> _______________________________________________
> >> dev mailing list
> >> dev@openvswitch.org
> >> https://mail.openvswitch.org/mailman/listinfo/ovs-dev
> >
>
