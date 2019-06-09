Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3D23ABCE
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 22:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729765AbfFIUiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 16:38:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45532 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfFIUiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 16:38:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B7F5E14DF3D4F;
        Sun,  9 Jun 2019 13:38:07 -0700 (PDT)
Date:   Sun, 09 Jun 2019 13:38:07 -0700 (PDT)
Message-Id: <20190609.133807.1807112771773489916.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     dsahern@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2 next] nexthop: off by one in nexthop_mpath_select()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190607153107.GS31203@kadam>
References: <0e02a744-f28e-e206-032b-a0ffac9f7311@gmail.com>
        <20190607153107.GS31203@kadam>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Jun 2019 13:38:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Fri, 7 Jun 2019 18:31:07 +0300

> The nhg->nh_entries[] array is allocated in nexthop_grp_alloc() and it
> has nhg->num_nh elements so this check should be >= instead of >.
> 
> Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reviewed-by: David Ahern <dsahern@gmail.com>
> ---
> v2: Use the correct Fixes tag

Applied, thanks Dan.
