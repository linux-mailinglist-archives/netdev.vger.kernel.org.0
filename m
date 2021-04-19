Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3803363CDA
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 09:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238008AbhDSHlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 03:41:06 -0400
Received: from mail-ua1-f46.google.com ([209.85.222.46]:40623 "EHLO
        mail-ua1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbhDSHk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 03:40:58 -0400
Received: by mail-ua1-f46.google.com with SMTP id 33so10637237uaa.7;
        Mon, 19 Apr 2021 00:40:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2VIr1L+x0KMjslWLfGf5hIF0vYoVyKryX0VbeLPhjXY=;
        b=LKALPdAQ9SPBJ025H5EYgB2JJmsvxOTF+kHXsHTU34o7eF0cbupVAKx0Pl2Y4ZGxNL
         DbXozQWlITmwPtqxhmbLU/JdK0k30IPYkrvHx9VLvdHT2h1RspTycjEkBxxGbOsqZuaU
         NShSEMFidZtLsAHt+55Cn8TGumibx/o2plGAGEMLA0TOouBH20rxKo2WNbNPrk1pDnWU
         SyecHBqysIu4a9BgeBRxyz1+Wig0maX/QGZoaCPR+nLQPzE2FT2+cJ9FNZ3wVcTvmClM
         5iXX/Nomp9F0c4ubk10keKK1t5EOah9l69616iJC0/CM8gvpHruTSq8I6ZKwtfjbsgj3
         3v3A==
X-Gm-Message-State: AOAM532V+YX/XKccR5yt9//t1CXUJJftMpEgv8PjmxwtAkLiUpglVBE+
        WMbA3haOmQpPm2XNW1J/ZcMHcd4ccJ4fvGw9+sQ=
X-Google-Smtp-Source: ABdhPJwwXmXRA54KsUIVTR+3h20psdWGNGLb0sv7M0Wa6xBFjtt5vw5IgsA9I8yZw3/8pDlvTRTO5cNvRqQf/YEF4l8=
X-Received: by 2002:a9f:3852:: with SMTP id q18mr5818471uad.58.1618818028444;
 Mon, 19 Apr 2021 00:40:28 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1618388989.git.npache@redhat.com> <0fa191715b236766ad13c5f786d8daf92a9a0cf2.1618388989.git.npache@redhat.com>
 <e26fbcc8-ba3e-573a-523d-9c5d5f84bc46@tessares.net> <CABVgOSm9Lfcu--iiFo=PNLCWCj4vkxqAqO0aZT9B2r3Kw5Fhaw@mail.gmail.com>
 <b57a1cc8-4921-6ed5-adb8-0510d1918d28@tessares.net> <CABVgOS=QDATYk3nn1jLHhVRh7rXoTp1+jQhUE5pZq8P9M0VpUA@mail.gmail.com>
In-Reply-To: <CABVgOS=QDATYk3nn1jLHhVRh7rXoTp1+jQhUE5pZq8P9M0VpUA@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 19 Apr 2021 09:40:17 +0200
Message-ID: <CAMuHMdWfYHjNOmPSEbPOJeqniQoCG=8PD8KA8xDWXo3WggdQ_w@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] kunit: mptcp: adhear to KUNIT formatting standard
To:     David Gow <davidgow@google.com>
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        Nico Pache <npache@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Brown <broonie@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>, mptcp@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Sat, Apr 17, 2021 at 6:24 AM David Gow <davidgow@google.com> wrote:
> > Like patch 1/6, I can apply it in MPTCP tree and send it later to
> > net-next with other patches.
> > Except if you guys prefer to apply it in KUnit tree and send it to
> > linux-next?
>
> Given 1/6 is going to net-next, it makes sense to send this out that
> way too, then, IMHO.
> The only slight concern I have is that the m68k test config patch in
> the series will get split from the others, but that should resolve
> itself when they pick up the last patch.

I can apply the m68k test config patch when all other parts have
entered mainline.  Note that I would have made the same changes
myself anyway, on -rc1 defconfig refresh.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
