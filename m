Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E6E26FBF8
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 14:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgIRMBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 08:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgIRMBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 08:01:39 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C914C06174A;
        Fri, 18 Sep 2020 05:01:39 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id x69so6674482oia.8;
        Fri, 18 Sep 2020 05:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TIYAqOC899ai1a4p5JYNNXAhXoOp92EoYJFeWARDSr8=;
        b=JiJrgQXGsX+jOAk0xZFxzHRLLbMYtmISgNJWWHpuXl1yM4hGxY8nVnfA8aBr4R0lCW
         4XHVsTkxIHYdRKXdZyhsPu2xHJuN5axUyf53dw/87ebwIjKcDr+KuJ51hz2pzPvgclvY
         OCTuTC1p1YxGTdMEnuZzTGCwjcFEmJffUFwFFtA1d4xzL4SSGsWydCETE9A4MiDIP0fq
         Il6e1pruTKUaVP9Anu3DaqhVhDy4pLzoCuC0TyDvqSp4Vb8GJKwqwMvCjiDpW/qoA3tl
         dXFynkrKm+9IZ5tDkr33YGST0q3+psiL85fCpLOQdBWRsE5NdqcoTS1YONRfsUitahoe
         dTtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TIYAqOC899ai1a4p5JYNNXAhXoOp92EoYJFeWARDSr8=;
        b=o8yLqp9sQ9FjH5+MR9fisO+SoGvAZeKah6z3qvK3z3/FjRYQ7mjDkT+GFLEgnI92f0
         goNYYEOg0CcgjfhAiAOhNhl0Q6myMqqUc0NW998UZTIBMO//HowZ6dIshy0rt3TyY+O3
         iCAUsvPZ+DBloTXvlKTkhcFm+IBsYgP6yq42ED8/bas9USJ9CUu3TPVkL7grTSLK9R0O
         pEdWHN4Oz+l28ZEN5IST7diu0xb2zW8kUExlp31A2jUoiIYtCUhUh6CfgkLVi0Y5ee/D
         FelVjyMBb8TlvOM05JlM0LeQ7C26aPNmYqldVuu52bUZmrLWppQF2LAzROfa3x86eEfM
         acLA==
X-Gm-Message-State: AOAM533b9fI+L5NJUy8Uy/GJtHrsB+WB3jnudIZlhAVbFgtfvyVFB/RP
        GnVZmL/1qBDTmBEQKCcutbdG6SuLF8qUgbx+9is=
X-Google-Smtp-Source: ABdhPJxu5ol7q18xYMzJhp/6UenCzAvLNkbwOSBEcqjjlIQRqp411YLeQHsDG1Gfmdv3v+3sWP93UpRQz1Wmpf7Fnc0=
X-Received: by 2002:a05:6808:3bb:: with SMTP id n27mr8814306oie.130.1600430499018;
 Fri, 18 Sep 2020 05:01:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200915171022.10561-1-oded.gabbay@gmail.com> <20200918120002.GA226091@nvidia.com>
In-Reply-To: <20200918120002.GA226091@nvidia.com>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Fri, 18 Sep 2020 15:01:08 +0300
Message-ID: <CAFCwf137pgTewcn4DwPwYRPwZARusD_5OW8OVyBPXZTyjw2KHA@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 3:00 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
>
> On Tue, Sep 15, 2020 at 08:10:08PM +0300, Oded Gabbay wrote:
> > Hello,
> >
> > This is the second version of the patch-set to upstream the GAUDI NIC code
> > into the habanalabs driver.
> >
> > The only modification from v2 is in the ethtool patch (patch 12). Details
> > are in that patch's commit message.
> >
> > Link to v2 cover letter:
> > https://lkml.org/lkml/2020/9/12/201
>
> >1. The NIC functionality is NOT exposed as different PCI Physical
> >   Functions. There is a single PF which is used for compute and
> >   networking, as the main goal of the NIC ports is to be used as
> >   intra-communication and not as standard network interfaces. This
> >   implies we can't connect different drivers to handle the networking
> >   ports because it is the same device, from the kernel POV, as the
> >   compute. Therefore, we must integrate the networking code into the
> >   main habanalabs driver.
>
> No, this means you need to use virtual bus/ancillary bus that your
> other Intel colleagues have been working on with Greg.
>
> It is specificaly intended as the way to split a single PCI function
> across multiple subsystems. eg drivers/misc/habanalabs would be the
> pci_driver and drivers/net/ethernet/habanadalabs would be the
> 'virtual/ancillary' driver. Probably one per port.
>
> Jasno

Understood.
We are doing a refactor of the code according to those guidelines and
will send an updated patch-set in a couple of weeks.
Thanks,
Oded
