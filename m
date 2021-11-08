Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E409447EBC
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 12:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239137AbhKHLVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 06:21:03 -0500
Received: from mail.netfilter.org ([217.70.188.207]:47120 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237148AbhKHLVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 06:21:02 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id BC43A6063C;
        Mon,  8 Nov 2021 12:16:18 +0100 (CET)
Date:   Mon, 8 Nov 2021 12:18:13 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     cgel.zte@gmail.com
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jing Yao <yao.jing2@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] netfilter: xt_IDLETIMER: replace snprintf in show
 functions with sysfs_emit
Message-ID: <YYkHdbjKFTiSlfNj@salvia>
References: <20211104114911.31214-1-yao.jing2@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211104114911.31214-1-yao.jing2@zte.com.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 04, 2021 at 11:49:11AM +0000, cgel.zte@gmail.com wrote:
> From: Jing Yao <yao.jing2@zte.com.cn>
> 
> coccicheck complains about the use of snprintf() in sysfs show
> functions:
> WARNING use scnprintf or sprintf
> 
> Use sysfs_emit instead of scnprintf, snprintf or sprintf makes more
> sense.

Applied, thanks.
