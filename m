Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 342C61C0CB8
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 05:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbgEADku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 23:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbgEADku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 23:40:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15DDBC035494;
        Thu, 30 Apr 2020 20:40:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5F5C112774471;
        Thu, 30 Apr 2020 20:40:49 -0700 (PDT)
Date:   Thu, 30 Apr 2020 20:40:48 -0700 (PDT)
Message-Id: <20200430.204048.2100348364642739809.davem@davemloft.net>
To:     weiyongjun1@huawei.com
Cc:     ioana.ciornei@nxp.com, ruxandra.radulescu@nxp.com,
        linux@armlinux.org.uk, ast@kernel.org, daniel@iogearbox.net,
        kuba@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] dpaa2-eth: fix error return code in
 setup_dpni()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200427104322.11214-1-weiyongjun1@huawei.com>
References: <20200427104322.11214-1-weiyongjun1@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 20:40:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Mon, 27 Apr 2020 10:43:22 +0000

> Fix to return negative error code -ENOMEM from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Applied, thanks.
