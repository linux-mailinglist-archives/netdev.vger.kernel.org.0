Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B417E325093
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 14:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbhBYNex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 08:34:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbhBYNe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 08:34:28 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF0FC061574
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 05:33:48 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id d9so5606615ote.12
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 05:33:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8TXR6/lpKpH9aZdVQTsnycwvzWAzc2Rzb8JN7l6hUgY=;
        b=fncs1cyXv6HwjmG0fFpd82YainoJ4y6Rj4btE30n8Ox6dlprrgKjKd1yhu5dFm72Sv
         enuB5Mb4oCFsLJjIVLr75iXL4ozDKgNWX+ffwxuKh5QEYQRljds0K3SxWetZWuh4GOIk
         K0DO2D21mrXeBeBusGqAzQ5RA5qr2irP4OKHzCZE10248iHJd2CqIljPa/e00LP7t0UJ
         LpcWMTpeku+a7UZTia8xlLwsmmZzq6uAR5GHk9Fya87tbZxOMDHFnPbao3vXN8G7p1cI
         +Isr54QZ6DjxEhBP4qZ29XBN2A66VKFLf9oBc05reuVht7eA0pHdS9ZBYy7Axf4kE1zO
         qiIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8TXR6/lpKpH9aZdVQTsnycwvzWAzc2Rzb8JN7l6hUgY=;
        b=iMViZ9nHlRO5Q+QlfUeknUg/dW/c41/yn7ZlLDu/6lYg5XHdhSC6hjUmRfSla4iobu
         0KpHWjo7anBGRdX0gvaRD3ZkcRHC5/pTEPuGAoEGQeVZye6hUZ/FGHA9FubHDQYQTEQ7
         v2B7alqzk/KZl+cETOqyA3rB/ZvdnHlz0gaXxW3s5Xrt+0AUYjJNwdraUQHe0+KPc+vs
         wV4ItyeaT8Mui7nNi9cHBJjkJ7KOBNsYRb7IRcXXgXzRDeVYBULGE9tlVsWcKX8dOhOk
         8OaDoR0ZpuEXnEI0P8rIWeT+1BHgIIB9LSNOVkvQHXqNKxdZuAz6yM2RlRaOYbZHdUGX
         RdSw==
X-Gm-Message-State: AOAM533zmGRRTsAGnfpf63Q+3sX/3870DlFQjL8MEQLF4W/EtI4rk1we
        /tLVnXEMcZao6ku71sswTBZ3P6wki/HDUD2qtw==
X-Google-Smtp-Source: ABdhPJxwGwzfdPpOaoBHPD8JMVluKVKrOY2vcrs3QVl9n4hF8abHIKEpDLtp/7W26gxScess3MdC1D4wkyAAmD84R6g=
X-Received: by 2002:a9d:131:: with SMTP id 46mr2270096otu.287.1614260027358;
 Thu, 25 Feb 2021 05:33:47 -0800 (PST)
MIME-Version: 1.0
References: <20210221213355.1241450-1-olteanv@gmail.com> <20210221213355.1241450-11-olteanv@gmail.com>
 <YDcAbFkT+OkE70kh@lunn.ch>
In-Reply-To: <YDcAbFkT+OkE70kh@lunn.ch>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Thu, 25 Feb 2021 07:33:35 -0600
Message-ID: <CAFSKS=M4K+bDHjQ7vnaT=Jf8TtnV6VCPr_8pCrk=B65FXR2WxQ@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 10/12] Documentation: networking: dsa: add
 paragraph for the HSR/PRP offload
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 7:42 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > +IEC 62439-3 (HSR/PRP)
> > +---------------------
> > +
> > +The Parallel Redundancy Protocol (PRP) is a network redundancy protocol which
> > +works by duplicating and sequence numbering packets through two independent L2
> > +networks (which are unaware of the PRP tail tags carried in the packets), and
> > +eliminating the duplicates at the receiver. The High-availability Seamless
> > +Redundancy (HSR) protocol is similar in concept, except all nodes that carry
> > +the redundant traffic are aware of the fact that it is HSR-tagged (because HSR
> > +uses a header with an EtherType of 0x892f) and are physically connected in a
> > +ring topology. Both HSR and PRP use supervision frames for monitoring the
>
> I don't know HSR/PRP terms. Should it be supervisory instead of
> supervision?

IEC 62439-3 refers to them primarily as supervision frames however
supervisory frames also appears once in the document.

>
> > +health of the network and for discovering the other nodes.
>
> Either "discovering other nodes" or "discovery of other nodes".
>
> > +
> > +In Linux, both HSR and PRP are implemented in the hsr driver, which
> > +instantiates a virtual, stackable network interface with two member ports.
> > +The driver only implements the basic roles of DANH (Doubly Attached Node
> > +implementing HSR) and DANP (Doubly Attached Node implementing PRP); the roles
> > +of RedBox and QuadBox aren't (therefore, bridging a hsr network interface with
>
> In colloquial English, you can get away with just 'aren't'. But in
> Queens English, you should follow it with something, in this case
> 'supported'.
>
>         Andrew
