Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53A842E19E
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 17:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfE2Pvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 11:51:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39386 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725936AbfE2Pvk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 11:51:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ldkr+gca17UfiFny4MxkQfM7IioA8ZM8BdCEeShu0EE=; b=gNNFaURLy8bGDFenMwlJAlj7lM
        mvNS30Bp2ftieBuTofE9i7Jf5sQjevSjpqJHiIJW0lchdiobG8Uury8q2QZ6cjJWOQzPIplL56ih7
        VYUJQchtSa6Ye2NzB/0cTGXq/XTPMODMTq/U1p5EbHDlXC4yUfYjs+mSkjWYN7c9YyVE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hW0rV-0000it-0C; Wed, 29 May 2019 17:51:33 +0200
Date:   Wed, 29 May 2019 17:51:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     Ruslan Babayev <ruslan@babayev.com>, wsa@the-dreams.de,
        linux@armlinux.org.uk, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [net-next,v4 0/2] Enable SFP on ACPI based systems
Message-ID: <20190529155132.GZ18059@lunn.ch>
References: <20190528230233.26772-1-ruslan@babayev.com>
 <20190529094818.GF2781@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529094818.GF2781@lahna.fi.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 12:48:18PM +0300, Mika Westerberg wrote:
> On Tue, May 28, 2019 at 04:02:31PM -0700, Ruslan Babayev wrote:
> > Changes:
> > v2:
> > 	- more descriptive commit body
> > v3:
> > 	- made 'i2c_acpi_find_adapter_by_handle' static inline
> > v4:
> > 	- don't initialize i2c_adapter to NULL. Instead see below...
> > 	- handle the case of neither DT nor ACPI present as invalid.
> > 	- alphabetical includes.
> > 	- use has_acpi_companion().
> > 	- use the same argument name in i2c_acpi_find_adapter_by_handle()
> > 	  in both stubbed and non-stubbed cases.
> > 
> > Ruslan Babayev (2):
> >   i2c: acpi: export i2c_acpi_find_adapter_by_handle
> >   net: phy: sfp: enable i2c-bus detection on ACPI based systems
> 
> For the series,
> 
> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Hi Mika

Are you happy for the i2c patch to be merged via net-next?

    Andrew
