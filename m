Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5D401D1FC4
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 22:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390613AbgEMUAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 16:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733135AbgEMUAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 16:00:14 -0400
Received: from smtp.tuxdriver.com (tunnel92311-pt.tunnel.tserv13.ash1.ipv6.he.net [IPv6:2001:470:7:9c9::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BA873C061A0E
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 13:00:13 -0700 (PDT)
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
        (envelope-from <linville@tuxdriver.com>)
        id 1jYxY3-00022U-2W; Wed, 13 May 2020 16:00:11 -0400
Received: from linville-x1.hq.tuxdriver.com (localhost.localdomain [127.0.0.1])
        by linville-x1.hq.tuxdriver.com (8.15.2/8.14.6) with ESMTP id 04DJvwjI668286;
        Wed, 13 May 2020 15:57:59 -0400
Received: (from linville@localhost)
        by linville-x1.hq.tuxdriver.com (8.15.2/8.15.2/Submit) id 04DJvwCQ668285;
        Wed, 13 May 2020 15:57:58 -0400
Date:   Wed, 13 May 2020 15:57:58 -0400
From:   "John W. Linville" <linville@tuxdriver.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Konstantin Kharlamov <hi-angel@yandex.ru>
Subject: Re: [PATCH ethtool] features: accept long legacy flag names when
 setting features
Message-ID: <20200513195758.GG650568@tuxdriver.com>
References: <20200413212120.7D775E0FAD@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200413212120.7D775E0FAD@unicorn.suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 11:21:20PM +0200, Michal Kubecek wrote:
> The legacy feature flags have long names (e.g. "generic-receive-offload")
> and short names (e.g. "gro"). While "ethtool -k" shows only long names,
> "ethtool -K" accepts only short names. This is a bit confusing as users
> have to resort to documentation to see what flag name to use; in
> particular, if a legacy flag corresponds to only one actual kernel feature,
> "ethtool -k" shows the output in the same form as if long flag name were
> a kernel feature name but this name cannot be used to set the flag/feature.
> 
> Accept both short and long legacy flag names in "ethool -K".
> 
> Reported-by: Konstantin Kharlamov <hi-angel@yandex.ru>
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Thanks (belatedly) -- queued for next release!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
