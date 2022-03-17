Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE314DC86B
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 15:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbiCQOLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 10:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbiCQOLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 10:11:37 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B441FDFF1
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 07:10:20 -0700 (PDT)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.94.2)
        (envelope-from <laforge@gnumonks.org>)
        id 1nUqpH-00EVke-Vw; Thu, 17 Mar 2022 15:10:04 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.95)
        (envelope-from <laforge@gnumonks.org>)
        id 1nUqiL-00CLqr-O7;
        Thu, 17 Mar 2022 15:02:53 +0100
Date:   Thu, 17 Mar 2022 15:02:53 +0100
From:   Harald Welte <laforge@gnumonks.org>
To:     "Drewek, Wojciech" <wojciech.drewek@intel.com>
Cc:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2-next v5 1/2] ip: GTP support in ip link
Message-ID: <YjM/jXnaCDaBrTNX@nataraja>
References: <20220316110815.46779-1-wojciech.drewek@intel.com>
 <20220316110815.46779-2-wojciech.drewek@intel.com>
 <c1cb87c2-0107-7b0d-966f-b26f44b23d80@gmail.com>
 <MW4PR11MB57765F252A537045612889E4FD129@MW4PR11MB5776.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW4PR11MB57765F252A537045612889E4FD129@MW4PR11MB5776.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wojciech, David,

On Thu, Mar 17, 2022 at 11:11:40AM +0000, Drewek, Wojciech wrote:
> > as a u32 does that mean more roles might get added? Seems like this
> > should have a attr to string converter that handles future additions.
> 
> I think no more roles are expected but we can ask Harald.

I also don't currently know of any situation where we would want to add
more roles.

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
