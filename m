Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF652631F5
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731140AbgIIQbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730719AbgIIQbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:31:09 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB29DC061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 09:31:08 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id n22so3324838edt.4
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 09:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KUBv01Di0MSYF5v2MUYD1ZToQiEjPpf0YDuWlSv0bc4=;
        b=oCe6fzHxCeS+luvEGnKp/kgCmBWzxyrbaZVxYqryebQl5WxoZXXvdHdqbQOv/lVo4/
         gaeKEz1f+AKAngw8t7Ya8++FjR2RC7BwDTlgGfU1ZZL+3yB6BUCrlI6sOIXY0IWH7WO4
         tx2+l0byx+YEDAcrs4JICpfoq67F35h6kE4BVeZe650cv/KrhZCMlDGMPLgoqKh6NjtE
         USCZhAEwO4erhI9ffRBw9wtnM5Z9qQw7m5ZubaKqDPXz4SQ4E6kCcR4ucBbwx4rUcKkF
         SaGfQmoHKgDSAGH53CvJAA7Fvomf1c+7uevc1J0p/2PaP9ibgQsecHsOK6xiRKG8A3gV
         KgcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KUBv01Di0MSYF5v2MUYD1ZToQiEjPpf0YDuWlSv0bc4=;
        b=KB/zxUHwFz2nDSi4RlQBRBGg/9SrgtherYx9pSgiEtpITkbfEkqy0VBDSu0RqIi2E3
         Ut19wyGC2gm0j4A03W/NioJC5slYdWPNp0TV+SwciP4mG1HU86lKeL7OJq84cxKFW81h
         jyuCNv9QTERV2jXanxbPzfrhyGTsTcto8A4AJtj+dL4p0S96LO81qzGjbY4i4+uaQ7m7
         KHE8u++nkWTWN3fGc9hjiyfyANtZ0WV9cVtC9NNrlk7vcSSd5vmedcSN2fPM5h124Wq1
         AbMcjY095pobLN8sscCnKmeTLf0OU/K4Sr9fHp0kFMeItyiFpFhJnI+L1se8usvpF519
         068w==
X-Gm-Message-State: AOAM5321rTxJjn7RIkRAj4/UdD9HFj2FB1T6baoMyhLB+sN5AP7ek+Wo
        Iq0QX7vpcjg0feJAKoqete8=
X-Google-Smtp-Source: ABdhPJzqdDmbPkEbah1xTzLhU4pF+mzO6OHjChiWWQ11lURFjQ9/a9L0DBf1mA7PnnhWR5GzIhPiKA==
X-Received: by 2002:aa7:cb8f:: with SMTP id r15mr5116160edt.356.1599669067511;
        Wed, 09 Sep 2020 09:31:07 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id i9sm3058926ejo.1.2020.09.09.09.31.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 09:31:07 -0700 (PDT)
Date:   Wed, 9 Sep 2020 19:31:05 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     davem@davemloft.net, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] net: dsa: set
 configure_vlan_while_not_filtering to true by default
Message-ID: <20200909163105.nynkw5jvwqapzx2z@skbuf>
References: <20200907182910.1285496-1-olteanv@gmail.com>
 <20200907182910.1285496-5-olteanv@gmail.com>
 <961ac1bd-6744-23ef-046f-4b7d8c4413a4@gmail.com>
 <a5e6cb01-88d0-a479-3262-b53dec0682cd@gmail.com>
 <f0217ae5-7897-17e2-a807-fc0ba0246c74@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0217ae5-7897-17e2-a807-fc0ba0246c74@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 05:02:06PM -0700, Florian Fainelli wrote:
> Found the problem, we do not allow the CPU port to be configured as
> untagged, and when we toggle vlan_filtering we actually incorrectly "move"
> the PVID from 1 to 0,

pvid 1 must be coming from the default_pvid of the bridge, I assume.
Where is pvid 0 (aka dev->ports[port].pvid) coming from? Is it simply
the cached value from B53_VLAN_PORT_DEF_TAG, from a previous
b53_vlan_filtering() call? Strange.

> which is incorrect, but since the CPU is also untagged in VID 0 this
> is why it "works" or rather two mistakes canceling it each other.

How does the CPU end up untagged in VLAN 0?

> I still need to confirm this, but the bridge in VLAN filtering mode seems to
> support receiving frames with the default_pvid as tagged, and it will untag
> it for the bridge master device transparently.

So it seems.

> The reason for not allowing the CPU port to be untagged
> (ca8931948344c485569b04821d1f6bcebccd376b) was because the CPU port could be
> added as untagged in several VLANs, e.g.: when port0-3 are PVID 1 untagged,
> and port 4 is PVID 2 untagged. Back then there was no support for Broadcom
> tags, so the only way to differentiate traffic properly was to also add a
> pair of tagged VIDs to the DSA master.
> I am still trying to remember whether there were other concerns that
> prompted me to make that change and would appreciate some thoughts on that.

I think it makes some sense to always configure the VLANs on the CPU
port as tagged either way. I did the same in Felix and it's ok. But that
was due to a hardware limitation. On sja1105 I'm keeping the same flags
as on the user port, and that is ok too.

> Tangentially, maybe we should finally add support for programming the CPU
> port's VLAN membership independently from the other ports.

How?

> The following appears to work nicely now and allows us to get rid of the
> b53_vlan_filtering() logic, which would no longer work now because it
> assumed that toggling vlan_filtering implied that there would be no VLAN
> configuration when filtering was off.
>
> diff --git a/drivers/net/dsa/b53/b53_common.c
> b/drivers/net/dsa/b53/b53_common.c
> index 26fcff85d881..fac033730f4a 100644
> --- a/drivers/net/dsa/b53/b53_common.c
> +++ b/drivers/net/dsa/b53/b53_common.c
> @@ -1322,23 +1322,6 @@ EXPORT_SYMBOL(b53_phylink_mac_link_up);
>  int b53_vlan_filtering(struct dsa_switch *ds, int port, bool
> vlan_filtering)
>  {
>         struct b53_device *dev = ds->priv;
> -       u16 pvid, new_pvid;
> -
> -       b53_read16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port), &pvid);
> -       if (!vlan_filtering) {
> -               /* Filtering is currently enabled, use the default PVID
> since
> -                * the bridge does not expect tagging anymore
> -                */
> -               dev->ports[port].pvid = pvid;
> -               new_pvid = b53_default_pvid(dev);
> -       } else {
> -               /* Filtering is currently disabled, restore the previous
> PVID */
> -               new_pvid = dev->ports[port].pvid;
> -       }
> -
> -       if (pvid != new_pvid)
> -               b53_write16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port),
> -                           new_pvid);

Yes, much simpler.

> 
>         b53_enable_vlan(dev, dev->vlan_enabled, vlan_filtering);
> 
> @@ -1389,7 +1372,7 @@ void b53_vlan_add(struct dsa_switch *ds, int port,
>                         untagged = true;
> 
>                 vl->members |= BIT(port);
> -               if (untagged && !dsa_is_cpu_port(ds, port))
> +               if (untagged)
>                         vl->untag |= BIT(port);
>                 else
>                         vl->untag &= ~BIT(port);
> @@ -1427,7 +1410,7 @@ int b53_vlan_del(struct dsa_switch *ds, int port,
>                 if (pvid == vid)
>                         pvid = b53_default_pvid(dev);
> 
> -               if (untagged && !dsa_is_cpu_port(ds, port))
> +               if (untagged)

Ok, so you're removing this workaround now. A welcome simplification.

>                         vl->untag &= ~(BIT(port));
> 
>                 b53_set_vlan_entry(dev, vid, vl);
> @@ -2563,6 +2546,8 @@ struct b53_device *b53_switch_alloc(struct device
> *base,
>         dev->priv = priv;
>         dev->ops = ops;
>         ds->ops = &b53_switch_ops;
> +       ds->configure_vlan_while_not_filtering = true;
> +       dev->vlan_enabled = ds->configure_vlan_while_not_filtering;
>         mutex_init(&dev->reg_mutex);
>         mutex_init(&dev->stats_mutex);
> 
> 
> -- 
> Florian

Looks good!

I'm going to hold off with my configure_vlan_while_not_filtering patch.
You can send this one before me.

Thanks,
-Vladimir
