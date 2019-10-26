Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 219B2E5E9B
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 20:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbfJZSVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 14:21:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47790 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbfJZSVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 14:21:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7E13C14DE9788;
        Sat, 26 Oct 2019 11:21:10 -0700 (PDT)
Date:   Sat, 26 Oct 2019 11:21:06 -0700 (PDT)
Message-Id: <20191026.112106.1243696018896349260.davem@davemloft.net>
To:     zhang.lin16@zte.com.cn
Cc:     ast@kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com,
        hawk@kernel.org, john.fastabend@gmail.com, mkubecek@suse.cz,
        jiri@mellanox.com, pablo@netfilter.org, f.fainelli@gmail.com,
        maxime.chevallier@bootlin.com, lirongqing@baidu.com,
        vivien.didelot@gmail.com, linyunsheng@huawei.com,
        natechancellor@gmail.com, arnd@arndb.de, dan.carpenter@oracle.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xue.zhihong@zte.com.cn, wang.yi59@zte.com.cn,
        jiang.xuexin@zte.com.cn
Subject: Re: [PATCH] net: Zeroing the structure ethtool_wolinfo in
 ethtool_get_wol()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1572076456-12463-1-git-send-email-zhang.lin16@zte.com.cn>
References: <1572076456-12463-1-git-send-email-zhang.lin16@zte.com.cn>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 26 Oct 2019 11:21:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhanglin <zhang.lin16@zte.com.cn>
Date: Sat, 26 Oct 2019 15:54:16 +0800

> memset() the structure ethtool_wolinfo that has padded bytes
> but the padded bytes have not been zeroed out.
> 
> Signed-off-by: zhanglin <zhang.lin16@zte.com.cn>

Applied and queued up for -stable.
