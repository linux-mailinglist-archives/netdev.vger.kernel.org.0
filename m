Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C03926E99F
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 01:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgIQXwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 19:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgIQXwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 19:52:30 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A82C06174A;
        Thu, 17 Sep 2020 16:52:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7A07A136663D0;
        Thu, 17 Sep 2020 16:35:41 -0700 (PDT)
Date:   Thu, 17 Sep 2020 16:52:27 -0700 (PDT)
Message-Id: <20200917.165227.836051306625197335.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     kuba@kernel.org, saeed@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] netdev: Remove unused functions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200917021910.41448-1-yuehaibing@huawei.com>
References: <20200916141814.7376-1-yuehaibing@huawei.com>
        <20200917021910.41448-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 17 Sep 2020 16:35:41 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Thu, 17 Sep 2020 10:19:10 +0800

> There is no callers in tree, so can remove it.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
> v2: fix title typo 'funtions' --> 'functions'

Applied, thank you.
