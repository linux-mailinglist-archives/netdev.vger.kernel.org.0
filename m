Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86739323548
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 02:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbhBXB2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 20:28:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:40498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234202AbhBXBW2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 20:22:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8993164E21;
        Wed, 24 Feb 2021 01:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614129676;
        bh=0gQ9SHblLH4RFSNgF8HnfknzeNNkvBMWR8jt+OkRNww=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=duyDHW2ZZtdTcIsTUOeJ1Lpj9gCsqep/WcMtvg3LBYFjP2u8UgTEP1Xt6pHRA8ex/
         UPkD8uXAMzdUw7PhMJ02DFPR6WKofZqkKdf1v3Nsdync4jPN+JitLH5slAePwKETcq
         dfHoWLaR22VibNmYIWx4d4h65eRTysZhZByLwF3Rj8kNYhcwkM6QXGXGi0Vi6JpJfl
         JxOGAEJ5KQmWGdgyy2p6a165V8W9Y7L93LGP1LbT1Dq4vHP2G8gDv8argoPkDt5LWK
         eB3mWdArmTBO3x5ZStasA1F7bcbkE4j4YXQfSgFsyf5M8vozNSqyOgXR4lha963pc4
         fmi7Kx+Q3oGGA==
Date:   Tue, 23 Feb 2021 17:21:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Simon Horman <simon.horman@netronome.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@netronome.com>
Subject: Re: [PATCH net] ethtool: fix the check logic of at least one
 channel for RX/TX
Message-ID: <20210223172106.0ef3dc20@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210223170206.77a7e306@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210223132440.810-1-simon.horman@netronome.com>
        <20210224003251.6lwgj2k73jt3edk5@lion.mk-sys.cz>
        <20210223170206.77a7e306@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Feb 2021 17:02:06 -0800 Jakub Kicinski wrote:
> On Wed, 24 Feb 2021 01:32:51 +0100 Michal Kubecek wrote:
> > On Tue, Feb 23, 2021 at 02:24:40PM +0100, Simon Horman wrote:  
> > > From: Yinjun Zhang <yinjun.zhang@corigine.com>
> > > 
> > > The command "ethtool -L <intf> combined 0" may clean the RX/TX channel
> > > count and skip the error path, since the attrs
> > > tb[ETHTOOL_A_CHANNELS_RX_COUNT] and tb[ETHTOOL_A_CHANNELS_TX_COUNT]
> > > are NULL in this case when recent ethtool is used.
> > > 
> > > Tested using ethtool v5.10.
> > > 
> > > Fixes: 7be92514b99c ("ethtool: check if there is at least one channel for TX/RX in the core")
> > > Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> > > Signed-off-by: Simon Horman <simon.horman@netronome.com>
> > > Signed-off-by: Louis Peens <louis.peens@netronome.com>    
> > 
> > Reviewed-by: Michal Kubecek <mkubecek@suse.cz>  
> 
> IOW you prefer this to what I proposed?

Hah, now I missed your email :)
