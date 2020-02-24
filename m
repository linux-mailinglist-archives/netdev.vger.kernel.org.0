Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6ADF16A061
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 09:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbgBXIse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 03:48:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:33864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727193AbgBXIse (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 03:48:34 -0500
Received: from dragon (80.251.214.228.16clouds.com [80.251.214.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3043A2080D;
        Mon, 24 Feb 2020 08:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582534113;
        bh=yvIzmLig8t+2r3suHxGs4IkD4tc1IS5MA9kFdFLwcPE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x1oAUQXUjY0n1B7WuYJEssdl5g/YAMYC1c/F/fL8g7/1+z1RsSdQdSWS7iJFw39fI
         zQhQdwJ5yekwXC3pGUPLCde5o/BsCnG5Vf9JoVJelunpHRydifOjKgfoU0Ow8BRCr1
         gGEkNf/BWHz7HYcqi2CWRYWYzidohQYcbGk00sks=
Date:   Mon, 24 Feb 2020 16:48:27 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net-next/devicetree 0/5] DT bindings for Felix DSA
 switch on LS1028A
Message-ID: <20200224084826.GE27688@dragon>
References: <20200219151259.14273-1-olteanv@gmail.com>
 <20200224063154.GK27688@dragon>
 <CA+h21hok4V_-uarhnyBkdXqnwRdXpgRJWLSvuuVn8K3VRMtrcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hok4V_-uarhnyBkdXqnwRdXpgRJWLSvuuVn8K3VRMtrcA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 09:59:53AM +0200, Vladimir Oltean wrote:
> Hi Shawn,
> 
> On Mon, 24 Feb 2020 at 08:32, Shawn Guo <shawnguo@kernel.org> wrote:
> >
> > On Wed, Feb 19, 2020 at 05:12:54PM +0200, Vladimir Oltean wrote:
> > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > >
> > > As per feedback received in v1, I've changed the DT bindings for the
> > > internal ports from "gmii" to "internal". So I would like the entire
> > > series to be merged through a single tree, be it net-next or devicetree.
> >
> > Will applying the patches via different trees as normal cause any
> > issue like build breakage or regression on either tree?  Otherwise, I do
> > not see the series needs to go in through a single tree.
> >
> > Shawn
> >
> 
> No, the point is that I've made some changes in the device tree
> bindings validation in the driver, which make the driver without those
> changes incompatible with the bindings themselves that I'm
> introducing. So I would like the driver to be operational on the
> actual commit that introduces the bindings, at least in your tree. I
> don't expect merge conflicts to occur in that area of the code.

The dt-bindings patch is supposed to go through subsystem tree together
with driver changes by nature.  That said, patch #1 and #2 are for
David, and I will pick up the rest (DTS ones).

Shawn
