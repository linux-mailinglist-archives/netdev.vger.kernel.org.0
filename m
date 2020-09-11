Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781C4266848
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 20:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbgIKSgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 14:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgIKSgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 14:36:01 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C04EC061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 11:36:00 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id j2so312167eds.9
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 11:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uFgeIqg587v9QaR00HukuFgpI4dYfAPg8DV43TLLb3o=;
        b=tJ/9SfGYh64hzni+cv9DS9W7S/2TrLduSxIJCgiLXetkSh+5KymCzahpVugQJvzrS+
         J48ma9xVGEYs22nTJn5pMDzT+n5QvyIJG+4oS89glS7cf6BCnR+wOVmyDwsPVE3zp2K5
         DJGBoG+YoSne4KAsKFP98+pKBKhY8f59ILsRu/m4+OJzmXcM1EHkO2SNG7JlWr/Imslz
         PcZCY2vbuzM9KQWOgaIyB9qT4MjrW0d1sOePlO69CtDG4Ur16z8jk0IckSimu9WsKLyX
         eOrnymd7Cb2NwA4NRa7UPbl/7Py+V4QpHHzChXWtncybZW/uu12vCHpI0OdVQ361uRWq
         O5RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uFgeIqg587v9QaR00HukuFgpI4dYfAPg8DV43TLLb3o=;
        b=QI8j2vl6itpp6nxyDbrch3qRMEQ+aR720wY7hxM7biff3aSYpt3/ZDEaID5xkrAo22
         a8OGiFd5CbQVWgCn2jnD4A1gzuK+OxNlBmTnxzsPdSGALhj5aDh6rHPeF3Y69FVhM4Nr
         UUXAK11Mypy81gvi3ir3bNQ4iPG62pW/nAUOOaPI7Jp9AoodqMcZnA46HooFiDQeowlv
         ZG5iMZD4sLHYUqO6H07HQ/2SoEa6z7HWFGDPdb2NjZ870bHZ1Q2rC7GHf6TiGvZiUuol
         vCV8z0V5/F0jyBQ/kRJI98QQGkgEd+LANLpVr6umAMbHAaP5Ch/hd1geDW/MK8o1DQ4E
         Piaw==
X-Gm-Message-State: AOAM530zazbc4cDgmT2tC9aZbsVJXflrfmrlAkDYHX436mwx6YR/MgpN
        qeRYmBDgRt579HON9x9Le70=
X-Google-Smtp-Source: ABdhPJxpHxXeeevN4KcEmfWDjMkpA4p43L3tb8ktAa5aONkRTDDsslJ6i6RlhYnhNppTb5Ce9WQhIw==
X-Received: by 2002:aa7:d30b:: with SMTP id p11mr3735911edq.80.1599849358626;
        Fri, 11 Sep 2020 11:35:58 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id c22sm2266162edr.70.2020.09.11.11.35.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 11:35:58 -0700 (PDT)
Date:   Fri, 11 Sep 2020 21:35:56 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     davem@davemloft.net, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] net: dsa: set
 configure_vlan_while_not_filtering to true by default
Message-ID: <20200911183556.l3cazdcwkosyw45v@skbuf>
References: <f0217ae5-7897-17e2-a807-fc0ba0246c74@gmail.com>
 <20200909163105.nynkw5jvwqapzx2z@skbuf>
 <11268219-286d-7daf-9f4e-50bdc6466469@gmail.com>
 <20200909175325.bshts3hl537xtz2q@skbuf>
 <5edf3aa2-c417-e708-b259-7235de7bc8d2@gmail.com>
 <7e45b733-de6a-67c8-2e28-30a5ba84f544@gmail.com>
 <20200911000337.htwr366ng3nc3a7d@skbuf>
 <04823ca9-728f-cd06-a4b2-bb943d04321b@gmail.com>
 <20200911154340.mfe7lwtklfepd5go@skbuf>
 <b6ec9450-6b3e-0473-a2f9-b57016f010c1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6ec9450-6b3e-0473-a2f9-b57016f010c1@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 11:23:28AM -0700, Florian Fainelli wrote:
> On 9/11/2020 8:43 AM, Vladimir Oltean wrote:
> > > The slightly confusing part is that a vlan_filtering=1 bridge accepts the
> > > default_pvid either tagged or untagged whereas a vlan_filtering=0 bridge
> > > does not, except for DHCP for instance. I would have to add a br0.1 802.1Q
> > > upper to take care of the default_pvid being egress tagged on the CPU port.
> > >
> > > We could solve this in the DSA receive path, or the Broadcom tag receive
> > > path as you say since that is dependent on the tagging format and switch
> > > properties.
> > >
> > > With Broadcom tags enabled now, all is well since we can differentiate
> > > traffic from different source ports using that 4 bytes tag.
> > >
> > > Where this broke was when using a 802.1Q separation because all frames that
> > > egressed the CPU were egress tagged and it was no longer possible to
> > > differentiate whether they came from the LAN group in VID 1 or the WAN group
> > > in VID 2. But all of this should be a thing of the past now, ok, all is
> > > clear again now.
> >
> > Or we could do this, what do you think?
>
> Yes, this would be working, and I just tested it with the following delta on
> top of my b53 patch:
>
> diff --git a/drivers/net/dsa/b53/b53_common.c
> b/drivers/net/dsa/b53/b53_common.c
> index 46ac8875f870..73507cff3bc4 100644
> --- a/drivers/net/dsa/b53/b53_common.c
> +++ b/drivers/net/dsa/b53/b53_common.c
> @@ -1427,7 +1427,7 @@ void b53_vlan_add(struct dsa_switch *ds, int port,
>                         untagged = true;
>
>                 vl->members |= BIT(port);
> -               if (untagged)
> +               if (untagged && !dsa_is_cpu_port(ds, port))
>                         vl->untag |= BIT(port);
>                 else
>                         vl->untag &= ~BIT(port);
> @@ -1465,7 +1465,7 @@ int b53_vlan_del(struct dsa_switch *ds, int port,
>                 if (pvid == vid)
>                         pvid = b53_default_pvid(dev);
>
> -               if (untagged)
> +               if (untagged && !dsa_is_cpu_port(ds, port))
>                         vl->untag &= ~(BIT(port));
>
>                 b53_set_vlan_entry(dev, vid, vl);
>
> and it works, thanks!
>

I'm conflicted. So you prefer having the CPU port as egress-tagged?

Also, I think I'll also experiment with a version of this patch that is
local to the DSA RX path. The bridge people may not like it, and as far
as I understand, only DSA has this situation where pvid-tagged traffic
may end up with a vlan tag on ingress.

Thanks,
-Vladimir
