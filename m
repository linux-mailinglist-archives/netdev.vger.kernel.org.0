Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0C4188D70
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 19:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgCQStJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 14:49:09 -0400
Received: from mail-qv1-f68.google.com ([209.85.219.68]:39695 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbgCQStJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 14:49:09 -0400
Received: by mail-qv1-f68.google.com with SMTP id v38so7443365qvf.6
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 11:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=vEdnz64oX1wE/aAPvEn6VtsTqUZteugOrVpgIot4PsM=;
        b=f0+ClySUspL7Nrr/dJ1GrhIjM3lU1UDFw5qhZgHLm2S4As6lMqBEQIYEzCGJBbpo7N
         p2p9k/GtjxycApE57UKrfE3F7u04MfQh7xa/Zpylq7aAVVV5UoCq8JqyMAR+LjZN6PoP
         ocqIddWSUgCIXoIZeK3Ep9er5m1cEKzClygXwchSmH7xibM5F6LKLqHenmm91A2RzVrB
         x3+nKw7RO3o4S0v0v8nJY29ySqX3T16R1dxZU7RzWu1qQ3miyHywM6wWWX5aTKEgJmuh
         1PF22/idF4yLVH5jyK/uTzRM0OhRvDM7ViHYW7WtqfdPnON0iqQb0Ju8gLTVdDfuXKk5
         gvTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=vEdnz64oX1wE/aAPvEn6VtsTqUZteugOrVpgIot4PsM=;
        b=t7KJvP/KQUX1O4ZngRjSaMXO/0WQkW2N2uIeaJiw6WRC3sY6BHhU+RvtLauDR2nuxN
         m2FrM3aXXOf0DHHt5Rj6MEL/gJ9bo14HgsR5ihGibfHvt23bH5Iy5D4cJJk6bQFqZdXP
         9c5aM2/Ckn9juZrgsZS1qUGuKlkEpJWBC7qwLXDMV4AS2EwoQz+6SqPSy4lyvjhjRSfb
         +M5Ej8B+xPev3y/32j6kSf89g0DaS+r0IFgZdb/+MTGt+FvDa7FN7f6MWQQmnph+0TDj
         +ahuIHF0rpyzbZu/KKgWfRMoLlLAuiW4jhdRFfJeXZyK9k1d4iQHKHb6qeraBI/0tiwJ
         CM8Q==
X-Gm-Message-State: ANhLgQ1kt4h26S5pK1HtlbDpGLGfbMCHGZrmt7NeXi8bpYTg6NOieNmT
        DxujV24gFJooj06XNo9d6bQ=
X-Google-Smtp-Source: ADFU+vucRsQIN+D287+RzLN+3N/wp9QVYENw7wFUdk+fHUFgHkzcp/ExHYrGnL3caSFAdaYtl6wUXw==
X-Received: by 2002:a0c:f786:: with SMTP id s6mr577378qvn.224.1584470947829;
        Tue, 17 Mar 2020 11:49:07 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id g4sm2480446qki.8.2020.03.17.11.49.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 11:49:07 -0700 (PDT)
Date:   Tue, 17 Mar 2020 14:49:06 -0400
Message-ID: <20200317144906.GB3155670@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ivan Vecera <ivecera@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/3] VLANs, DSA switches and multiple bridges
In-Reply-To: <20200317151238.GQ25745@shell.armlinux.org.uk>
References: <20200218114515.GL18808@shell.armlinux.org.uk>
 <e2b53d14-7258-0137-79bc-b0a21ccc7b8f@gmail.com>
 <CA+h21hrjAT4yCh=UgJJDfv3=3OWkHUjMRB94WuAPDk-hkhOZ6w@mail.gmail.com>
 <15ce2fae-c2c8-4a36-c741-6fef58115604@gmail.com>
 <20200219231528.GS25745@shell.armlinux.org.uk>
 <e9b51f9e-4a8f-333d-5ba9-3fcf220ace7c@gmail.com>
 <20200221002110.GE25745@shell.armlinux.org.uk>
 <20200316111524.GE5827@shell.armlinux.org.uk>
 <20200317120044.GH5827@shell.armlinux.org.uk>
 <CA+h21hpGvhgxdNid8OMG15Zyp6uzGjAq_xmGgz2Udvo3sHuZ0g@mail.gmail.com>
 <20200317151238.GQ25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Tue, 17 Mar 2020 15:12:38 +0000, Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> On Tue, Mar 17, 2020 at 04:21:00PM +0200, Vladimir Oltean wrote:
> > Hi Russell,
> > 
> > On Tue, 17 Mar 2020 at 14:00, Russell King - ARM Linux admin
> > <linux@armlinux.org.uk> wrote:
> > >
> > > On Mon, Mar 16, 2020 at 11:15:24AM +0000, Russell King - ARM Linux admin wrote:
> > > > On Fri, Feb 21, 2020 at 12:21:10AM +0000, Russell King - ARM Linux admin wrote:
> > > > > On Thu, Feb 20, 2020 at 10:56:17AM -0800, Florian Fainelli wrote:
> > > > > > Let's get your patch series merged. If you re-spin while addressing
> > > > > > Vivien's comment not to use the term "vtu", I think I would be fine with
> > > > > > the current approach of having to go after each driver and enabling them
> > > > > > where necessary.
> > > > >
> > > > > The question then becomes what to call it.  "always_allow_vlans" or
> > > > > "always_allow_vlan_config" maybe?
> > > >
> > > > Please note that I still have this patch pending (i.o.w., the problem
> > > > with vlans remains unfixed) as I haven't received a reply to this,
> > > > although the first two patches have been merged.
> > >
> > > Okay, I think three and a half weeks is way beyond a reasonable time
> > > period to expect any kind of reply.
> > >
> > > Since no one seems to have any idea what to name this, but can only
> > > offer "we don't like the vtu" term, it's difficult to see what would
> > > actually be acceptable.  So, I propose that we go with the existing
> > > naming.
> > >
> > > If you only know what you don't want, but not what you want, and aren't
> > > even willing to discuss it, it makes it very much impossible to
> > > progress.
> > >
> > > --
> > > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > > FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
> > 
> > As I said, I know why I need this blocking of bridge vlan
> > configuration for sja1105, but not more. For sja1105 in particular, I
> > fully admit that the hardware is quirky, but I can work around that
> > within the driver. The concern is for the other drivers where we don't
> > really "remember" why this workaround is in place. I think, while your
> > patch is definitely a punctual fix for one case that doesn't need the
> > workaround, it might be better for maintenance to just see exactly
> > what breaks, instead of introducing this opaque property.
> > While I don't want to speak on behalf of the maintainers, I think that
> > may be at least part of the reason why there is little progress being
> > made. Introducing some breakage which is going to be fixed better next
> > time might be the more appropriate thing to do.
> 
> The conclusion on 21st February was that all patches should be merged,
> complete with the boolean control, but there was an open question about
> the name of the boolean used to enable this behaviour.
> 
> That question has not been resolved, so I'm trying to re-open discussion
> of that point.  I've re-posted the patch.
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up

In response to your 3/3 patch, I suggested commands to test setting up a
VLAN filtering aware bridge with your own default PVID before enslaving
DSA ports. Unfortunately you left this unanswered. I think this would be
much more interesting in order to tackle the issue you're having here with
mv88e6xxx and bridge, instead of pointing out the lack of response regarding
an alternative boolean name. That being said, "force_vlan_programming",
"always_allow_vlans", or whatever explicit non-"vtu" term is fine by me.


Thanks,

	Vivien
