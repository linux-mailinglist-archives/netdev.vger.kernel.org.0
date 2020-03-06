Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8507617B3B5
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 02:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgCFBWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 20:22:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:33974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726173AbgCFBWr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 20:22:47 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0873B2070E;
        Fri,  6 Mar 2020 01:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583457767;
        bh=z4/BvLgVcoYP84AbS8NqHffe1V9Zb+C82XnN4mHz9hE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xFgOMUONu3PUr+P+sxgTdv7z3X0S8dbMsyLvB0R3jHy/8P54qJhWWS+e8Uy8btAGp
         zgUJHNwuTaGm1OWeHUzwRs0pXzWnLvBCWpMQ5uNQKmYNI+QOXkZO8LCBLetnwTvy4n
         fxnk82NQdN1yMpRhJbuS3Pm5p8DuBU29qGuQwB/g=
Date:   Thu, 5 Mar 2020 17:22:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Tieman, Henry W" <henry.w.tieman@intel.com>
Subject: Re: [net-next 05/16] ice: Add support for tunnel offloads
Message-ID: <20200305172245.37a4b3d2@kicinski-fedora-PC1C0HJN>
In-Reply-To: <4fd3bf3a8d473af7a40831b63e126f3dd6959950.camel@intel.com>
References: <20200304232136.4172118-1-jeffrey.t.kirsher@intel.com>
        <20200304232136.4172118-6-jeffrey.t.kirsher@intel.com>
        <20200304184638.12845fc7@kicinski-fedora-PC1C0HJN>
        <4fd3bf3a8d473af7a40831b63e126f3dd6959950.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 Mar 2020 01:08:45 +0000 Nguyen, Anthony L wrote:
> > > +	status = ice_create_tunnel(&pf->hw, tnl_type, port);
> > > +	if (status == ICE_ERR_ALREADY_EXISTS)
> > > +		dev_dbg(ice_pf_to_dev(pf), "port %d already exists in
> > > UDP tunnels list\n",
> > > +			port);
> > > +	else if (status == ICE_ERR_OUT_OF_RANGE)
> > > +		netdev_err(netdev, "Max tunneled UDP ports reached,
> > > port %d not added\n",
> > > +			   port);  
> > 
> > error is probably a little much for resource exhaustion since it's
> > not
> > going to cause any problem other than a slow down?  
> 
> Correct, just a slow down. A warning then or did you prefer a dbg?

No preference.
