Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 554E822A39D
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 02:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733187AbgGWA3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 20:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729486AbgGWA3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 20:29:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20064C0619DC;
        Wed, 22 Jul 2020 17:29:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 46E0B11FFC81F;
        Wed, 22 Jul 2020 17:12:29 -0700 (PDT)
Date:   Wed, 22 Jul 2020 17:29:12 -0700 (PDT)
Message-Id: <20200722.172912.135195129615704553.davem@davemloft.net>
To:     wanghai38@huawei.com
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: qed: Remove unneeded cast from memory
 allocation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200722021027.12797-1-wanghai38@huawei.com>
References: <20200722021027.12797-1-wanghai38@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Jul 2020 17:12:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>
Date: Wed, 22 Jul 2020 10:10:27 +0800

> Remove casting the values returned by memory allocation function.
> 
> Coccinelle emits WARNING: casting value returned by memory allocation
> unction to (struct roce_destroy_qp_req_output_params *) is useless.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

Applied, thank you.
