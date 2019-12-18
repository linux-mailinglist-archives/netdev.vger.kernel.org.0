Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0E312538E
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 21:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbfLRUiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 15:38:20 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:33903 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfLRUiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 15:38:20 -0500
Received: by mail-oi1-f194.google.com with SMTP id l136so1890924oig.1;
        Wed, 18 Dec 2019 12:38:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hZ9E1NuLuIvtf+WPRqjwV9sUZ6orTffbf5yW67pbe2s=;
        b=E585jzx3Zv6Wlx+jFwqfOn4RW+GD6f6DtZJ2J8WlGjkowZ5UPuIFQVQI1NarROUnaa
         Gnd2vNMKT2nPo+iSwd7RZYbLOyTLLj86Sak+a6GTFEUqwJ3oKB4QP/vVR5Dsp7QJ1Oz+
         Av/Jyen7gqMx4BVr2HYtwqN9aR4U1jhudBgeEtzdrBoy9bg9plo11TBa8Axdpcju6GAu
         elPAq+/tWIAR0PqOMbvvegMWY/WzjrudBITniuWST8f98yF/fWtaAL7KNV5/g9whHqtz
         /wKBWnwETqehgdh4WGEk6sHoQyvHwSPMDcWKWsMz6MQ0aPXrfo0T7GdKVYMkVSBmDx/5
         MMsA==
X-Gm-Message-State: APjAAAWOBVDdpAfI7KMhdtfH7AU5G+Pytyr7wIN4IU+Ox4ogH9i+FXGv
        PSie/iWYUpKCT/uW1Jb+PQ==
X-Google-Smtp-Source: APXvYqxAKp78mrKcfBIIJGi+RshJWSvfi1+AG5ZtMHY8fR0aL5vcNcIROydHyMWaiCPZ0EZmvYFcMQ==
X-Received: by 2002:aca:dd04:: with SMTP id u4mr1348308oig.94.1576701499476;
        Wed, 18 Dec 2019 12:38:19 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id s83sm1185529oif.33.2019.12.18.12.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 12:38:18 -0800 (PST)
Date:   Wed, 18 Dec 2019 14:38:18 -0600
From:   Rob Herring <robh@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Guillaume La Roque <glaroque@baylibre.com>, marcel@holtmann.org,
        johan.hedberg@gmail.com, linux-bluetooth@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        nsaenzjulienne@suse.de, linux-kernel@vger.kernel.org,
        khilman@baylibre.com
Subject: Re: [PATCH v5 1/2] dt-bindings: net: bluetooth: add interrupts
 properties
Message-ID: <20191218203818.GA8009@bogus>
References: <20191213150622.14162-1-glaroque@baylibre.com>
 <20191213150622.14162-2-glaroque@baylibre.com>
 <20191213161901.GZ10631@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213161901.GZ10631@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 05:19:01PM +0100, Johan Hovold wrote:
> On Fri, Dec 13, 2019 at 04:06:21PM +0100, Guillaume La Roque wrote:
> > add interrupts and interrupt-names as optional properties
> > to support host-wakeup by interrupt properties instead of
> > host-wakeup-gpios.
> > 
> > Signed-off-by: Guillaume La Roque <glaroque@baylibre.com>
> > ---
> >  Documentation/devicetree/bindings/net/broadcom-bluetooth.txt | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt b/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> > index b5eadee4a9a7..95912d979239 100644
> > --- a/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> > +++ b/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> > @@ -36,7 +36,9 @@ Optional properties:
> >      - pcm-frame-type: short, long
> >      - pcm-sync-mode: slave, master
> >      - pcm-clock-mode: slave, master
> > -
> > + - interrupts: must be one, used to wakeup the host processor if
> > +   gpiod_to_irq function not supported
> 
> This is a Linux implementation detail which therefore doesn't belong in
> the binding.
> 
> I think the general rule is to prefer interrupts over gpios where we
> have a choice, but here the current binding already has a
> host-wakeup-gpios.
> 
> Not sure how best to handle that, maybe Rob knows.

Use gpiod_to_irqd().

You can also deprecate the gpio prop, but you have to keep driver 
support for it. And updating dts files would break old kernels with new 
dtbs.

Rob
