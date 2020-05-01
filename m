Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F35341C1B49
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 19:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730133AbgEARKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 13:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728495AbgEARKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 13:10:19 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9937C061A0C;
        Fri,  1 May 2020 10:10:18 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id t12so7745093edw.3;
        Fri, 01 May 2020 10:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mdsa9GHdUWtpaN13DncP5RB/gp8GCrhEqRpKlncbW8M=;
        b=VFix+ZzzMeP4eNt2Ma6wISbnBws23mS6CK24e9btsoxi/rWAL28gHCi3lnw01N2Mso
         xg7A5BAI4W+HY83Q4a9smJTfbPRB6vX6oaiV3FXBRkn6hDHWIN0DGdL47vAFMZS93EAF
         Xkpme5PxE0x9U6DQBOSk3KEchoiisb+4c0tORK82VbZJgmveYqqkviH8RVMWJ5kFg7Xj
         2ccbyQziO0INOSv7Rs+puN5g+q31+TzX5QZpBq0IJFlBvvq+RRHCqRO29F3xDWvwUxN3
         UqXlO2R0Jo/A2g7JJ6pIyPJD/KyOOoAubmsnNLXOyDELxVxqF3Zt+TX4hw9AX1+H4XOu
         eayg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mdsa9GHdUWtpaN13DncP5RB/gp8GCrhEqRpKlncbW8M=;
        b=KH6APUGmwO6Cgkv0Yr7wskij2sg1bsKpbIBT431RhNEcBwvYBoLxbSPlVJsfpbeZTL
         vCcgVwDhyLs+IZgNCbXTmXe76lAGsxOKGJJRGs6oJnU/JaaESiUOP2BEOBiiVoZtMXwS
         itE3ot4Qpu+ZMN5kV+t7hPt4hKEnEDzu2tZXC03SMnL/4jS55O4AzAeMDv2pHqtKRK6q
         x5ng3vIjQiNM+otZEM3ES+LCfvu76cma6E40FxPrnw359XGCs9B9ArLCYN7RSpbRDYMv
         FVGuoIT1NIdt5pLzqWHaqFHb4EOYO8AiQKJRTjgKNWuIqb2GfekUD/yua822zKWDNrHS
         d29A==
X-Gm-Message-State: AGi0PuZftMEqRK0YqDO+jlQbgsRnLa52uE4NxttneIjJSKH/r4KGK4rM
        7UKqp+Sc0w5Ixot+lc7HHGkYceDwRoIU+Ye88T4=
X-Google-Smtp-Source: APiQypIlznByGASsngfncYgj2mcw6Vrs/KqUKB8Ee7ab33jQKBgHBdr9tJ2P2JZNmmWhIHFqaa9FcURiBcyKlJ1LWcU=
X-Received: by 2002:a50:fc06:: with SMTP id i6mr4256455edr.110.1588353017519;
 Fri, 01 May 2020 10:10:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
 <20200429201644.1144546-9-martin.blumenstingl@googlemail.com> <20200501154448.GH128733@lunn.ch>
In-Reply-To: <20200501154448.GH128733@lunn.ch>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Fri, 1 May 2020 19:10:06 +0200
Message-ID: <CAFBinCCbtLRomdikKWkS+HOFoek4cGhN4L91FQfQ4rbKTV-xvg@mail.gmail.com>
Subject: Re: [PATCH RFC v2 08/11] net: stmmac: dwmac-meson8b: add support for
 the RX delay configuration
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     robh+dt@kernel.org, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        jianxin.pan@amlogic.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Fri, May 1, 2020 at 5:44 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > +     if (rx_dly_config & PRG_ETH0_ADJ_ENABLE) {
> > +             /* The timing adjustment logic is driven by a separate clock */
> > +             ret = meson8b_devm_clk_prepare_enable(dwmac,
> > +                                                   dwmac->timing_adj_clk);
> > +             if (ret) {
> > +                     dev_err(dwmac->dev,
> > +                             "Failed to enable the timing-adjustment clock\n");
> > +                     return ret;
> > +             }
> > +     }
>
> Hi Martin
>
> It is a while since i used the clk API. I thought the get_optional()
> call returned a NULL pointer if the clock does not exist.
> clk_prepare_enable() passed a NULL pointer is a NOP, but it also does
> not return an error. So if the clock does not exist, you won't get
> this error, the code keeps going, configures the hardware, but it does
> not work.
>
> I think you need to check dwmac->timing_adj_clk != NULL here, and
> error out if DT has properties which require it.
Thank you for your excellent code review quality (as always)!
you are right and I will fix that in the next version


Martin
