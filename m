Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3945823C174
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 23:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbgHDV2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 17:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728052AbgHDV2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 17:28:40 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D15DC06174A;
        Tue,  4 Aug 2020 14:28:40 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id p13so7090232ilh.4;
        Tue, 04 Aug 2020 14:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ciaZt6EUILZyIz2M0YERVxMKuRp4SLQkkYv0ULi+inU=;
        b=eN5rCaEl1qMzAhoNDilXB5ze5enUX9BcHPQHnaY/TMxXvCxeMm1MUisX+SGPuU0vFI
         CIeeNKvHPIt5EdHRwi2BH0hH7I+b8oHLI4SuYcg0lwTJRLTm4IZl16PE0I5Yh4fmUs9G
         tmYhAK2BrAj9BIU+RHeEryqpwDrWLh3hOFv1MjSmZk1YY5i7pH3Z5oxhnWXpBr/lfe41
         hOoFdp8Eu3PFtk1b0rlLnHj0ycv80EGegnQ8BkSzVLDP9RrqykOvQY09skxsyaIHLYiY
         zOz74gPopuR6dnJ6Z//C7xoi8+NYqcgJWWolhzRefJNne/btdmnOsLyQzl3WsBgjdqf8
         /Y/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ciaZt6EUILZyIz2M0YERVxMKuRp4SLQkkYv0ULi+inU=;
        b=A2lOJY/KHmRzuuwbbnMZFEfBeqUl2DifQZwPi9S6R4oEO7ZUgsn8a+MA9KEjlBU/r/
         OXAd9YWDaL8yFNog2QKAjw398t7iK7ZfyvWxsOsW8PDtKlrku091bFVXSNuUhUf/LQov
         l9q1D6sV/1/up/LJR+dRAlTfRLZ3HlrSgYSsDht3EPMuNDnTbdYtGetY9j3516+CYyDR
         pioayM3h4qxAgKKwQVU9T9E+0HBu1XhcPLliWmgvQ5yUSt+wSc2tsJv4PejvJKad+cLL
         13dz5w5T2jnI9qziLpG090j7qY9k0eBJm04LV4sc3vCQjGVDxClg+fbdudVzTVIxrqT5
         iQ5g==
X-Gm-Message-State: AOAM532QT6GI6g652e7O+MuoRHq64sgpomHr1I6Wnc8mTZOjkbWmqQCK
        v2OMXfHrmWAiYlMGndwci6Xn3G2W9YnfCIwUdNo=
X-Google-Smtp-Source: ABdhPJyOUlBXAgb/u6T90sJc4Ntbg8WLxywWFpuKjtfpKmPNerVARBP3L8KPF1FRXNN6ilgFF2m96jZ3uNYxbrPL6ko=
X-Received: by 2002:a92:9116:: with SMTP id t22mr417064ild.305.1596576519697;
 Tue, 04 Aug 2020 14:28:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200707171515.110818-1-izabela.bakollari@gmail.com> <20200804160908.46193-1-izabela.bakollari@gmail.com>
In-Reply-To: <20200804160908.46193-1-izabela.bakollari@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 4 Aug 2020 14:28:28 -0700
Message-ID: <CAM_iQpV-AfX_=o0=ZhU2QzV_pmyWs8RKV0yyMuxFgwFAPwpnXw@mail.gmail.com>
Subject: Re: [PATCHv2 net-next] dropwatch: Support monitoring of dropped frames
To:     izabela.bakollari@gmail.com
Cc:     Neil Horman <nhorman@tuxdriver.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 4, 2020 at 9:14 AM <izabela.bakollari@gmail.com> wrote:
>
> From: Izabela Bakollari <izabela.bakollari@gmail.com>
>
> Dropwatch is a utility that monitors dropped frames by having userspace
> record them over the dropwatch protocol over a file. This augument
> allows live monitoring of dropped frames using tools like tcpdump.
>
> With this feature, dropwatch allows two additional commands (start and
> stop interface) which allows the assignment of a net_device to the
> dropwatch protocol. When assinged, dropwatch will clone dropped frames,
> and receive them on the assigned interface, allowing tools like tcpdump
> to monitor for them.
>
> With this feature, create a dummy ethernet interface (ip link add dev
> dummy0 type dummy), assign it to the dropwatch kernel subsystem, by using
> these new commands, and then monitor dropped frames in real time by
> running tcpdump -i dummy0.

drop monitor is already able to send dropped packets to user-space,
and wireshark already catches up with this feature:

https://code.wireshark.org/review/gitweb?p=wireshark.git;a=commitdiff;h=a94a860c0644ec3b8a129fd243674a2e376ce1c8

So what you propose here seems pretty much a duplicate?

Thanks.
