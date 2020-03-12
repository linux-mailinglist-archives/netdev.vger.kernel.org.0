Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A539018265A
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 01:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387480AbgCLAtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 20:49:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:46626 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731423AbgCLAtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 20:49:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JzdyPrN62BdDAmrcldEmQFBwM9GdlQHzAxzjjEn6/H4=; b=I8n0l60QOxFd+cp1P0neh7j0VR
        z70RmleKd/l2LQqNCfyS3at4gq0Ah39vt0UeHGb7Ln1Y8F4evjFFz2DNhpGf2P9oQZrEQOziZFk4e
        NkC8lvwUXApjj8AIaMD9L8Z6xa0ME5+VSt4FjDIC6MJrjT+jsALZz3g0ijpX39ZLFf0pb4ftipMjz
        gJ5R0QxLbRASQ5bylEPSkjNTdmwQwxISYGAiNrSmOhkr51riRVHJsOxK4/2m3vyqlrGyjmeuZO5l7
        FgeOMMtM3h5fUk2VTU0Faj2pyWk/GPQCIOZjt1bzyGCJOxSXWpioyI13QCMxKoYKqgTgAtWRQBxXc
        gUex38tg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jCC2i-0004EW-5V; Thu, 12 Mar 2020 00:49:44 +0000
Date:   Wed, 11 Mar 2020 17:49:44 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     peter@bikeshed.quignogs.org.uk
Cc:     linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Reformat return value descriptions as ReST lists.
Message-ID: <20200312004944.GF22433@bombadil.infradead.org>
References: <20200311192823.16213-1-peter@bikeshed.quignogs.org.uk>
 <20200311192823.16213-2-peter@bikeshed.quignogs.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311192823.16213-2-peter@bikeshed.quignogs.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 07:28:23PM +0000, peter@bikeshed.quignogs.org.uk wrote:
> Added line breaks and blank lines to separate list items and escaped end-of-line
> colons.
> 
> This removes these warnings from doc build...
> 
> ./drivers/net/phy/sfp-bus.c:579: WARNING: Unexpected indentation.
> ./drivers/net/phy/sfp-bus.c:619: WARNING: Unexpected indentation.

I'm all in favour of removing warnings, but I think you've fixed this
the wrong way.

> @@ -572,12 +572,18 @@ static void sfp_upstream_clear(struct sfp_bus *bus)
>   * the sfp_bus structure, incrementing its reference count.  This must
>   * be put via sfp_bus_put() when done.
>   *
> - * Returns: on success, a pointer to the sfp_bus structure,
> + * Returns\:

This should be Return: (not Returns:) and marks a section header,
not the beginning of the list.  See the "Return values" section
in Documentation/doc-guide/kernel-doc.rst

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

Seems to me this should use the " * * VALUE - Description" format
described in the document I mentioned above.
