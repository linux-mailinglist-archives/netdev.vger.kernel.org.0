Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 273D7263881
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 23:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730165AbgIIVb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 17:31:26 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:33090 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgIIVbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 17:31:25 -0400
Received: by mail-io1-f66.google.com with SMTP id r25so4878572ioj.0;
        Wed, 09 Sep 2020 14:31:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4LJPa6wY+bmsqueUyPNc2PybKgdIOrPEhe+awiCsZb8=;
        b=tVlWtGorMxVbEhgGrlqRTgTSSqmAZxdodriD8XQm0QPwJn9ZX23B5gV28j3p5WFfYq
         ZVta2bFlWQYvw6m+u+fgNdtcEdMwx244/sZxEP0q3i5pEqvzXlqJoCCKGOOIDWpxVomJ
         5muKTPsUhBVgNSLwFq8fhtXGi3gXdOtANOIVpMEvW6xXdhrbOV3DGorLiVbslsGs+rtY
         FPxo8OGPCfQM5Ji2V3jCKfws+tSJ0Jw25lrZHIrn/z2yPjhg4heL35jtNI0g289d9rBc
         pmvOmMD9E6wlbZd9X9XEsffNi6awV3M2w2T0DwIMgfa1MWdyLipt0AScZB5LuGbdli7R
         2OVw==
X-Gm-Message-State: AOAM532rE9WzXeX+pNVU15Ddu49P4OYPUDSGtdgGuKo+8UMRDpf/E9JZ
        z8WC6FAEoVSWmhZMIvyPhA==
X-Google-Smtp-Source: ABdhPJx+yi3NeE5/5sKNkbuyeC6+1XRipNeRGuLJCswC6gjgCaTEgcvbt1hptOmwmXb8008oPjMkBA==
X-Received: by 2002:a02:8805:: with SMTP id r5mr6116720jai.52.1599687084653;
        Wed, 09 Sep 2020 14:31:24 -0700 (PDT)
Received: from xps15 ([64.188.179.251])
        by smtp.gmail.com with ESMTPSA id u25sm1733942iot.35.2020.09.09.14.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 14:31:23 -0700 (PDT)
Received: (nullmailer pid 3107682 invoked by uid 1000);
        Wed, 09 Sep 2020 21:31:22 -0000
Date:   Wed, 9 Sep 2020 15:31:22 -0600
From:   Rob Herring <robh@kernel.org>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-leds@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next + leds v2 1/7] dt-bindings: leds: document
 binding for HW controlled LEDs
Message-ID: <20200909213122.GA3087645@bogus>
References: <20200909162552.11032-1-marek.behun@nic.cz>
 <20200909162552.11032-2-marek.behun@nic.cz>
 <20200909182730.GK3290129@lunn.ch>
 <20200909203310.15ca4e42@dellmb.labs.office.nic.cz>
 <20200909205923.GB3056507@bogus>
 <20200909230726.233b4081@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909230726.233b4081@nic.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 09, 2020 at 11:07:26PM +0200, Marek Behun wrote:
> On Wed, 9 Sep 2020 14:59:23 -0600
> Rob Herring <robh@kernel.org> wrote:
> 
> > > 
> > > I don't know :) I copied this from other drivers, I once tried setting
> > > up environment for doing checking of device trees with YAML schemas,
> > > and it was a little painful :)  
> > 
> > pip3 install dtschema ?
> > 
> > Can you elaborate on the issue.
> > 
> > Rob
> > 
> 
> I am using Gentoo and didn't want to bloat system with non-portage
> packages, nor try to start a virtual environment. In the end I did it
> in a chroot Ubuntu :)

A user install doesn't work?

I don't really care for virtual env either.

> The other thing is that the make dt_binding_check executed for
> quite a long time, and I didn't find a way to just do the binding check
> some of the schemas.

It's a bit faster now with what's queued for 5.10. The schema 
validation is under 10sec now on my laptop. For the examples, any 
new schema could apply to any example, so we have to check them all. 
It's faster too, but still minutes to run.

> But I am not criticizing anything, I think that it is a good thing to
> have this system.

Good to hear. Just want to improve any pain points if possible.

Rob

