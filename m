Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F56323546
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 02:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbhBXB1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 20:27:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:58946 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234578AbhBXBLE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 20:11:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CD80FAE05;
        Wed, 24 Feb 2021 01:10:11 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 7770A60795; Wed, 24 Feb 2021 02:10:11 +0100 (CET)
Date:   Wed, 24 Feb 2021 02:10:11 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Simon Horman <simon.horman@netronome.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@netronome.com>
Subject: Re: [PATCH net] ethtool: fix the check logic of at least one channel
 for RX/TX
Message-ID: <20210224011011.zc2xedfcaiprle7j@lion.mk-sys.cz>
References: <20210223132440.810-1-simon.horman@netronome.com>
 <20210224003251.6lwgj2k73jt3edk5@lion.mk-sys.cz>
 <20210223170206.77a7e306@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223170206.77a7e306@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 05:02:06PM -0800, Jakub Kicinski wrote:
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

No, that was my misunderstanding, please see my reply to your e-mail.

Michal
