Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34122273B8A
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 09:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729803AbgIVHPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 03:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729774AbgIVHPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 03:15:14 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A86C061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:15:13 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id s205so13211564lja.7
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nBA/ZJIe5iPuWqiqRDaypsyElJCWV/FBf0JxuxOKs+k=;
        b=CoanfWAS9+dkD+Z4sKSJJM2QQBaCOo1ETAhY+T542ptwMaT9mby0B9oxF7pc1QzGb4
         bU+LYSw9ctdKI03vMWC4OQhMhmPs1JURzYNO9qoYVl3crDMDNCYYPGn8BODhokMe7KBV
         i0TDeSeW/EE1oKmQxtqNRNapj4ZIcqV5WCD78=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nBA/ZJIe5iPuWqiqRDaypsyElJCWV/FBf0JxuxOKs+k=;
        b=CnSGHg42j/ItQRm+uruy51kUigQfkGYntAImrptJ1fWVfsDs6dTNkIbQ5ejHYBAqCA
         8O9R/vHQqFwKunfZF+nA2rFWy5F8DiAnnluP3NfLp+KbB0Oi/eh+wVOpj992OnVxmTLR
         RK0MKKOl39WZblONTMjX+5ZfYD7jfuEmGwYFgVl+PreDQszH5kbRyRur0C4eZH8xdn1Y
         NPv+Os7Ny45APa5tRAnkN1FxNJGHd66ezoeXXK/mWGAjaYWQhIVn4X04+jye+ZDDMjTZ
         vlONdBUV57nbtqQO7jv5bKNWxodX/pip1xCa6xD4Yk2rSa5qwXqKjyERYqwbnSYWv0kB
         Xikw==
X-Gm-Message-State: AOAM531yF6udfguO4XkkRt1HBjq87D903K1Pv2Lp4U5nx/nRqYv54F6D
        jC32WcPq0a2QVTRdxCbuwqpxcDYjmpHa1rWPEvvUVDh+0qw=
X-Google-Smtp-Source: ABdhPJw2+voLyVj7TRpPT8CcnpzktOqZl7TDYEE3W8wuLQpHwQ6RnX6FaCF1dmItX9Pv/AJjqZ20+F9JdCZqOLYFuIA=
X-Received: by 2002:a2e:808b:: with SMTP id i11mr1107298ljg.366.1600758912053;
 Tue, 22 Sep 2020 00:15:12 -0700 (PDT)
MIME-Version: 1.0
References: <1600670391-5533-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200921091820.hiulkidpedzgl4lz@lion.mk-sys.cz> <CAACQVJo1YCFsxTeUi7T_+0AtrDzYGAY-CRZXvm31NXbQ41CCTQ@mail.gmail.com>
 <20200922065207.yann26svrf32bnsd@lion.mk-sys.cz>
In-Reply-To: <20200922065207.yann26svrf32bnsd@lion.mk-sys.cz>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Tue, 22 Sep 2020 12:45:00 +0530
Message-ID: <CAACQVJqY5xhGUCmVnRu=Rd2dcdw5ZX2h6=mrE1fFkX-72_3qPQ@mail.gmail.com>
Subject: Re: [PATCH ethtool] bnxt: Add Broadcom driver support.
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 12:22 PM Michal Kubecek <mkubecek@suse.cz> wrote:
>
> On Tue, Sep 22, 2020 at 11:24:24AM +0530, Vasundhara Volam wrote:
> > On Mon, Sep 21, 2020 at 2:48 PM Michal Kubecek <mkubecek@suse.cz> wrote:
> > > > +             return -1;
> > > > +     }
> > > > +
> > > > +     pcie_stats = (u16 *)(regs->data + BNXT_PXP_REG_LEN);
> > > > +     fprintf(stdout, "PCIe statistics:\n");
> > > > +     fprintf(stdout, "----------------\n");
> > > > +     for (i = 0; i < ARRAY_SIZE(bnxt_pcie_stats); i++) {
> > > > +             pcie_stat = 0;
> > > > +             memcpy(&pcie_stat, &pcie_stats[stats[i].offset],
> > > > +                    stats[i].size * sizeof(u16));
> > >
> > > This will only work on little endian architectures.
> >
> > Data is already converted to host endian order by ETHTOOL_REGS, so it
> > will not be an issue.
>
> It does not work correctly. Assume we are on big endian architecture and
> are reading a 16-bit value (stats[i].size = 1) 0x1234 which is laid out
> in memory as
>
>     ... 12 34 ...
>
> Copying that by memcpy() to the address of 64-bit pcie_stat, you get
>
>    12 34 00 00 00 00 00 00
>
> which represents 0x1234000000000000, not 0x1234. You will also have the
> same problem with 32-bit values (stats[i].size = 2).
You are right. I understood the issue now.

I will modify it to use different size variables based on the size and
convert it to a switch statement.

Thanks.
>
> Michal
