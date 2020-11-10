Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 778D42ADB2D
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 17:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732704AbgKJQD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 11:03:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:45292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732582AbgKJQD2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 11:03:28 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A53D207D3;
        Tue, 10 Nov 2020 16:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605024207;
        bh=SiYSXDXUJxVZojeQO/kS9w6FUKM9O6mVhUfv39+0efY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JcT5pggsIhzu5mxgCU10YetP7i2mY4mkODFe/1nHat69PpYsHp9tqsFWbtNONJaRg
         qhnzpV+EhSeP3Rs17NLcmwvgm9CBHDP1QukakrbtD28vhzPD4cCsPHTTmPZm9RwoLc
         2VoUGu0UGDYIy8vfEluYgwh5RuZDl0+z57JqnezQ=
Date:   Tue, 10 Nov 2020 08:03:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Dike <jdike@akamai.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [PATCH net V2] Exempt multicast addresses from five-second
 neighbor lifetime
Message-ID: <20201110080325.2f67d85d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <aaf62231-75d2-6b2f-9982-3d24ca4e4e80@akamai.com>
References: <20201109025052.23280-1-jdike@akamai.com>
        <20201109114733.0ee71b82@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <aaf62231-75d2-6b2f-9982-3d24ca4e4e80@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 09:21:53 -0500 Jeff Dike wrote:
> > Perhaps it would make sense to widen the API to any "computed" address
> > rather than implicitly depending on this behavior for mcast?  
> 
> I'm happy to do that, but I don't know of any other types of
> addresses which are computed and end up in the neighbors table.

Fair point, thinking about it again only mcast or local addresses 
could be computed but I never heard of local addresses being used
like that, so you can stick to what you have.
