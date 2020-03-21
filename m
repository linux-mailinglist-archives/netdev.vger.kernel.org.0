Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2358B18E358
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 18:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbgCUR2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 13:28:39 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:39009 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727128AbgCUR2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 13:28:39 -0400
Received: by mail-ed1-f67.google.com with SMTP id a43so11058733edf.6
        for <netdev@vger.kernel.org>; Sat, 21 Mar 2020 10:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kwWoOqKP35zop+F72DWbVtRp/nMdp8PZ8UIKLzpbLkU=;
        b=hQv9xBoPj+DdaDi463DZ52DsBCTJufp/dHLKenvFgK+8L+LqG+z/WaGrHSiH+O4Zwq
         9Cc6AdZL+dmdHt8HRI+YAUsn/ehHU7cqubjv/Es9x/Dzi0nG6LXGrunYQJvuAGe3r5WX
         CYSIAfJUOGfPLyn2BpfH359Q8VDfJedMuTkxLY9gW/+OsLMAYYwXXIA8GYjVimSKTiAG
         hXLOZ9YIweSHuXvggz85w6jMZVNmhZ0MXdQwD008Hu58SXo059Y25Jivdv3lk6NnHgAA
         B7txB9UTcHAb5iB55fZvPPKTvh1/jp868wfOfRgJ7TXSSLyegakQAHGf3VNgVxMVRWZP
         8nVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kwWoOqKP35zop+F72DWbVtRp/nMdp8PZ8UIKLzpbLkU=;
        b=CHKTGA6TSatFu2ejW2P+K4ljUbMwC8imBBowwCAjOlAUjgPrwojVmq98PAYZoeqrJN
         FPvNwW2nm+2vebqe+aSbRisvmjIziaDlB9HIAI+Y34DVCv0H7LsNsPVSIHgEE1eKZmMU
         lchVniPfplXzCXHRqg+cy3fXC7mU/2rZQ5W1PeeDOuA9zgPBOCohgcV1S3D6Vo6Od1kO
         pXwc9TDjeHRaDVRbnYRMB0iwKOX9Xo/icGI/aEEcE5Lh5fNSku5A6V5zZZWvEvEyf+05
         dhePxBS34tuHVACFNHunsXj+ZhogVAvpQ8kC90cl1CVx9/sVwTjCODleYR/iYFwwT6d+
         yQiQ==
X-Gm-Message-State: ANhLgQ3/UANVNMtPu9XBeh6Yht2eyp/zn0E+7qG+79Lt8z0HgoHcB32m
        nhqoQ6SE7RG4SFzTqHhSXAthB1iX1HwqlCmvCbA=
X-Google-Smtp-Source: ADFU+vuTy5ZUNFuGLPfb4vyFSQ/4Rs2ZVkF/jRNDyDNWrwVvy/NNMIcC0NyNlzBMiWAw1a4FpJLxj+eDIpG2E7OHYRY=
X-Received: by 2002:a50:d5da:: with SMTP id g26mr14247694edj.179.1584811716231;
 Sat, 21 Mar 2020 10:28:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200319211649.10136-1-olteanv@gmail.com> <20200319211649.10136-2-olteanv@gmail.com>
 <20200320100925.GB16662@lunn.ch> <CA+h21hrvsfwspGE6z37p-fwso3oD0pXijh+fZZfEEUEv6bySHQ@mail.gmail.com>
 <158470229183.43774.8932556125293087780@kwain> <CA+h21ho4aqgCSjgPTJ10cVeUow_RAUTNd9NSrVPJJVEqjAws9g@mail.gmail.com>
 <20200321170146.GF22639@lunn.ch>
In-Reply-To: <20200321170146.GF22639@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 21 Mar 2020 19:28:25 +0200
Message-ID: <CA+h21hqVEgq-bnj-9E+75eXOVWmc4zoDKos1g8UXV12SjgSemg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/4] net: phy: mscc: rename enum
 rgmii_rx_clock_delay to rgmii_clock_delay
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Mar 2020 at 19:01, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > And to add to that: without documentation, I don't really know what
> > I'm consolidating.
>
> It looked like the defines for the delays could be shared. But if you
> are not happy with this, lets leave it as is.
>
>     Andrew

To be honest, the reason why I'm not happy respinning is that I'll
need to backport these patches to a 5.4 kernel. I have nothing against
sending some further consolidation patches with Antoine's work, but
respinning this series would mean that I'd also need to backport
Antoine's patches.

Thanks,
-Vladimir
