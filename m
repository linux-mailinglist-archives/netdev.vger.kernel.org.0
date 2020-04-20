Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D051B1630
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 21:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgDTTtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 15:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725897AbgDTTtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 15:49:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4CAC061A0C;
        Mon, 20 Apr 2020 12:49:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 54B47127FE1D5;
        Mon, 20 Apr 2020 12:49:38 -0700 (PDT)
Date:   Mon, 20 Apr 2020 12:49:37 -0700 (PDT)
Message-Id: <20200420.124937.2260131206540617269.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, kuba@kernel.org
Subject: Re: [PATCH V2 net-next 00/10] net: hns3: misc updates for -next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1587349055-4403-1-git-send-email-tanhuazhong@huawei.com>
References: <1587349055-4403-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Apr 2020 12:49:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Mon, 20 Apr 2020 10:17:25 +0800

> This patchset includes some misc updates for the HNS3 ethernet driver.
> 
> [patch 1&2] separates two bloated function.
> [patch 3-5] removes some redundant code.
> [patch 6-7] cleans up some coding style issues.
> [patch 8-10] adds some debugging information.
> 
> Change log:
> V1->V2:	removes an unnecessary initialization in [patch 1] which
> 	suggested by David Miller.
> 	modified some print format issue and commit log in [patch 8].

Series applied, thank you.
