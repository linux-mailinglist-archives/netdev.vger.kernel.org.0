Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB1E04040EF
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 00:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235936AbhIHWVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 18:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233502AbhIHWVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 18:21:09 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B08C061575;
        Wed,  8 Sep 2021 15:20:01 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id q3so4995660edt.5;
        Wed, 08 Sep 2021 15:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A/z46u5iCcUqemWTauT1aj0M/3peluecpk1k9FGi/3Y=;
        b=JbjAKn+hxjVPzj+PHJTbQT2RPNf3c4NTBr2y7hRgJLYsLem9tr+x2A0hZ++PcBepRL
         1bATHItQ6lB/GsuswUJXnSS9mL3xN5INueysCjS4jgKPNjkauN/PfB4i4T+cCHsAVq4Z
         uR9LkFItVsqJMxZx0LwBJgTFG3EiOg0GJiy7vJ4xP/2c7yIHmHN1kYIazJ5g1uvtel94
         K+EuCxMlJI400TWN51ntB2NC3NIVAYupkL4sdokgU0huSZO6nPJdNEdxRMbSw65dfDHR
         /FzYywH3R+vMyUh4Eg0XsJhJnUyGLLL24kWScjUY+iAjfEkLbvU1+u900Q571oN0m18M
         xQLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A/z46u5iCcUqemWTauT1aj0M/3peluecpk1k9FGi/3Y=;
        b=ia2s4PoLHHTtBbbiBJgbuWNCh0OSMpMOfBFa0xE4xntCDTUILJQpsvMRCU1ytmXh5Z
         3AfIOQ9FodIp85rXRTHp8N3gifLe+uTgccV6k5j8q3fKrAiPIGvj0ZoA/6L05TDuQe7K
         MLi5BQNSaKbcrC0LG/x9Fr9Yh0gu0/u7BIfd2PjlF+fmuB7Ozq6tuufgdGO/HqT+XYoH
         U00xU5RkgSJuGMx7B8ZyrLlmr1MAFXICJrQ01u3iqt8Y11vBms3OEj1Qo7ieOLDNL2ys
         17PxB2Km8O2TP42pIvUkdMnnZcjn7i7klmpDWKw9KSn1wYKfEEyLtY5mJh/C2bP9aMQB
         DGBQ==
X-Gm-Message-State: AOAM530MExQj13crKM22PSyNa3d805Q453s07yGDmLOGPT3sUWk19zhO
        joAQDLWgXkli2F8gtgqEx/Y=
X-Google-Smtp-Source: ABdhPJygff7gW6OthEjRhcyEm/Na6dz5ZoiSXY5aFLsOh2s7vSMjs2evuUkiobwox4aXuL8GyEwG7w==
X-Received: by 2002:a05:6402:2691:: with SMTP id w17mr493381edd.339.1631139599681;
        Wed, 08 Sep 2021 15:19:59 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id bx11sm112702ejb.107.2021.09.08.15.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 15:19:59 -0700 (PDT)
Date:   Thu, 9 Sep 2021 01:19:58 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Circular dependency between DSA switch driver and tagging
 protocol driver
Message-ID: <20210908221958.cjwuag6oz2fmnd2n@skbuf>
References: <20210908220834.d7gmtnwrorhharna@skbuf>
 <e0567cfe-d8b6-ed92-02c6-e45dd108d7d7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0567cfe-d8b6-ed92-02c6-e45dd108d7d7@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 08, 2021 at 03:14:51PM -0700, Florian Fainelli wrote:
> On 9/8/2021 3:08 PM, Vladimir Oltean wrote:
> > Hi,
> >
> > Since commits 566b18c8b752 ("net: dsa: sja1105: implement TX
> > timestamping for SJA1110") and 994d2cbb08ca ("net: dsa: tag_sja1105: be
> > dsa_loop-safe"), net/dsa/tag_sja1105.ko has gained a build and insmod
> > time dependency on drivers/net/dsa/sja1105.ko, due to several symbols
> > exported by the latter and used by the former.
> >
> > So first one needs to insmod sja1105.ko, then insmod tag_sja1105.ko.
> >
> > But dsa_port_parse_cpu returns -EPROBE_DEFER when dsa_tag_protocol_get
> > returns -ENOPROTOOPT. It means, there is no DSA_TAG_PROTO_SJA1105 in the
> > list of tagging protocols known by DSA, try again later. There is a
> > runtime dependency for DSA to have the tagging protocol loaded. Combined
> > with the symbol dependency, this is a de facto circular dependency.
> >
> > So when we first insmod sja1105.ko, nothing happens, probing is deferred.
> >
> > Then when we insmod tag_sja1105.ko, we expect the DSA probing to kick
> > off where it left from, and probe the switch too.
> >
> > However this does not happen because the deferred probing list in the
> > device core is reconsidered for a new attempt only if a driver is bound
> > to a new device. But DSA tagging protocols are drivers with no struct
> > device.
> >
> > One can of course manually kick the driver after the two insmods:
> >
> > echo spi0.1 > /sys/bus/spi/drivers/sja1105/bind
> >
> > and this works, but automatic module loading based on modaliases will be
> > broken if both tag_sja1105.ko and sja1105.ko are modules, and sja1105 is
> > the last device to get a driver bound to it.
> >
> > Where is the problem?
>
> I'd say with 994d2cbb08ca, since the tagger now requires visibility into
> sja1105_switch_ops which is not great, to say the least. You could solve
> this by:
>
> - splitting up the sja1150 between a library that contains
> sja1105_switch_ops and does not contain the driver registration code
>
> - finding a different way to do a dsa_switch_ops pointer comparison, by
> e.g.: maintaining a boolean in dsa_port that tracks whether a particular
> driver is backing that port

What about 566b18c8b752 ("net: dsa: sja1105: implement TX timestamping for SJA1110")?
It is essentially the same problem from a symbol usage perspective, plus
the fact that an skb queue belonging to the driver is accessed.
