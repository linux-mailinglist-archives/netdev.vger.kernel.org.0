Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A88A2F84AA
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 19:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387526AbhAOSo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 13:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbhAOSoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 13:44:25 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4362DC0613C1;
        Fri, 15 Jan 2021 10:43:45 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id u19so10674191edx.2;
        Fri, 15 Jan 2021 10:43:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2wTYsbuyYQ2FbFdy6VZkTjORDxCVE2/HiFWUNQyuqfo=;
        b=TA5SREHguQtnh4V82TM0JtFv/Nox2ciU80Iae2LFCssqGDAfkzIF1WlKWzGA5W0mo2
         Z190SFkCoGB3UtVRrHCW6Sh5T4BhngIkmb/gTe0cXFiJmlWlzSIGwEenRZnXdKx0oGqc
         hTWGld3Nfs8rVAYr54D+NvpVdr9e6yrkDjTNxqkQIiozKYj5bYmI63OCb046LgF4ta85
         giK7BsWaaMrWdq/2q6FpEV32FOrqeTKhlP0SRWja9TJPXryzpvJTtv+0Sr++6NXm5uwV
         EpAU2OUPLxVKdUUL3NHc+BtPf984GqhpO/qYtmpPOhGY535Vq/WnrCxI5WQCBDCcXi81
         wYBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2wTYsbuyYQ2FbFdy6VZkTjORDxCVE2/HiFWUNQyuqfo=;
        b=teRu7Ltpw0tG/voiTxoth6h775+NWXMPyoq/9OTFrr5cD1bEEmVMb6Ad9/XhpmCLbh
         cnd0PgSMKBvQEokq+ATQLRi87BDLHihLbTmOcJaGpujnRjod8FktmrIUVOmK1+kEUV0x
         Q30fFMGH+y0otb2K50f3AC2Q4XTiA6saH4pqa/NohhyLGnLW0ftMghUlCG+E9esaaIQx
         Ls8OJ/X1ClPoBx55UXEsGIFwE96GBZPX8MaOBXojyHxZNTtBI36+2MAA/dYrbFoirK9+
         dorA888bVJ7nUhAgpvuBzm/cXZoBhxEFXHBqekeVqIffa88ncNn78Xnzxmhj0vxlgHNw
         ej1g==
X-Gm-Message-State: AOAM531p5RoPr3mlCgMwRrekVexspwRYiRj98J/iC8fagw5mOIlr9I3O
        Ye4GZ6iSFj9y2pn0FFZY5dY=
X-Google-Smtp-Source: ABdhPJzfm4ZE9tW7a5cOdid8Be0Ri9Z1l7Nnmx9gaWSuokT1bvaxR/aS/+U4vPDyfuOEv2MwxCB41w==
X-Received: by 2002:aa7:c78c:: with SMTP id n12mr10884722eds.363.1610736224029;
        Fri, 15 Jan 2021 10:43:44 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id mb15sm4051240ejb.9.2021.01.15.10.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 10:43:43 -0800 (PST)
Date:   Fri, 15 Jan 2021 20:43:42 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v5 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20210115184342.jp7vu3pxukoifxsv@skbuf>
References: <20210114195734.55313-1-george.mccollister@gmail.com>
 <20210114195734.55313-3-george.mccollister@gmail.com>
 <20210114224843.374dmyzvtszat6m4@skbuf>
 <CAFSKS=P5u8YAL=1Rww0VqdHkcf11j7R-bJ02sj6pWoxvqRm3jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFSKS=P5u8YAL=1Rww0VqdHkcf11j7R-bJ02sj6pWoxvqRm3jw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 09:30:29AM -0600, George McCollister wrote:
> On Thu, Jan 14, 2021 at 4:48 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > On Thu, Jan 14, 2021 at 01:57:33PM -0600, George McCollister wrote:
> [snip]
> >
> > Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> >
> > This driver is good to go, just one small nitpick below, you can fix it
> > up afterwards if you want.
> >
> > > +static void xrs700x_port_stp_state_set(struct dsa_switch *ds, int port,
> > > +                                    u8 state)
> > > +{
> > > +     struct xrs700x *priv = ds->priv;
> > > +     unsigned int bpdus = 1;
> > > +     unsigned int val;
> > > +
> > > +     switch (state) {
> > > +     case BR_STATE_DISABLED:
> > > +             bpdus = 0;
> > > +             fallthrough;
> > > +     case BR_STATE_BLOCKING:
> > > +     case BR_STATE_LISTENING:
> > > +             val = XRS_PORT_DISABLED;
> > > +             break;
> > > +     case BR_STATE_LEARNING:
> > > +             val = XRS_PORT_LEARNING;
> > > +             break;
> > > +     case BR_STATE_FORWARDING:
> > > +             val = XRS_PORT_FORWARDING;
> > > +             break;
> > > +     default:
> > > +             dev_err(ds->dev, "invalid STP state: %d\n", state);
> > > +             return;
> > > +     }
> > > +
> > > +     regmap_fields_write(priv->ps_forward, port, val);
> > > +
> > > +     /* Enable/disable inbound policy added by xrs700x_port_add_bpdu_ipf()
> > > +      * which allows BPDU forwarding to the CPU port when the front facing
> > > +      * port is in disabled/learning state.
> >                       ~~~~~~~~
> > You probably mean blocking. When the port is in BR_STATE_DISABLED, you
> > set bpdus = 1, which makes sense.
> 
> That doesn't sound quite right, let me try to explain this differently
> and you can tell me if it makes more sense. If so I'll update it, add
> the reviewed-bys and post v6:
> 
> Enable/disable inbound policy added by xrs700x_port_add_bpdu_ipf()
> which allows BPDU forwarding to the CPU port. The policy must be
> enabled when the front facing port is in BLOCKING, LISTENING and
> LEARNING BR_STATEs since the switch doesn't otherwise forward BPDUs
> when the port is set to XRS_PORT_DISABLED and XRS_PORT_LEARNING.

No, that was clear in the first place. It is even intelligible with the
comment as-is, otherwise I would have asked you what you mean. You don't
need to resent. I made a mistake when I said "you set bpdus = 1", you
obviously set bpdus = 0 for BR_STATE_DISABLED and 1 for everything else.
I think I should just get more sleep before giving review comments.
