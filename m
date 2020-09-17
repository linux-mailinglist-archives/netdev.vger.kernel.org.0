Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A26C426CFE6
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 02:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgIQAXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 20:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbgIQAXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 20:23:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D30C06178B
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 17:13:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5D6FA13C70972;
        Wed, 16 Sep 2020 16:57:09 -0700 (PDT)
Date:   Wed, 16 Sep 2020 17:13:55 -0700 (PDT)
Message-Id: <20200916.171355.1205456391955745862.davem@davemloft.net>
To:     nikolay@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next] net: bridge: mcast: don't ignore return value
 of __grp_src_toex_excl
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200915145724.2065042-1-nikolay@cumulusnetworks.com>
References: <20200915145724.2065042-1-nikolay@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 16 Sep 2020 16:57:09 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date: Tue, 15 Sep 2020 17:57:24 +0300

> When we're handling TO_EXCLUDE report in EXCLUDE filter mode we should
> not ignore the return value of __grp_src_toex_excl() as we'll miss
> sending notifications about group changes.
> 
> Fixes: 5bf1e00b6849 ("net: bridge: mcast: support for IGMPV3/MLDv2 CHANGE_TO_INCLUDE/EXCLUDE report")
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

Applied, thank you.
