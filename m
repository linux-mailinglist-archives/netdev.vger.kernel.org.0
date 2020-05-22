Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A97E1DF104
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 23:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731069AbgEVVXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 17:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730976AbgEVVXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 17:23:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D7FC061A0E;
        Fri, 22 May 2020 14:23:36 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 479AF12723346;
        Fri, 22 May 2020 14:23:36 -0700 (PDT)
Date:   Fri, 22 May 2020 14:23:35 -0700 (PDT)
Message-Id: <20200522.142335.2074810945591510427.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, kuba@kernel.org, huangguangbin2@huawei.com
Subject: Re: [PATCH net-next 1/5] net: hns3: add support for VF to query
 ring and vector mapping
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1590115786-9940-2-git-send-email-tanhuazhong@huawei.com>
References: <1590115786-9940-1-git-send-email-tanhuazhong@huawei.com>
        <1590115786-9940-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 May 2020 14:23:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Fri, 22 May 2020 10:49:42 +0800

> From: Guangbin Huang <huangguangbin2@huawei.com>
> 
> This patch adds support for VF to query the mapping of ring and
> vector.
> 
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>

As Jakub said nothing is making this request, please remove it until
you add code that does.
