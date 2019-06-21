Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 620584F081
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 23:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbfFUV3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 17:29:55 -0400
Received: from mail-qt1-f170.google.com ([209.85.160.170]:39977 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfFUV3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 17:29:55 -0400
Received: by mail-qt1-f170.google.com with SMTP id a15so8419353qtn.7
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 14:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=loFj+Pr7pRs4SHXQnOjh+jAlQGi6IGG/YkUdfc1YtPI=;
        b=D2qwsNLyzuycVpU4oFumJrtqdMIv6Lf8CvKClU3eP7HDdvNgqomNdJvv3gAXl5vce/
         1E/DN52ZvcKY6p5ryOYcEF+n02+2ojwAdK94MvZAZXCRLukYCuyAcLNPlFnsPfpUOtxL
         k1jlijVcXU1/M3Lh+4xZ44OclactFopr14/BDA2fxhsIL408Ovrk4/8Cieqen2OLbOeX
         go7M+Ccg7HXRC3NVfyojAR2WNMaOzKLAmV4Gz8qbcHPMMVMsvUUP749fk39SDuZArZdL
         j2g3rhqWsojqXqV46eLYqGd2iRktmeoEkH+sLHBG0HjVqWl+3gpFsULad2xm5GHukcw5
         e6RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=loFj+Pr7pRs4SHXQnOjh+jAlQGi6IGG/YkUdfc1YtPI=;
        b=iS0iqQvFHeI+DJqXyGsv5st33gVwSNtSuk1v0BWVrQOFkP6FWw5M0eEGrFin8rUl2F
         kqPQfcllGzrd8php4K9n4Q5nWh6FkSAodpGF0UwnEyPWu7DPX0Jx5mBjTgogj0olqGc0
         pV+9NmgyTBaNoErXBVZLEj3i2cepL4qVfQ+0fDbzmyTfXyEzdejhF+iDzQumMYf8NDJi
         BswawEQ1xL3HScKcYgCsJ/HcTr04EuMbFtXS2VGcErHCmjOIjdn+w1RZq8jyl4DSaRtb
         Fndu/TM6sJcenw//U2dvlp/uAkDfOZISpVXTAftsw0omM5nFOkXVKv5GFjlL1Raio/mP
         QrzQ==
X-Gm-Message-State: APjAAAWPmw85heTNIAvBq0J8duN+pZKE2uGKZAiVlZH825qV4sjBVBYX
        oTOaalRgTYVHM76uvYR1OgycJWuG1LU=
X-Google-Smtp-Source: APXvYqw6+ArQQen9f9vmZhH7CvtbVtQsku/EHe/xJ/N4HVqFSMeqAQqFGYxzUO3vgjGSl057QcIA/g==
X-Received: by 2002:ac8:354d:: with SMTP id z13mr71861818qtb.340.1561152593975;
        Fri, 21 Jun 2019 14:29:53 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id u4sm2047775qkb.16.2019.06.21.14.29.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 14:29:53 -0700 (PDT)
Date:   Fri, 21 Jun 2019 17:29:52 -0400
Message-ID: <20190621172952.GB9284@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, idosch@mellanox.com,
        Jiri Pirko <jiri@resnulli.us>, linux@armlinux.org.uk,
        andrew@lunn.ch, davem@davemloft.net
Subject: Re: [RFC net-next] net: dsa: add support for MC_DISABLED attribute
In-Reply-To: <5d653a4d-3270-8e53-a5e0-88ea5e7a4d3f@gmail.com>
References: <20190620235639.24102-1-vivien.didelot@gmail.com>
 <5d653a4d-3270-8e53-a5e0-88ea5e7a4d3f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jun 2019 19:24:47 -0700, Florian Fainelli <f.fainelli@gmail.com> wrote:
> > This patch adds support for enabling or disabling the flooding of
> > unknown multicast traffic on the CPU ports, depending on the value
> > of the switchdev SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED attribute.
> > 
> > This allows the user to prevent the CPU to be flooded with a lot of
> > undesirable traffic that the network stack needs to filter in software.
> > 
> > The bridge has multicast snooping enabled by default, hence CPU ports
> > aren't bottlenecked with arbitrary network applications anymore.
> > But this can be an issue in some scenarios such as pinging the bridge's
> > IPv6 address. Setting /sys/class/net/br0/bridge/multicast_snooping to
> > 0 would restore unknown multicast flooding and thus fix ICMPv6. As
> > an alternative, enabling multicast_querier would program the bridge
> > address into the switch.
> From what I can read from mlxsw, we should probably also implement the
> SWITCHDEV_ATTR_ID_PORT_MROUTER attribute in order to be consistent.
> 
> Since the attribute MC_DISABLED is on the bridge master, we should also
> iterate over the list of switch ports being a member of that bridge and
> change their flooding attribute, taking into account whether
> BR_MCAST_FLOOD is set on that particular port or not. Just paraphrasing
> what mlxsw does here again...

Ouch, doesn't sound like what a driver should be doing :-(

Ido, I cannot find documentation for multicast_snooping or MC_DISABLED
and the naming isn't clear. Can this be considered as an equivalent
of mcast_flood but targeting the bridge device itself, describing
whether the bridge is interested or not in unknown multicast traffic?

> Once you act on the user-facing ports, you might be able to leave the
> CPU port flooding unconditionally, since it would only "flood" the CPU
> port either because an user-facing port has BR_MCAST_FLOOD set, or
> because this is known MC traffic that got programmed via the bridge's
> MDB. Would that work?

You may want the machine or network connected behind a bridge port
to be flooded with unknown multicast traffic, without having the
CPU conduit clogged up with this traffic. So these are two distinct
settings for me.

The only scenario I can think of needing the CPU to be flooded is if
there's a non-DSA port in the bridge maybe. But IMHO this should be
handled by the bridge, offloading or not the appropriate attribute.

> On a higher level, I really wish we did not have to re-implement a lot
> of identical or similar logic in each switch drivers and had a more
> central model of what is behaviorally expected.

I couldn't agree more, ethernet switch drivers should only offload
the notified bridge configuration, not noodling their own logic...


Russell, Ido, Florian, so far I understand that a multicast-unaware
bridge must flood unknown traffic everywhere (CPU included);
and a multicast-aware bridge must only flood its ports if their
mcast_flood is on, and known traffic targeting the bridge must be
offloaded accordingly. Do you guys agree with this?


Thanks,
Vivien
