Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBA842507EB
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 20:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgHXSjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 14:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgHXSjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 14:39:23 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9927C061573
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 11:39:22 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id t14so9266107wmi.3
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 11:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Q8D4OzWKUNx15CbGcAR0w+lXslLK9LxZvOQg2mf4Bjo=;
        b=BvAAZuwcWsdehauGOAk8294HO8zHMgme0u4tXb2NGCVN47M9j0tTR+lMGbqM7IZcwv
         oPfkcAQFHpV86OZqd8rCunlQtZxl3sB/rSUzwuEw+x+BggFj3r+5p4tdLjAfHTAb3f8P
         dnEhRgujhZcrEEc+Dfiszo8yzB8rNYIK1njvfbKR5p61PC/IC6ntEKUKM+ynB8Cyljug
         a0OLVKZ/7PQJR5R7E3RKI2XKwrc1mMkHRM59qMBmikYb2xE8be3sujuuFxSBqbcCpSey
         /Zg5tyMdQLZwjJBtlW8aPDIfFDumUUWil9nmPuxz+frZ5NS7nVJpHw9b+J1zVaEdUSut
         xgjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Q8D4OzWKUNx15CbGcAR0w+lXslLK9LxZvOQg2mf4Bjo=;
        b=UXPcQ2MoNQfYproKv2DNeOut5uq83SqnEQo4pF00AOBfG2+3ak3KqZ6pS5VYxKaasG
         moEW739mxeqVaCiAR99j3oiZouuuIWjJXTO8Pf8L2pcp9a4oIp1BLJHxVlC1b1bjJXC3
         /YnZPccSdcqhDjncyM8E7i4MZ0ky/FMwHd+NGx3mAFQ4Rf0KDPDSUYEY4gpnP7vgrMwf
         Yo7hYLQEOwdTDu6EwBXFcFEORqs+YV1+1DRbaCSJlWbZy74W9UG5MT/lRkOBAw7wA2QW
         EzX3osYHRfOl2tUd4l4bSRLou+XKJI35UIA/09f6Bo19uhv3N0cUZRTo0QecNeb/k2/+
         6y/Q==
X-Gm-Message-State: AOAM531loMWoN8gMGZcaTf9lFArJOc9BHD6Zd7XK7hxs0gjt2tngAQiW
        48vQJcIkbj0BNqqHjeJWNRpj5tN0DI3egHL4Zz8VvQ==
X-Google-Smtp-Source: ABdhPJxV/TbXAm0yAAIroekjkwiu99+kRlWBsYwUa/sFYrb8OKc4ws3IR2Q0YCNpxmOBrzvQGW99WZDvD4EsXUA5oJg=
X-Received: by 2002:a7b:ce0e:: with SMTP id m14mr592417wmc.160.1598294361125;
 Mon, 24 Aug 2020 11:39:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAM7CaVQf-xymnx8y-nn7E3N6P5=-HF2i_1XhFgp1MZB1==WZiA@mail.gmail.com>
 <6be0e30c-e9ec-17ea-968b-6ec5a9559dac@gmail.com>
In-Reply-To: <6be0e30c-e9ec-17ea-968b-6ec5a9559dac@gmail.com>
From:   Priyaranjan Jha <priyarjha@google.com>
Date:   Mon, 24 Aug 2020 11:39:10 -0700
Message-ID: <CAAkXG4f5YvZKxQ+2SgcOTwJ1ToGUQnCuSnOBZsXTke+fLcE_WA@mail.gmail.com>
Subject: Re: Request for backport of 78dc70ebaa38aa303274e333be6c98eef87619e2
 to 4.19.y
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     =?UTF-8?Q?Robert_Bengtsson=2D=C3=96lund?= 
        <robert.bengtsson-olund@intinor.se>, netdev@vger.kernel.org,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you, Eric, Robert.
We will try to provide the backport for the patch soon.

Thanks,
Priyaranjan

(resending since previous reply bounced back)
On Mon, Aug 24, 2020 at 9:14 AM Eric Dumazet <eric.dumazet@gmail.com> wrote=
:
>
>
>
> On 8/24/20 7:35 AM, Robert Bengtsson-=C3=96lund wrote:
> > Hi everyone
> >
> > We stumbled upon a TCP BBR throughput issue that the following change f=
ixes.
> > git: 78dc70ebaa38aa303274e333be6c98eef87619e2
> >
> > Our issue:
> > We have a transmission that is application limited to 20Mbps on an
> > ethernet connection that has ~1Gbps capacity.
> > Without this change our transmission seems to settle at ~3.5Mbps.
> >
> > We have seen the issue on a slightly different network setup as well
> > between two fiber internet connections.
> >
> > Due to what the mentioned commit changes we suspect some middlebox
> > plays with the ACK frequency in both of our cases.
> >
> > Our transmission is basically an RTMP feed through ffmpeg to MistServer=
.
> >
> > Best regards
> > /Robert
> >
>
> Please always CC patch authors in this kind of requests.
>
> Thanks.
>
> Patch was :
>
> commit 78dc70ebaa38aa303274e333be6c98eef87619e2
> Author: Priyaranjan Jha <priyarjha@google.com>
> Date:   Wed Jan 23 12:04:54 2019 -0800
>
>     tcp_bbr: adapt cwnd based on ack aggregation estimation
>
>     Aggregation effects are extremely common with wifi, cellular, and cab=
le
>     modem link technologies, ACK decimation in middleboxes, and LRO and G=
RO
>     in receiving hosts. The aggregation can happen in either direction,
>     data or ACKs, but in either case the aggregation effect is visible
>     to the sender in the ACK stream.
>
>     Previously BBR's sending was often limited by cwnd under severe ACK
>     aggregation/decimation because BBR sized the cwnd at 2*BDP. If packet=
s
>     were acked in bursts after long delays (e.g. one ACK acking 5*BDP aft=
er
>     5*RTT), BBR's sending was halted after sending 2*BDP over 2*RTT, leav=
ing
>     the bottleneck idle for potentially long periods. Note that loss-base=
d
>     congestion control does not have this issue because when facing
>     aggregation it continues increasing cwnd after bursts of ACKs, growin=
g
>     cwnd until the buffer is full.
>
>     To achieve good throughput in the presence of aggregation effects, th=
is
>     algorithm allows the BBR sender to put extra data in flight to keep t=
he
>     bottleneck utilized during silences in the ACK stream that it has evi=
dence
>     to suggest were caused by aggregation.
>
>     A summary of the algorithm: when a burst of packets are acked by a
>     stretched ACK or a burst of ACKs or both, BBR first estimates the exp=
ected
>     amount of data that should have been acked, based on its estimated
>     bandwidth. Then the surplus ("extra_acked") is recorded in a windowed=
-max
>     filter to estimate the recent level of observed ACK aggregation. Then=
 cwnd
>     is increased by the ACK aggregation estimate. The larger cwnd avoids =
BBR
>     being cwnd-limited in the face of ACK silences that recent history su=
ggests
>     were caused by aggregation. As a sanity check, the ACK aggregation de=
gree
>     is upper-bounded by the cwnd (at the time of measurement) and a globa=
l max
>     of BW * 100ms. The algorithm is further described by the following
>     presentation:
>     https://datatracker.ietf.org/meeting/101/materials/slides-101-iccrg-a=
n-update-on-bbr-work-at-google-00
>
>     In our internal testing, we observed a significant increase in BBR
>     throughput (measured using netperf), in a basic wifi setup.
>     - Host1 (sender on ethernet) -> AP -> Host2 (receiver on wifi)
>     - 2.4 GHz -> BBR before: ~73 Mbps; BBR after: ~102 Mbps; CUBIC: ~100 =
Mbps
>     - 5.0 GHz -> BBR before: ~362 Mbps; BBR after: ~593 Mbps; CUBIC: ~601=
 Mbps
>
>     Also, this code is running globally on YouTube TCP connections and pr=
oduced
>     significant bandwidth increases for YouTube traffic.
>
>     This is based on Ian Swett's max_ack_height_ algorithm from the
>     QUIC BBR implementation.
>
>     Signed-off-by: Priyaranjan Jha <priyarjha@google.com>
>     Signed-off-by: Neal Cardwell <ncardwell@google.com>
>     Signed-off-by: Yuchung Cheng <ycheng@google.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
>
