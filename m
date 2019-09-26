Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3D0CBF8A0
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 20:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbfIZSCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 14:02:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727502AbfIZSCT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 14:02:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC8DE222CC;
        Thu, 26 Sep 2019 18:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569520938;
        bh=QJDg+8fSbQAJxMAvp592p5HNgoUEZPOIHiYjHDq13jI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UbFQAVtBTg3EvwEVIamRpQjnzkK7eHUHkGUIaJ0Jy2cbjmC0Uz/w82MwyJ/R3V1U/
         s5NnA5pacLeKtrq8xmJz5g+jKdh9Jn2rcwOSIsw//G20JLhJf5QNSSaM7Fm2ZUd1f+
         S5FxM4DlZihO0uCNtwwslZp9g3Bv/kdOBgWjH6qw=
Date:   Thu, 26 Sep 2019 20:02:15 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [RFC 04/20] RDMA/irdma: Add driver framework definitions
Message-ID: <20190926180215.GA1733924@kroah.com>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-5-jeffrey.t.kirsher@intel.com>
 <20190926165506.GF19509@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926165506.GF19509@mellanox.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 04:55:12PM +0000, Jason Gunthorpe wrote:
> On Thu, Sep 26, 2019 at 09:45:03AM -0700, Jeff Kirsher wrote:
> > +int i40iw_probe(struct platform_device *pdev)
> > +{
> > +	struct i40e_peer_dev_platform_data *pdata =
> > +		dev_get_platdata(&pdev->dev);
> > +	struct i40e_info *ldev;
> 
> I thought Greg already said not to use platform_device for this?

Yes I did, which is what I thought this whole "use MFD" was supposed to
solve.  Why is a platform device still being used here?

thanks,

greg k-h
