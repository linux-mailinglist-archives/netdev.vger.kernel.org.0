Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE6DF19165F
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 17:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbgCXQ1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 12:27:34 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43096 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728180AbgCXQ1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 12:27:33 -0400
Received: by mail-qt1-f196.google.com with SMTP id a5so8239898qtw.10
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 09:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tlapnet.cz; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BWu1zcR/bT21mohqpxDblPAYHiybhVc6xLLKtFFb1E0=;
        b=EeBAIYNpWsxWeFE9nfoAAuXrQoZyNiQ4AJ7LYdYJRwAOV1R5mevYiH9oe0YQZlZr7l
         V1Q6AWFvOkn42rMli7QZp4vqlhVhwLO2iMZ/sJfFweF01fOv0a2jb3k+mZzmZ7BOJQVc
         PUXOPLPZrz9lBuXzwl1hlsqittRdVJJli0VAXQCMTd6c01CT5aRIow3KPISlFaX99673
         qLWamqu8XdpoQ25EnTnA7spuETLsPN1syIsWzRwzw+O7vznQTYFhUNtKDVhcbCWhtfgb
         hGGGYIohVT38KtFiVIxzIlRAppb04Fj7RWSEoEWKPGUlDaUxD8XaX2PKdUkuGjB9fUtd
         JQPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BWu1zcR/bT21mohqpxDblPAYHiybhVc6xLLKtFFb1E0=;
        b=LUeoSExi3bHf5vd+JKF3CAGNpaGh9/1x5SIe+i6KE9mrao6C3xZXgdOf6BfxtkS59T
         ml6ngut2azcjGsu1QaSzU9xdtZLBZ7ouxRrKCrIsddjcTxlAYcZfijnfzXoxiYRyzB/E
         sITkbkUmdF3dpPKc6OFCkulz4kEFad2cFUgnW+iNIL07GLUPNnrOdNFaUQdsD9PttTiT
         6Pn88rIk8vaW3zdo/902a+iEO457vlmEYqpxJ8Re6eToe2+A0PCw/igUkSzgenRVKYeX
         DKZeqwJGZDi4SATkwaM9wJTRxLsv4Fo6NMAnPGOb2+475C4/hmR9NKZKHcnAopoxcMo2
         2SoA==
X-Gm-Message-State: ANhLgQ2zymmozjD0ZWy0yo/XGlLdl/BL58/U0N3Qw2c/h+tNLNQhOGPj
        L0THFOnIxWGv28ob/LFQU9Je2NeJAO7V0skY5o6dDA==
X-Google-Smtp-Source: ADFU+vtOdo+8kCKdJs/8iS33yKteeXAIAlIyaOaX3GYnNwXfxny0JJ1A8NNyQfPawv4XyNnTiAXOTHmUhOkvo+tN5Eg=
X-Received: by 2002:ac8:2939:: with SMTP id y54mr26909043qty.160.1585067252011;
 Tue, 24 Mar 2020 09:27:32 -0700 (PDT)
MIME-Version: 1.0
References: <CANxWus8WiqQZBZF9aWF_wc-57OJcEb-MoPS5zup+JFY_oLwHGA@mail.gmail.com>
 <CAM_iQpUPvcyxoW9=z4pY6rMfeAJNAbh21km4fUTSredm1rP+0Q@mail.gmail.com>
In-Reply-To: <CAM_iQpUPvcyxoW9=z4pY6rMfeAJNAbh21km4fUTSredm1rP+0Q@mail.gmail.com>
From:   =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Date:   Tue, 24 Mar 2020 17:27:20 +0100
Message-ID: <CANxWus9HZhN=K5oFH-qSO43vJ39Yn9YhyviNm5DLkWVnkoSeQQ@mail.gmail.com>
Subject: Re: iproute2: tc deletion freezes whole server
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Thank you for the reply!

On Mon, Mar 23, 2020 at 7:18 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > perf trace tc qdisc del dev enp1s0f0 root
>
> Can you capture a `perf record` for kernel functions too? We
> need to know where kernel spent time on during this 11s delay.

See perd.data.{ifb0, enp1s0f0} here
https://github.com/zvalcav/tc-kernel/tree/master/20200324. I hope it
is the output you wanted. If you need anything else, let me know.

> > When I call this command on ifb interface or RJ45 interface everything
> > is done within one second.
>
>
> Do they have the same tc configuration and same workload?

Yes, both reproducers are exactly the same, interfaces are configured
in a similar way. I have the most of the offloading turned off for
physical interfaces. Yet metallic interfaces don't cause that big
delay and SFP+ dual port cards do, yet not all of them. Only
difference in reproducers is the interface name. See git repository
above, tc-interface_name-upload/download.txt files. I have altered my
whole setup in daemon I'm working on to change interfaces used. The
only difference is the existence of ingress tc filter rules to
redirect traffic to ifb interfaces in production setup. I don't use tc
filter classification in current setup. I use nftables' ability to
classify traffic. There is no traffic on interfaces except ssh
session. It behaves similar way with and without traffic.

> > My testing setup consists of approx. 18k tc class rules and approx.
> > 13k tc qdisc rules and was altered only with different interface name....
>
> Please share you tc configurations (tc -s -d qd show dev ..., tc
> -s -d filter show dev...).

I've placed whole reproducers into repository. Do you need exports of rules too?

> Also, it would be great if you can provide a minimal reproducer.

I'm afraid that minor reproducer won't cause the problem. This was
happening mostly on servers with large tc rule setups. I was trying to
create small reproducer for nftables developer many times without
success. I can try to create reproducer as small as possible, but it
may still consist of thousands of rules.
