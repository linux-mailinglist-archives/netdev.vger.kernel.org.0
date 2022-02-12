Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0A74B33C1
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 09:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbiBLIUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 03:20:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiBLIUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 03:20:15 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF71926AF9
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 00:20:10 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.94.2)
        (envelope-from <laforge@gnumonks.org>)
        id 1nIndU-000SLB-GZ; Sat, 12 Feb 2022 09:20:04 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.95)
        (envelope-from <laforge@gnumonks.org>)
        id 1nInbo-005Ank-RM;
        Sat, 12 Feb 2022 09:18:20 +0100
Date:   Sat, 12 Feb 2022 09:18:20 +0100
From:   Harald Welte <laforge@gnumonks.org>
To:     Marcin Szycik <marcin.szycik@linux.intel.com>
Cc:     netdev@vger.kernel.org, michal.swiatkowski@linux.intel.com,
        wojciech.drewek@intel.com, davem@davemloft.net, kuba@kernel.org,
        pablo@netfilter.org, osmocom-net-gprs@lists.osmocom.org
Subject: Re: [RFC PATCH net-next v5 2/6] gtp: Implement GTP echo response
Message-ID: <YgdtTGq9uBu3zCF+@nataraja>
References: <20220211175405.7651-1-marcin.szycik@linux.intel.com>
 <20220211175504.7854-1-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220211175504.7854-1-marcin.szycik@linux.intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 06:55:04PM +0100, Marcin Szycik wrote:
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>

Reviewed-By: Harald Welte <laforge@gnumonks.org>
Tested-By: Harald Welte <laforge@gnumonks.org>

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
