Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B53211595
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 00:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgGAWEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 18:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgGAWEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 18:04:14 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A593C08C5C1;
        Wed,  1 Jul 2020 15:04:14 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id dm19so15202055edb.13;
        Wed, 01 Jul 2020 15:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iFf+nz1PIcWLglG4iJr5ZGTsWCrjow9npmRMAWBEENw=;
        b=YvEIfAV0Igjy0O0J0IYztMsG1KekvK4sHRwUPH8yQojQAFQtDJq89FSEVpW8aN0rPi
         tgk38NR2HLoMn3VsPGa53Cz6akmXIziT/l1Qyt+jinp5ovJXM/NaRQ3paHG4yTTQ9HZF
         b5SerZOayYtHcFu7cz4k7INgp+8Iq3gUTeW4aMy2/nyAgTq0135jzdQPeg9vZ+q2Rte7
         KglE19fUB/F/RK0eZ29tA0nosomgdlMdLcQ28CheiQoL0rGfNoOQsunr1YlMvq/67hUV
         0p3osMJIp7sJ/vp4MXdAu3Lr/dxkItDqSLni+dzAJRfVPEdB5uUL1pgabFzKmpy5gWiH
         p7mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iFf+nz1PIcWLglG4iJr5ZGTsWCrjow9npmRMAWBEENw=;
        b=i4epEh9hGjUODK3TM0NSXVJlW3cSyHJPTVmzZWq3GWzmDxK+PPHPnvjdQB/laKCV/R
         ldERs5HaMTdmyKwXw2Ta1GMTGRgAKcdHMqFkKPxgPdtkgzqWrjC+SjjtXK9QCuN50i33
         sE83zWSqEB1dJ+ovppI9M++85zr4fdgptFDugaboFU8alwRNQ82Q87JtP8oLzWBR11Sa
         XejtzoMeQKa44wouqmdIcpb4DN4RixtZSRXB1dAE52EDJv7le4U4nYGLqNsycr9C6KQ1
         8kgTbbJBhtDS6YJSxcmvM09t0gaq19OcmAdRSpRDqodXOlZVGzwKHJNNzdC4J9qstZzc
         xW+Q==
X-Gm-Message-State: AOAM5333Vuo8JcmHlrP7G0S/meHifTyFIHOALxloWxIJyEZyLxAYHSHo
        Zs+n8hX9UppfZPexyu0sihZ+uSM9se6G9/QskpU=
X-Google-Smtp-Source: ABdhPJx2uiQuAv8NKlOX1yDPenefz1yRqEZ83yzQi/GqTFtCmxYidN1mAmQmElJusOWegGptOzISl7YuQL0KmMJw1cw=
X-Received: by 2002:a05:6402:2d7:: with SMTP id b23mr19223958edx.145.1593641053052;
 Wed, 01 Jul 2020 15:04:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200701213433.9217-1-michael@walle.cc> <20200701215310.GL1551@shell.armlinux.org.uk>
In-Reply-To: <20200701215310.GL1551@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 2 Jul 2020 01:04:02 +0300
Message-ID: <CA+h21hotHbN1xpZcnTMftXesgz7T6sEGCCPzFKdtG1NfMxguLg@mail.gmail.com>
Subject: Re: [PATCH RESEND net-next v3 0/3] net: enetc: remove bootloader dependency
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Michael Walle <michael@walle.cc>, netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Heiko Thiery <heiko.thiery@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Jul 2020 at 00:53, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> fixing up almost every driver the best I can with the exception of two -
> felix DSA and Mediatek.
>
> I'm not going to wait for Felix or Mediatek.  As I say, I've given
> plenty of warning, and it's only a _suspicion_ of breakage on my
> side.
>

What do you mean "I'm not going to wait for Felix"?
https://patchwork.ozlabs.org/project/netdev/patch/20200625152331.3784018-5-olteanv@gmail.com/
We left it at:

> I'm not going to review patch 7
> tonight because of this fiasco.  To pissed off to do a decent job, so
> you're just going to have to wait.

So, I was actively waiting for you to review it ever since, just like
you said, so I could send a v2. Were you waiting for anything?

Thank you,
-Vladimir
