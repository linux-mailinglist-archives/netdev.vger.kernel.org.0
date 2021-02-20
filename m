Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B557B3205AA
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 15:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhBTOZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 09:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbhBTOZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Feb 2021 09:25:34 -0500
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA35C061574;
        Sat, 20 Feb 2021 06:24:53 -0800 (PST)
Received: by mail-oo1-xc36.google.com with SMTP id n19so1956641ooj.11;
        Sat, 20 Feb 2021 06:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3ty4ns4hL8CFQY262vfeqaJkUX/iOPEFerZSeZAZer8=;
        b=FfhFUaKJY2KQoE7k8SiJgsYpb7YqhsruYeFILm1/eK1WtbTbqpPXHOhvkuUQcU4laL
         St7nUjASBuABKFQGKwFbGhs8XZQmqEsUO2/HAa4Cu7548wC2qT326vuaBD1rgaGE+1JQ
         AjxgusOJc1iNHHWrVBVd86i5h55spT2jtNK4jimHJo3V//QxEo1m3I/Xcf6gYMPyVCiD
         DybOim1eVJg/PCpxviHfDXR0ROsrTWUDygcBugj3QGaMJfAlf47IWduIOKwKQdxfg3VL
         UUQbr5T9QIKr6KItlruDdFOA1O9T+CvjrBjIaLKa13Qux+Y93vOKUfTnhFp8GQ8vViat
         6hOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3ty4ns4hL8CFQY262vfeqaJkUX/iOPEFerZSeZAZer8=;
        b=bGUGVv7fVeu7FHLzUzKUNyidllw6jnxqnRO7gsRyioXpSR48d700at8BnppeybBL2i
         vBvBB8BTkkJY37IhYBvLwDA39QrnoOeiF35EeIu9MJa7tuK/uNsrh7d9HqfHstZzSsi+
         T205anjwmsk8V+egcNAaFAXnYhrRq4MtJHWCBLsXleLfFBL7xgHofeprNg8xx7BiVv1o
         jEGFzxUE/A7WKw33bDha2C79kCdYpHSQKCsqqenID1AaTcLJTzPmWZQ+LZ+NsCxAIsjd
         dKeyW3KEkwf1EQY3m9L3KBiy/w+LnJom6YYBze9dbdMbr/UOOKV/awR4HCBa6ha0uVOX
         DCQA==
X-Gm-Message-State: AOAM532YzkorfF8upHRHozXa3tjKqt8hxxVgdg85f8IZTxbVEqSc3PLi
        UgdzeQd7hD/799LEuRmDCGg2x/6+COonR4G9nQ==
X-Google-Smtp-Source: ABdhPJzCURahRxy1n0mMqM2nAPEHTY3sHRwB3uhsyOscTCrApYnJ6DWDnah95gEP2r2O7Yz+LtZFq1Ux33FbI0wJD3U=
X-Received: by 2002:a4a:3407:: with SMTP id b7mr10747975ooa.43.1613831093179;
 Sat, 20 Feb 2021 06:24:53 -0800 (PST)
MIME-Version: 1.0
References: <20210220051222.15672-1-f.fainelli@gmail.com> <22f9e6b7-c65a-7bfb-ee8d-7763c2a7fe74@gmail.com>
In-Reply-To: <22f9e6b7-c65a-7bfb-ee8d-7763c2a7fe74@gmail.com>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Sat, 20 Feb 2021 08:24:41 -0600
Message-ID: <CAFSKS=M2+mHZvG+OWBTM4YiCr4+p4Lh3917fL_7XUw_jCm1CFA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: Fix dependencies with HSR
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 19, 2021 at 11:14 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 2/19/2021 9:12 PM, Florian Fainelli wrote:
> > The core DSA framework uses hsr_is_master() which would not resolve to a
> > valid symbol if HSR is built-into the kernel and DSA is a module.
> >
> > Fixes: 18596f504a3e ("net: dsa: add support for offloading HSR")
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> > ---
> > David, Jakub,
> >
> > This showed up in linux-next which means it will show up in Linus' tree
> > soon as well when your pull request gets sent out.
>
> I had initially considered making is_hsr_master() a static inline that
> would compare dev->dev.type->name with "hsr" since the HSR master would
> set a custom dev_type, however the xrs700x driver would still fail to
> link because it calls hsr_get_version() and for that one there is no
> easy solution.

Thanks for looking into this. It's not something I've run into before.
It didn't occur to me what would happen if HSR was a module. I'll look
out for this in the future.

Sorry for the inconvenience.

Reviewed-by: George McCollister <george.mccollister@gmail.com>

-George

> --
> Florian
