Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA571E70AF
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437739AbgE1Xrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 19:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437651AbgE1Xrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 19:47:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE37FC014D07;
        Thu, 28 May 2020 16:39:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 09A3C1296DF83;
        Thu, 28 May 2020 16:39:19 -0700 (PDT)
Date:   Thu, 28 May 2020 16:39:19 -0700 (PDT)
Message-Id: <20200528.163919.1875829376638675209.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, kuba@kernel.org
Subject: Re: [PATCH net-next 00/12] net: hns3: misc updates for -next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1590673699-63819-1-git-send-email-tanhuazhong@huawei.com>
References: <1590673699-63819-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 28 May 2020 16:39:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Thu, 28 May 2020 21:48:07 +0800

> This patchset includes some updates for the HNS3 ethernet driver.
> 
> #1 removes an unnecessary 'goto'.
> #2 adds a missing mutex destroy.
> #3&4 refactor two function, make them more readable and maintainable.
> #5&6 fix unsuitable type of gro enable field both for PF & VF.
> #7-#11 removes some unused fields, macro and redundant definitions.
> #12 adds more debug info for parsing speed fails.

Series applied, thanks.
