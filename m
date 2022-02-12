Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC3C24B3469
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 12:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbiBLLKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 06:10:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234014AbiBLLKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 06:10:12 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF87F26553
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 03:10:08 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.94.2)
        (envelope-from <laforge@gnumonks.org>)
        id 1nIqI0-000bvs-UW; Sat, 12 Feb 2022 12:10:04 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.95)
        (envelope-from <laforge@gnumonks.org>)
        id 1nIqAx-005Bsx-I4;
        Sat, 12 Feb 2022 12:02:47 +0100
Date:   Sat, 12 Feb 2022 12:02:47 +0100
From:   Harald Welte <laforge@gnumonks.org>
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
Message-ID: <YgeT1wXjvWgR3Xkl@nataraja>
References: <20220127163749.374283-1-marcin.szycik@linux.intel.com>
 <20220127163900.374645-1-marcin.szycik@linux.intel.com>
 <Yf6nBDg/v1zuTf8l@nataraja>
 <fd23700b-4269-a615-a73d-10476ffaf82d@linux.intel.com>
 <YgYoT4UWw0Efq33K@nataraja>
 <MW4PR11MB57766A32DF641A69831B610EFD309@MW4PR11MB5776.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW4PR11MB57766A32DF641A69831B610EFD309@MW4PR11MB5776.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 10:05:54AM +0000, Drewek, Wojciech wrote:

> Thanks for triggering CI.
> Do I see correctly that results for our changes are the same as for master?

The results are identical to master/net-next, so all good!
-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
