Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B53091D21DF
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 00:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730947AbgEMWUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 18:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730064AbgEMWUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 18:20:30 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F685C061A0C;
        Wed, 13 May 2020 15:20:30 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F0F5812118550;
        Wed, 13 May 2020 15:20:28 -0700 (PDT)
Date:   Wed, 13 May 2020 15:20:28 -0700 (PDT)
Message-Id: <20200513.152028.653894441720284438.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     linux-net-drivers@solarflare.com, ecree@solarflare.com,
        mhabets@solarflare.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] sfc: fix dereference of table before it is null
 checked
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200512171355.221810-1-colin.king@canonical.com>
References: <20200512171355.221810-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 May 2020 15:20:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Tue, 12 May 2020 18:13:55 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently pointer table is being dereferenced on a null check of
> table->must_restore_filters before it is being null checked, leading
> to a potential null pointer dereference issue.  Fix this by null
> checking table before dereferencing it when checking for a null
> table->must_restore_filters.
> 
> Addresses-Coverity: ("Dereference before null check")
> Fixes: e4fe938cff04 ("sfc: move 'must restore' flags out of ef10-specific nic_data")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied, thanks.
