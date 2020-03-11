Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57C1018235B
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 21:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbgCKUi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 16:38:29 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:59420 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbgCKUi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 16:38:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=3hYQEX/tomyIOsSexIuldCUpSADhNxZ8eQYnaEcFn18=; b=IfAh+L8ZczZRtFfoWmsl9z/ye
        XcfBseejrsr3l1sZrmLXzEBAfftLamurehbQuN625BX+V+gsTLyAK2pcZbI+BkVMsr0tzka7O0ClM
        kfg60MDbLmQQpQu1gtlJPVWK6xGkExmPKhH23r1GblU6JZL+oImiRRDzmmZBhdM72jIPF7nUzuf6f
        37UhPl9ek5oMESkdqvvCiawQCtNIXjP4+9M6nBveQ4MWzS6KedxOzb73EIqlHhUUKJudj49csc/Y6
        VXBhVIdgylGq/uei+lT3PJ6dp5U0QM+A5GQUqP29qoLaT65VkEy1/QSkCDF7kNKeNbkU4mU1BvbNr
        CkD7H8ZOA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35140)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jC87P-0005PG-LZ; Wed, 11 Mar 2020 20:38:24 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jC87O-0005ce-3f; Wed, 11 Mar 2020 20:38:18 +0000
Date:   Wed, 11 Mar 2020 20:38:18 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     peter@bikeshed.quignogs.org.uk
Cc:     linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Reformat return value descriptions as ReST lists.
Message-ID: <20200311203817.GT25745@shell.armlinux.org.uk>
References: <20200311192823.16213-1-peter@bikeshed.quignogs.org.uk>
 <20200311192823.16213-2-peter@bikeshed.quignogs.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311192823.16213-2-peter@bikeshed.quignogs.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 07:28:23PM +0000, peter@bikeshed.quignogs.org.uk wrote:
> From: Peter Lister <peter@bikeshed.quignogs.org.uk>
> 
> Added line breaks and blank lines to separate list items and escaped end-of-line
> colons.
> 
> This removes these warnings from doc build...
> 
> ./drivers/net/phy/sfp-bus.c:579: WARNING: Unexpected indentation.
> ./drivers/net/phy/sfp-bus.c:619: WARNING: Unexpected indentation.
> 
> Signed-off-by: Peter Lister <peter@bikeshed.quignogs.org.uk>
> ---
>  drivers/net/phy/sfp-bus.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
> index d949ea7b4f8c..df1c66df830f 100644
> --- a/drivers/net/phy/sfp-bus.c
> +++ b/drivers/net/phy/sfp-bus.c
> @@ -572,12 +572,18 @@ static void sfp_upstream_clear(struct sfp_bus *bus)
>   * the sfp_bus structure, incrementing its reference count.  This must
>   * be put via sfp_bus_put() when done.
>   *
> - * Returns: on success, a pointer to the sfp_bus structure,
> + * Returns\:
> + *
> + *          on success, a pointer to the sfp_bus structure,
>   *	    %NULL if no SFP is specified,
> + *
>   * 	    on failure, an error pointer value:
> + *
>   * 		corresponding to the errors detailed for
>   * 		fwnode_property_get_reference_args().
> + *
>   * 	        %-ENOMEM if we failed to allocate the bus.
> + *
>   *		an error from the upstream's connect_phy() method.

Is this really necessary?  This seems to be rather OTT, and makes the
comment way too big IMHO.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
