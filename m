Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F041B32BE
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 00:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgDUWp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 18:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726067AbgDUWp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 18:45:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD0BC0610D5;
        Tue, 21 Apr 2020 15:45:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 93CE3128E9282;
        Tue, 21 Apr 2020 15:45:56 -0700 (PDT)
Date:   Tue, 21 Apr 2020 15:45:55 -0700 (PDT)
Message-Id: <20200421.154555.572490249375777103.davem@davemloft.net>
To:     yanaijie@huawei.com
Cc:     jeffrey.t.kirsher@intel.com, ast@kernel.org, daniel@iogearbox.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        kpsingh@chromium.org, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] i40e: Remove unneeded conversion to bool
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200420123448.7382-1-yanaijie@huawei.com>
References: <20200420123448.7382-1-yanaijie@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Apr 2020 15:45:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Yan <yanaijie@huawei.com>
Date: Mon, 20 Apr 2020 20:34:48 +0800

> The '==' expression itself is bool, no need to convert it to bool again.
> This fixes the following coccicheck warning:
> 
> drivers/net/ethernet/intel/i40e/i40e_main.c:1614:52-57: WARNING:
> conversion to bool not needed here
> drivers/net/ethernet/intel/i40e/i40e_main.c:11439:52-57: WARNING:
> conversion to bool not needed here
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Applied to net-next.
