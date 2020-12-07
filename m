Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E22A2D0B38
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 08:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgLGHkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 02:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgLGHkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 02:40:17 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF0FC0613D0
        for <netdev@vger.kernel.org>; Sun,  6 Dec 2020 23:39:37 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 3C18A4D0D8855;
        Sun,  6 Dec 2020 23:38:55 -0800 (PST)
Date:   Sun, 06 Dec 2020 23:38:50 -0800 (PST)
Message-Id: <20201206.233850.576775262589107523.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, huangdaode@huawei.com, sfr@canb.auug.org.au
Subject: Re: [PATCH net] net: hns3: remove a misused pragma packed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1607325625-29945-1-git-send-email-tanhuazhong@huawei.com>
References: <1607325625-29945-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Sun, 06 Dec 2020 23:38:55 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Mon, 7 Dec 2020 15:20:25 +0800

> hclge_dbg_reg_info[] is defined as an array of packed structure
> accidentally. However, this array contains pointers, which are
> no longer aligned naturally, and cannot be relocated on PPC64.
> Hence, when compile-testing this driver on PPC64 with
> CONFIG_RELOCATABLE=y (e.g. PowerPC allyesconfig), there will be
> some warnings.
> 
> Since each field in structure hclge_qos_pri_map_cmd and
> hclge_dbg_bitmap_cmd is type u8, the pragma packed is unnecessary
> for these two structures as well, so remove the pragma packed in
> hclge_debugfs.h to fix this issue, and this increases
> hclge_dbg_reg_info[] by 4 bytes per entry.
> 
> Fixes: a582b78dfc33 ("net: hns3: code optimization for debugfs related to "dump reg"")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>

Applied, thank you.
