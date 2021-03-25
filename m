Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551B2349295
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 14:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhCYNCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 09:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbhCYNC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 09:02:26 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC07C06174A;
        Thu, 25 Mar 2021 06:02:26 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id h13so2317466eds.5;
        Thu, 25 Mar 2021 06:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KQS35TMJy4T86ONDIZnKLs94bciaa3L422WJ0FTqWss=;
        b=RFWGp1bQOZREn5Y2Ri1MKBju/SFE1psyUCGeNeUN7tjKOPUlnoU7XZdZvZ3ir8xoHn
         SUQjPDxPQogq5VfsvC/XtAAPNtA5Pba8dSZfwVYEWG42g7L7e8kzMBQKD4aTw7p++D43
         Mgfd74+EVVM7bJjK3MABAO6dmZoHGMD37x1eANJh4zkMd+FsJ69bMuz9wqLh37GdoV5A
         gTvCz1B2K/YKkiM4rC7wqVqyFZWjan3xBju7PaomHNPgYq5yXeMSNwogiZXygu3iBc3u
         ekoxnwQA6R/BVBvFjDjXsbZNb5RaSXfLOitf6h5cIPkk2Ybth1wcdoAfeid9aqQNJrjA
         EEaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KQS35TMJy4T86ONDIZnKLs94bciaa3L422WJ0FTqWss=;
        b=FtOZcPW7KM7n+vIER2Zyka+kfAw5Aak4qk/4CPkgAenF62dH+6WjTSzgsIu4BAgDMS
         vIf0hiACqLQhRZSqnPNF7WNeZbd5ca6yuXWN9fB7AK+SzwyyiBBBLCF8Pr0N8YZPWljS
         3TaCU2ncY43h0eopbKJ+R8H4eX0CKYOjxw4kEOm8Jp1rbdMK63JzzTPoyUh0hovBtHy7
         XWod4iUrcdn3Basmio6NU6Zs9v6R+nQFzjbbe2UvSP0/iLJkfD7A+Q/TVkzVclwIPjZf
         WG9fG8w4J/EJOvSuJ2ePdSsP0lv4Ri9kSUMUflw8H9nK2z1a2XPstUTd05q9Z8Q+/N8x
         5wlQ==
X-Gm-Message-State: AOAM5322GsAcIEaOJOrBO0W7cu4YFq+s18mo8JGcuRE/GW5/0rii7qcG
        xbmg/cg0f4RVYY+FmmppvSnXSzSqCVBQp9MDKdo=
X-Google-Smtp-Source: ABdhPJzGCRnxNmEocmvJFl2tGCwcEob2RxbYURRmiWStbJz3Gv3AehO0e+pdaPs5FgrX8utZ6hsPIti0QqI1wFzORwQ=
X-Received: by 2002:aa7:d4d6:: with SMTP id t22mr9149294edr.376.1616677345028;
 Thu, 25 Mar 2021 06:02:25 -0700 (PDT)
MIME-Version: 1.0
References: <MWHPR18MB14217B983EFC521DAA2EEAD2DE649@MWHPR18MB1421.namprd18.prod.outlook.com>
 <YFpO7n9uDt167ANk@lunn.ch> <CA+sq2CeT2m2QcrzSn6g5rxUfmJDVQqjYFayW+bcuopCCoYuQ6Q@mail.gmail.com>
 <YFyHKqUpG9th+F62@lunn.ch>
In-Reply-To: <YFyHKqUpG9th+F62@lunn.ch>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Thu, 25 Mar 2021 18:32:12 +0530
Message-ID: <CA+sq2CfvscPPNTq4PR-6hjYhQuj=u2nmLa0Jq2cKRNCA-PypGQ@mail.gmail.com>
Subject: Re: [net-next PATCH 0/8] configuration support for switch headers & phy
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Hariprasad Kelam <hkelam@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 6:20 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > > So you completely skipped how this works with mv88e6xxx or
> > > prestera. If you need this private flag for some out of mainline
> > > Marvell SDK, it is very unlikely to be accepted.
> > >
> > >         Andrew
> >
> > What we are trying to do here has no dependency on DSA drivers and
> > neither impacts that functionality.
>
> So this is an indirect way of saying: Yes, this is for some out of
> mainline Marvell SDK.
>
> > Here we are just notifying the HW to parse the packets properly.
>
> But the correct way for this to happen is probably some kernel
> internal API between the MAC and the DSA driver. Mainline probably has
> no need for this private flag.
>
>    Andrew

Didn't get why you say so.
HW expects some info from SW to do the packet parsing properly and
this is specific to this hardware.
How can we generalize this ?
It's not just the DSA tags, the requirement is also for packets with
Higig header ie when system is connected to a switch
which appends Higig2 header to all pkts.

Thanks,
Sunil.
