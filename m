Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7C336B809
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235759AbhDZRZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235079AbhDZRZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:25:08 -0400
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA86AC061756
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 10:24:25 -0700 (PDT)
Received: by mail-vs1-xe2e.google.com with SMTP id d25so22003650vsp.1
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 10:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nFoayYppu/XPpzfTAr4b3cv0yWnD0jbL4+Ih3zwmTOE=;
        b=j9VaMQH4Vv3//heVBPqkuRLtLnxrsi/cEXXiXk8BZ43exlwgDkflEWNwfzuiL28UR4
         9mT02If5rDug6x9vOb68tgsY54huyXplSbX2Dva2lVaPlqPUiZlK5GKw6MD2ASpO71L1
         VLEwv5MhxpYulhr8kHBG8tNbRKYp0geOfLriuWf5Jgx2G9YTuGgP6GVO8bqEep57WJoj
         UtDoPLQzOhaYBHz/1b2b66QtebqKw7HUseVlDbeEbocrDiY3D2GyMbVb8qBZsPmD6Ev1
         5+PrYAtJJpPrnJKmGrj3ckY6AP2HvjmeeeiIHP/5qz25wnQy5IjQ+83adI6XWPeW2bsL
         zQxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nFoayYppu/XPpzfTAr4b3cv0yWnD0jbL4+Ih3zwmTOE=;
        b=GggemJ8qMhHdOQEbrI88OZsLV1iz39Ug0vsAWlT53EtuydDvRppoM3q1T9/zY0GdCq
         IShdpjZ5ft//Ii1LRLf6eG9BwqeUzqN45/HBi6q6K4X4Aoj9ArNiU/gURkIwcxOwsPew
         WypRrlWUfMpvWoln9RZgD+5zq7MxyU39k18mRfsSJ6PYLBAFu3gYaFVoP13saXuTrl8H
         qm6bHQDybM8VESD5TqDh0vPvhIh6n6ZqpXLjZs9hYI2nIm1iLufQjNn8esGIKld3W0c/
         uIVUxQQQEPaU4zEvrplFYOzxlBLgYWUtAJ6eP0Y65ghqaV/LWMDAOO5oXvpebPtvQpZz
         UH/g==
X-Gm-Message-State: AOAM530MyhVUHG8IvKkz112/Wuh/bQb5iDvVSULaLZQ7PiXfckkvC1PZ
        d7QLk2nY1dapv3X+JRFR9j3XazVp9LgjYZ8rZ59YbA==
X-Google-Smtp-Source: ABdhPJx7RRQUWohPru1KlZUjdZ23TjBu17Nk/B5ZiNMICedbqxTZtYL/kZq43WqNcpcq0qj4kfsQkixku0ihFc2Yuqc=
X-Received: by 2002:a05:6102:418:: with SMTP id d24mr4755091vsq.54.1619457864670;
 Mon, 26 Apr 2021 10:24:24 -0700 (PDT)
MIME-Version: 1.0
References: <d7fbf3d3a2490d0a9e99945593ada243da58e0f8.1619000255.git.cdleonard@gmail.com>
 <CADVnQynLSDQHxgMN6=mU2m58t_JKUyugmw0j6g1UDG+jLxTfAw@mail.gmail.com>
 <50de1e9f-eed7-f827-77ea-708f4621e3d4@drivenets.com> <CADVnQykBebycW1XcvD=NGan+BrJ3N1m5Q-pWs5vyYNmQQLjrBw@mail.gmail.com>
 <5af52ab4-237f-8646-76e4-5e24236d9b4a@drivenets.com>
In-Reply-To: <5af52ab4-237f-8646-76e4-5e24236d9b4a@drivenets.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Mon, 26 Apr 2021 13:24:07 -0400
Message-ID: <CADVnQykNRumYbEj4s-NV=BQLqVAbR2An4rLVZft4gq_E-JdNug@mail.gmail.com>
Subject: Re: [RFC] tcp: Delay sending non-probes for RFC4821 mtu probing
To:     Leonard Crestez <lcrestez@drivenets.com>
Cc:     Matt Mathis <mattmathis@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuchung Cheng <ycheng@google.com>,
        John Heffner <johnwheffner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 1:09 PM Leonard Crestez <lcrestez@drivenets.com> wrote:
>
> On 26.04.2021 18:59, Neal Cardwell wrote:
> > On Sun, Apr 25, 2021 at 10:34 PM Leonard Crestez <lcrestez@drivenets.com> wrote:
> >> On 4/21/21 3:47 PM, Neal Cardwell wrote:
> >>> On Wed, Apr 21, 2021 at 6:21 AM Leonard Crestez <cdleonard@gmail.com> wrote:
>
> >>> If the goal is to increase the frequency of PMTU probes, which seems
> >>> like a valid goal, I would suggest that we rethink the Linux heuristic
> >>> for triggering PMTU probes in the light of the fact that the loss
> >>> detection mechanism is now RACK-TLP, which provides quick recovery in
> >>> a much wider variety of scenarios.
> >>
> >>> You mention:
> >>>> Linux waits for probe_size + (1 + retries) * mss_cache to be available
> >>>
> >>> The code in question seems to be:
> >>>
> >>>     size_needed = probe_size + (tp->reordering + 1) * tp->mss_cache;
> >>> How about just changing this to:
> >>>
> >>>     size_needed = probe_size + tp->mss_cache;
> >>>
> >>> The rationale would be that if that amount of data is available, then
> >>> the sender can send one probe and one following current-mss-size
> >>> packet. If the path MTU has not increased to allow the probe of size
> >>> probe_size to pass through the network, then the following
> >>> current-mss-size packet will likely pass through the network, generate
> >>> a SACK, and trigger a RACK fast recovery 1/4*min_rtt later, when the
> >>> RACK reorder timer fires.
> >>
> >> This appears to almost work except it stalls after a while. I spend some
> >> time investigating it and it seems that cwnd is shrunk on mss increases
> >> and does not go back up. This causes probes to be skipped because of a
> >> "snd_cwnd < 11" condition.
> >>
> >> I don't undestand where that magical "11" comes from, could that be
> >> shrunk. Maybe it's meant to only send probes when the cwnd is above the
> >> default of 10? Then maybe mtu_probe_success shouldn't shrink mss below
> >> what is required for an additional probe, or at least round-up.
> >>
> >> The shrinkage of cwnd is a problem with this "short probes" approach
> >> because tcp_is_cwnd_limited returns false because tp->max_packets_out is
> >> smaller (4). With longer probes tp->max_packets_out is larger (6) so
> >> tcp_is_cwnd_limited returns true even for a cwnd of 10.
> >>
> >> I'm testing using namespace-to-namespace loopback so my delays are close
> >> to zero. I tried to introduce an artificial delay of 30ms (using tc
> >> netem) and it works but 20ms does not.
> >
> > I agree the magic 11 seems outdated and unnecessarily high, given RACK-TLP.
> >
> > I think it would be fine to change the magic 11 to a magic
> > (TCP_FASTRETRANS_THRESH+1), aka 3+1=4:
> >
> >    - tp->snd_cwnd < 11 ||
> >    + p->snd_cwnd < (TCP_FASTRETRANS_THRESH + 1) ||
> >
> > As long as the cwnd is >= TCP_FASTRETRANS_THRESH+1 then the sender
> > should usually be able to send the 1 probe packet and then 3
> > additional packets beyond the probe, and in the common case (with no
> > reordering) then with failed probes this should allow the sender to
> > quickly receive 3 SACKed segments and enter fast recovery quickly.
> > Even if the sender doesn't have 3 additional packets, or if reordering
> > has been detected, then RACK-TLP should be able to start recovery
> > quickly (5/4*RTT if there is at least one SACK, or 2*RTT for a TLP if
> > there is no SACK).
>
> As far as I understand tp->reordering is a dynamic evaluation of the
> fastretrans threshold to deal with environments with lots of reordering.
> Your suggestion seems equivalent to the current size_needed calculation
> except using packets instead of bytes.
>
> Wouldn't it be easier to drop the "11" check and just verify that
> size_needed fits into cwnd as bytes?

Yes, that sounds good to me (dropping the "11" check in favor of
verifying that size_needed fits into the cwnd).

neal
