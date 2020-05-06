Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0A91C7B9F
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 22:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729152AbgEFU5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 16:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726815AbgEFU5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 16:57:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA47C061A0F;
        Wed,  6 May 2020 13:57:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8EDDD120F5281;
        Wed,  6 May 2020 13:57:52 -0700 (PDT)
Date:   Wed, 06 May 2020 13:57:51 -0700 (PDT)
Message-Id: <20200506.135751.1936111471360870743.davem@davemloft.net>
To:     yanaijie@huawei.com
Cc:     roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        kuba@kernel.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: bridge: return false in br_mrp_enabled()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200506061616.18929-1-yanaijie@huawei.com>
References: <20200506061616.18929-1-yanaijie@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 13:57:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Yan <yanaijie@huawei.com>
Date: Wed, 6 May 2020 14:16:16 +0800

> Fix the following coccicheck warning:
> 
> net/bridge/br_private.h:1334:8-9: WARNING: return of 0/1 in function
> 'br_mrp_enabled' with return type bool
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Applied.
