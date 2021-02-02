Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C60E30BE35
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 13:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbhBBMa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 07:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhBBMay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 07:30:54 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBE0C06174A
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 04:30:12 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id t17so14746829qtq.2
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 04:30:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aAQDedECOO/jRiSU/wpV13Pwdg3tcOn7WNnJoR3QOcc=;
        b=GT71/ZGvFiLmjq1pizrcz4wyskMzu5cFm982uGsN86uT+vkafQ9G4A5rLoUzJ12fp4
         ZChBOutzOQVQxga+uK6/ZsYSRHarZH4l9DbiPGLGx90tS3gp9cAuVt3Pzpqs35qXs0Yd
         mns0efOOubAACJc2DRi7B1fafv43CI7X4ptdxWw2jEEJaJUrYtQX8UXqNeHlkcU2WXZn
         tzUHBlXK5EoKvHe+DzMGdDSg73B8drO9skIWERlni9zXSDvwd0Qfcldu2LlReWEdZ9cj
         a3SQr96kpp2xpjOWPd03UjS94GBkID/DCiK2cXB2SiBX3GRXyOmeuEt/VHqlbMCr1rt7
         BJkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aAQDedECOO/jRiSU/wpV13Pwdg3tcOn7WNnJoR3QOcc=;
        b=kgnw1Ey3u2XO8BBoxoyexNf2JTVDmGMQJ/O21McjI82XsDkK+qdYTdXl85p+kPopm9
         iTNrKa7tOOWBEvWuOZYc9h7kQmC82Co/hF0oa+sFzNTmoHLnr1whJ5ttPcqHItau0Jk5
         bE3HWzVcD3LcGEAagSsul7DgGt1kIPe50t9xBdPNQv4FV8LbOt7Hs2MybMEeEeajqlZG
         DcaumfMwHgSL25yu1DSEek0qLeiuzVAtkWdQ3tXhV1gzvFSX7XzdY2QQtU7sLXB/DR0x
         DG9CWT6urxb99qMCemqE6oKwwQjFfdf3nFCP66stAlFP5+q3IixdAVF2siQ79nI6BMSz
         lmRA==
X-Gm-Message-State: AOAM530FXC6IOrO6Rg3NRV6ze26Mvxjryj4Ltg/aBE/G9/wNXmcewbdq
        mn7mVuhY0xWrqRCxtltK684=
X-Google-Smtp-Source: ABdhPJwQfkaKNjn5f5lU8P4EBTjhaTt+BMc7BB5tsnMoxy+KSN8Zs4AoLYpo/enGOH0KyduEHIYekQ==
X-Received: by 2002:aed:3303:: with SMTP id u3mr20180358qtd.18.1612269011153;
        Tue, 02 Feb 2021 04:30:11 -0800 (PST)
Received: from horizon.localdomain ([2001:1284:f013:89ca:fde2:42b9:c0d1:d526])
        by smtp.gmail.com with ESMTPSA id z187sm6217377qkb.52.2021.02.02.04.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 04:30:09 -0800 (PST)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 58A41C02BD; Tue,  2 Feb 2021 09:30:07 -0300 (-03)
Date:   Tue, 2 Feb 2021 09:30:07 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH RESEND net-next] netlink: add tracepoint at NL_SET_ERR_MSG
Message-ID: <20210202123007.GE3288@horizon.localdomain>
References: <fb6e25a4833e6a0e055633092b05bae3c6e1c0d3.1611934253.git.marcelo.leitner@gmail.com>
 <20210201173400.19f452d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201173400.19f452d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 01, 2021 at 05:34:00PM -0800, Jakub Kicinski wrote:
> On Mon,  1 Feb 2021 15:12:19 -0300 Marcelo Ricardo Leitner wrote:
> > Often userspace won't request the extack information, or they don't log it
> > because of log level or so, and even when they do, sometimes it's not
> > enough to know exactly what caused the error.
> > 
> > Netlink extack is the standard way of reporting erros with descriptive
> > error messages. With a trace point on it, we then can know exactly where
> > the error happened, regardless of userspace app. Also, we can even see if
> > the err msg was overwritten.
> > 
> > The wrapper do_trace_netlink_extack() is because trace points shouldn't be
> > called from .h files, as trace points are not that small, and the function
> > call to do_trace_netlink_extack() on the macros is not protected by
> > tracepoint_enabled() because the macros are called from modules, and this
> > would require exporting some trace structs. As this is error path, it's
> > better to export just the wrapper instead.
> > 
> > Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> 
> Did you measure the allyesconfig bloat from this?

Now I did:

$ ./scripts/bloat-o-meter -t out/{orig,new}/vmlinux
...
Total: Before=212077464, After=212108056, chg +0.01%

$ size out/{orig,new}/vmlinux
   text    data     bss     dec     hex filename
267409181       333328965       83018348        683756494       28c14bce      out/orig/vmlinux
267413171       333337273       83010156        683760600       28c15bd8      out/new/vmlinux

with the commit on top of 46eb3c108fe1744d0a6abfda69ef8c1d4f0e92d4.
It's not much because it's adding just a function call to the macro,
rather than the tracepoint itself.

> How valuable is it to have the tracepoint in at the time it's set?

To know exactly its source. It's very helpful to track down some
EINVALs reported to userspace. If not, we have to rely on the errmsg
and grep the code afterwards.

Also, if the message is a common one, one may not be able to easily
distinguish them. Ideally this shouldn't happen, but when debugging
applications such as OVS, where lots of netlink requests are flying,
it saves us time. I can, for example, look at a perf capture and
search for cls_flower or so. Otherwise, it will all show up as
"af_netlink: <err_msg>"

Also, it allows tracking when a previous errmsg (which would have been
a warning) is overwritten with a new one.

> IIRC extack is passed in to the callbacks from the netlink core, it's
> just not reported to user space if not requested. So we could capture
> the message in af_netlink.c, no?

If 4k is too much, yes. It looses practicality, per above, but should
be doable.

  Marcelo
