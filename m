Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E8045362B
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 16:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238541AbhKPPpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 10:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238378AbhKPPol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 10:44:41 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891F5C06121D;
        Tue, 16 Nov 2021 07:41:27 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mn0a7-000431-C1; Tue, 16 Nov 2021 16:41:11 +0100
Date:   Tue, 16 Nov 2021 16:41:11 +0100
From:   Florian Westphal <fw@strlen.de>
To:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>
Subject: Re: [PATCH v3 net-next 2/6] rtnetlink: Add new RTM_GETEECSTATE
 message to get SyncE status
Message-ID: <20211116154111.GF6326@breakpoint.cc>
References: <20211110114448.2792314-1-maciej.machnikowski@intel.com>
 <20211110114448.2792314-3-maciej.machnikowski@intel.com>
 <YY0+PmNU4MSGfgqA@hog>
 <20211111162252.GJ16363@breakpoint.cc>
 <MW5PR11MB58124A70268058505368A5C8EA999@MW5PR11MB5812.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW5PR11MB58124A70268058505368A5C8EA999@MW5PR11MB5812.namprd11.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Machnikowski, Maciej <maciej.machnikowski@intel.com> wrote:
> > More importantly, why is this added to rtnetlink (routing sockets)?
> > It appears to be unrelated?
> > 
> > Looks like this should be in ethtool (it has netlink api nowadays) or
> > devlink.
> 
> We identified it as a generic place in previous RFCs.

Doesn't answer my question.  EECSTATE doesn't appear to be related to
anything else thats currently exposed via rtnetlink from a conceptional
point of view.

> Ethtool calls are not
> available in non-ethernet packet networks

Thats news to me.  ethtool ops are linked via netdevice struct.

> and the concept of that functionality
> is - any packet network can implement it - SONET, GPON or even wireless.

Ethtool ops expose a wide range of low-level functions not related to
ethernet, e.g. eeprom dump, interrupt coalescing settings of and so on
and so forth.

But hey, if net maintainers are ok with rtnetlink...

I just feel putting synce interaction in rtnetlink is arbitrary
and bad precendence.
