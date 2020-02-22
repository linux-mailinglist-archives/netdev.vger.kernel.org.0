Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3129F168D36
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 08:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgBVH1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 02:27:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:55580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726689AbgBVH1y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Feb 2020 02:27:54 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4002A208C4;
        Sat, 22 Feb 2020 07:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582356473;
        bh=wOV8gK/veMPH7q8CwIpLOCpHYD+xA+n8wXcEYpSjPjc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FDDCe+L8IWs79G3eUmurDA7fVj7SYeHkVD4XYAFeh5/YWpEq1HgIaNgMxOXjy1Xxo
         EMMarbtYGK3rble5VhCZB10GuGWDl1swynkX9bC/DkuG78aGk7B1HsAXc/nlpUDbaC
         UAGoQC/xyXZplCUXurmHkqeQcn1SWIcITk4AlMhU=
Date:   Sat, 22 Feb 2020 09:27:50 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     David Miller <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 00/16] Clean driver, module and FW versions
Message-ID: <20200222072750.GF209126@unreal>
References: <20200220145855.255704-1-leon@kernel.org>
 <20200220171714.60a70238@kicinski-fedora-PC1C0HJN>
 <20200221.113520.1105280751683846601.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221.113520.1105280751683846601.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 21, 2020 at 11:35:20AM -0800, David Miller wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> Date: Thu, 20 Feb 2020 17:17:14 -0800
>
> > A few minor nit picks I registered, IDK how hard we want to press
> > on these:
> >
> >  - it seems in couple places you remove the last user of DRV_RELDATE,
> >    but not the define. In case of bonding maybe we can remove the date
> >    too. IDK what value it brings in the description, other than perhaps
> >    humoring people;
> >  - we should probably give people a heads up by CCing maintainers
> >    (regardless of how dumb we find not bothering to read the ML as
> >    a maintainer);
> >  - one on the FW below..
> >
> >> As part of this series, I deleted various creative attempts to mark
> >> absence of FW. There is no need to set "N/A" in ethtool ->fw_version
> >> field and it is enough to do not set it.
> >
> > These seem reasonable to me, although in abundance of caution it could
> > be a good idea to have them as separate commits so we can revert more
> > easily. Worse come to worst.
>
> Leon please address this feedback as it seems reasonable to me.

Of course, it was just weekend here, so I wasn't near computer too much :).

Thanks
