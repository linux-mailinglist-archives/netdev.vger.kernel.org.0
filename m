Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA36E1AF663
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 05:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgDSDRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 23:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725877AbgDSDRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 23:17:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F07C061A0C;
        Sat, 18 Apr 2020 20:17:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 555ED127B391F;
        Sat, 18 Apr 2020 20:17:49 -0700 (PDT)
Date:   Sat, 18 Apr 2020 20:17:46 -0700 (PDT)
Message-Id: <20200418.201746.783676213458110248.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, kuba@kernel.org, shenjian15@huawei.com
Subject: Re: [PATCH net-next 01/10] net: hns3: split out
 hclge_fd_check_ether_tuple()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1587192429-11463-2-git-send-email-tanhuazhong@huawei.com>
References: <1587192429-11463-1-git-send-email-tanhuazhong@huawei.com>
        <1587192429-11463-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 18 Apr 2020 20:17:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Sat, 18 Apr 2020 14:47:00 +0800

> +static int hclge_fd_check_spec(struct hclge_dev *hdev,
> +			       struct ethtool_rx_flow_spec *fs,
> +			       u32 *unused_tuple)
> +{
> +	int ret = 0;

There is no code path that uses 'ret' without it first being
assigned.  If I let this code in, then someone is going to
submit a fixup patch removing the initialization.
