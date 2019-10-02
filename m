Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A121FC8C51
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 17:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbfJBPIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 11:08:00 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:44834 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbfJBPIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 11:08:00 -0400
Received: by mail-oi1-f195.google.com with SMTP id w6so17904413oie.11;
        Wed, 02 Oct 2019 08:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8D7K4SNgNO8Gge2dBZ9l/7+f3o962jFEm28AAS+rD5U=;
        b=lOa/wbZZCG3LtJE49X70CP2HtOtE7MPfPbsftTjD9pDqXGpMW3/uIW5Yd0N7fA6WH0
         45L26CADJcoHiRb3L8ZDVJ2MuvPei9LlSbtzv9Ib2BrM5BrS77fWsyuu75Rf/bjcdVF9
         dWSmHXLStQ33A9Du7tOb8bfpH/iex/M5SwieVSvQv+QogodSAq9QgYq3UApVocp/g6vc
         gaeJHyNQTSOTrtmSKJkLqILR5BnKi+zGFB9oDhYyW1Y3KyrYVec+kqKBsC05lVr1dgey
         R8qrjmIkNqm5BAhqX7F/t2PKAcRkDXoSYTOfWUq3PcP1tra67gZkYRpjOE78xqDIbpFk
         G0yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8D7K4SNgNO8Gge2dBZ9l/7+f3o962jFEm28AAS+rD5U=;
        b=HDFuW6JHJbpZMg1SPrrQQgzicZboJXqg/MXndXND131UZISvjaHKjLqiWnudIeblGa
         GYR/6iwf/hdXzkypTexeSMIZ6mSHSpTdGQm/8wL4ViMuNmcjhlvqBuW26QHfxrJt+vvM
         wyO+V4zVu8CYER9f82UGuktpORypmsCbmjwgTLrl767IM2R0rTJtaNF2bTZDklj5d0IW
         pHVH0Ydn7UdFNjDCOys4fkd+849VspwRaUdZIy1Muz/fA8tMWdWpEYer4rT3K9WG5iBY
         17DVFNkHOH5AmNtP0vlRNS7AWiB4NNNGZqBGO7tLeE7liP35ZytXSvVJWJPzEp97SHRc
         2ovA==
X-Gm-Message-State: APjAAAXqD9/XEkMTfeu01XamlhLnfAPQLbQ0MbxBtTsSrYlhkIJ8kZd7
        EZhGaYat1hz43Ef7saF3yJlvtNSidBpnAQiSwNyQtPYN
X-Google-Smtp-Source: APXvYqxY4JDul9/OZkpfkz/q9DgEWbGMbiwZZNNn3rEnuql1J4fjP8sO6y0uQCDajynGIZB0pVp9jtLUXhvsEvES7gk=
X-Received: by 2002:aca:b902:: with SMTP id j2mr3047808oif.169.1570028879257;
 Wed, 02 Oct 2019 08:07:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190918183552.28959-1-TheSven73@gmail.com> <20190918183552.28959-4-TheSven73@gmail.com>
 <20190930140621.GB2280096@kroah.com>
In-Reply-To: <20190930140621.GB2280096@kroah.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Wed, 2 Oct 2019 11:07:47 -0400
Message-ID: <CAGngYiXWF-qwTiC95oUQobYRwuruZ6Uu7USwPRqhhyw-mogv7w@mail.gmail.com>
Subject: Re: [PATCH v1 3/5] staging: fieldbus core: add support for device configuration
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Enrico Weigelt <lkml@metux.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "J. Kiszka" <jan.kiszka@siemens.com>,
        Frank Iwanitz <friw@hms-networks.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 10:09 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> Why is a new way of doing configuration needed here?  What does this
> provide that the current code doesn't already do?

The fieldbus core doesn't have a configuration mechanism yet. This
patch adds one.
I deliberately omitted configuration when the core was added - I wanted to keep
complexity to a minimum. I'm sorry I didn't make this clearer.

As a result, the current core can only work with cards that either don't require
any config, or get it straight from the network/PLC. Profinet is a good example
of this. Most cards do require config however. So does the hms flnet card, which
I tried to add in the patchset.

> And have you looked at the recent configfs fixes to make sure this code
> still works with them?  I can't test this so rebasing this on 5.4-rc1
> would be good for you to do first.
>

Thanks for the heads-up! I will test that out.
