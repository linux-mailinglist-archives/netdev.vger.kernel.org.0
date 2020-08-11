Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07EA52421DA
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 23:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgHKVVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 17:21:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:48068 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726173AbgHKVVA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Aug 2020 17:21:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9B448AC46;
        Tue, 11 Aug 2020 21:21:20 +0000 (UTC)
Received: by localhost (Postfix, from userid 1000)
        id 4A9697F447; Tue, 11 Aug 2020 23:20:59 +0200 (CEST)
Date:   Tue, 11 Aug 2020 23:20:59 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool 3/7] ioctl: get rid of signed/unsigned comparison
 warnings
Message-ID: <20200811212059.lhbht3jdfxco2i4m@carpenter>
References: <cover.1597007532.git.mkubecek@suse.cz>
 <0365573afe3649e47c1aa2490e1818a50613ee0a.1597007533.git.mkubecek@suse.cz>
 <20200810141924.GF2123435@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200810141924.GF2123435@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 10, 2020 at 04:19:24PM +0200, Andrew Lunn wrote:
> > -	while (arg_num < ctx->argc) {
> > +	while (arg_num < (unsigned int)ctx->argc) {
> 
> Did you try changing ctx->argc to an unsigned int? I guess there would
> be less casts that way, and it is a more logical type for this.
> 
>     Andrew

I tried now and the number of changes in ethtool.c is not as bad as
I thought. I even found one missing check which could allow argc to fall
below 0.

Michal
