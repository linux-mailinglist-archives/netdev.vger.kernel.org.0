Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21DF82E16CC
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 04:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731692AbgLWDCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 22:02:22 -0500
Received: from mail-ot1-f48.google.com ([209.85.210.48]:35038 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731679AbgLWDCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 22:02:21 -0500
Received: by mail-ot1-f48.google.com with SMTP id i6so13905392otr.2;
        Tue, 22 Dec 2020 19:02:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4u37ms/Si9A3oB8jAQflb1Vh60Vfp1JUY9iDInmV/gY=;
        b=MXTTvpuN8oOFcT7sj3B+MWTW/q3LvurO6rkB+EWt7zXGcPJA8KkcLnxOsfGfdLsxcv
         /XTGTG1RY+sirGou6wciGblYKilWB2A+dpKv+CKyssVajUXNpkNXzsFA33nPVKkDjyVu
         ymcZCc7Rmb42Mtsu/oirY4k2ET5P77TdN4Mq5wpN4BltQ4P8zq4/QWgoJ6Sp7ZPcAe4S
         UcltJG902k0LOAgzki7kf2o+ZwS5wsxXILtaknmK315FV881qCiheb7cC+xQmBgC6X/Y
         JPmdphOkcNhAhHZ/IoRwdXsJQ9UIs9/kJ+2arGP+eD67zgA0RrRDQUcCU4P3m+lNEF2r
         voSw==
X-Gm-Message-State: AOAM532r7xUYDXT7XkwHITIf9gwdU+Ue8kU3hE/Rz/O+SBtKVEJ8icrg
        J/sogbAIppHeiQwfil9Q74MTcN8B2A3SEQ45PVkupMabOo4=
X-Google-Smtp-Source: ABdhPJyTeqgVBJqtPHr0GmZiGICS0iBY56imQUhCmgOeTkrnuiYOiEtoaEw8DB6J60eZ/0/rLjvoeUovyVxMiVX1WR0=
X-Received: by 2002:a05:6830:578:: with SMTP id f24mr16194360otc.7.1608692500429;
 Tue, 22 Dec 2020 19:01:40 -0800 (PST)
MIME-Version: 1.0
References: <3a9b2c8c275d56d9c7904cf9b5177047b196173d.camel@neukum.org>
 <20201219222140.4161646-1-roland@kernel.org> <20201222184926.35382198@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201222184926.35382198@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Roland Dreier <roland@kernel.org>
Date:   Tue, 22 Dec 2020 19:01:23 -0800
Message-ID: <CAG4TOxM0BJ4TcVfcqx1E6r-ozgVGrLfFWzgxuqyGtTSiVvNpXQ@mail.gmail.com>
Subject: Re: cdc_ncm kernel log spam with trendnet 2.5G USB adapter
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Oliver Neukum <oliver@neukum.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 6:49 PM Jakub Kicinski <kuba@kernel.org> wrote:

> I'm not sure what the story here is but if this change is expected to
> get into the networking tree we'll need a fresh posting. This sort of
> scissored reply does not get into patchwork.

OK, will resend.  Too bad about patchwork, "git am" drops everything
before scissors lines by default.

> It sounds like you're getting tens of those messages a second, we can
> remove the message but the device is still generating spurious events,
> wasting CPU cycles. Was blocking those events deemed unfeasible?

I certainly don't know enough about the USB CDC class to know why the
spurious messages are showing up or whether they could be suppressed
without a fix in the adapter firmware.  But even ~30 spurious messages
per second doesn't seem so bad for a multi-gig adapter that might be
handling 100,000 or more packets per second.

 - R.
