Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 979CB41B34D
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 17:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241716AbhI1PvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 11:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241649AbhI1PvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 11:51:20 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF944C06161C;
        Tue, 28 Sep 2021 08:49:40 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id y35so33914467ede.3;
        Tue, 28 Sep 2021 08:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hRiBztZqBVQEzMkrcGgXWRAdKig8C9T5npDuGjeSkF0=;
        b=O6qG2E0JSc4jtkX1FlgDJuyQzrwHCXuTBIMLdLdLy4IBeMLatdehA8sObA/bCpUPcS
         SDgnXUsGujmwrwRnkHcO2QY61U68ZMEp1rCYV+Sms79fw+xeo8ZXYZ9xUonlvicnidmu
         JMcRG3m1uA/D84+RRItYInoZjFBeBQbqRSEwoRa7e++hYoFfVkoe7JtWhrzWl9gE1KiL
         T7j8L1uE6wyDbiBmR3Eut3vi2tZ4dnBn3C2Spr75Lezq5adq32Far/MFenKJj6ICj6L9
         CF2RqYRzfRgQDcs7kUWPUv8Pacj++nQYLJSUNK2ki6wfw3L8M4VQq3sYa7hQZvZsvUrs
         nAWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hRiBztZqBVQEzMkrcGgXWRAdKig8C9T5npDuGjeSkF0=;
        b=siEYQCI29jZb24kaHfyNCLz/OlwE6A5SRX/IBm1V/V9BD017NPm7aP7BloPlBwp3WJ
         Hw+Crw+wkU2HGSi6jlspw5XEK4c1nQ2QavK5T9IV38kEmIl2/0uyQGEY4otgAVoMZM4h
         FhpM8HF77ctMTWxBFUCm1YTlWHBiFTi6Rs4Q9NDDwIUbuijZyyHOYSDWx5eNcPOoWmpV
         cldf5h1wEoynR4HjWR5s0AVIZKnkK3f1ceLBJ5BJ2p8AyhWjW+Ync/urT6TbWZH0Isye
         Hys8OSlzfWmUWmILfHaIkAW61ycGzb1pYiFIJtBuKHw7EXd0PmT7+/dGSuOo+5tID5w4
         CRNg==
X-Gm-Message-State: AOAM530JE7ShXt7GcpgJ5niIgKyzAdJRRjZdrPXlxMn95oLAullywZ6+
        0F3VeIyeWIMf04YKps8XcOySelfwx6iXRwXDBfs=
X-Google-Smtp-Source: ABdhPJzQpqUF7UbUgIUC+WeIrjtZuqHjGV9wEes8bihvyMAmfAIJe8udtm6pYBDZAKCTcYp+57UtD3Ny6yqN+AZ9CHo=
X-Received: by 2002:a17:906:38c8:: with SMTP id r8mr7501161ejd.172.1632844129259;
 Tue, 28 Sep 2021 08:48:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210928092657.GI2048@kadam> <6f90fa0f-6d3b-0ca7-e894-eb971b3b69fa@gmail.com>
 <20210928103908.GJ2048@kadam> <63b18426-c39e-d898-08fb-8bfd05b7be9e@gmail.com>
 <20210928105943.GL2083@kadam> <283d01f0-d5eb-914e-1bd2-baae0420073c@gmail.com>
 <f587da4b-09dd-4c32-4ee4-5ec8b9ad792f@gmail.com> <20210928113055.GN2083@kadam>
 <YVMRWNDZDUOvQjHL@shell.armlinux.org.uk> <20210928135207.GP2083@kadam> <YVM3sFBIHzEnshvd@shell.armlinux.org.uk>
In-Reply-To: <YVM3sFBIHzEnshvd@shell.armlinux.org.uk>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Tue, 28 Sep 2021 23:48:23 +0800
Message-ID: <CAD-N9QXHcrv+6SJSOz3NyBkAnze2wVf_azYmjbGCVd5Ge_OQng@mail.gmail.com>
Subject: Re: [PATCH] net: mdiobus: Fix memory leak in __mdiobus_register
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Yanfei Xu <yanfei.xu@windriver.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        andrew@lunn.ch, hkallweit1@gmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, p.zabel@pengutronix.de,
        syzbot <syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 11:41 PM Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
>
> On Tue, Sep 28, 2021 at 04:52:07PM +0300, Dan Carpenter wrote:
> > On Tue, Sep 28, 2021 at 01:58:00PM +0100, Russell King (Oracle) wrote:
> > >
> > > This thread seems to be getting out of hand.
> >
> > The thread was closed.  We need to revert Yanfei's patch and apply
> > Pavel's patch.  He's going to resend.
> >
> > > So, I would suggest a simple fix is to set bus->state to
> > > MDIOBUS_UNREGISTERED immediately _after_ the successful
> > > device_register().
> >
> > Not after.  It has to be set to MDIOBUS_UNREGISTERED if device_register()
> > fails, otherwise there will still be a leak.
>
> Ah yes, you are correct - the device name may not be freed. Also...
>
>  * NOTE: _Never_ directly free @dev after calling this function, even
>  * if it returned an error! Always use put_device() to give up your
>  * reference instead.
>
> So yes, we must set to MDIOBUS_UNREGISTERED even if device_register()
> fails.
>

So we have reached an agreement. Pavel's patch fixes the syzbot link
[1], other than Yanfei's patch. However, Yanfei's patch also fixes
another memory link nearby.

Right?

[1] https://syzkaller.appspot.com/bug?id=fa99459691911a0369622248e0f4e3285fcedd97

> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
