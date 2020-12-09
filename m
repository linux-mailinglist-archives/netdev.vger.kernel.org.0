Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5D32D37B0
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 01:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731954AbgLIA0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 19:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731948AbgLIA0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 19:26:11 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1700DC0613D6;
        Tue,  8 Dec 2020 16:25:31 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id A598E4D249B50;
        Tue,  8 Dec 2020 16:25:30 -0800 (PST)
Date:   Tue, 08 Dec 2020 16:25:30 -0800 (PST)
Message-Id: <20201208.162530.1164741419803418853.davem@davemloft.net>
To:     zhengyongjun3@huawei.com
Cc:     jcliburn@gmail.com, chris.snook@gmail.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: atheros: simplify the return expression
 of atl2_phy_setup_autoneg_adv()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201208135730.11926-1-zhengyongjun3@huawei.com>
References: <20201208135730.11926-1-zhengyongjun3@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 08 Dec 2020 16:25:30 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>
Date: Tue, 8 Dec 2020 21:57:30 +0800

> Simplify the return expression.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Applied.
