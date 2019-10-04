Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40917CC4F3
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 23:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387702AbfJDVkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 17:40:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33452 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbfJDVkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 17:40:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=M1M/k4IIrk8kGVxwaFpXU6gJ63/1aMhsMG9wmmFpQCM=; b=ShA53JA2YU9PAiTDmFW2K8QMxC
        tATuqk5S7gBam71oaDp7+MIhK7QgR9K+2HxPr5GajbdEyCsDaTz4sJsBpM2X3WIE48U6yEQp1xibx
        OMYbsoX5mLu/QzEIInyGIgIEK+HVgZ0ag4OHpziTNE+FO92YyqJXkwQwKfKA6uI6pt2Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iGVJb-0003WF-Oy; Fri, 04 Oct 2019 23:40:43 +0200
Date:   Fri, 4 Oct 2019 23:40:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 net-next 2/2] net: dsa: mv88e6xxx: Add devlink param
 for ATU hash algorithm.
Message-ID: <20191004214043.GB12889@lunn.ch>
References: <20191004210934.12813-1-andrew@lunn.ch>
 <20191004210934.12813-3-andrew@lunn.ch>
 <20191004143236.334e9e05@cakuba.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004143236.334e9e05@cakuba.hsd1.ca.comcast.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 04, 2019 at 02:32:36PM -0700, Jakub Kicinski wrote:
> On Fri,  4 Oct 2019 23:09:34 +0200, Andrew Lunn wrote:
> > diff --git a/Documentation/networking/devlink-params-mv88e6xxx.txt b/Documentation/networking/devlink-params-mv88e6xxx.txt
> > new file mode 100644
> > index 000000000000..cc5c1ac87c36
> > --- /dev/null
> > +++ b/Documentation/networking/devlink-params-mv88e6xxx.txt
> > @@ -0,0 +1,6 @@
> > +ATU_hash		[DEVICE, DRIVER-SPECIFIC]
> > +			Select one of four possible hashing algorithms for
> > +			MAC addresses in the Address Translation Unity.
> > +			A value of 3 seems to work better than the default of
> > +			1 when many MAC addresses have the same OUI.
> > +			Configuration mode: runtime
> 
> I think it's common practice to specify the type here? Otherwise looks
> good to me, thanks for adding it!

Hi Jakub

Ah, yes. It is a u8, but only values 0-3 are valid.

I will do a v3, but will wait a day for further comments.

    Andrew
