Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78E820FCE3
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 21:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbgF3Tm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 15:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbgF3Tm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 15:42:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72886C061755;
        Tue, 30 Jun 2020 12:42:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 029E3127419FC;
        Tue, 30 Jun 2020 12:42:28 -0700 (PDT)
Date:   Tue, 30 Jun 2020 12:42:28 -0700 (PDT)
Message-Id: <20200630.124228.241806266805092135.davem@davemloft.net>
To:     luobin9@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoxianjun@huawei.com, yin.yinshi@huawei.com,
        cloud.wangxiaoyun@huawei.com, chiqijun@huawei.com
Subject: Re: [PATCH net-next] hinic: remove unused but set variable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200630023034.9281-1-luobin9@huawei.com>
References: <20200630023034.9281-1-luobin9@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jun 2020 12:42:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luo bin <luobin9@huawei.com>
Date: Tue, 30 Jun 2020 10:30:34 +0800

> remove unused but set variable to avoid auto build test WARNING
> 
> Signed-off-by: Luo bin <luobin9@huawei.com>
> Reported-by: kernel test robot <lkp@intel.com>

Applied, thanks.
