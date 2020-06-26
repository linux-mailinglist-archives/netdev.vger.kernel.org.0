Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2BD20B622
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 18:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbgFZQqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 12:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727779AbgFZQqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 12:46:30 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9F6C03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 09:46:30 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id j10so7909597qtq.11
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 09:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gr160rMYRcjmtoZY21/638rmAoCFIvjDMvGJKaB98Qg=;
        b=mpSxL0KaUp4LdsKA4xOTmVL4pBos/UQ1OPqEOeyUJsRW/XVlXmMmOnJmAPyQIu88FN
         aqI5qDwDitNwLs1gg0szF9t6/JsnQrFxpD+rpOVm32UaRwtZB/sRsLEA+E/NBjiKsA7H
         lI8s1jMx/CEc7/K5vAZxTktI/ohnTq3bB/OzINKlVj6mzLJdsGkk45A4ClxWqpOLOJHO
         S89clO5CgZH1gv9Qe0MSgCLiS+ZTmC9V+PUUu0T27alEt/1x3qKjDT/auNiwLQqi886I
         Ytdf/pDQwVz9Wl0UFYpr9TZ7iQuc3yA04Qe2aCB7AJPJxzW0TCqUkuzCT9O6rlp2uLz0
         Klgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gr160rMYRcjmtoZY21/638rmAoCFIvjDMvGJKaB98Qg=;
        b=YEDF8N12LH7N46OF1c7Ru0CPnJr3eZvs2m2J9h05BjbLOzNJA+dR3AggXuL7Uq9gmc
         c2SdlbpEQSrhv6oWdqfEJ9W2jXbLZlygMxh6VDvduLZAbNnu8AbopqDIhiv1gszR6VCI
         0B1qfy5YB+/fqRTrrXrZJJksyiNYEHUmtnOB9xpO/fBC2IvkM7rbMhMSYkmhM2+ulokV
         /sgxXEzUCsx6PYHe/+HmBff6hYF45B3KP/W5WQMHjyLeXBaGTqE467L8dADqgu3beEQM
         nFDAruyQkn9IWV3B1bwTo4OVv5PNbCNt+M5lmmFQqeTFHh1fUvPJ3UfUMj5dCr7v8ysT
         X9lA==
X-Gm-Message-State: AOAM532kiD5HG0rqdkDaLWIhJCvUU90E7AJvuccWvBbTy/0oqm1NTnS1
        qQA+1PBVR4gWHJ4b2IpwGS+boD4RkvQJ17KJVS99lznIDoEkZA==
X-Google-Smtp-Source: ABdhPJy3nQIWtJ5Z/QM1w49W1mYF5Xy6IzS3j7k/f2jF1Yuws0LEgAZ6VAz07oJelg3BAnK/ihC28kw7feFMH/UEk/o=
X-Received: by 2002:ac8:514d:: with SMTP id h13mr3701950qtn.223.1593189989331;
 Fri, 26 Jun 2020 09:46:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200626144724.224372-1-idosch@idosch.org> <20200626145342.GA224557@shredder>
 <20200626150622.GD535869@lunn.ch>
In-Reply-To: <20200626150622.GD535869@lunn.ch>
From:   Adrian Pop <popadrian1996@gmail.com>
Date:   Fri, 26 Jun 2020 17:45:51 +0100
Message-ID: <CAL_jBfRojYBvkD5fW_gLAxWiLaiSD7mQ_rXGjSaDxnkdK3gCiA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/2] mlxsw: Add support for QSFP-DD transceiver type
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        vadimp@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ido, Andrew!

I'm happy to receive these emails and to see that my old patch had
some interest. Yes, at that time there was no official support for
QSFP-DD in the upstream kernel. I was able to test my code using a
custom driver we developed in my company. If everything works out, I'd
be happy to re-submit it.

> It is a while ago, but i thought there was something odd about the
> order of the pages, or the number of the pages? And there was no clear
> indication from the kernel about QSPF page format vs QSPF-DD page
> format?
>
> So Adrian's patch is probably a good starting point, but i think it
> needs further work.

It is true, my patch was basically defining a KAPI. The decision to
have the pages 0x10 and 0x11 right after 0x00, 0x01 and 0x02 was made
based on the need to provide the same stats for QSFP-DD as for QSFP.
At that point, page 0x03 was not needed. Anyway, due to the way I
defined the offset values in qsfp-dd.h, if we add page 0x03 it would
be extremely easy to just change

#define PAG11H_OFFSET (0x04 * 0x80)
to
#define PAG11H_OFFSET (0x05 * 0x80)

and probably everything else would stay the same.
We can continue our discussion about the needed pages in the "[PATCH
net-next 1/2]" e-mails chain.


On Fri, 26 Jun 2020 at 16:06, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Fri, Jun 26, 2020 at 05:53:42PM +0300, Ido Schimmel wrote:
> > On Fri, Jun 26, 2020 at 05:47:22PM +0300, Ido Schimmel wrote:
> > > From: Ido Schimmel <idosch@mellanox.com>
> > >
> > > This patch set from Vadim adds support for Quad Small Form Factor
> > > Pluggable Double Density (QSFP-DD) modules in mlxsw.
> >
> > Adrian,
> >
> > In November you sent a patch that adds QSFP-DD support in ethtool user
> > space utility:
> > https://patchwork.ozlabs.org/project/netdev/patch/20191109124205.11273-1-popadrian1996@gmail.com/
> >
> > Back then Andrew rightfully noted that no driver in the upstream kernel
> > supports QSFP-DD and the patch was deferred.
>
> Hi Ido
>
> It is a while ago, but i thought there was something odd about the
> order of the pages, or the number of the pages? And there was no clear
> indication from the kernel about QSPF page format vs QSPF-DD page
> format?
>
> So Adrian's patch is probably a good starting point, but i think it
> needs further work.
>
>       Andrew
