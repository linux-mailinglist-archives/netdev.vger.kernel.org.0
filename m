Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCDA423F96
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 15:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238027AbhJFNu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 09:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238012AbhJFNuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 09:50:25 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D6EC061749
        for <netdev@vger.kernel.org>; Wed,  6 Oct 2021 06:48:33 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id 66so2946252vsd.11
        for <netdev@vger.kernel.org>; Wed, 06 Oct 2021 06:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f1BakAplYMB4a4n6E6XHwcsoRqox7iup+XH7aypy+bI=;
        b=DKOlZEGSFyM1LgT8fwDWd2BqKO8Gon2W3PRNoRiEIGr+uOyujxwtw2K2kpS5YMT8Yv
         BSQbVUSMfuaxM3rQieBKmT8XHJAiB/SR/YxBdMZ3Vpij1aMg5BXwn7QnjftgbSMafyHn
         nt5N/aBeko1LDa/frbcSiQDp8i43AAs3gAM+qTq2zf9dJPcND+4hX6e7SORMhVjmunnC
         UFnLJMwwno3dnsYQ0m2TYbDBhe0+H89A3sBvMIK+Pew1wl1CE5Gq7L81qGgnCo47X639
         rmjPwnfecBdciUgvyYpJNTpuJzee/5UGeE1TDhtr/AAcLuINVjAGVQeuCfyfuuxAwd9W
         U9Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f1BakAplYMB4a4n6E6XHwcsoRqox7iup+XH7aypy+bI=;
        b=TCEtwSTVKw2M76td595De0sIEPcVxLAo02gECEKl8QJz3idgV3qT53syCABDeUYVjb
         wO4t955Hx7edYmybiuD+7yeVaYS6M2FTMBdPVYPXIEgBeZdIJEo9J92td0L8nm7UDHGK
         SZlTJMrVe8uS0LhkEijlfUL4DZCX81tCjAgiix9Vlub3iTA53J/ActecXs/hJMz2npnS
         6O69R3JIX8JlJi1xoXX49cnR37CI0pqAqWHUQkGUZa6tMQT6YA82UPI6tlfBQAmj6ohC
         vJwmyVEVR5Gru0m5PLIF2PyBSPg30bBERNq7Y24TfupApO7ifFRo8wcSsK4D/3+MwzqF
         m51A==
X-Gm-Message-State: AOAM531q2dzFGipU6Ju65S5eM2hWjp0KROvtEv1Pd96KoPBwDHHpXvgf
        QJGgCjsBb9EUMYA+xK0paFyvJmzhmzSJdWqVZSnm2QUt
X-Google-Smtp-Source: ABdhPJwz/Ob8B+4kN0hVspROm9DWEDP7+//Dh5cDSB5u9OGfjWQNUh1RBU5mcjwFEj2qJuGTe97BAbnrhj5KApGmKIw=
X-Received: by 2002:a67:e416:: with SMTP id d22mr23220193vsf.41.1633528112549;
 Wed, 06 Oct 2021 06:48:32 -0700 (PDT)
MIME-Version: 1.0
References: <1633504726-30751-1-git-send-email-sbhatta@marvell.com> <20211006064328.28a5da0a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211006064328.28a5da0a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Wed, 6 Oct 2021 19:18:20 +0530
Message-ID: <CALHRZuoryTs0ApwY=ubX7GHja826QnACMUePyfw2KHmhYaQq1Q@mail.gmail.com>
Subject: Re: [net-next PATCH v2 0/3] Add devlink params to vary cqe and rbuf
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Subbaraya Sundeep <sbhatta@marvell.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Wed, Oct 6, 2021 at 7:14 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 6 Oct 2021 12:48:43 +0530 Subbaraya Sundeep wrote:
> > Octeontx2 hardware writes a Completion Queue Entry(CQE) in the
> > memory provided by software when a packet is received or
> > transmitted. CQE has the buffer pointers (IOVAs) where the
> > packet data fragments are written by hardware. One 128 byte
> > CQE can hold 6 buffer pointers and a 512 byte CQE can hold
> > 42 buffer pointers. Hence large packets can be received either
> > by using 512 byte CQEs or by increasing size of receive buffers.
> > Current driver only supports 128 byte CQEs.
> > This patchset adds devlink params to change CQE and receive
> > buffer sizes which inturn helps to tune whether many small size
> > buffers or less big size buffers are needed to receive larger
> > packets. Below is the patches description:
>
> nak. Stop ignoring feedback and reposting your patches.
Sure and noted.

Thanks,
Sundeep
