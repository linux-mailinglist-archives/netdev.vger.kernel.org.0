Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED9E1F5CF6
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 22:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgFJUTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 16:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbgFJUTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 16:19:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6276C03E96B
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 13:19:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BF41A119289BF;
        Wed, 10 Jun 2020 13:19:05 -0700 (PDT)
Date:   Wed, 10 Jun 2020 13:19:02 -0700 (PDT)
Message-Id: <20200610.131902.2093057899383691022.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, roopa@cumulusnetworks.com
Subject: Re: [PATCH v2 net] nexthop: Fix fdb labeling for groups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200609025443.19409-1-dsahern@kernel.org>
References: <20200609025443.19409-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 10 Jun 2020 13:19:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Mon,  8 Jun 2020 20:54:43 -0600

> fdb nexthops are marked with a flag. For standalone nexthops, a flag was
> added to the nh_info struct. For groups that flag was added to struct
> nexthop when it should have been added to the group information. Fix
> by removing the flag from the nexthop struct and adding a flag to nh_group
> that mirrors nh_info and is really only a caching of the individual types.
> Add a helper, nexthop_is_fdb, for use by the vxlan code and fixup the
> internal code to use the flag from either nh_info or nh_group.
> 
> v2
> - propagate fdb_nh in remove_nh_grp_entry
> 
> Fixes: 38428d68719c ("nexthop: support for fdb ecmp nexthops")
> Cc: Roopa Prabhu <roopa@cumulusnetworks.com>
> Signed-off-by: David Ahern <dsahern@kernel.org>

Applied, thanks David.
