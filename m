Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4723E439D1A
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234597AbhJYRLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235717AbhJYRKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 13:10:09 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616FBC029833
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 10:04:46 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id i189so16528940ioa.1
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 10:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lgdXiqDvxgu+xZfGtPCHM8GTcNnXqfqcjwou73pLEj0=;
        b=WqCS8EOKVKaAXCsDsVRNwvOzKc2IisLjY0EvIIedu5Sm2CVuSfh/O5qja3aRLJ5Np7
         faKQPPkbIYr2ELZR1G9zPSoy95gqqaZqjwsO63gBJWmcgW0xCUbCL4RSTIL3HmY77e6A
         UsDd5xqa5m+QUKH+H7z/O65X14AchAZWsW7BBM+D/jEpcyMZLiBPyOXy0dAJqjAd0bPM
         HH/lZd8Gpiy19ImLvC8uDi6Ye+NlPNpdliao8SudX/38Y1NxdLEn93vFjdB9uC0bRLOx
         Qv0PGhqOtkMzqqKIgilSalRkChnG/qmG/5H5sSKkHwFPsrrJJgHgDGe7bf/RXmrWe0sE
         Mvqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lgdXiqDvxgu+xZfGtPCHM8GTcNnXqfqcjwou73pLEj0=;
        b=65y5VFM0g12nmpY6p69O/G/VU96A0MW3vbOkZhQ+ZBryEWIBSvLTbFlNJL2hKf/lyk
         XtJ0nhiwR+2UMB3mHyctY/DbCUKxlJdbokP/MFOQ/f6xqvZmGBRT+UE3d/s/QuCdW9XE
         +CW3fVWA2SZ76BbVMbMLMT+aeTNBgA5R0UUYX41vGKfn/nNtA6362KSn4sZOrSBMpG1q
         AsyI5Z/ZyeIOe5YQQTWZc0f5SN9FzHnY86Hnoy6vUeKQnwbTvOo79sMtJ/dCUK8APB6y
         NKhLl4FMLwcYsNHcn21m++6sjZY3SbFS2aXBkFqoR515jQidjCLqrk49Kxbz634mgR52
         aH6Q==
X-Gm-Message-State: AOAM530y0IoVgz0jHs2vTbD8QFz1SKjTzrvS3Nwp72rElYZwYVBVsGpn
        LEY0GJI3//l/r39Fw8TVnudYKS7XESZkXWQnOxbQjw==
X-Google-Smtp-Source: ABdhPJwMvNRNZFOYHIVw8UjsFK1rCkFF2HiOPsWBwZObCa0+GbWkXZsoj7iKLoRz+YUrhiXfcOyMJPkfghpEzNF0vAw=
X-Received: by 2002:a05:6602:148b:: with SMTP id a11mr11745957iow.85.1635181485832;
 Mon, 25 Oct 2021 10:04:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAOhMmr7bWv_UgdkFZz89O4=WRfUFhXHH5hHEOBBfBaAR8f4Ygw@mail.gmail.com>
 <CA+h21hqrX32qBmmdcNiNkp6_QvzsX61msyJ5_g+-FFJazxLgDw@mail.gmail.com> <YXY15jCBCAgB88uT@d3>
In-Reply-To: <YXY15jCBCAgB88uT@d3>
From:   Slade Watkins <slade@sladewatkins.com>
Date:   Mon, 25 Oct 2021 13:04:34 -0400
Message-ID: <CA+pv=HPyCEXvLbqpAgWutmxTmZ8TzHyxf3U3UK_KQ=ePXSigBQ@mail.gmail.com>
Subject: Re: Unsubscription Incident
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Lijun Pan <lijunp213@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 12:43 AM Benjamin Poirier
<benjamin.poirier@gmail.com> wrote:
>
> On 2021-10-22 18:54 +0300, Vladimir Oltean wrote:
> > On Fri, 22 Oct 2021 at 18:53, Lijun Pan <lijunp213@gmail.com> wrote:
> > >
> > > Hi,
> > >
> > > From Oct 11, I did not receive any emails from both linux-kernel and
> > > netdev mailing list. Did anyone encounter the same issue? I subscribed
> > > again and I can receive incoming emails now. However, I figured out
> > > that anyone can unsubscribe your email without authentication. Maybe
> > > it is just a one-time issue that someone accidentally unsubscribed my
> > > email. But I would recommend that our admin can add one more
> > > authentication step before unsubscription to make the process more
> > > secure.
> > >
> > > Thanks,
> > > Lijun
> >
> > Yes, the exact same thing happened to me. I got unsubscribed from all
> > vger mailing lists.
>
> It happened to a bunch of people on gmail:
> https://lore.kernel.org/netdev/1fd8d0ac-ba8a-4836-59ab-0ed3b0321775@mojatatu.com/t/#u

I can at least confirm that this didn't happen to me on my hosted
Gmail through Google Workspace. Could be wrong, but it seems isolated
to normal @gmail.com accounts.

Best,
             -slade
