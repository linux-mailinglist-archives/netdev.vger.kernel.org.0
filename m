Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAD12D378C
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 01:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731080AbgLIAYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 19:24:43 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:45470 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730243AbgLIAYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 19:24:42 -0500
X-Greylist: delayed 146706 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Dec 2020 19:24:42 EST
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 3C8884D248DBC;
        Tue,  8 Dec 2020 16:24:02 -0800 (PST)
Date:   Tue, 08 Dec 2020 16:24:01 -0800 (PST)
Message-Id: <20201208.162401.2089617891923555485.davem@davemloft.net>
To:     zhengyongjun3@huawei.com
Cc:     jiri@nvidia.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: core: devlink: simplify the return
 expression of devlink_nl_cmd_trap_set_doit()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201208121046.9297-1-zhengyongjun3@huawei.com>
References: <20201208121046.9297-1-zhengyongjun3@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 08 Dec 2020 16:24:02 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>
Date: Tue, 8 Dec 2020 20:10:46 +0800

> Simplify the return expression.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Applied.
