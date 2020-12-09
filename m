Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7385F2D37B7
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 01:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731993AbgLIA0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 19:26:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:45660 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731997AbgLIA0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 19:26:39 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 4CD754D248DBC;
        Tue,  8 Dec 2020 16:25:54 -0800 (PST)
Date:   Tue, 08 Dec 2020 16:25:53 -0800 (PST)
Message-Id: <20201208.162553.1237236803727367213.davem@davemloft.net>
To:     zhengyongjun3@huawei.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: ipv6: rpl_iptunnel: simplify the return
 expression of rpl_do_srh()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201208120949.9243-1-zhengyongjun3@huawei.com>
References: <20201208120949.9243-1-zhengyongjun3@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 08 Dec 2020 16:25:54 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>
Date: Tue, 8 Dec 2020 20:09:49 +0800

> Simplify the return expression.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Applied.
