Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48EF92581FA
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 21:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729727AbgHaTmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 15:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727075AbgHaTmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 15:42:51 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26F0C061573;
        Mon, 31 Aug 2020 12:42:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8C6C7128967F9;
        Mon, 31 Aug 2020 12:26:03 -0700 (PDT)
Date:   Mon, 31 Aug 2020 12:42:49 -0700 (PDT)
Message-Id: <20200831.124249.1568909620880778703.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     qiang.zhao@nxp.com, kuba@kernel.org, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net/wan/fsl_ucc_hdlc: Add MODULE_DESCRIPTION
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200829115823.10140-1-yuehaibing@huawei.com>
References: <20200829115823.10140-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 31 Aug 2020 12:26:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Sat, 29 Aug 2020 19:58:23 +0800

> Add missing MODULE_DESCRIPTION.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
