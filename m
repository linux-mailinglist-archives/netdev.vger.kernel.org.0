Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 408B54B33D0
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 09:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbiBLIaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 03:30:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbiBLIaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 03:30:10 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C33426AF9
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 00:30:07 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.94.2)
        (envelope-from <laforge@gnumonks.org>)
        id 1nInnA-000SvA-6y; Sat, 12 Feb 2022 09:30:04 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.95)
        (envelope-from <laforge@gnumonks.org>)
        id 1nInkZ-005ArE-8s;
        Sat, 12 Feb 2022 09:27:23 +0100
Date:   Sat, 12 Feb 2022 09:27:23 +0100
From:   Harald Welte <laforge@gnumonks.org>
To:     Wojciech Drewek <wojciech.drewek@intel.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Subject: Re: [PATCH iproute2-next v3 1/2] ip: GTP support in ip link
Message-ID: <Ygdva1xzzNLJE54B@nataraja>
References: <20220211182902.11542-1-wojciech.drewek@intel.com>
 <20220211182902.11542-2-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220211182902.11542-2-wojciech.drewek@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wojciech,

I'm not an iproute2 developer, but LGTM.

On Fri, Feb 11, 2022 at 07:29:01PM +0100, Wojciech Drewek wrote:
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>

Reviewed-by: Harald Welte <laforge@gnumonks.org>

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
