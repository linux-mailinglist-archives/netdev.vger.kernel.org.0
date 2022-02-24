Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08ECA4C392F
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 23:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbiBXWuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 17:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231920AbiBXWum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 17:50:42 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77A1124C16
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 14:50:10 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.94.2)
        (envelope-from <laforge@gnumonks.org>)
        id 1nNMw0-000i9o-8z; Thu, 24 Feb 2022 23:50:04 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.95)
        (envelope-from <laforge@gnumonks.org>)
        id 1nNMqJ-002eeV-KK;
        Thu, 24 Feb 2022 23:44:11 +0100
Date:   Thu, 24 Feb 2022 23:44:11 +0100
From:   Harald Welte <laforge@gnumonks.org>
To:     Marcin Szycik <marcin.szycik@linux.intel.com>
Cc:     netdev@vger.kernel.org, michal.swiatkowski@linux.intel.com,
        wojciech.drewek@intel.com, davem@davemloft.net, kuba@kernel.org,
        pablo@netfilter.org, jiri@resnulli.us,
        osmocom-net-gprs@lists.osmocom.org,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v9 0/7] ice: GTP support in switchdev
Message-ID: <YhgKO8rdxMxclZPm@nataraja>
References: <20220224185500.18384-1-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220224185500.18384-1-marcin.szycik@linux.intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcin,

On Thu, Feb 24, 2022 at 07:54:53PM +0100, Marcin Szycik wrote:
> Add support for adding GTP-C and GTP-U filters in switchdev mode.

For the changes to the gtp.ko driver this v9 looks fine to me.  I cannot
comment about the switchdevs bits, those are beyond my expertise.

Regards,
	Harald
-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
