Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD8F91DDBF7
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 02:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730449AbgEVAOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 20:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729771AbgEVAOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 20:14:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B7C8C061A0E;
        Thu, 21 May 2020 17:14:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E6349120ED486;
        Thu, 21 May 2020 17:14:31 -0700 (PDT)
Date:   Thu, 21 May 2020 17:14:31 -0700 (PDT)
Message-Id: <20200521.171431.915213255847424378.davem@davemloft.net>
To:     weiyongjun1@huawei.com
Cc:     netdev@vger.kernel.org, grygorii.strashko@ti.com,
        christophe.jaillet@wanadoo.fr, colin.king@canonical.com,
        kuba@kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 0/2 v3] net: ethernet: ti: fix some return value check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200520034116.170946-1-weiyongjun1@huawei.com>
References: <20200520034116.170946-1-weiyongjun1@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 May 2020 17:14:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Wed, 20 May 2020 11:41:14 +0800

> This patchset convert cpsw_ale_create() to return PTR_ERR() only, and
> changed all the caller to check IS_ERR() instead of NULL.
> 
> Since v2:
> 1) rebased on net.git, as Jakub's suggest
> 2) split am65-cpsw-nuss.c changes, as Grygorii's suggest

Series applied, thanks.
