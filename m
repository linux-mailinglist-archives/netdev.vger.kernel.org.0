Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD486202AEB
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 15:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730134AbgFUN7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 09:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729649AbgFUN7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 09:59:08 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C0BC061794;
        Sun, 21 Jun 2020 06:59:08 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id i25so16774522iog.0;
        Sun, 21 Jun 2020 06:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vewurYL4RT3PvWQlki3nCvTIJMlXg35oGMx6lZeoqnQ=;
        b=Ig1fa5DB6SeYcM+hYKkE99p+3/vtG3Fthf56KEPUiUxC/c978WNjcoM0qPl1MHcWmV
         NtvJHsF0Dxok/k4FanZWpn/GcS+5wxqcJdRaoYjtqgGrZ2Pwbho2UvVJQaQZxmt1uTFP
         zi2a19v83PEYobt3kTCxdIgttxxUO/efojSw8NnlAwM7/3KlsEbUhpLLhEvDocrHKf/3
         tfVtculHMkMtQmBH2fLwPvD8T7Y+WWEFtzWg13p5k/72CezWXul4zS5ye9Oljtwc+2yd
         QnuC1sbaug6H/LCAyfYpPR4J2PZFgJHZkHQosks3gr9PL+s0hYORDmqHa1sUORd14REA
         BWKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vewurYL4RT3PvWQlki3nCvTIJMlXg35oGMx6lZeoqnQ=;
        b=H9OUxTyMxGy+fp55OdJEYCjKsOzbh0CS0Fu2sYIHeVYXdYRaw3c8TcVYfSK+ph7PHg
         qFKxfCSx66SI+HO0wZx/GtmzKeEgicPxijWyer9n3u5WztueFw5zumrr6idrxPGjx8Ag
         wLJjNcgYY6Jzv+3KDaO0hwivHwK53tqLJvUUbQk26wUrTWUZgVlE9yhgaELCIBxQd+Q6
         oBtgesfSKUYjfLwmaKfcsKNVA08BzFbPBpLCMHYmjZYi2rmrzgvv+xpCVXayuxxnkO3o
         D4qgrtmMo7wHGKPyE3jvLB1G+hQnXDpCn1KnCcCV7S29j7nYbqKvZqDrBzhp0xqoOkrd
         sqpA==
X-Gm-Message-State: AOAM530Km01aDevwdKmqZcmTp+feKtiINOOM3zaMdyns6vFYKB6TWXeQ
        k4mkW1v0sSygb9debxW5pj2oayrHFNsecjryV1L0O1Wcgyo=
X-Google-Smtp-Source: ABdhPJx6FfnBE+hglRYT/TBZHWM9Gh2Mshx5cImM9LIkZNmDKbt1yczIAVJ4UaTA7z/kTr1TTqzGByD4aqT+zz0+xQw=
X-Received: by 2002:a6b:b5d1:: with SMTP id e200mr14321200iof.191.1592747947123;
 Sun, 21 Jun 2020 06:59:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200621084512.GA720@nautica> <20200621135312.78201-1-alexander.kapshuk@gmail.com>
 <20200621135623.GA20810@nautica>
In-Reply-To: <20200621135623.GA20810@nautica>
From:   Alexander Kapshuk <alexander.kapshuk@gmail.com>
Date:   Sun, 21 Jun 2020 16:58:30 +0300
Message-ID: <CAJ1xhMXbhVyh6Ut86cZtssbYR6q_t6tiaJFCdb-FoX1FrSaOAA@mail.gmail.com>
Subject: Re: [PATCH] net/9p: Validate current->sighand in client.c
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     lucho@ionkov.net, ericvh@gmail.com, davem@davemloft.net,
        kuba@kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 21, 2020 at 4:56 PM Dominique Martinet
<asmadeus@codewreck.org> wrote:
>
> Alexander Kapshuk wrote on Sun, Jun 21, 2020:
> > Fix rcu not being dereferenced cleanly by using the task
> > helpers (un)lock_task_sighand instead of spin_lock_irqsave and
> > spin_unlock_irqrestore to ensure current->sighand is a valid pointer as
> > suggested in the email referenced below.
>
> Ack.
> I'll take this once symbol issue is resolved ; thanks for your time.
>
> --
> Dominique

Noted.
Thanks.
