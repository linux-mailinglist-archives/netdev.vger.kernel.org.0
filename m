Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4976D44DA48
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 17:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbhKKQ0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 11:26:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234033AbhKKQZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 11:25:59 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4F8C061766;
        Thu, 11 Nov 2021 08:23:10 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mlCqi-0000fB-0W; Thu, 11 Nov 2021 17:22:52 +0100
Date:   Thu, 11 Nov 2021 17:22:52 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     Maciej Machnikowski <maciej.machnikowski@intel.com>,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        richardcochran@gmail.com, abyagowi@fb.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        linux-kselftest@vger.kernel.org, idosch@idosch.org,
        mkubecek@suse.cz, saeed@kernel.org, michael.chan@broadcom.com,
        petrm@nvidia.com
Subject: Re: [PATCH v3 net-next 2/6] rtnetlink: Add new RTM_GETEECSTATE
 message to get SyncE status
Message-ID: <20211111162252.GJ16363@breakpoint.cc>
References: <20211110114448.2792314-1-maciej.machnikowski@intel.com>
 <20211110114448.2792314-3-maciej.machnikowski@intel.com>
 <YY0+PmNU4MSGfgqA@hog>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YY0+PmNU4MSGfgqA@hog>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sabrina Dubroca <sd@queasysnail.net> wrote:
> Hello Maciej,
> 
> 2021-11-10, 12:44:44 +0100, Maciej Machnikowski wrote:
> > diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
> > index 5888492a5257..1d8662afd6bd 100644
> > --- a/include/uapi/linux/rtnetlink.h
> > +++ b/include/uapi/linux/rtnetlink.h
> > @@ -185,6 +185,9 @@ enum {
> >  	RTM_GETNEXTHOPBUCKET,
> >  #define RTM_GETNEXTHOPBUCKET	RTM_GETNEXTHOPBUCKET
> >  
> > +	RTM_GETEECSTATE = 124,
> > +#define RTM_GETEECSTATE	RTM_GETEECSTATE
> 
> I'm not sure about this. All the other RTM_GETxxx are such that
> RTM_GETxxx % 4 == 2. Following the current pattern, 124 should be
> reserved for RTM_NEWxxx, and RTM_GETEECSTATE would be 126.

More importantly, why is this added to rtnetlink (routing sockets)?
It appears to be unrelated?

Looks like this should be in ethtool (it has netlink api nowadays) or
devlink.
