Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 493C71347DC
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729071AbgAHQYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:24:47 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:39977 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728966AbgAHQYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 11:24:46 -0500
Received: by mail-ot1-f67.google.com with SMTP id w21so4127230otj.7
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 08:24:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mkqdKgKEKSOJiiH/qFun7xmdUvzRn9MkMSMD1VCbtj0=;
        b=A9E6pUYFoelj/sfPaCIMuK2N3hXMpCM3fgEVoCDgDpE3YO1HCUshhXMId7kpzNV3nW
         Yf82+dy7hi7DC3xv94ElRXGbc/xI5+JvyyRBiOuJfpEIx4bkX05SZvAARTI6hJGS7ohO
         Kz12pwQeJzEUegFuJojQRgOnyevuH/K9hdwHTQhWgFwMGICot8SeGVdcnuLHKseYcUCm
         fAOXZO9SagDc5MdHr4UORG4idfBYyMMkQHUAbckZk+gTZbT5BnRmXTWb+pXZnL6AXLdy
         7oy6JrNf52a9Ttf10R6ZFv/SPaF6+8Ch4fvkLAKIOPkdfhiH+by0oxBNt6Oa1iHp5ch3
         w6Nw==
X-Gm-Message-State: APjAAAXujjRmoBczXqhmplxTkiywcPPyrQRI+vkPmcnCB31qE4VrFWjJ
        ptKsqvCA9+eQpUI0AROx0lRnafY=
X-Google-Smtp-Source: APXvYqyCfFxQk/BBM5zzeeFlQURUkqWNrI1IRWecen1f7QJPpre8mqAWDTNrcEnC0/KYHyBgxE6lSw==
X-Received: by 2002:a05:6830:1482:: with SMTP id s2mr4962974otq.285.1578500685106;
        Wed, 08 Jan 2020 08:24:45 -0800 (PST)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id e21sm1214582oib.16.2020.01.08.08.24.43
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 08:24:43 -0800 (PST)
Received: from rob (uid 1000)
        (envelope-from rob@rob-hp-laptop)
        id 220333
        by rob-hp-laptop (DragonFly Mail Agent v0.11);
        Wed, 08 Jan 2020 10:24:43 -0600
Date:   Wed, 8 Jan 2020 10:24:43 -0600
From:   Rob Herring <robh@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
Cc:     "maxime.ripard@bootlin.com" <maxime.ripard@bootlin.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC] obsolete references to
 Documentation/devicetree/bindings/net/ethernet.txt
Message-ID: <20200108162443.GA16710@bogus>
References: <VI1PR04MB5567BBD2827A5DDDFD0D82B7EC2E0@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191226110821.GE1480@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191226110821.GE1480@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 26, 2019 at 12:08:21PM +0100, Andrew Lunn wrote:
> On Mon, Dec 23, 2019 at 09:00:50AM +0000, Madalin Bucur (OSS) wrote:
> > Hi,
> > 
> > this patch removed the ethernet.txt content and added the information found in
> > it in the ethernet-controller.yaml (Documentation/devicetree/bindings/net):
> > 
> >   commit 9d3de3c58347623b5e71d554628a1571cd3142ad
> >   Author: Maxime Ripard <maxime.ripard@bootlin.com>
> >   Date:   Thu Jun 27 17:31:43 2019 +0200
> > 
> >       dt-bindings: net: Add YAML schemas for the generic Ethernet options
> > 
> >       The Ethernet controllers have a good number of generic options that can be
> >       needed in a device tree. Add a YAML schemas for those.
> > 
> >       Reviewed-by: Rob Herring <robh@kernel.org>
> >       Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> >       Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> >       Signed-off-by: Rob Herring <robh@kernel.org>
> > 
> > There are still many references to the previous ethernet.txt document:
> > 
> >   $ grep ethernet.txt Documentation/devicetree/bindings/net/ -r | wc -l
> >   96
> > 
> > Should those be updated too or it's enough to rely on the current content
> > of the previous ethernet.txt file:
> > 
> >   $ cat Documentation/devicetree/bindings/net/ethernet.txt
> >   This file has moved to ethernet-controller.yaml.

If this wasn't enough, we wouldn't have put that there.

> 
> Hi Madalin
> 
> Feel free to fix the references if you want. Probably a perl one liner
> should do most of the work.

The above was done to avoid some churn. The real fix is convert bindings 
to DT schema. The references should get dropped as part of that.

Rob
