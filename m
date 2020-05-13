Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F344A1D1FC6
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 22:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390756AbgEMUAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 16:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733135AbgEMUAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 16:00:16 -0400
Received: from smtp.tuxdriver.com (tunnel92311-pt.tunnel.tserv13.ash1.ipv6.he.net [IPv6:2001:470:7:9c9::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F2916C061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 13:00:15 -0700 (PDT)
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
        (envelope-from <linville@tuxdriver.com>)
        id 1jYxY2-00022R-Sl; Wed, 13 May 2020 16:00:10 -0400
Received: from linville-x1.hq.tuxdriver.com (localhost.localdomain [127.0.0.1])
        by linville-x1.hq.tuxdriver.com (8.15.2/8.14.6) with ESMTP id 04DJvCwa668263;
        Wed, 13 May 2020 15:57:13 -0400
Received: (from linville@localhost)
        by linville-x1.hq.tuxdriver.com (8.15.2/8.15.2/Submit) id 04DJvCF9668262;
        Wed, 13 May 2020 15:57:12 -0400
Date:   Wed, 13 May 2020 15:57:12 -0400
From:   "John W. Linville" <linville@tuxdriver.com>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     netdev@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: Re: [PATCH V3 ethtool] ethtool: Add support for Low Latency Reed
 Solomon
Message-ID: <20200513195712.GE650568@tuxdriver.com>
References: <20200326110929.18698-1-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326110929.18698-1-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 01:09:29PM +0200, Tariq Toukan wrote:
> From: Aya Levin <ayal@mellanox.com>
> 
> Introduce a new FEC mode LLRS: Low Latency Reed Solomon, update print
> and initialization functions accordingly. In addition, update related
> man page.
> 
> Signed-off-by: Aya Levin <ayal@mellanox.com>
> Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>

Thanks (belatedly) -- queued for next release!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
