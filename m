Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE55A168EDB
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 13:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbgBVMdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 07:33:18 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43416 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbgBVMdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 07:33:18 -0500
Received: by mail-ed1-f65.google.com with SMTP id dc19so5877805edb.10;
        Sat, 22 Feb 2020 04:33:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Oi8wtUJc/ZugTi+ijz3fdth5kIyS+1a0ZDxcmMSZ+Ww=;
        b=UPC1RCXaaTRucYrzIsJUBYFQPRozFLRYPaby3m4gsIOM+Wok5jFCsijg++GMLkTgcD
         emjQAgGbeGTDKCuEgy708ZwH8nsHR8SLDIKSSFeORVERTU221fsQHzp7QM1/gFYz4Ueb
         SNuT79hDLJUmE8Ejt7rGYfAlTvV9ZjrqTBN2kfauVapGP+jAUsRL+lFFfjcq26Ar9PXJ
         KI66coEmGbl5YnC20VwY0y7uwJOMbJhQF41vyVYsiRewTF2NdSLtuQ3YiPxpZR9b9EJu
         zfEmlMSZbXLIVImjIIIxOqicZ8jy3y/jckgIDh7n3r1W78+1vHaoz/CIlqnT3Wj/TEKW
         obYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Oi8wtUJc/ZugTi+ijz3fdth5kIyS+1a0ZDxcmMSZ+Ww=;
        b=pR4cNWxKiakjzQX4JyFE2GcnyWa+qWO9ko8RP+t/Xx87t+73eI+cTXfgAvpZkxZzjN
         E4L6mUzfpbXotjZOFiSbqhwHES63ULwLJsepPYo3lSsMteh8jG9O9QfhMSozQ/qmXVqc
         7ZVU/hyepDNdqCnnJAGo9/cHdsNZtVleY3W4ofTDDQ6F4OlqwbBfhNZ0x0Sm1mAABb47
         WxTwgvY1AwzpmCa/e8ewZg1KibAUlvDepxAArcpADKU6CJSnFtAnj4OtYfy8/xWST3kr
         BOOUHBcVgfU6cMcypUT1xWfKvFbYEJGnOVQRzshruNKRml3B+4/dWdNEidohxuXSNx/j
         W+JQ==
X-Gm-Message-State: APjAAAUDThjVeysqd3TDUapzmfRI6s9x34dkBZ9AxJ6wJpFrotYFcy/O
        dvG01AtMFvtvIjMMXcQUJ4cPIL899PCI1+XK6n0=
X-Google-Smtp-Source: APXvYqxZOaxYQ2aJT+V+cev2nVAQE4ak0/DAh9KbLNirVUNjfgjAqdVfgOUCrvX6Tl1imqGzGxeJM8UVPW50MiKWAYA=
X-Received: by 2002:a17:906:1e48:: with SMTP id i8mr36633456ejj.189.1582374796161;
 Sat, 22 Feb 2020 04:33:16 -0800 (PST)
MIME-Version: 1.0
References: <20200219151259.14273-4-olteanv@gmail.com> <20200222112841.29927-1-michael@walle.cc>
In-Reply-To: <20200222112841.29927-1-michael@walle.cc>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 22 Feb 2020 14:33:05 +0200
Message-ID: <CA+h21hroaskWAmCcv7UuMDEXSVAAmbX+JGTLr-pBqN-kj-=fGg@mail.gmail.com>
Subject: Re: [PATCH v2 net-next/devicetree 3/5] dt-bindings: net: dsa: ocelot:
 document the vsc9959 core
To:     Michael Walle <michael@walle.cc>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        netdev <netdev@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Sat, 22 Feb 2020 at 13:28, Michael Walle <michael@walle.cc> wrote:
>
> > +Any port can be disabled, but the CPU port should be kept enabled.
>
> What is the reason for this? Do you mean if you actually want to use it? In
> fact, I'd would like to see it disabled by default in the .dtsi file. It
> doesn't make sense to just have the CPU port enabled, but not any of the
> outgoing ports. It'd just confuse the user if there is an additional
> network port which cannot be used.
>
> -michael
>

I can disable all internal ports by default, but there is one
configuration which will not work: enabling only eno3 and switch port
5. This is because the switch PCS registers belong to eno2, and if
that is disabled, the memory accesses will be invalid. So providing a
configuration with eno2 disabled by default is more likely to produce
confusion. But I'll try to clarify better next time.

> > --
> > 2.17.1
>
>

Thanks,
-Vladimir
