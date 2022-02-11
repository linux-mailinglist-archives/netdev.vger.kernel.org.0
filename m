Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 624B94B211B
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 10:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241172AbiBKJKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 04:10:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236211AbiBKJKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 04:10:24 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247C5B53
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 01:10:20 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.94.2)
        (envelope-from <laforge@osmocom.org>)
        id 1nIRwK-00GkDp-Ov; Fri, 11 Feb 2022 10:10:04 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.95)
        (envelope-from <laforge@osmocom.org>)
        id 1nIRqq-004xbL-9i;
        Fri, 11 Feb 2022 10:04:24 +0100
Date:   Fri, 11 Feb 2022 10:04:24 +0100
From:   Harald Welte <laforge@osmocom.org>
To:     "Drewek, Wojciech" <wojciech.drewek@intel.com>
Cc:     Marcin Szycik <marcin.szycik@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "osmocom-net-gprs@lists.osmocom.org" 
        <osmocom-net-gprs@lists.osmocom.org>
Subject: Re: [RFC PATCH net-next v3 1/5] gtp: Allow to create GTP device
 without FDs
Message-ID: <YgYmmJAuTetYH4LX@nataraja>
References: <20220127163749.374283-1-marcin.szycik@linux.intel.com>
 <20220127163900.374645-1-marcin.szycik@linux.intel.com>
 <Yf6nBDg/v1zuTf8l@nataraja>
 <MW4PR11MB57764998297DC775D71753E8FD2D9@MW4PR11MB5776.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW4PR11MB57764998297DC775D71753E8FD2D9@MW4PR11MB5776.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wojciech,

On Tue, Feb 08, 2022 at 01:30:32PM +0000, Drewek, Wojciech wrote:

> For now we don't have such tree. I will see what we can do.

I would appreciate it, so we can get this tested before it hits net-next.

> > I'm wondering if we should make this more explicit, i.e. rather than
> > implicitly creating the kernel socket automagically, make this mode
> > explicit upon request by some netlink attribute.
>
> I agree, it would look cleaner.

Excellent.

> > > Sockets are created with the
> > > commonly known UDP ports used for GTP protocol (GTP0_PORT and
> > > GTP1U_PORT).
> > 
> > I'm wondering if there are use cases that need to operate on
> > non-standard ports.  The current module can be used that way (as the
> > socket is created in user space). If the "kernel socket mode" was
> > requested explicitly via netlink attribute, one could just as well
> > pass along the port number[s] this way.
>
> Yes, it is possible to create socket with any port number using FD approach,
> but gtp module still assumes that ports are 2152 and 3386 at least in tx path
> (see gtp_push_header).  Implementing this shouldn't be hard but is it crucial?

Not crucial.

-- 
- Harald Welte <laforge@osmocom.org>            http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
