Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95A8CF6C9E
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 03:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfKKCU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 21:20:26 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:34009 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbfKKCU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 21:20:26 -0500
Received: by mail-oi1-f194.google.com with SMTP id l202so10203298oig.1
        for <netdev@vger.kernel.org>; Sun, 10 Nov 2019 18:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nfsWG4xyw5/l54C2LzZopGrNtf3htxTRkD1pP2aAsKA=;
        b=fcOvJiZVmr6Gf1GxTNxcef7FRuGuCwKNquDJ3WK+l6UFCViOrB9fXRhwbWzqIPYokw
         yg60aVfIQb9pVEssUTFIG5IjOsW0ig6zH/mo4QCvv4lh7ZM3NRR5LELhc6IS9leVNqj7
         6Q5+lImOrvLyZcr1xGppqCUrzT2Dvai1xSGwn75fGbKhI90oc1N6DGCggtratc77rgAZ
         vZ1Ts743VUH80N2HW/OaOhGT9eSq9ZNIv7oCfrqyGCPDqIIGeeoqeX5Kc9EjIOK/p1JA
         vF4Y1PBqSlQ4XKjgQShOv8WK0vaWlsuJwcGdgdE15Vr70Zh3i50CeiPkUOAjXWlb1PIL
         b6wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nfsWG4xyw5/l54C2LzZopGrNtf3htxTRkD1pP2aAsKA=;
        b=AUErddrkX88Nz/YsZ+AhFAw+U1XIH07jKyPnOYi6+UhpCg3C5Rme4QAF+Bq8YOHyb6
         1RtdHLaipqIPLwtbbZYtv9dJMhcEjzFzOK+dG+AdlXWIP5zXrqk1Qr0cwZDdfhy9DZoA
         64Q/ouhi1XwbrtQ6qChaV3b/VLySzo4KW5TbBUAGPnFPqGghsfb6EkgxsIFnxzqKji0l
         LBycAPo4+l9xg/1DhXEwnjyZhHfPnWJ8Lp1CqRqG1AB+VXYOn35YAWgJX1+MQXez6e9c
         2HhvgDQr+MmX5nfdPgM/51DQFNcrOxffKET+ffox8PpepY4shbI22I19LpnO3RAsHoXR
         +1Pg==
X-Gm-Message-State: APjAAAWLtFW0VEhW7HqGB1aBECoX3NBDAYN6TFNC6ZFmHQH6jOTVnZ74
        Thkv6cdW5gEEF2qiKtMGKBKfXDqRm1DpS7r/IEg=
X-Google-Smtp-Source: APXvYqylMQADp6HiT85Nzz6DikUBXpEyNqwndnBgFA/4bfYij2aYk/O9MR19MBEG27Mph2iE9gSg/4VnyCgQ1S+WUqg=
X-Received: by 2002:aca:1a03:: with SMTP id a3mr22314178oia.58.1573438825448;
 Sun, 10 Nov 2019 18:20:25 -0800 (PST)
MIME-Version: 1.0
References: <CAJwzM1k7iW9tJZiO-JhVbnT-EmwaJbsroaVbJLnSVY-tyCzjLQ@mail.gmail.com>
 <0d553faa-b665-14cf-e977-d2b0ff3d763e@gmail.com>
In-Reply-To: <0d553faa-b665-14cf-e977-d2b0ff3d763e@gmail.com>
From:   Avinash Patil <avinashapatil@gmail.com>
Date:   Sun, 10 Nov 2019 18:20:15 -0800
Message-ID: <CAJwzM1kWiSPs0z6_PcZSguJE+4RagTB0Qp2cbyqKpiGabtuknQ@mail.gmail.com>
Subject: Re: Possible bug in TCP retry logic/Kernel crash
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the response, Eric.

I have tested 4.19.80 as well and I see same issue there.  I can run
more tests(for additional data/logs) if needed- let me know.

Best,
Avinash

On Sun, Nov 10, 2019 at 3:48 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 11/9/19 9:59 PM, Avinash Patil wrote:
> > Hi everyone,
> >
> > Kernel: Linux 4.19.35 kernel built from linux-stable
> >
>
> This is quite an old version.
>
> Please upgrade to the latest one.
>
> $ git log --oneline v4.19.35..v4.19.82 -- net/ipv4/tcp*c
> 3fdcf6a88ded2bb5c3c0f0aabaff253dd3564013 tcp: better handle TCP_USER_TIMEOUT in SYN_SENT state
> 67fe3b94a833779caf4504ececa7097fba9b2627 tcp: fix tcp_ecn_withdraw_cwr() to clear TCP_ECN_QUEUE_CWR
> 5977bc19ce7f1ed25bf20d09d8e93e56873a9abb tcp: remove empty skb from write queue in error cases
> 6f3126379879bb2b9148174f0a4b6b65e04dede9 tcp: inherit timestamp on mtu probe
> 1b200acde418f4d6d87279d3f6f976ebf188f272 tcp: Reset bytes_acked and bytes_received when disconnecting
> c60f57dfe995172c2f01e59266e3ffa3419c6cd9 tcp: fix tcp_set_congestion_control() use from bpf hook
> 6323c238bb4374d1477348cfbd5854f2bebe9a21 tcp: be more careful in tcp_fragment()
> dad3a9314ac95dedc007bc7dacacb396ea10e376 tcp: refine memory limit test in tcp_fragment()
> 59222807fcc99951dc769cd50e132e319d73d699 tcp: enforce tcp_min_snd_mss in tcp_mtu_probing()
> 7f9f8a37e563c67b24ccd57da1d541a95538e8d9 tcp: add tcp_min_snd_mss sysctl
> ec83921899a571ad70d582934ee9e3e07f478848 tcp: tcp_fragment() should apply sane memory limits
> c09be31461ed140976c60a87364415454a2c3d42 tcp: limit payload size of sacked skbs
> 6728c6174a47b8a04ceec89aca9e1195dee7ff6b tcp: tcp_grow_window() needs to respect tcp_space()
>
