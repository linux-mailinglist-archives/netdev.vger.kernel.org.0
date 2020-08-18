Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA182490BA
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 00:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgHRWYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 18:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726863AbgHRWYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 18:24:30 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65089C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 15:24:30 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id p13so19035670ilh.4
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 15:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YHnJDIaYf4mdvn9CMDvH3Yk1koBMsbu9mrKzrPqgFBI=;
        b=GYhC+y3/uQD6VHWU2k7VJuj8wOPDAqa0+m347cff9xY+NeIup4ULqlvlUqI6rUacrt
         5rfjfgVjpwn/GmT8Z4C6qmGDUUyMAUPWPkcUX9vIn0l8kto/srL/ZwRPXdNCA2PG4ypg
         E7TCLCvA/Q7b9gpMuK16EtmOyGtPVcs7vb4+GS42Mwb/AWChdtHBsSVhKSNrQbKfZP+H
         CMXjaiS/ny0owiVlZ10LEFzNzb0yqa9YrK2kh1d/13S4SsviGUt6WmdBfjraqqvorpTD
         Bky/U4HloyJG3g8DCVVzcIF4YlZGmgvNr6LNxKZwEF487CfXmkkyCHCyfoGDTyZ+J1LF
         mAnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YHnJDIaYf4mdvn9CMDvH3Yk1koBMsbu9mrKzrPqgFBI=;
        b=ru8HvvqH7djiZCcFpFrVJPhva6/EMIgshwdO0lo+9Oi4FJV8q37++DzOVSZr/x24U4
         v/QgkpyR0N8NJ3g9Y3mTPzx2KipETWHJajNpNPo73341bBH/DevmOY00j0yB+8yQETr/
         iZX5MgkYV7cylHD/r6suIigGbT9O4JOQz21JdBkKcEFlKkUkHEPtC4fcnTdw9eBjsvgv
         r1N5XLXQGopX8Ru4B1nrl58vnrKWT2aBFSqV1QhBFs7p8Wz/N2wOcmQuUY9yLwA22xT/
         w8UwlkVLgt3OUOrAgVjyKvI5CGJBeQ48LfJQOm0e1AD+WQedKJ8d6AGk2nG8HkJU+RHS
         p6zg==
X-Gm-Message-State: AOAM5305+FzlTCZneeUgMuWxJR86lW3NkHN6lvdoo/EFT7KfEXRsdgqb
        WDNjSP3j8Fdk8ds2sNhjgO7EwW3uNgjj1acJki9SyMZF1C8=
X-Google-Smtp-Source: ABdhPJxVEGoBpxdKltijAHk1dwq+sj64wx1cF2cQ4GhLd1ZWnnl7pGXgiQ0e0sFWy7HCpwP4/J1TrhI+XGvxSd5u27w=
X-Received: by 2002:a05:6e02:1352:: with SMTP id k18mr13803303ilr.276.1597789469473;
 Tue, 18 Aug 2020 15:24:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200818194417.2003932-1-awogbemila@google.com> <20200818.131940.1414544499108292772.davem@davemloft.net>
In-Reply-To: <20200818.131940.1414544499108292772.davem@davemloft.net>
From:   David Awogbemila <awogbemila@google.com>
Date:   Tue, 18 Aug 2020 15:24:18 -0700
Message-ID: <CAL9ddJcPgz0K_y=kGO7WcxM9LurH5Gco2HqUHxnn=EWkLh8CbA@mail.gmail.com>
Subject: Re: [PATCH net-next 00/18] GVE Driver v1.1.0 Features.
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 1:19 PM David Miller <davem@davemloft.net> wrote:
>
> From: David Awogbemila <awogbemila@google.com>
> Date: Tue, 18 Aug 2020 12:43:59 -0700
>
> > This patch series updates the GVE driver to v1.1.0 which broadly includes:
> > - introducing "raw adressing" mode, which allows the driver avoid copies in
> >   the guest.
> > - increased stats coverage.
> > - batching AdminQueue commands to the device.
>
> This series is a bit too large.
>
> Please sync with upstream more often so that you can submit smaller
> patch sets, perhaps 10 or so patches at a time at most.

Thanks, I'll split the patchset up.
