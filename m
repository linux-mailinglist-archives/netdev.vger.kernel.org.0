Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD3D290D22
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 23:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410983AbgJPVQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 17:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410939AbgJPVQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 17:16:31 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87526C061755;
        Fri, 16 Oct 2020 14:16:31 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id o18so3943690edq.4;
        Fri, 16 Oct 2020 14:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VSnWz88Q1YHtZWP5Yh8SPjKPcnS0NnqVe2qNoXSx430=;
        b=eDE3g6WrBimI+exwbEkjL2MXMij8bGDLRIe9Y/3sFpqn/bLzoiROOdUZeXHCFJdisa
         vR9BvD7iiMWzaFDeufJS6ZGBpp7TDe7dEaq8Gl6Kqv1VT4WqM7FOs5k2Tr1r/89DMVz6
         07jdk8C94c7a+mgKMKXuuoy2cpIpdsRkDNkaqiUOj7dkNQwz7czK1LUXanoCIDz+vUoU
         01/AgVyppJrHBuwdU9A8u9yIhaJgZlFfD+g0p0hA6SaXTMI1UjdKNdYI10x9VBgDzsAo
         sWa5b2KOjG9NUz0yYzvJzQ72yif6H0gDaoiped/PzvzJErI90vCnhXVMu3p82+7EJcc1
         FQLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VSnWz88Q1YHtZWP5Yh8SPjKPcnS0NnqVe2qNoXSx430=;
        b=F8CMLw6evSWJzyO9J6TBF1+kXEmYqLmTJOtjvmKyoClNmskrBDPOQgHYBTG4nnr25N
         s5vPqktNYPBiWQTuxulT4ldEIpWvcWaO1HK3lPc86xDJMnSHFsaFy4Bqf7YtO1YrbvMH
         UwKgdFRLJ3oQK3MCMBAKxQkyOoGzyrvbiMG7ZM9IciusSODrgqyLFOI0NN4sWFKycgfr
         Y121224DTQvQ7TqbBb/OmEpL3Cz2r/23ouPL48yk9O6eNAbUtpIUxsId814EvK9zsQDN
         JeHGQFYhfiV4465vhSmxLNT+NHoc0KFN8nICnWQNKJZb/97GWuMB8uFRHUajg4NugvNn
         IlFQ==
X-Gm-Message-State: AOAM533ZP84kU3HGCimVwMXdIWyPIUtUy8pouySgnHPS+S/2Gija+fsc
        tl3Tz4AsGY8h53tsdEzfCMg=
X-Google-Smtp-Source: ABdhPJwpBpAdoWzh31W5pCqEMvMHo2F6Z7BDJES44AoW9PEB1rhb6lgj/TPE0IxXPE83jN1n8TdcLw==
X-Received: by 2002:aa7:cd85:: with SMTP id x5mr6472017edv.0.1602882990288;
        Fri, 16 Oct 2020 14:16:30 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id v14sm2800800ejh.6.2020.10.16.14.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 14:16:29 -0700 (PDT)
Date:   Sat, 17 Oct 2020 00:16:28 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     kernel test robot <lkp@intel.com>,
        Christian Eggers <ceggers@arri.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        kbuild-all@lists.01.org,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: point out the tail taggers
Message-ID: <20201016211628.mw7jlvqx3audzo76@skbuf>
References: <20201016162800.7696-1-ceggers@arri.de>
 <202010170153.fwOuks52-lkp@intel.com>
 <20201016173317.4ihhiamrv5w5am6y@skbuf>
 <20201016201428.GI139700@lunn.ch>
 <20201016201930.2i2lw4aixklyg6j7@skbuf>
 <20201016210318.GL139700@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016210318.GL139700@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 11:03:18PM +0200, Andrew Lunn wrote:
> 2ecbc1f684482b4ed52447a39903bd9b0f222898 does not have net-next, as
> far as i see,

Not sure what you mean by that.

> and tail_tag only hit net when net-next was merged into
> net.

net-next is only merged into net via Linus Torvalds, as far as I
understand.

> Or i'm reading the git history wrong.

So the only plausible scenario is that yesterday's 'net/master' did not
contain 2ecbc1f684482b4ed52447a39903bd9b0f222898, but today it does, due
to Linus Torvalds merging net-next and Jakub merging that merge into net.
