Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A522600EE
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730362AbgIGQ4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730839AbgIGQ4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 12:56:34 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A67C061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 09:56:32 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id l4so13019781ilq.2
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 09:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gIeclJNQfaoTYUatA0Pf0vpvZFqloC6JAx+vN+VnncQ=;
        b=L4xq4KbrRuL5mZY07VY0SfgPi1v9tAzQZbgDIUMHd7E2P4OCti39LsgqhYQrwfxNze
         F5NZ2n/jnQ8autD37gmvtxqc/eVdqn9AQf014LD53DpJLq+wRYY4wzPhBBpt6O/uTLQR
         SXFQrbymqhaC8rHuzCzi5PRYwoGVaAjpDXEI61ehpzIfU+7ZI+pibW2oO1WTvpnFxOf1
         GRuHVC1To3R/fGRKiI2HCDRBnjq8gNwZdDOxsQ73Kzy7RVjYusNrMnyt7sIvIG1OHALA
         0X4Tx7aQXONUaQDux+76MOtiYG+3xpIf4FisUgRNO8FTEjNyzdjAEpFAgKMtXec2JfhX
         zliQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gIeclJNQfaoTYUatA0Pf0vpvZFqloC6JAx+vN+VnncQ=;
        b=hVijrkHSjpYrmYeP83l+JgZGGBkwj+X4VD4aVScEHX297MEFm/uo0YZVlLEfLrjMVM
         7yAYEINw48kbAuLJvywxjl/SMP25ZhLzNIl6NLGD4AGdk1DE9ctlDuBSB2gK0bHh9Eeg
         WmgvmjmZC/A6+FjzoKLs6sGNc1j8RSf07kkUF7zMBXmdc/dmVdo7kpwH8Ozo4B/PqUGi
         NfdZ8YtgpRnLjZS9jwDizgyYW5bssOFcmbiopZGXR5xPe4pUuPKdOEO9b/786hXq65ZK
         ZY9HfvzGLZuaWkrQgYMd10SWRqO1vBWbQTZoeO1kSqA/q1GZsqn/xQe8K//Vuw6s0nVI
         3Cxw==
X-Gm-Message-State: AOAM532VAKKXYprCUimDtOGZLdX0ztlFTfom0Wh5YK6JnUVMSdY1R9Z/
        a0oyifmXjqh2EdEbADCmBknJyzocTtfKKL0L6JB2Wg==
X-Google-Smtp-Source: ABdhPJw7JuQVJ/9zn3b7UmQeHiwZqa4KkElAgoNPgbllVULdzq9qQMHPhDFgxVkIf86Q093aADu8FPSQPwa7MuTOLhA=
X-Received: by 2002:a92:2c0f:: with SMTP id t15mr19975935ile.205.1599497791872;
 Mon, 07 Sep 2020 09:56:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200903140714.1781654-1-yyd@google.com> <20200907125312.evg6kio5dt3ar6c6@lion.mk-sys.cz>
In-Reply-To: <20200907125312.evg6kio5dt3ar6c6@lion.mk-sys.cz>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 7 Sep 2020 18:56:20 +0200
Message-ID: <CANn89iKZ19+AJOf5_5orPrUObYef+L-HrwF_Oay6o75ZbG7UhQ@mail.gmail.com>
Subject: Re: [PATCH ethtool,v2] ethtool: add support show/set-time-stamping
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     "Kevin(Yudong) Yang" <yyd@google.com>,
        netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 7, 2020 at 2:53 PM Michal Kubecek <mkubecek@suse.cz> wrote:
>
> On Thu, Sep 03, 2020 at 10:07:14AM -0400, Kevin(Yudong) Yang wrote:
> > Before this patch, ethtool has -T/--show-time-stamping that only
> > shows the device's time stamping capabilities but not the time
> > stamping policy that is used by the device.
> >
> > This patch adds support to set/get device time stamping policy at
> > the driver level by calling ioctl(SIOCSHWTSTAMP).
> >
> > Tested: ran following cmds on a Mellanox NIC with mlx4_en driver:
> > ./ethtool -T eth1
> > ...
> > Hardware Transmit Timestamp Modes:
> >         off                   (HWTSTAMP_TX_OFF)
> >         on                    (HWTSTAMP_TX_ON)
> > Hardware Receive Filter Modes:
> >         none                  (HWTSTAMP_FILTER_NONE)
> >         all                   (HWTSTAMP_FILTER_ALL)
> > Hardware Timestamping Policy:
> >         Rx filter 0, none                  (HWTSTAMP_FILTER_NONE)
> >         Tx type 0, off                   (HWTSTAMP_TX_OFF)
> >
> > ./ethtool --set-time-stamping eth1 rx 1; ./ethtool -T eth1;
> > ...
> > Hardware Timestamping Policy:
> >       Rx filter 1, all                   (HWTSTAMP_FILTER_ALL)
> >       Tx type 0, off                   (HWTSTAMP_TX_OFF)
> >
> > ./ethtool --set-time-stamping eth1 rx 1 tx 1; ./ethtool -T eth1;
> > rx unmodified, ignoring
> > ...
> > Hardware Timestamping Policy:
> >       Rx filter 1, all                   (HWTSTAMP_FILTER_ALL)
> >       Tx type 1, on                    (HWTSTAMP_TX_ON)
> >
> > ./ethtool --set-time-stamping eth1 rx 0; ./ethtool -T eth1;
> > ...
> > Hardware Timestamping Policy:
> >       Rx filter 0, none                  (HWTSTAMP_FILTER_NONE)
> >       Tx type 1, on                    (HWTSTAMP_TX_ON)
> >
> > ./ethtool --set-time-stamping eth1 tx 0; ./ethtool -T eth1
> > ...
> > Hardware Timestamping Policy:
> >       Rx filter 0, none                  (HWTSTAMP_FILTER_NONE)
> >       Tx type 0, off                   (HWTSTAMP_TX_OFF)
> >
> > ./ethtool --set-time-stamping eth1 rx 123 tx 456
> > rx should be in [0..15], tx should be in [0..2]
> >
> > Signed-off-by: Kevin Yang <yyd@google.com>
> > Reviewed-by: Neal Cardwell <ncardwell@google.com>
> > Reviewed-by: Eric Dumazet <edumazet@google.com>
> > ---
>
> As I said in response to v1 patch, I don't like the idea of adding a new
> ioctl interface to ethool when we are working on replacing and
> deprecating the existing ones. Is there a strong reason why this feature
> shouldn't be implemented using netlink?

I do not think this is a fair request.

All known kernels support the ioctl(), none of them support netlink so far.

Are you working on the netlink interface, or are you requesting us to
implement it ?

The ioctl has been added years ago, and Kevin patch is reasonable enough.

Thank you.
