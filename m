Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD530D7F58
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 20:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbfJOSrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 14:47:07 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44316 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727083AbfJOSrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 14:47:07 -0400
Received: by mail-lj1-f194.google.com with SMTP id m13so21302158ljj.11
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 11:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=dpHnScfJCNKkYcD6OPUhJS8Pdc4N6JJm1BZibg64fhU=;
        b=ZHpJiGiljIadYG+VrSfPgyD37XrichTuiiRIlwIbVNjCly/Ljd1/9V0SU5lU3OPLHp
         YaGpNldiqTYwX3xHV8kLr5o8h9ecdNypeGUh5/Ebya/iwczsgLNidYx1J3DdDl1tfSV5
         Y4NaiiIGdE/XXyf9BY4aja3OrRbcW8OHRN+vIodIYPELLZ9eGPfV04tULr64JP/aHkIC
         2TNV36asXt0OoQoNNtizazMj/uQowTEbd3ydq/2ldP8ezhKMh4klJLNGUleQjTx4LbTY
         DPH5oQPlFa7UqkLZUxg4Rh0ef3wOsxEDBzQT0B8b+ljhiazyba3SZK4551mRCst+kI8v
         W9zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=dpHnScfJCNKkYcD6OPUhJS8Pdc4N6JJm1BZibg64fhU=;
        b=BuvZIyVd6o1FqqzZFlkf6g64U/AY75uhWgJnf4QI97A9TrBDe0+rSz1kKBUUJXVdSz
         5WIkMx7D9a560rwZyRDZz3KkkgkB6VYMJ5Tq8fvuuwYKMTRuQU1sw38YZD//swU8LPj+
         3c5nimQNv5N7rl7VuS9pq/FI8xVlQURuYP/KwOc+YutC2RPd310Ad17AfYvZsNnsS9su
         KJuc7ZTjSY45iwUnzD8LfjfF7pdGFwOPLcdgyD9M341PyZXUJb1FcLpx98BsspVnx9U3
         vcR/HhxHIndJdVDguVM6NKKfselsybJDL6fg2D4RsHFVdLzczRa/h2DnFBIh+dopfoXi
         VzbQ==
X-Gm-Message-State: APjAAAWo/3x4+8lCX62jd1V7jFefqQfD2lTKLcPzgWEmy9KtAYIo/45F
        4vydhQ9x8PKqJ8fhamvM/fNBsg==
X-Google-Smtp-Source: APXvYqxrRgW/tDMgtL6XX/H61A1NBMf+9MttwnNzp7o2V7NJ8jp5xVeiCoMHFhRSQDO4HV0ZNKsF6w==
X-Received: by 2002:a2e:9a43:: with SMTP id k3mr22149736ljj.70.1571165225094;
        Tue, 15 Oct 2019 11:47:05 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id v21sm430188lfi.22.2019.10.15.11.47.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 11:47:04 -0700 (PDT)
Date:   Tue, 15 Oct 2019 11:46:57 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        herbert@gondor.apana.org.au, steffen.klassert@secunet.com
Subject: Re: [PATCH net-next v4 0/6] ipsec: add TCP encapsulation support
 (RFC 8229)
Message-ID: <20191015114657.45954831@cakuba.netronome.com>
In-Reply-To: <20191015082424.GA435630@bistromath.localdomain>
References: <cover.1570787286.git.sd@queasysnail.net>
 <20191014.144327.888902765137276425.davem@davemloft.net>
 <20191015082424.GA435630@bistromath.localdomain>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Oct 2019 10:24:24 +0200, Sabrina Dubroca wrote:
> 2019-10-14, 14:43:27 -0400, David Miller wrote:
> > From: Sabrina Dubroca <sd@queasysnail.net>
> > Date: Fri, 11 Oct 2019 16:57:23 +0200
> >   
> > > This patchset introduces support for TCP encapsulation of IKE and ESP
> > > messages, as defined by RFC 8229 [0]. It is an evolution of what
> > > Herbert Xu proposed in January 2018 [1] that addresses the main
> > > criticism against it, by not interfering with the TCP implementation
> > > at all. The networking stack now has infrastructure for this: TCP ULPs
> > > and Stream Parsers.  
> > 
> > So this will bring up a re-occurring nightmare in that now we have another
> > situation where stacking ULPs would be necessary (kTLS over TCP encap) and
> > the ULP mechanism simply can't do this.
> > 
> > Last time this came up, it had to do with sock_map.  No way could be found
> > to stack ULPs properly, so instead sock_map was implemented via something
> > other than ULPs.
> > 
> > I fear we have the same situation here again and this issue must be
> > addressed before these patches are included.
> > 
> > Thanks.  
> 
> I don't think there's any problem here. We're not stacking ULPs on the
> same socket. There's a TCP encap socket for IPsec, which belongs to
> the IKE daemon. The traffic on that socket is composed of IKE messages
> and ESP packets. Then there's whatever userspace sockets (doesn't have
> to be TCP), and the whole IPsec and TCP encap is completely invisible
> to them.
> 
> Where we would probably need ULP stacking is if we implement ESP over
> TLS [1], but we're not there.
> 
> [1] https://tools.ietf.org/html/rfc8229#appendix-A

But can there be any potential issues if the TCP socket with esp ULP is
also inserted into a sockmap? (well, I think sockmap socket gets a ULP,
I think we prevent sockmap on top of ULP but not the other way around..)

Is there any chance we could see some selftests here?
