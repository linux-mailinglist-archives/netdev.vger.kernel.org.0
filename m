Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 339921810DF
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 07:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgCKGkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 02:40:00 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42604 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgCKGkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 02:40:00 -0400
Received: by mail-wr1-f67.google.com with SMTP id v11so1050017wrm.9
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 23:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fyS/g7I2VOj0AwsGJjVLeF+gFSd8vbdest2kZu3k210=;
        b=nlCjxCshWjXLTvzwR7tGXhMUnBbgMCVgzVZxuHT/4kBBmDr5e8EkOUHCjtQ69ppivd
         Kte4QmqqqzPI0cZc+de9UpnGYbTTwWC9xITdTViGg7ZWVpjSP4YAvYqZvakL4+hfBOC+
         FDvMO/DipTg+MmZtSG6hlv0pe6Lh++fBhQRqHi3TmvkxcUQp0+9mv6T/ltncdOARIcBE
         x4LBf+PfnH00QZ5Ni2I6Mo/uckRFkfm0pmSbLdMn6/qSth9VVwzyiUx2di4KpVzUvBE/
         RuPWXpDvDcXpAMJ0PdwR2CkRiaE54tpb3NXWZx2K4igi4o2LsjBrVJTH7uBK4vjCfPzP
         4oiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fyS/g7I2VOj0AwsGJjVLeF+gFSd8vbdest2kZu3k210=;
        b=d6UGL5hPXb1JhtbW/t0q3/szZsZTXyU5OfD80S5H0IREPcx1saMV/SG+RGz5n6BzMF
         5vnrbvz7AnbSRewMIAYaTZzZxk8dCH0zA6UE865/ZH4xo9bZcHPzLkFIMnXAyjUcBtRw
         PNMcJu6ibXZNz8TjsKMuVzOixf3TvcTy12NKt0VDQNP5zNDjmrDlXGG2mMqG2KMR8+CG
         jBnWC6XxoIcOReeNOul++OcgVeIcx76liDS8CXlMLul1GO08qGnIQE4AS88wqCp2l63n
         X8rj6HmzvOn4tfNCQ8OR8oqVSv/5Ge6w7JDOjx9sdysP9MrUbXq2a+OrHqtnVhmJ8AWh
         pdtg==
X-Gm-Message-State: ANhLgQ1QM9P66EKfkArCJ8NIHfJlbMmZ1L1PmCtNo+PK1OVoLhX6QWEH
        MqDciTFP9rBR7n1ENQtZvJ6fZY1fV3hiGni+6rc=
X-Google-Smtp-Source: ADFU+vsOPJzXIbGz5BWvsNjriUaBRtOZO+QkAKpG6gE2eLILP98GeghVYkzPiAcxLPtqG8eGStsJSKjF/ixhOdFbZV0=
X-Received: by 2002:adf:80af:: with SMTP id 44mr2480611wrl.241.1583908796727;
 Tue, 10 Mar 2020 23:39:56 -0700 (PDT)
MIME-Version: 1.0
References: <1583866045-7129-1-git-send-email-sunil.kovvuri@gmail.com>
 <1583866045-7129-5-git-send-email-sunil.kovvuri@gmail.com> <20200310192111.GC11247@lunn.ch>
In-Reply-To: <20200310192111.GC11247@lunn.ch>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Wed, 11 Mar 2020 12:09:45 +0530
Message-ID: <CA+sq2CeTFZdH60MS1fPhfTJjSJFCn2wY6iPH+VvuLSHzkApB-w@mail.gmail.com>
Subject: Re: [PATCH net-next 4/6] octeontx2-vf: Ethtool support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Tomasz Duszynski <tduszynski@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 12:51 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Wed, Mar 11, 2020 at 12:17:23AM +0530, sunil.kovvuri@gmail.com wrote:
> > +int __weak otx2vf_open(struct net_device *netdev)
> > +{
> > +     return 0;
> > +}
> > +
> > +int __weak otx2vf_stop(struct net_device *netdev)
> > +{
> > +     return 0;
> > +}
>
> Hi Sunil
>
> weak symbols are very unusual in a driver. Why are they required?
>
> Thanks
>         Andrew

For ethtool configs which need interface reinitialization of interface
we need to either call PF or VF open/close fn()s.
If VF driver is not compiled in, then PF driver compilation will fail
without these weak symbols.
They are there just for compilation purpose, no other use.

Thanks,
Sunil.
