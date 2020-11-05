Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E832A8731
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 20:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732099AbgKET3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 14:29:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgKET3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 14:29:48 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C565C0613CF;
        Thu,  5 Nov 2020 11:29:48 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id x12so3090517wrm.8;
        Thu, 05 Nov 2020 11:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IEZ9p00rgiSdsobZZ6m51z0iGJli/xa8uAws+u4wKLQ=;
        b=pR25c4Gjdxn3KSfWyePOQ6ruq3VkG2NHIhiqrNJy8zP5HslzioHDvj/w/W1aKHI6gl
         A2flWc3BgGLK/cN/StRNPl6Ba8cCOqMcwtCp5YyhsDboYqqeTm+wCz2+ex59nNHVl4md
         iFotiVRORYZpQ0Et4zRa2UXkw94bIYCXRRJgIyJhnR1HJWbvZShHQrPk8O89ZQ1e+cyF
         llY20KCt7fBGUQ7rXDDToKIg2fsk9Csmd0MckjsaRt09OnL/CEOEYTJjrLiRiGn283oy
         L7mLoAGcL6yDWS/xrTAS/L1yREcZTkt0FZj3VMYI0lu5z29dbIPZh+fkq1xGusBsPvXy
         qLsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IEZ9p00rgiSdsobZZ6m51z0iGJli/xa8uAws+u4wKLQ=;
        b=LL08HAjr3trBPExJ84kbyyhXoCLEEmC5IEJfIjxythEMMPTCUD5zichV6OKBeVCDL6
         VH5eV7yn62Z404oUgwgt5qgN5uBylt7WXNP+NRe5+LT27kgS/B8SlSQFe1tqjRg9VV4h
         wPI3VKDkPCGH8or02J1cQiy1/dbijCBbIsbppXZNv9xm/xw7YghLaNcmGmDtTtMx/hXH
         a5r8M0fBXUUdjfN7xMzb7EYZukjSQU2yfYkgOGw9kucTgCNMkfIo21fME2y0u4W+TEfI
         uld7DD2OmPRF92EDloHGSufL0FrJcIc7ycfHtetBLqcOs3REKGZ/BUPIStUFgYSNLPpl
         6D8w==
X-Gm-Message-State: AOAM530hP0oKtVC1yATHQ3+lxKCWGjiqZa8uxocOOvXydm+3U3dzYG+W
        zZveX8qwxd2f2bg3fsZ4l0tkTr4+ohpKTEsdct8=
X-Google-Smtp-Source: ABdhPJxQy42cWOWUrSyWEQkumWJ45TSM56KVWwRab8GksSRCau0dT3WxtbMv8ACbvaTPEunRhRzCyfnAEoF9o8gj2iQ=
X-Received: by 2002:a5d:4c4f:: with SMTP id n15mr4601176wrt.137.1604604587134;
 Thu, 05 Nov 2020 11:29:47 -0800 (PST)
MIME-Version: 1.0
References: <BYAPR18MB2679EC3507BD90B93B37A3F8C5EE0@BYAPR18MB2679.namprd18.prod.outlook.com>
 <1dd085b9f7013e9a28057f3080ee7b920bfbc9fc.camel@kernel.org>
In-Reply-To: <1dd085b9f7013e9a28057f3080ee7b920bfbc9fc.camel@kernel.org>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Fri, 6 Nov 2020 00:59:35 +0530
Message-ID: <CA+sq2Cc9-vvF8K_FASca5FGYyFc_53QWqyEtoHAx6xVCs41LiQ@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 3/3] octeontx2-af: Add devlink health
 reporters for NIX
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     George Cherian <gcherian@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > > Output:
> > > >  # ./devlink health
> > > >  pci/0002:01:00.0:
> > > >    reporter npa
> > > >      state healthy error 0 recover 0
> > > >    reporter nix
> > > >      state healthy error 0 recover 0
> > > >  # ./devlink  health dump show pci/0002:01:00.0 reporter nix
> > > >   NIX_AF_GENERAL:
> > > >          Memory Fault on NIX_AQ_INST_S read: 0
> > > >          Memory Fault on NIX_AQ_RES_S write: 0
> > > >          AQ Doorbell error: 0
> > > >          Rx on unmapped PF_FUNC: 0
> > > >          Rx multicast replication error: 0
> > > >          Memory fault on NIX_RX_MCE_S read: 0
> > > >          Memory fault on multicast WQE read: 0
> > > >          Memory fault on mirror WQE read: 0
> > > >          Memory fault on mirror pkt write: 0
> > > >          Memory fault on multicast pkt write: 0
> > > >    NIX_AF_RAS:
> > > >          Poisoned data on NIX_AQ_INST_S read: 0
> > > >          Poisoned data on NIX_AQ_RES_S write: 0
> > > >          Poisoned data on HW context read: 0
> > > >          Poisoned data on packet read from mirror buffer: 0
> > > >          Poisoned data on packet read from mcast buffer: 0
> > > >          Poisoned data on WQE read from mirror buffer: 0
> > > >          Poisoned data on WQE read from multicast buffer: 0
> > > >          Poisoned data on NIX_RX_MCE_S read: 0
> > > >    NIX_AF_RVU:
> > > >          Unmap Slot Error: 0
> > > >
> > >
> > > Now i am a little bit skeptic here, devlink health reporter
> > > infrastructure was
> > > never meant to deal with dump op only, the main purpose is to
> > > diagnose/dump and recover.
> > >
> > > especially in your use case where you only report counters, i don't
> > > believe
> > > devlink health dump is a proper interface for this.
> > These are not counters. These are error interrupts raised by HW
> > blocks.
> > The count is provided to understand on how frequently the errors are
> > seen.
> > Error recovery for some of the blocks happen internally. That is the
> > reason,
> > Currently only dump op is added.
>
> So you are counting these events in driver, sounds like a counter to
> me, i really think this shouldn't belong to devlink, unless you really
> utilize devlink health ops for actual reporting and recovery.
>
> what's wrong with just dumping these counters to ethtool ?

This driver is a administrative driver which handles all the resources
in the system and doesn't do any IO.
NIX and NPA are key co-processor blocks which this driver handles.
With NIX and NPA, there are pieces
which gets attached to a PCI device to make it a networking device. We
have netdev drivers registered to this
networking device. Some more information about the drivers is available at
https://www.kernel.org/doc/html/latest/networking/device_drivers/ethernet/marvell/octeontx2.html

So we don't have a netdev here to report these co-processor block
level errors over ethtool.

Thanks,
Sunil.
