Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32958258246
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 22:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729917AbgHaUIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 16:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729908AbgHaUIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 16:08:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0A9C061573;
        Mon, 31 Aug 2020 13:08:43 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 923DF128A6C24;
        Mon, 31 Aug 2020 12:51:56 -0700 (PDT)
Date:   Mon, 31 Aug 2020 13:08:42 -0700 (PDT)
Message-Id: <20200831.130842.722673775419344862.davem@davemloft.net>
To:     linmiaohe@huawei.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: ipv6: remove unused arg exact_dif in
 compute_score
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200831062610.8078-1-linmiaohe@huawei.com>
References: <20200831062610.8078-1-linmiaohe@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 31 Aug 2020 12:51:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Date: Mon, 31 Aug 2020 02:26:10 -0400

> The arg exact_dif is not used anymore, remove it. inet6_exact_dif_match()
> is no longer needed after the above is removed, remove it too.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

Applied to net-next.

