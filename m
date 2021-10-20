Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60981435259
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 20:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbhJTSKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 14:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbhJTSKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 14:10:37 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA365C06161C;
        Wed, 20 Oct 2021 11:08:22 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id d21-20020a9d4f15000000b0054e677e0ac5so7479292otl.11;
        Wed, 20 Oct 2021 11:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wP/mB1qZJe5g+pwoorAaeFOblwRY0oDwaSr3e3eVqxA=;
        b=AvmhQIc5Yr/COM8fDecgdx5pQypgoZ1Mq09JQL+C2SlHP9Ejd8yv80hM6oFKVL9chD
         yt5CP0w0ENdaAr9E677iAOci+MeDvjBO5k231FGjjKQGA8yxFwerM9duNnocmWR041zG
         Bv9cMYXxtHTXE5kga1scyYT9T7km8LM6ES+4qgXfAkmFNL/FHGY4MO6GhGcR1+r1aP3T
         NmzHjRiYwzJ3OhYbIDeOeiwKHAkE89FV5dyhUqoXpUXEzw0/TtnPzhI3i7wb3SGRScQs
         Uss5NpbK14bk+rFTZnzMA7CNPvDBKLHRss2fkHWqbRFItD1UvkZNO0ADMYA/a3Puw7ip
         dVPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wP/mB1qZJe5g+pwoorAaeFOblwRY0oDwaSr3e3eVqxA=;
        b=56DWoeLCN4oCUphCqCiuhOWIaxLO5tRVdQe4Srk52/01/YXAqzOInUl6si1x+hfzBR
         0Eyj1QF+jwLGuo6Re/EwEs8iitnf2XVF7f4mqKeeL2cWmEWfHXGPOpJ1pP73heFmNqX/
         TjOz0NzNDApmIxCDZQ/Zrxh3lc+WY18NYdEBu2FpcO9DTp/mH4hyIutPmv4AR/ipWAvG
         lbw37zOFoWtfKDvD+ERxdTfGdemwq/uX1N7MN07R/1M433FPvEg/CRE1K83Kgo3l3NTK
         O12bYf7Rb+TaCGnQM3uupbFR58cI9SoEa0h9ASv8u7tjA7DI0fre4ouzO+9sP+aDYpHF
         AOYQ==
X-Gm-Message-State: AOAM533PP4bA3ehRa3tJpBCrAdHY4k6txJWLIgMByPzJ/P0oCOUx3pkn
        I6bAcyV8esJMKIbFo1Om2inSBmWMs5DxdT4FntU=
X-Google-Smtp-Source: ABdhPJz/PySPsO38rUxwoenDSbW9EMnPquIoJnT6awfWd0tx4IOccSLTpi7kPtfbpCVK8PQPfjZ+Jmg0T6MQ3VQchyY=
X-Received: by 2002:a9d:734d:: with SMTP id l13mr688223otk.238.1634753302001;
 Wed, 20 Oct 2021 11:08:22 -0700 (PDT)
MIME-Version: 1.0
References: <20211018085305.853996-1-luo.penghao@zte.com.cn> <20211020092537.GF3935@kernel.org>
In-Reply-To: <20211020092537.GF3935@kernel.org>
From:   Jesse Brandeburg <jesse.brandeburg@gmail.com>
Date:   Wed, 20 Oct 2021 11:08:11 -0700
Message-ID: <CAEuXFEzXSU-Ws6T_8TBVfgskh4VA14LmirFYSjdQpwtndfeeww@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH linux-next] e1000: Remove redundant statement
To:     Simon Horman <horms@kernel.org>
Cc:     luo penghao <cgel.zte@gmail.com>,
        NetDEV list <netdev@vger.kernel.org>,
        Zeal Robot <zealci@zte.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org, Jakub Kicinski <kuba@kernel.org>,
        luo penghao <luo.penghao@zte.com.cn>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apologies for the duplicates, mail from my intel account going out
through outlook.com is not being delivered.

On Wed, Oct 20, 2021 at 7:00 AM Simon Horman <horms@kernel.org> wrote:

> > Value stored to 'ctrl_reg' is never read.
>
> I agree this does seem to be the case.
>
> > Reported-by: Zeal Robot <zealci@zte.com.cn>
> > Signed-off-by: luo penghao <luo.penghao@zte.com.cn>
>
> Reviewed-by: Simon Horman <horms@kernel.org>

Thanks for the review, but (davem/kuba) please do not apply.

> > @@ -1215,8 +1215,6 @@ static int e1000_integrated_phy_loopback(struct e1000_adapter *adapter)
> >               e1000_write_phy_reg(hw, PHY_CTRL, 0x8140);
> >       }
> >
> > -     ctrl_reg = er32(CTRL);

Thanks for your patch, but this change is not safe. you're removing a
read that could do two things. The first is that the read "flushes"
the write just above to PCI (it's a PCI barrier), and the second is
that the read can have some side effects.

If this change must be done, the code should be to remove the
assignment to ctrl_reg, but leave the read, so the line would just
look like:
        er32(CTRL);

This will get rid of the warning and not change the flow from the
hardware perspective.

> > -
> >       /* force 1000, set loopback */
> >       e1000_write_phy_reg(hw, PHY_CTRL, 0x4140);
> >

Please do not apply this.
