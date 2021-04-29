Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4EE36F239
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 23:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237482AbhD2Vow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 17:44:52 -0400
Received: from mail-ot1-f53.google.com ([209.85.210.53]:39930 "EHLO
        mail-ot1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237337AbhD2Vov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 17:44:51 -0400
Received: by mail-ot1-f53.google.com with SMTP id 65-20020a9d03470000b02902808b4aec6dso57951010otv.6;
        Thu, 29 Apr 2021 14:44:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NUjEHeIYS+Jp7nmJYchYeYeVG/hrdkNydZypiWccS9s=;
        b=kOY/RVEysATDvVco7+Esy/gTMSrzLFnSxaEoshvzDZvGDfsQrxq2og7SCvjue2k/5W
         YWLyIbS3C08pQLFVHPuKM1s7BwydxlQij3ULFQwxev3StMzp2r/YWgWONPd7kMD02vm6
         esTkH2pThrXHn9mCJLKR5xwIlOkiyQdHQa5edLieg2taRowmjEdQw/tXfS2xPceKRBxq
         hDcWQTBpCrC1Mp0FThjIKR4Irt6pXa3irGx9nLi82Uni5N3K1LSCuO68JtlSRatb1U1w
         AIosgjTuoQQXvucBV71fWWsYHhKJsMThpqc3DOpIdCUEXF9xDAnadAM/wodL0wMLT5LR
         8bKg==
X-Gm-Message-State: AOAM530ZkyUd3iiaxddJ41btOOjhlhShzutaorPYXcxOyAZG76e47FMo
        q6N4P95djq5KxNUNGrQWtA==
X-Google-Smtp-Source: ABdhPJygXojSe2J50XKBCo08TPZKWp/owhJaMfn7/8jv8UHyFyjpFTCS737KNSxaEN0EW0zI7vvFRw==
X-Received: by 2002:a9d:46f:: with SMTP id 102mr1145972otc.218.1619732644218;
        Thu, 29 Apr 2021 14:44:04 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id q130sm276601oif.40.2021.04.29.14.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 14:44:03 -0700 (PDT)
Received: (nullmailer pid 1828784 invoked by uid 1000);
        Thu, 29 Apr 2021 21:44:02 -0000
Date:   Thu, 29 Apr 2021 16:44:02 -0500
From:   Rob Herring <robh@kernel.org>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>, netdev@vger.kernel.org,
        davem@davemloft.net, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, wigyori@uid0.hu, rayknight@me.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 1/3 net-next v4] net: ethernet: ixp4xx: Add DT bindings
Message-ID: <20210429214402.GA1823812@robh.at.kernel.org>
References: <20210425003038.2937498-1-linus.walleij@linaro.org>
 <161940061597.7794.15882879498463210620.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161940061597.7794.15882879498463210620.git-patchwork-notify@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 01:30:15AM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This series was applied to netdev/net-next.git (refs/heads/master):
> 
> On Sun, 25 Apr 2021 02:30:36 +0200 you wrote:
> > This adds device tree bindings for the IXP4xx ethernet
> > controller with optional MDIO bridge.
> > 
> > Cc: Zoltan HERPAI <wigyori@uid0.hu>
> > Cc: Raylynn Knight <rayknight@me.com>
> > Cc: devicetree@vger.kernel.org
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> > 
> > [...]
> 
> Here is the summary with links:
>   - [1/3,net-next,v4] net: ethernet: ixp4xx: Add DT bindings
>     https://git.kernel.org/netdev/net-next/c/48ac0b5805dd
>   - [2/3,net-next,v4] net: ethernet: ixp4xx: Retire ancient phy retrieveal
>     https://git.kernel.org/netdev/net-next/c/3e8047a98553
>   - [3/3,net-next,v4] net: ethernet: ixp4xx: Support device tree probing
>     https://git.kernel.org/netdev/net-next/c/95aafe911db6

What happened to net-next being closed during the merge window? Oh 
well, I'm sure someone is checking the schemas...

Rob
